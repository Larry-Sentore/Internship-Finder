// Authenticated app shell: bottom-nav tabs, swapping Post/My Applications by role.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../models/app_user.dart';
import '../../auth/providers/auth_providers.dart';

@RoutePage(name: 'HomeRoute')
class HomeShellScreen extends ConsumerWidget {
  const HomeShellScreen({super.key});

  // Builds the bottom tab bar and shows a different second tab depending on the person's role.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(currentAppUserProvider).value;
    final isStartupOwner = appUser?.role == UserRole.startupOwner;

    return AutoTabsRouter(
      routes: [
        const FeedRoute(),
        // Startup owners get a tab to post opportunities; students get one to track their applications.
        if (isStartupOwner) const PostOpportunityRoute() else const MyApplicationsRoute(),
        // Startup owners also get a tab to review everyone who applied to their postings.
        if (isStartupOwner) const MyApplicantsRoute(),
        const ConversationsRoute(),
        const ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: tabsRouter.setActiveIndex,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Feed',
              ),
              // This label and icon must match the tab picked above.
              if (isStartupOwner)
                const NavigationDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle),
                  label: 'Post',
                )
              else
                const NavigationDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment),
                  label: 'Applications',
                ),
              // Lets startup owners review everyone who applied to their postings.
              if (isStartupOwner)
                const NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Applicants',
                ),
              const NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline),
                selectedIcon: Icon(Icons.chat_bubble),
                label: 'Messages',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
