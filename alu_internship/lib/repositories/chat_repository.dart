// Firestore data-access layer for conversations and messages.
import '../core/constants/firestore_collections.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../services/firestore_service.dart';

class ChatRepository {
  ChatRepository({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  String _messagesPath(String conversationId) =>
      '${FirestoreCollections.conversations}/$conversationId/${FirestoreCollections.messages}';

  Future<String> getOrCreateConversation(List<String> participantIds) async {
    final sorted = [...participantIds]..sort();
    final existing = await _firestoreService.getCollection(
      FirestoreCollections.conversations,
      queryBuilder: (q) =>
          q.where('participantIds', isEqualTo: sorted).limit(1),
    );
    if (existing.docs.isNotEmpty) return existing.docs.first.id;

    final conversation = Conversation(id: '', participantIds: sorted);
    final doc = await _firestoreService.add(
      FirestoreCollections.conversations,
      conversation.toMap(),
    );
    return doc.id;
  }

  Stream<List<Conversation>> watchConversationsForUser(String userId) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.conversations,
          queryBuilder: (q) => q
              .where('participantIds', arrayContains: userId)
              .orderBy('lastMessageAt', descending: true),
        )
        .map((snapshot) => snapshot.docs.map(Conversation.fromFirestore).toList());
  }

  Stream<List<Message>> watchMessages(String conversationId) {
    return _firestoreService
        .streamCollection(
          _messagesPath(conversationId),
          queryBuilder: (q) => q.orderBy('sentAt'),
        )
        .map((snapshot) => snapshot.docs.map(Message.fromFirestore).toList());
  }

  Future<void> sendMessage(String conversationId, Message message) async {
    await _firestoreService.add(
      _messagesPath(conversationId),
      message.toMap(),
    );
    await _firestoreService.update(
      FirestoreCollections.conversations,
      conversationId,
      {
        'lastMessage': message.text,
        'lastMessageAt': DateTime.now().toUtc(),
      },
    );
  }
}
