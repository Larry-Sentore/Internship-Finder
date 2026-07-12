// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ApplicantReviewScreen]
class ApplicantReviewRoute extends PageRouteInfo<ApplicantReviewRouteArgs> {
  ApplicantReviewRoute({
    Key? key,
    required String opportunityId,
    List<PageRouteInfo>? children,
  }) : super(
         ApplicantReviewRoute.name,
         args: ApplicantReviewRouteArgs(key: key, opportunityId: opportunityId),
         initialChildren: children,
       );

  static const String name = 'ApplicantReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ApplicantReviewRouteArgs>();
      return ApplicantReviewScreen(
        key: args.key,
        opportunityId: args.opportunityId,
      );
    },
  );
}

class ApplicantReviewRouteArgs {
  const ApplicantReviewRouteArgs({this.key, required this.opportunityId});

  final Key? key;

  final String opportunityId;

  @override
  String toString() {
    return 'ApplicantReviewRouteArgs{key: $key, opportunityId: $opportunityId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ApplicantReviewRouteArgs) return false;
    return key == other.key && opportunityId == other.opportunityId;
  }

  @override
  int get hashCode => key.hashCode ^ opportunityId.hashCode;
}

/// generated route for
/// [BookmarksScreen]
class BookmarksRoute extends PageRouteInfo<void> {
  const BookmarksRoute({List<PageRouteInfo>? children})
    : super(BookmarksRoute.name, initialChildren: children);

  static const String name = 'BookmarksRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BookmarksScreen();
    },
  );
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required String conversationId,
    List<PageRouteInfo>? children,
  }) : super(
         ChatRoute.name,
         args: ChatRouteArgs(key: key, conversationId: conversationId),
         initialChildren: children,
       );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return ChatScreen(key: args.key, conversationId: args.conversationId);
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({this.key, required this.conversationId});

  final Key? key;

  final String conversationId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, conversationId: $conversationId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatRouteArgs) return false;
    return key == other.key && conversationId == other.conversationId;
  }

  @override
  int get hashCode => key.hashCode ^ conversationId.hashCode;
}

/// generated route for
/// [ConversationsScreen]
class ConversationsRoute extends PageRouteInfo<void> {
  const ConversationsRoute({List<PageRouteInfo>? children})
    : super(ConversationsRoute.name, initialChildren: children);

  static const String name = 'ConversationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ConversationsScreen();
    },
  );
}

/// generated route for
/// [EditProfileScreen]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfileScreen();
    },
  );
}

/// generated route for
/// [FeedScreen]
class FeedRoute extends PageRouteInfo<void> {
  const FeedRoute({List<PageRouteInfo>? children})
    : super(FeedRoute.name, initialChildren: children);

  static const String name = 'FeedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FeedScreen();
    },
  );
}

/// generated route for
/// [HomeShellScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeShellScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MyApplicationsScreen]
class MyApplicationsRoute extends PageRouteInfo<void> {
  const MyApplicationsRoute({List<PageRouteInfo>? children})
    : super(MyApplicationsRoute.name, initialChildren: children);

  static const String name = 'MyApplicationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyApplicationsScreen();
    },
  );
}

/// generated route for
/// [OpportunityDetailScreen]
class OpportunityDetailRoute extends PageRouteInfo<OpportunityDetailRouteArgs> {
  OpportunityDetailRoute({
    Key? key,
    required String opportunityId,
    List<PageRouteInfo>? children,
  }) : super(
         OpportunityDetailRoute.name,
         args: OpportunityDetailRouteArgs(
           key: key,
           opportunityId: opportunityId,
         ),
         initialChildren: children,
       );

  static const String name = 'OpportunityDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OpportunityDetailRouteArgs>();
      return OpportunityDetailScreen(
        key: args.key,
        opportunityId: args.opportunityId,
      );
    },
  );
}

class OpportunityDetailRouteArgs {
  const OpportunityDetailRouteArgs({this.key, required this.opportunityId});

  final Key? key;

  final String opportunityId;

  @override
  String toString() {
    return 'OpportunityDetailRouteArgs{key: $key, opportunityId: $opportunityId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OpportunityDetailRouteArgs) return false;
    return key == other.key && opportunityId == other.opportunityId;
  }

  @override
  int get hashCode => key.hashCode ^ opportunityId.hashCode;
}

/// generated route for
/// [PostOpportunityScreen]
class PostOpportunityRoute extends PageRouteInfo<void> {
  const PostOpportunityRoute({List<PageRouteInfo>? children})
    : super(PostOpportunityRoute.name, initialChildren: children);

  static const String name = 'PostOpportunityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PostOpportunityScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [RoleSelectionScreen]
class RoleSelectionRoute extends PageRouteInfo<void> {
  const RoleSelectionRoute({List<PageRouteInfo>? children})
    : super(RoleSelectionRoute.name, initialChildren: children);

  static const String name = 'RoleSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RoleSelectionScreen();
    },
  );
}

/// generated route for
/// [SignupScreen]
class SignupRoute extends PageRouteInfo<SignupRouteArgs> {
  SignupRoute({Key? key, required UserRole role, List<PageRouteInfo>? children})
    : super(
        SignupRoute.name,
        args: SignupRouteArgs(key: key, role: role),
        initialChildren: children,
      );

  static const String name = 'SignupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignupRouteArgs>();
      return SignupScreen(key: args.key, role: args.role);
    },
  );
}

class SignupRouteArgs {
  const SignupRouteArgs({this.key, required this.role});

  final Key? key;

  final UserRole role;

  @override
  String toString() {
    return 'SignupRouteArgs{key: $key, role: $role}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SignupRouteArgs) return false;
    return key == other.key && role == other.role;
  }

  @override
  int get hashCode => key.hashCode ^ role.hashCode;
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}
