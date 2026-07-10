// Firestore data-access layer for reading/writing startup profiles.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/startup.dart';
import '../services/firestore_service.dart';

class StartupRepository {
  StartupRepository({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  Future<String> createStartup(Startup startup) async {
    final doc = await _firestoreService.add(
      FirestoreCollections.startups,
      startup.toMap(),
    );
    return doc.id;
  }

  Future<void> updateStartup(String id, Map<String, dynamic> data) {
    return _firestoreService.update(FirestoreCollections.startups, id, data);
  }

  Future<void> setVerificationStatus(String id, VerificationStatus status) {
    return updateStartup(id, {'verificationStatus': status.value});
  }

  Future<Startup?> getStartup(String id) async {
    final doc = await _firestoreService.getDoc(
      FirestoreCollections.startups,
      id,
    );
    return doc.exists ? Startup.fromFirestore(doc) : null;
  }

  Stream<Startup?> watchStartup(String id) {
    return _firestoreService
        .streamDoc(FirestoreCollections.startups, id)
        .map((doc) => doc.exists ? Startup.fromFirestore(doc) : null);
  }

  Stream<List<Startup>> watchVerifiedStartups() {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.startups,
          queryBuilder: (q) => q
              .where('verificationStatus', isEqualTo: VerificationStatus.verified.value)
              .orderBy('name'),
        )
        .map(_mapSnapshot);
  }

  Stream<List<Startup>> watchStartupsByOwner(String ownerId) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.startups,
          queryBuilder: (q) => q.where('ownerId', isEqualTo: ownerId),
        )
        .map(_mapSnapshot);
  }

  List<Startup> _mapSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map(Startup.fromFirestore).toList();
  }
}
