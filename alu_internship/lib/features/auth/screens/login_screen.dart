// Login screen UI for existing users.
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alu_internship/core/theme/app_theme.dart';
import 'package:alu_internship/core/router/app_router.dart';
import 'package:alu_internship/features/auth/providers/auth_providers.dart';

@RoutePage(name: 'LoginRoute')
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!formkey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
      if (!mounted) return;
      context.router.replaceAll([const HomeRoute()]);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Invalid email or password')),
      );
    } catch (e, stackTrace) {
      debugPrint('Login failed: $e\n$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                      Text("Welcome Back", style: AppTextStyles.headingLarge),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        "Sign in to stay connected with your campus community",
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
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
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
                                  "Login",
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
                          Text("Don't have an account? ", style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () =>
                                context.router.push(const RoleSelectionRoute()),
                            child: Text(
                              "Sign up",
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
