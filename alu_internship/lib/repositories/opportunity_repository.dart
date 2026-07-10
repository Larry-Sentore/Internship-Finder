// Firestore data-access layer for reading/writing opportunity postings.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/opportunity.dart';
import '../services/firestore_service.dart';

class OpportunityRepository {
  OpportunityRepository({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  Future<String> createOpportunity(Opportunity opportunity) async {
    final doc = await _firestoreService.add(
      FirestoreCollections.opportunities,
      opportunity.toMap(),
    );
    return doc.id;
  }

  Future<void> updateOpportunity(String id, Map<String, dynamic> data) {
    return _firestoreService.update(
      FirestoreCollections.opportunities,
      id,
      data,
    );
  }

  Future<void> closeOpportunity(String id) {
    return updateOpportunity(id, {'status': OpportunityStatus.closed.value});
  }

  Future<void> deleteOpportunity(String id) {
    return _firestoreService.delete(FirestoreCollections.opportunities, id);
  }

  Future<Opportunity?> getOpportunity(String id) async {
    final doc = await _firestoreService.getDoc(
      FirestoreCollections.opportunities,
      id,
    );
    return doc.exists ? Opportunity.fromFirestore(doc) : null;
  }

  Stream<Opportunity?> watchOpportunity(String id) {
    return _firestoreService
        .streamDoc(FirestoreCollections.opportunities, id)
        .map((doc) => doc.exists ? Opportunity.fromFirestore(doc) : null);
  }

  /// Streams open opportunities, optionally filtered by [category].
  /// Firestore has no native full-text search, so free-text [searchQuery]
  /// filtering is applied client-side against the title.
  Stream<List<Opportunity>> watchOpenOpportunities({
    OpportunityCategory? category,
    String? searchQuery,
  }) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.opportunities,
          queryBuilder: (q) {
            Query<Map<String, dynamic>> query = q.where(
              'status',
              isEqualTo: OpportunityStatus.open.value,
            );
            if (category != null) {
              query = query.where('category', isEqualTo: category.value);
            }
            return query.orderBy('createdAt', descending: true);
          },
        )
        .map((snapshot) {
          final opportunities = snapshot.docs.map(Opportunity.fromFirestore);
          if (searchQuery == null || searchQuery.trim().isEmpty) {
            return opportunities.toList();
          }
          final query = searchQuery.trim().toLowerCase();
          return opportunities
              .where((o) => o.title.toLowerCase().contains(query))
              .toList();
        });
  }

  Stream<List<Opportunity>> watchOpportunitiesByStartup(String startupId) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.opportunities,
          queryBuilder: (q) => q
              .where('startupId', isEqualTo: startupId)
              .orderBy('createdAt', descending: true),
        )
        .map((snapshot) => snapshot.docs.map(Opportunity.fromFirestore).toList());
  }
}
