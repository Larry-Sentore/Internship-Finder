// Screen where a startup owner reviews everyone who applied across all of their postings.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../post_opportunity/providers/post_opportunity_providers.dart';
import '../providers/application_providers.dart';
import '../widgets/applicant_card.dart';

@RoutePage(name: 'MyApplicantsRoute')
class MyApplicantsScreen extends ConsumerWidget {
  const MyApplicantsScreen({super.key});

  // Loads the signed-in owner's startup, then every application submitted to any of its postings.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(myStartupProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Applicants', style: AppTextStyles.headingSmall),
      ),
      body: startup.when(
        data: (startup) {
          if (startup == null) {
            return const EmptyState(
              icon: Icons.storefront_outlined,
              title: 'No startup found for your account yet.',
            );
          }
          return _ApplicantsList(startupId: startup.id);
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load applicants',
          subtitle: '$error',
        ),
      ),
    );
  }
}

class _ApplicantsList extends ConsumerWidget {
  const _ApplicantsList({required this.startupId});

  final String startupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsByStartupProvider(startupId));

    return applications.when(
      data: (list) {
        if (list.isEmpty) {
          return const EmptyState(
            icon: Icons.people_outline,
            title: 'No applicants yet',
            subtitle: 'Students who apply to any of your postings will show up here.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            for (final application in list)
              ApplicantCard(application: application, showOpportunityTitle: true),
          ],
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load applicants',
        subtitle: '$error',
      ),
    );
  }
}
