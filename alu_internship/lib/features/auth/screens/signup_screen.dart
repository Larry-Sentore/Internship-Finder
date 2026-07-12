// Registration/onboarding screen for new students and startup owners.
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alu_internship/core/theme/app_theme.dart';
import 'package:alu_internship/core/router/app_router.dart';
import 'package:alu_internship/features/auth/providers/auth_providers.dart';
import 'package:alu_internship/features/post_opportunity/providers/post_opportunity_providers.dart';
import 'package:alu_internship/models/app_user.dart';
import 'package:alu_internship/models/startup.dart';

@RoutePage(name: 'SignupRoute')
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key, required this.role});

  final UserRole role;

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final startupNameController = TextEditingController();
  final startupIndustryController = TextEditingController();
  final startupWebsiteController = TextEditingController();
  final startupDescriptionController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // True when this sign-up form is being filled in by a startup founder, not a student.
  bool get _isStartupOwner => widget.role == UserRole.startupOwner;

  // Clears the text fields from memory when this screen closes.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    startupNameController.dispose();
    startupIndustryController.dispose();
    startupWebsiteController.dispose();
    startupDescriptionController.dispose();
    super.dispose();
  }

  // Creates the account, and if this is a startup founder, also creates their startup entry.
  Future<void> _handleSignup() async {
    if (!formkey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final appUser = await ref
          .read(authRepositoryProvider)
          .signUp(
            email: emailController.text.trim(),
            password: passwordController.text,
            displayName: fullNameController.text.trim(),
            role: widget.role,
          );

      // Only startup founders need a startup created alongside their account.
      if (_isStartupOwner) {
        await ref
            .read(startupRepositoryProvider)
            .createStartup(
              Startup(
                id: '',
                ownerId: appUser.uid,
                name: startupNameController.text.trim(),
                description: startupDescriptionController.text.trim(),
                industry: startupIndustryController.text.trim(),
                website: startupWebsiteController.text.trim().isEmpty
                    ? null
                    : startupWebsiteController.text.trim(),
              ),
            );
      }

      if (!mounted) return;
      context.router.replaceAll([const HomeRoute()]);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Sign up failed')));
    } catch (e, stackTrace) {
      debugPrint('Signup failed: $e\n$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Draws the sign-up form. Startup founders see extra fields for their startup's details.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(width: AppSpacing.md),
            Text(
              "ALU Intercampus",
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Icon(
                            Icons.lock,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xxl),
                      Text("Welcome", style: AppTextStyles.headingLarge),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        "Sign Up to stay connected with your campus community",
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email", style: AppTextStyles.labelMedium),
                            SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Please enter your email'
                                  : null,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.input,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.primary,
                                ),
                                hintText: "Enter your email",
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textMuted,
                                ),
                                filled: true,
                                fillColor: AppColors.primaryLight,
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg),
                            Text("Full Name", style: AppTextStyles.labelMedium),
                            SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: fullNameController,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Please enter your full name'
                                  : null,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.input,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.primary,
                                ),
                                hintText: "Enter your full name",
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textMuted,
                                ),
                                filled: true,
                                fillColor: AppColors.primaryLight,
                              ),
                            ),
                            // These extra fields about the startup only show up for founders.
                            if (_isStartupOwner) ...[
                              SizedBox(height: AppSpacing.lg),
                              Text(
                                "Startup Name",
                                style: AppTextStyles.labelMedium,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              TextFormField(
                                controller: startupNameController,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Please enter your startup name'
                                    : null,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.input,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.rocket_launch_outlined,
                                    color: AppColors.primary,
                                  ),
                                  hintText: "e.g., EduBridge",
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.primaryLight,
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),
                              Text("Industry", style: AppTextStyles.labelMedium),
                              SizedBox(height: AppSpacing.sm),
                              TextFormField(
                                controller: startupIndustryController,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Please enter an industry'
                                    : null,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.input,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.business_center_outlined,
                                    color: AppColors.primary,
                                  ),
                                  hintText: "e.g., EdTech, Fintech, Logistics",
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.primaryLight,
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),
                              Text(
                                "Website (optional)",
                                style: AppTextStyles.labelMedium,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              TextFormField(
                                controller: startupWebsiteController,
                                keyboardType: TextInputType.url,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.input,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.link,
                                    color: AppColors.primary,
                                  ),
                                  hintText: "https://...",
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.primaryLight,
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),
                              Text(
                                "Startup Description",
                                style: AppTextStyles.labelMedium,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              TextFormField(
                                controller: startupDescriptionController,
                                maxLines: 3,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Please describe your startup'
                                    : null,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.input,
                                    ),
                                  ),
                                  hintText: "What does your startup do?",
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.primaryLight,
                                ),
                              ),
                            ],
                            SizedBox(height: AppSpacing.lg),
                            Text("Password", style: AppTextStyles.labelMedium),
                            SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              obscureText: _obscurePassword,
                              controller: passwordController,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Please enter your password'
                                  : null,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.input,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primary,
                                ),
                                hintText: "Enter your password",
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textMuted,
                                ),
                                filled: true,
                                fillColor: AppColors.primaryLight,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.button,
                              ),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                              : Text(
                                  "Sign Up",
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        "—— or continue with ——",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.login,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              "Google",
                              style: AppTextStyles.labelMedium,
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                                vertical: AppSpacing.md,
                              ),
                              side: const BorderSide(color: AppColors.cardBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.button),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.lg),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.school, color: AppColors.primary),
                            label: Text("Edu Portal", style: AppTextStyles.labelMedium),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                                vertical: AppSpacing.md,
                              ),
                              side: const BorderSide(color: AppColors.cardBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.button),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ", style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () =>
                                context.router.replace(const LoginRoute()),
                            child: Text(
                              "Log in",
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
