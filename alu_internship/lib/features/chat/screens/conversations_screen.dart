// Screen listing the current user's chat conversations.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../models/conversation.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/chat_providers.dart';

@RoutePage(name: 'ConversationsRoute')
class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  // Loads and lists every conversation the signed-in person is part of.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(myConversationsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Messages', style: AppTextStyles.headingSmall),
      ),
      body: conversations.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.chat_bubble_outline,
              title: 'No conversations yet',
              subtitle: 'Messages with startups and students will show up here.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              for (final conversation in list)
                _ConversationCard(conversation: conversation),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load conversations',
          subtitle: '$error',
        ),
      ),
    );
  }
}

// One row in the conversation list: the other person's photo, name, last message, and time.
class _ConversationCard extends ConsumerWidget {
  const _ConversationCard({required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateChangesProvider).value;
    // A conversation only stores two ids, so this finds the one that isn't me.
    final otherUid = conversation.otherParticipant(currentUser?.uid ?? '');
    final otherUser = ref.watch(appUserByIdProvider(otherUid));

    return InkWell(
      // Tapping a row opens the full chat with that person.
      onTap: () => context.router.push(ChatRoute(conversationId: conversation.id)),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: otherUser.value?.photoUrl != null
                  ? NetworkImage(otherUser.value!.photoUrl!)
                  : null,
              child: otherUser.value?.photoUrl == null
                  ? const Icon(Icons.person, color: AppColors.primary)
                  : null,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.value?.displayName ?? '',
                    style: AppTextStyles.headingSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    conversation.lastMessage ?? 'Say hello!',
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(_timeAgo(conversation.lastMessageAt), style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  // Turns the last message's timestamp into a short label like "now", "5m", "2h", or "3d".
  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
