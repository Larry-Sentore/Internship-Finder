// Initial route: waits for Firebase Auth state and routes to Login or Home accordingly.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../auth/providers/auth_providers.dart';

@RoutePage(name: 'SplashRoute')
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateChangesProvider, (previous, next) {
      next.whenData((user) {
        if (user == null) {
          context.router.replaceAll([const LoginRoute()]);
        }
      });
    });

    ref.listen(currentAppUserProvider, (previous, next) {
      next.whenData((appUser) {
        if (appUser != null) {
          context.router.replaceAll([const HomeRoute()]);
        }
      });
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
