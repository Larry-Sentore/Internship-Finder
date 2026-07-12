// Riverpod providers exposing opportunity listing/search/filter state to the UI.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../models/opportunity.dart';
import '../../../repositories/opportunity_repository.dart';

final opportunityRepositoryProvider = Provider<OpportunityRepository>((ref) {
  return OpportunityRepository();
});

class OpportunityFeedFilter {
  const OpportunityFeedFilter({this.category, this.searchQuery = ''});

  final OpportunityCategory? category;
  final String searchQuery;

  OpportunityFeedFilter copyWith({
    OpportunityCategory? Function()? category,
    String? searchQuery,
  }) {
    return OpportunityFeedFilter(
      category: category != null ? category() : this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OpportunityFeedFilter &&
        other.category == category &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode => Object.hash(category, searchQuery);
}

final opportunityFeedFilterProvider =
    StateProvider<OpportunityFeedFilter>((ref) => const OpportunityFeedFilter());

final feedOpportunitiesProvider = StreamProvider.autoDispose((ref) {
  final filter = ref.watch(opportunityFeedFilterProvider);
  return ref
      .watch(opportunityRepositoryProvider)
      .watchOpenOpportunities(
        category: filter.category,
        searchQuery: filter.searchQuery,
      );
});

final opportunityByIdProvider = StreamProvider.autoDispose
    .family<Opportunity?, String>((ref, opportunityId) {
      return ref
          .watch(opportunityRepositoryProvider)
          .watchOpportunity(opportunityId);
    });

final opportunitiesByStartupProvider = StreamProvider.autoDispose
    .family<List<Opportunity>, String>((ref, startupId) {
      return ref
          .watch(opportunityRepositoryProvider)
          .watchOpportunitiesByStartup(startupId);
    });
