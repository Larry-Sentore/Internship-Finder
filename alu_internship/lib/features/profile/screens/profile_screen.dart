// Screen displaying a student's profile/portfolio.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/app_user.dart';
import '../../../models/application.dart';
import '../../applications/providers/application_providers.dart';
import '../../auth/providers/auth_providers.dart';

@RoutePage(name: 'ProfileRoute')
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(currentAppUserProvider).value;
    final applications = ref.watch(myApplicationsProvider).value ?? const [];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Row(
              children: [
                Text('Profile', style: AppTextStyles.headingLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: appUser?.photoUrl != null
                        ? NetworkImage(appUser!.photoUrl!)
                        : null,
                    child: appUser?.photoUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    appUser?.displayName ?? '',
                    style: AppTextStyles.headingMedium,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    appUser?.email ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            if (appUser?.role == UserRole.student) ...[
              SizedBox(height: AppSpacing.xl),
              _ApplicationStats(applications: applications),
            ],
            SizedBox(height: AppSpacing.xl),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _ProfileRow(
                    icon: Icons.badge_outlined,
                    label: 'My Profile',
                    onTap: () =>
                        context.router.push(const EditProfileRoute()),
                  ),
                  _ProfileRow(
                    icon: Icons.interests_outlined,
                    label: 'Skills & Interests',
                    onTap: () =>
                        context.router.push(const EditProfileRoute()),
                  ),
                  _ProfileRow(
                    icon: Icons.bookmark_border,
                    label: 'Saved Opportunities',
                    onTap: () => context.router.push(const BookmarksRoute()),
                  ),
                  _ProfileRow(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  _ProfileRow(
                    icon: Icons.logout,
                    label: 'Logout',
                    color: AppColors.error,
                    showDivider: false,
                    onTap: () async {
                      await ref.read(authRepositoryProvider).signOut();
                      if (!context.mounted) return;
                      context.router.replaceAll([const LoginRoute()]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationStats extends StatelessWidget {
  const _ApplicationStats({required this.applications});

  final List<Application> applications;

  @override
  Widget build(BuildContext context) {
    final shortlisted = applications
        .where((a) => a.status == ApplicationStatus.underReview)
        .length;
    final accepted = applications
        .where((a) => a.status == ApplicationStatus.accepted)
        .length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(value: applications.length, label: 'Applications'),
        _StatItem(value: shortlisted, label: 'Shortlisted'),
        _StatItem(value: accepted, label: 'Accepted'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: AppTextStyles.statValue),
        SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTextStyles.statLabel),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color ?? AppColors.primary),
          title: Text(
            label,
            style: AppTextStyles.bodyLarge.copyWith(color: color),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.cardBorder, indent: 16),
      ],
    );
  }
}
