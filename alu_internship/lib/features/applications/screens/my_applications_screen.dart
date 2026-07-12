// Screen where a student tracks the status of applications they submitted.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../models/application.dart';
import '../../opportunities/providers/opportunity_providers.dart';
import '../../post_opportunity/providers/post_opportunity_providers.dart';
import '../providers/application_providers.dart';

@RoutePage(name: 'MyApplicationsRoute')
class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(myApplicationsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('My Applications', style: AppTextStyles.headingSmall),
      ),
      body: applications.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.assignment_outlined,
              title: 'No applications yet',
              subtitle: 'Opportunities you apply to will show up here.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              for (final application in list)
                _ApplicationCard(application: application),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load applications',
          subtitle: '$error',
        ),
      ),
    );
  }
}

class _ApplicationCard extends ConsumerWidget {
  const _ApplicationCard({required this.application});

  final Application application;

  bool get _canWithdraw =>
      application.status == ApplicationStatus.pending ||
      application.status == ApplicationStatus.underReview;

  Future<void> _handleWithdraw(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw application?'),
        content: const Text('You can\'t reapply to this opportunity after withdrawing.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref
          .read(applicationRepositoryProvider)
          .withdrawApplication(application.id);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not withdraw: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunity = ref.watch(opportunityByIdProvider(application.opportunityId));
    final startup = ref.watch(startupByIdProvider(application.startupId));

    return InkWell(
      onTap: () => context.router.push(
        OpportunityDetailRoute(opportunityId: application.opportunityId),
      ),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(Icons.work_outline, color: AppColors.primary),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity.when(
                          data: (o) => o?.title ?? '',
                          loading: () => '',
                          error: (_, _) => '',
                        ),
                        style: AppTextStyles.headingSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        startup.when(
                          data: (s) => s?.name ?? '',
                          loading: () => '',
                          error: (_, _) => '',
                        ),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: application.status),
              ],
            ),
            if (_canWithdraw) ...[
              SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _handleWithdraw(context, ref),
                  child: Text(
                    'Withdraw',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
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
