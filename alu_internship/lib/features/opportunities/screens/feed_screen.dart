// Main discovery feed where students browse/search/filter open opportunities.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../models/opportunity.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/opportunity_providers.dart';
import '../widgets/opportunity_card.dart';

@RoutePage(name: 'FeedRoute')
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  // Draws the greeting, search bar, category picker, and the list of open opportunities.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(currentAppUserProvider).value;
    final filter = ref.watch(opportunityFeedFilterProvider);
    final opportunities = ref.watch(feedOpportunitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Greeting with the person's first name and their profile photo.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${_firstName(appUser?.displayName)} 👋',
                        style: AppTextStyles.headingLarge,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        'Find meaningful ways to contribute.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: appUser?.photoUrl != null
                      ? NetworkImage(appUser!.photoUrl!)
                      : null,
                  child: appUser?.photoUrl == null
                      ? const Icon(Icons.person, color: AppColors.primary)
                      : null,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            // Typing here updates the search text, which narrows down the list below.
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => ref
                        .read(opportunityFeedFilterProvider.notifier)
                        .update((f) => f.copyWith(searchQuery: value)),
                    decoration: InputDecoration(
                      hintText: 'Search opportunities...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textMuted,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            Text('Browse by category', style: AppTextStyles.headingSmall),
            SizedBox(height: AppSpacing.md),
            // A row of category circles. Tapping one filters the list; tapping it again clears it.
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: OpportunityCategory.values.length,
                separatorBuilder: (_, _) => SizedBox(width: AppSpacing.lg),
                itemBuilder: (context, index) {
                  final category = OpportunityCategory.values[index];
                  final isSelected = filter.category == category;
                  return GestureDetector(
                    onTap: () => ref
                        .read(opportunityFeedFilterProvider.notifier)
                        .update(
                          (f) => f.copyWith(
                            category: () => isSelected ? null : category,
                          ),
                        ),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _categoryIcon(category),
                            color: isSelected ? AppColors.white : AppColors.primary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(category.displayLabel, style: AppTextStyles.caption),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            Text('Recent opportunities', style: AppTextStyles.headingSmall),
            SizedBox(height: AppSpacing.md),
            // The actual list of opportunities that match the current search and category.
            opportunities.when(
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off,
                    title: 'No opportunities found',
                    subtitle: 'Try a different search or category.',
                  );
                }
                return Column(
                  children: [
                    for (final opportunity in list)
                      OpportunityCard(opportunity: opportunity),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.only(top: AppSpacing.xl),
                child: LoadingIndicator(),
              ),
              error: (error, _) => EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load opportunities',
                subtitle: '$error',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Picks which little icon to show for each category in the "Browse by category" row.
  IconData _categoryIcon(OpportunityCategory category) {
    switch (category) {
      case OpportunityCategory.softwareDevelopment:
        return Icons.code;
      case OpportunityCategory.design:
        return Icons.palette_outlined;
      case OpportunityCategory.marketing:
        return Icons.campaign_outlined;
      case OpportunityCategory.operations:
        return Icons.settings_outlined;
      case OpportunityCategory.research:
        return Icons.science_outlined;
      case OpportunityCategory.businessAnalysis:
        return Icons.bar_chart;
      case OpportunityCategory.contentCreation:
        return Icons.edit_outlined;
      case OpportunityCategory.communityManagement:
        return Icons.groups_outlined;
      case OpportunityCategory.other:
        return Icons.category_outlined;
    }
  }

  // Pulls out just the first name from someone's full name, for a shorter greeting.
  String _firstName(String? displayName) {
    if (displayName == null || displayName.trim().isEmpty) return 'there';
    return displayName.trim().split(' ').first;
  }
}
