// Reusable icon button that opens (or starts) a conversation with a given user.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_providers.dart';
import '../../features/chat/providers/chat_providers.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';

class MessageUserButton extends ConsumerStatefulWidget {
  const MessageUserButton({super.key, required this.otherUserId});

  final String? otherUserId;

  @override
  ConsumerState<MessageUserButton> createState() => _MessageUserButtonState();
}

class _MessageUserButtonState extends ConsumerState<MessageUserButton> {
  bool _isLoading = false;

  Future<void> _handleMessage() async {
    final otherUserId = widget.otherUserId;
    final user = ref.read(authStateChangesProvider).value;
    if (otherUserId == null || user == null) return;

    setState(() => _isLoading = true);
    try {
      final conversationId = await ref
          .read(chatRepositoryProvider)
          .getOrCreateConversation([user.uid, otherUserId]);
      if (!mounted) return;
      context.router.push(ChatRoute(conversationId: conversationId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not start conversation: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: OutlinedButton(
        onPressed: _isLoading || widget.otherUserId == null
            ? null
            : _handleMessage,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.cardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
      ),
    );
  }
}
