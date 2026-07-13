// Reusable card for one applicant: their name, note, resume link, status, and accept/reject actions.
// Used both when reviewing applicants for a single opportunity and when browsing every
// applicant across a startup's postings (where the opportunity title is also shown).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/application_status_badge.dart';
import '../../../core/widgets/message_user_button.dart';
import '../../../models/application.dart';
import '../../auth/providers/auth_providers.dart';
import '../../opportunities/providers/opportunity_providers.dart';
import '../providers/application_providers.dart';

class ApplicantCard extends ConsumerWidget {
  const ApplicantCard({
    super.key,
    required this.application,
    this.showOpportunityTitle = false,
  });

  final Application application;

  /// Shows which opportunity this application is for, e.g. in a list that mixes
  /// applicants from more than one posting.
  final bool showOpportunityTitle;

  // True while the application hasn't been accepted or rejected yet.
  bool get _isPending =>
      application.status == ApplicationStatus.pending ||
      application.status == ApplicationStatus.underReview;

  // Opens the applicant's resume link in the browser when tapped.
  Future<void> _openResume(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open $url')));
    }
  }

  // Saves the new status (accepted or rejected) for this application.
  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    ApplicationStatus status,
  ) async {
    try {
      await ref
          .read(applicationRepositoryProvider)
          .updateStatus(application.id, status);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not update status: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Looks up the applying student's name and photo using their id.
    final student = ref.watch(appUserByIdProvider(application.studentId));
    final opportunity = showOpportunityTitle
        ? ref.watch(opportunityByIdProvider(application.opportunityId))
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shows which posting this application is for, when mixing applicants
          // from more than one opportunity in the same list.
          if (opportunity != null && (opportunity.value?.title.isNotEmpty ?? false)) ...[
            Text(
              opportunity.value!.title,
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.xs),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: student.value?.photoUrl != null
                    ? NetworkImage(student.value!.photoUrl!)
                    : null,
                child: student.value?.photoUrl == null
                    ? const Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.value?.displayName ?? '',
                      style: AppTextStyles.headingSmall,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    // Shows the short note the student wrote, if they wrote one.
                    if (application.coverNote.isNotEmpty)
                      Text(
                        application.coverNote,
                        style: AppTextStyles.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    // Shows a link to the student's resume, if they added one to their profile.
                    if (application.resumeUrl != null) ...[
                      SizedBox(height: AppSpacing.xs),
                      InkWell(
                        onTap: () => _openResume(context, application.resumeUrl!),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Text(
                              'View Resume',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ApplicationStatusBadge(status: application.status),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              // Lets the startup owner start a chat with this applicant.
              MessageUserButton(otherUserId: application.studentId),
              // Only show the accept/reject buttons while a decision hasn't been made yet.
              if (_isPending) ...[
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateStatus(
                      context,
                      ref,
                      ApplicationStatus.rejected,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(
                      context,
                      ref,
                      ApplicationStatus.accepted,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
