// Riverpod providers exposing opportunity listing/search/filter state to the UI.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../models/opportunity.dart';
import '../../../repositories/opportunity_repository.dart';

// Gives screens access to reading, creating, and updating opportunity postings.
final opportunityRepositoryProvider = Provider<OpportunityRepository>((ref) {
  return OpportunityRepository();
});

// Holds the search text and category the student has picked on the feed screen.
class OpportunityFeedFilter {
  const OpportunityFeedFilter({this.category, this.searchQuery = ''});

  final OpportunityCategory? category;
  final String searchQuery;

  // Returns a copy of this filter with just the given parts swapped out.
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

// Remembers the current search text and category so the feed screen can react when they change.
final opportunityFeedFilterProvider =
    StateProvider<OpportunityFeedFilter>((ref) => const OpportunityFeedFilter());

// Gets the list of open opportunities that match the current search text and category.
final feedOpportunitiesProvider = StreamProvider.autoDispose((ref) {
  final filter = ref.watch(opportunityFeedFilterProvider);
  return ref
      .watch(opportunityRepositoryProvider)
      .watchOpenOpportunities(
        category: filter.category,
        searchQuery: filter.searchQuery,
      );
});

// Gets one specific opportunity by its id, for the detail screen.
final opportunityByIdProvider = StreamProvider.autoDispose
    .family<Opportunity?, String>((ref, opportunityId) {
      return ref
          .watch(opportunityRepositoryProvider)
          .watchOpportunity(opportunityId);
    });

// Gets every opportunity posted by one startup.
final opportunitiesByStartupProvider = StreamProvider.autoDispose
    .family<List<Opportunity>, String>((ref, startupId) {
      return ref
          .watch(opportunityRepositoryProvider)
          .watchOpportunitiesByStartup(startupId);
    });
