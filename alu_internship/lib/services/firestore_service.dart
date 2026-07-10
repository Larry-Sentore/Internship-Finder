// Generic wrapper around Cloud Firestore CRUD/stream operations.
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _db.collection(path);

  Future<DocumentReference<Map<String, dynamic>>> add(
    String collectionPath,
    Map<String, dynamic> data,
  ) {
    return collection(collectionPath).add(data);
  }

  Future<void> set(
    String collectionPath,
    String docId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) {
    return collection(
      collectionPath,
    ).doc(docId).set(data, SetOptions(merge: merge));
  }

  Future<void> update(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) {
    return collection(collectionPath).doc(docId).update(data);
  }

  Future<void> delete(String collectionPath, String docId) {
    return collection(collectionPath).doc(docId).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(
    String collectionPath,
    String docId,
  ) {
    return collection(collectionPath).doc(docId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDoc(
    String collectionPath,
    String docId,
  ) {
    return collection(collectionPath).doc(docId).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String collectionPath, {
    Query<Map<String, dynamic>> Function(
      Query<Map<String, dynamic>> query,
    )?
    queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = collection(collectionPath);
    if (queryBuilder != null) query = queryBuilder(query);
    return query.get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String collectionPath, {
    Query<Map<String, dynamic>> Function(
      Query<Map<String, dynamic>> query,
    )?
    queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = collection(collectionPath);
    if (queryBuilder != null) query = queryBuilder(query);
    return query.snapshots();
  }
}
