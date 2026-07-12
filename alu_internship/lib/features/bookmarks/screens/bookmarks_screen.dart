// Screen listing opportunities the current student has bookmarked/saved.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../opportunities/providers/opportunity_providers.dart';
import '../../opportunities/widgets/opportunity_card.dart';
import '../providers/bookmark_providers.dart';

@RoutePage(name: 'BookmarksRoute')
class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(myBookmarksProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Bookmarks', style: AppTextStyles.headingSmall),
      ),
      body: bookmarks.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.bookmark_border,
              title: 'No bookmarks yet',
              subtitle: 'Opportunities you save will show up here.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              for (final bookmark in list)
                _BookmarkedOpportunity(opportunityId: bookmark.opportunityId),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load bookmarks',
          subtitle: '$error',
        ),
      ),
    );
  }
}

class _BookmarkedOpportunity extends ConsumerWidget {
  const _BookmarkedOpportunity({required this.opportunityId});

  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunity = ref.watch(opportunityByIdProvider(opportunityId));

    return opportunity.when(
      data: (opportunity) => opportunity == null
          ? const SizedBox.shrink()
          : OpportunityCard(opportunity: opportunity),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
