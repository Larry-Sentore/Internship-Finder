// Screen for startup owners to review and act on applicants to their opportunity.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/message_user_button.dart';
import '../../../models/application.dart';
import '../../auth/providers/auth_providers.dart';
import '../../opportunities/providers/opportunity_providers.dart';
import '../providers/application_providers.dart';

@RoutePage(name: 'ApplicantReviewRoute')
class ApplicantReviewScreen extends ConsumerWidget {
  const ApplicantReviewScreen({super.key, required this.opportunityId});

  final String opportunityId;

  // Loads the opportunity's title and the list of people who applied to it, then shows them.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunity = ref.watch(opportunityByIdProvider(opportunityId));
    final applications = ref.watch(applicationsByOpportunityProvider(opportunityId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          opportunity.value?.title ?? 'Applicants',
          style: AppTextStyles.headingSmall,
        ),
      ),
      body: applications.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'No applicants yet',
              subtitle: 'Students who apply to this opportunity will show up here.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              for (final application in list)
                _ApplicantCard(application: application),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load applicants',
          subtitle: '$error',
        ),
      ),
    );
  }
}

// One applicant's card: their name, note, resume link, current status, and action buttons.
class _ApplicantCard extends ConsumerWidget {
  const _ApplicantCard({required this.application});

  final Application application;

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
              _StatusBadge(status: application.status),
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

// Small colored label showing the application's current status (e.g. Pending, Accepted).
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    // Picks which icon, color, and text to show based on the status.
    final IconData icon;
    final Color color;
    final String label;
    switch (status) {
      case ApplicationStatus.pending:
        icon = Icons.hourglass_top;
        color = AppColors.warning;
        label = 'Pending';
      case ApplicationStatus.underReview:
        icon = Icons.visibility_outlined;
        color = AppColors.primary;
        label = 'Shortlisted';
      case ApplicationStatus.accepted:
        icon = Icons.check_circle_outline;
        color = AppColors.success;
        label = 'Accepted';
      case ApplicationStatus.rejected:
        icon = Icons.cancel_outlined;
        color = AppColors.error;
        label = 'Rejected';
      case ApplicationStatus.withdrawn:
        icon = Icons.undo;
        color = AppColors.textMuted;
        label = 'Withdrawn';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}
