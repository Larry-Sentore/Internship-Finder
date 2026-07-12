// Screen for a startup owner to post a new internship/opportunity listing.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../models/opportunity.dart';
import '../../../models/startup.dart';
import '../../opportunities/providers/opportunity_providers.dart';
import '../providers/post_opportunity_providers.dart';

@RoutePage(name: 'PostOpportunityRoute')
class PostOpportunityScreen extends ConsumerStatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  ConsumerState<PostOpportunityScreen> createState() =>
      _PostOpportunityScreenState();
}

class _PostOpportunityScreenState
    extends ConsumerState<PostOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _commitmentController = TextEditingController();
  final _locationController = TextEditingController();
  OpportunityCategory _category = OpportunityCategory.softwareDevelopment;
  bool _isSubmitting = false;

  // Clears the text fields from memory when this screen closes.
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    _commitmentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Saves the new opportunity to the database, then empties the form so another can be posted.
  Future<void> _handleSubmit(Startup startup) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      // Turns the comma-separated skills text into a proper list, e.g. "Dart, Flutter" -> [Dart, Flutter].
      final skills = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      await ref
          .read(opportunityRepositoryProvider)
          .createOpportunity(
            Opportunity(
              id: '',
              startupId: startup.id,
              postedBy: startup.ownerId,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              category: _category,
              skillsRequired: skills,
              commitment: _commitmentController.text.trim(),
              location: _locationController.text.trim(),
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Opportunity posted!')));
      _formKey.currentState!.reset();
      _titleController.clear();
      _descriptionController.clear();
      _skillsController.clear();
      _commitmentController.clear();
      _locationController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not post opportunity: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // Loads the owner's startup first, since every opportunity needs to be linked to one.
  @override
  Widget build(BuildContext context) {
    final myStartup = ref.watch(myStartupProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Post Opportunity', style: AppTextStyles.headingSmall),
      ),
      body: myStartup.when(
        data: (startup) {
          if (startup == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'No startup found for your account yet.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _VerificationNotice(startup: startup),
                  SizedBox(height: AppSpacing.xl),
                  Text('Title', style: AppTextStyles.headingSmall),
                  SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _titleController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter a title'
                        : null,
                    decoration: InputDecoration(
                      hintText: 'e.g., Flutter Developer',
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text('Category', style: AppTextStyles.headingSmall),
                  SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<OpportunityCategory>(
                    initialValue: _category,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [
                      for (final category in OpportunityCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.displayLabel),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _category = value);
                    },
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text('Commitment', style: AppTextStyles.headingSmall),
                  SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _commitmentController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter a commitment'
                        : null,
                    decoration: InputDecoration(
                      hintText: 'e.g., Part-time (8-10 hrs/week)',
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text('Location', style: AppTextStyles.headingSmall),
                  SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _locationController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter a location'
                        : null,
                    decoration: InputDecoration(
                      hintText: 'e.g., On-campus, Remote, Kigali',
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text('Skills required', style: AppTextStyles.headingSmall),
                  SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _skillsController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter at least one skill'
                        : null,
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
                  Text('Description', style: AppTextStyles.headingSmall),
                  SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please describe the opportunity'
                        : null,
                    decoration: InputDecoration(
                      hintText: 'What will the student work on?',
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => _handleSubmit(startup),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.button,
                          ),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              'Post Opportunity',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => Center(
          child: Text('Could not load your startup: $error'),
        ),
      ),
    );
  }
}

// A small warning banner reminding the owner their startup isn't ALU-verified yet.
class _VerificationNotice extends StatelessWidget {
  const _VerificationNotice({required this.startup});

  final Startup startup;

  @override
  Widget build(BuildContext context) {
    // Hides itself once the startup has been verified.
    if (startup.isVerified) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          const Icon(Icons.hourglass_top, color: AppColors.warning),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${startup.name} is still pending ALU verification. '
              'You can prepare your posting now.',
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
