// App-wide navigation/routing config (screen paths and route guards for auth state).
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/app_user.dart';
import '../../features/applications/screens/applicant_review_screen.dart';
import '../../features/applications/screens/my_applications_screen.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/role_selection_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/bookmarks/screens/bookmarks_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/chat/screens/conversations_screen.dart';
import '../../features/home/screens/home_shell_screen.dart';
import '../../features/opportunities/screens/detail_screen.dart';
import '../../features/opportunities/screens/feed_screen.dart';
import '../../features/post_opportunity/screens/post_opportunity_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/splash/screens/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

  final Ref ref;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: RoleSelectionRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignupRoute.page),
    AutoRoute(
      page: HomeRoute.page,
      guards: [AuthGuard(ref)],
      children: [
        AutoRoute(page: FeedRoute.page, initial: true),
        AutoRoute(page: PostOpportunityRoute.page),
        AutoRoute(page: MyApplicationsRoute.page),
        AutoRoute(page: ConversationsRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: OpportunityDetailRoute.page, guards: [AuthGuard(ref)]),
    AutoRoute(page: BookmarksRoute.page, guards: [AuthGuard(ref)]),
    AutoRoute(page: ApplicantReviewRoute.page, guards: [AuthGuard(ref)]),
    AutoRoute(page: EditProfileRoute.page, guards: [AuthGuard(ref)]),
    AutoRoute(page: ChatRoute.page, guards: [AuthGuard(ref)]),
  ];
}

/// Blocks navigation into authenticated routes when no user is signed in,
/// redirecting to the login screen instead.
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.ref);

  final Ref ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isSignedIn = ref.read(authRepositoryProvider).currentUser != null;
    if (isSignedIn) {
      resolver.next(true);
    } else {
      resolver.next(false);
      router.replaceAll([const LoginRoute()]);
    }
  }
}
