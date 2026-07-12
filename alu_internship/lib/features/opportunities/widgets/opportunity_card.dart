// Reusable card widget summarizing an opportunity in list/feed views.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/opportunity.dart';
import '../../auth/providers/auth_providers.dart';
import '../../bookmarks/providers/bookmark_providers.dart';
import '../../post_opportunity/providers/post_opportunity_providers.dart';

// Shows one opportunity as a card: icon, title, startup name, quick facts, and a bookmark button.
// Used in the feed, bookmarks list, and applications list so opportunities always look the same.
class OpportunityCard extends ConsumerWidget {
  const OpportunityCard({super.key, required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Looks up the startup's name and whether this opportunity is already saved.
    final startup = ref.watch(startupByIdProvider(opportunity.startupId));
    final isBookmarked = ref.watch(isBookmarkedProvider(opportunity.id));

    return InkWell(
      // Tapping the card opens the full opportunity details.
      onTap: () => context.router.push(
        OpportunityDetailRoute(opportunityId: opportunity.id),
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
        child: Row(
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
                    opportunity.title,
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
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    [
                      opportunity.commitment,
                      opportunity.location,
                    ].where((s) => s.isNotEmpty).join(' · '),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isBookmarked.value == true
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: AppColors.primary,
              ),
              onPressed: () => _toggleBookmark(ref, isBookmarked.value ?? false),
            ),
          ],
        ),
      ),
    );
  }

  // Saves or un-saves this opportunity for the signed-in student when the bookmark icon is tapped.
  Future<void> _toggleBookmark(WidgetRef ref, bool currentlyBookmarked) async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;
    final repo = ref.read(bookmarkRepositoryProvider);
    if (currentlyBookmarked) {
      await repo.removeBookmark(user.uid, opportunity.id);
    } else {
      await repo.addBookmark(user.uid, opportunity.id);
    }
  }
}
