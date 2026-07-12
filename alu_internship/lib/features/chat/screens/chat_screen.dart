// One-on-one chat screen for messaging between a student and a startup.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../models/message.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/chat_providers.dart';

@RoutePage(name: 'ChatRoute')
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    setState(() => _isSending = true);
    _messageController.clear();
    try {
      await ref
          .read(chatRepositoryProvider)
          .sendMessage(
            widget.conversationId,
            Message(
              id: '',
              conversationId: widget.conversationId,
              senderId: user.uid,
              text: text,
            ),
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not send message: $e')));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateChangesProvider).value;
    final conversation = ref.watch(conversationByIdProvider(widget.conversationId));
    final otherUid = conversation.value?.otherParticipant(currentUser?.uid ?? '');
    final otherUser = otherUid == null
        ? null
        : ref.watch(appUserByIdProvider(otherUid));
    final messages = ref.watch(messagesProvider(widget.conversationId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          otherUser?.value?.displayName ?? 'Chat',
          style: AppTextStyles.headingSmall,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                    icon: Icons.chat_bubble_outline,
                    title: 'No messages yet',
                    subtitle: 'Send the first message to start the conversation.',
                  );
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });
                return ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    for (final message in list)
                      _MessageBubble(
                        message: message,
                        isMine: message.senderId == currentUser?.uid,
                      ),
                  ],
                );
              },
              loading: () => const LoadingIndicator(),
              error: (error, _) => EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load messages',
                subtitle: '$error',
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.white),
                      onPressed: _isSending ? null : _handleSend,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine});

  final Message message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: isMine ? null : Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          message.text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isMine ? AppColors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
