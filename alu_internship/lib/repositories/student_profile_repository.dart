// Firestore data-access layer for a student's extended profile.
import '../core/constants/firestore_collections.dart';
import '../models/student_profile.dart';
import '../services/firestore_service.dart';

class StudentProfileRepository {
  StudentProfileRepository({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  Future<void> setProfile(StudentProfile profile) {
    return _firestoreService.set(
      FirestoreCollections.studentProfiles,
      profile.uid,
      profile.toMap(),
      merge: true,
    );
  }

  Future<StudentProfile?> getProfile(String uid) async {
    final doc = await _firestoreService.getDoc(
      FirestoreCollections.studentProfiles,
      uid,
    );
    return doc.exists ? StudentProfile.fromFirestore(doc) : null;
  }

  Stream<StudentProfile?> watchProfile(String uid) {
    return _firestoreService
        .streamDoc(FirestoreCollections.studentProfiles, uid)
        .map((doc) => doc.exists ? StudentProfile.fromFirestore(doc) : null);
  }
}
