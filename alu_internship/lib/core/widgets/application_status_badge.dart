// Reusable colored label showing an application's current status (e.g. Pending, Accepted).
import 'package:flutter/material.dart';

import '../../models/application.dart';
import '../theme/app_theme.dart';

class ApplicationStatusBadge extends StatelessWidget {
  const ApplicationStatusBadge({super.key, required this.status});

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
