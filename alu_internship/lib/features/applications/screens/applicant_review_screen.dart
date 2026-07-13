// Screen for startup owners to review and act on applicants to their opportunity.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../opportunities/providers/opportunity_providers.dart';
import '../providers/application_providers.dart';
import '../widgets/applicant_card.dart';

@RoutePage(name: 'ApplicantReviewRoute')
class ApplicantReviewScreen extends ConsumerWidget {
  const ApplicantReviewScreen({super.key, required this.opportunityId});

  final String opportunityId;

  // Loads the opportunity's title and the list of people who applied to it, then shows them.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunity = ref.watch(opportunityByIdProvider(opportunityId));
    final applications = ref.watch(applicationsByOpportunityProvider(opportunityId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          opportunity.value?.title ?? 'Applicants',
          style: AppTextStyles.headingSmall,
        ),
      ),
      body: applications.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'No applicants yet',
              subtitle: 'Students who apply to this opportunity will show up here.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              for (final application in list)
                ApplicantCard(application: application),
            ],
          );
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
