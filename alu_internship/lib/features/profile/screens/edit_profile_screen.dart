// Screen for a student to edit their profile details and skills.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/app_user.dart';
import '../../../models/student_profile.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/profile_providers.dart';

@RoutePage(name: 'EditProfileRoute')
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _skillsController = TextEditingController();
  final _interestsController = TextEditingController();
  final _resumeUrlController = TextEditingController();
  bool _fieldsPopulated = false;
  bool _isSaving = false;

  // Clears the text fields from memory when this screen closes.
  @override
  void dispose() {
    _skillsController.dispose();
    _interestsController.dispose();
    _resumeUrlController.dispose();
    super.dispose();
  }

  // Fills the text fields with the student's saved profile, but only the first time it loads,
  // so it doesn't overwrite anything they're in the middle of typing.
  void _populateFields(StudentProfile? profile) {
    if (_fieldsPopulated || profile == null) return;
    _fieldsPopulated = true;
    _skillsController.text = profile.skills.join(', ');
    _interestsController.text = profile.interests.join(', ');
    _resumeUrlController.text = profile.resumeUrl ?? '';
  }

  // Saves the skills, interests, and resume link the student typed in.
  Future<void> _handleSave() async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    setState(() => _isSaving = true);
    try {
      // Turns the comma-separated text into proper lists, e.g. "Dart, Flutter" -> [Dart, Flutter].
      final skills = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      final interests = _interestsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      final resumeUrl = _resumeUrlController.text.trim();

      await ref
          .read(studentProfileRepositoryProvider)
          .setProfile(
            StudentProfile(
              uid: user.uid,
              skills: skills,
              interests: interests,
              resumeUrl: resumeUrl.isEmpty ? null : resumeUrl,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save profile: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // Draws the skills, interests, and resume fields. Startup owners don't see this section.
  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(currentAppUserProvider).value;
    final isStudent = appUser?.role == UserRole.student;
    final studentProfile = ref.watch(myStudentProfileProvider);

    if (isStudent) {
      studentProfile.whenData(_populateFields);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Edit Profile', style: AppTextStyles.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isStudent) ...[
              Text('Skills', style: AppTextStyles.headingSmall),
              SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _skillsController,
                decoration: InputDecoration(
                  hintText: 'Comma-separated, e.g., Flutter, Dart, Firebase',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text('Interests', style: AppTextStyles.headingSmall),
              SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _interestsController,
                decoration: InputDecoration(
                  hintText: 'Comma-separated, e.g., UX Design, Fintech',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text('Resume URL', style: AppTextStyles.headingSmall),
              SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _resumeUrlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://...',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Startup owners will see this resume link when you apply.',
                style: AppTextStyles.caption,
              ),
              SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          'Save',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
