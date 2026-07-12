// Riverpod providers exposing conversation/message state to the UI.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/conversation.dart';
import '../../../models/message.dart';
import '../../../repositories/chat_repository.dart';
import '../../auth/providers/auth_providers.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

/// The signed-in user's conversations, most recently active first.
final myConversationsProvider = StreamProvider.autoDispose<List<Conversation>>((
  ref,
) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(const []);
  return ref.watch(chatRepositoryProvider).watchConversationsForUser(user.uid);
});

final conversationByIdProvider = StreamProvider.autoDispose
    .family<Conversation?, String>((ref, conversationId) {
      return ref.watch(chatRepositoryProvider).watchConversation(conversationId);
    });

final messagesProvider = StreamProvider.autoDispose.family<List<Message>, String>((
  ref,
  conversationId,
) {
  return ref.watch(chatRepositoryProvider).watchMessages(conversationId);
});
