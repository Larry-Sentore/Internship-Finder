// Data model for a single chat message within a conversation.
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final bool read;
  final DateTime? sentAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    this.read = false,
    this.sentAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'text': text,
      'read': read,
      'sentAt': FieldValue.serverTimestamp(),
    };
  }

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      conversationId: map['conversationId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      read: map['read'] as bool? ?? false,
      sentAt: (map['sentAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Message.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Message.fromMap(doc.id, doc.data() ?? {});
  }
}
