// Onboarding screen where a new user picks student or startup-owner before signing up.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:alu_internship/core/theme/app_theme.dart';
import 'package:alu_internship/core/router/app_router.dart';
import 'package:alu_internship/models/app_user.dart';

@RoutePage(name: 'RoleSelectionRoute')
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  // Shows two cards so the new user can pick whether they are a student or a startup founder.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          "ALU Intercampus",
          style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("How will you use ALU Intercampus?", style: AppTextStyles.headingLarge, textAlign: TextAlign.center),
                SizedBox(height: AppSpacing.sm),
                Text(
                  "This determines what you'll see and do on the platform.",
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xxl),
                // Picking this sends the student to sign up with the student role already chosen.
                _RoleCard(
                  icon: Icons.school_outlined,
                  title: "I'm a Student",
                  subtitle: "Discover internships and apply to student-led startups",
                  onTap: () => context.router.push(
                    SignupRoute(role: UserRole.student),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                // Picking this sends the founder to sign up with the startup-owner role chosen.
                _RoleCard(
                  icon: Icons.rocket_launch_outlined,
                  title: "I'm a Startup Founder",
                  subtitle: "Post opportunities and find student talent",
                  onTap: () => context.router.push(
                    SignupRoute(role: UserRole.startupOwner),
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: AppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () => context.router.replace(const LoginRoute()),
                      child: Text(
                        "Log in",
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// One tappable card showing an icon, a title, and a short description.
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headingSmall),
                  SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
