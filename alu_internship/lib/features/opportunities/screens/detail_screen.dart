// Detail screen for a single opportunity, with an option to apply/express interest.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/message_user_button.dart';
import '../../../models/application.dart';
import '../../../models/opportunity.dart';
import '../../../repositories/application_repository.dart';
import '../../applications/providers/application_providers.dart';
import '../../auth/providers/auth_providers.dart';
import '../../post_opportunity/providers/post_opportunity_providers.dart';
import '../../profile/providers/profile_providers.dart';
import '../providers/opportunity_providers.dart';

@RoutePage(name: 'OpportunityDetailRoute')
class OpportunityDetailScreen extends ConsumerStatefulWidget {
  const OpportunityDetailScreen({super.key, required this.opportunityId});

  final String opportunityId;

  @override
  ConsumerState<OpportunityDetailScreen> createState() =>
      _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState
    extends ConsumerState<OpportunityDetailScreen> {
  bool _isApplying = false;

  Future<void> _handleApply(Opportunity opportunity) async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    setState(() => _isApplying = true);
    try {
      final studentProfile = await ref
          .read(studentProfileRepositoryProvider)
          .getProfile(user.uid);
      await ref
          .read(applicationRepositoryProvider)
          .submitApplication(
            Application(
              id: '',
              opportunityId: opportunity.id,
              startupId: opportunity.startupId,
              studentId: user.uid,
              resumeUrl: studentProfile?.resumeUrl,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Application submitted!')));
    } on DuplicateApplicationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not apply: $e')));
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  String _postedLabel(DateTime? date) {
    if (date == null) return 'Recently posted';
    final days = DateTime.now().difference(date).inDays;
    if (days <= 0) return 'Posted today';
    if (days == 1) return 'Posted 1 day ago';
    return 'Posted $days days ago';
  }

  @override
  Widget build(BuildContext context) {
    final opportunityAsync = ref.watch(
      opportunityByIdProvider(widget.opportunityId),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Opportunity Details', style: AppTextStyles.headingSmall),
      ),
      body: opportunityAsync.when(
        data: (opportunity) {
          if (opportunity == null) {
            return const EmptyState(
              icon: Icons.search_off,
              title: 'Opportunity not found',
            );
          }
          return _OpportunityDetailBody(
            opportunity: opportunity,
            isApplying: _isApplying,
            onApply: () => _handleApply(opportunity),
            postedLabel: _postedLabel(opportunity.createdAt),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load opportunity',
          subtitle: '$error',
        ),
      ),
    );
  }
}

class _OpportunityDetailBody extends ConsumerWidget {
  const _OpportunityDetailBody({
    required this.opportunity,
    required this.isApplying,
    required this.onApply,
    required this.postedLabel,
  });

  final Opportunity opportunity;
  final bool isApplying;
  final VoidCallback onApply;
  final String postedLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(startupByIdProvider(opportunity.startupId));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppGradients.heroBanner,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opportunity.title,
                            style: AppTextStyles.headingMedium,
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            startup.when(
                              data: (s) => s?.name ?? '',
                              loading: () => '',
                              error: (_, _) => '',
                            ),
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                _SkillChips(skills: opportunity.skillsRequired),
                SizedBox(height: AppSpacing.lg),
                const Divider(color: AppColors.cardBorder),
                SizedBox(height: AppSpacing.md),
                _InfoRow(icon: Icons.schedule, text: opportunity.commitment),
                SizedBox(height: AppSpacing.md),
                _InfoRow(icon: Icons.work_outline, text: opportunity.location),
                SizedBox(height: AppSpacing.md),
                _InfoRow(icon: Icons.calendar_today_outlined, text: postedLabel),
                SizedBox(height: AppSpacing.md),
                const Divider(color: AppColors.cardBorder),
                SizedBox(height: AppSpacing.lg),
                Text('About', style: AppTextStyles.headingSmall),
                SizedBox(height: AppSpacing.sm),
                Text(opportunity.description, style: AppTextStyles.bodyMedium),
                SizedBox(height: AppSpacing.lg),
                Text('Skills required', style: AppTextStyles.headingSmall),
                SizedBox(height: AppSpacing.sm),
                _SkillChips(skills: opportunity.skillsRequired),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              MessageUserButton(otherUserId: startup.value?.ownerId),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppGradients.heroBanner,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  child: ElevatedButton(
                    onPressed: isApplying ? null : onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                    ),
                    child: isApplying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            'Apply Now',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        SizedBox(width: AppSpacing.sm),
        Text(text, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _SkillChips extends StatelessWidget {
  const _SkillChips({required this.skills});

  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final skill in skills)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.chip),
            ),
            child: Text(skill, style: AppTextStyles.labelSmall),
          ),
      ],
    );
  }
}
