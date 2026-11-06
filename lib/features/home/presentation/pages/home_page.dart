import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/phase2_providers.dart';
import '../../../authentication/authentication.dart';
import '../../../learning_session/learning_session.dart';

final class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authentication = ref.watch(authenticationControllerProvider);
    final profileState = ref.watch(learnerProfileControllerProvider);
    final goalsState = ref.watch(goalsControllerProvider);
    final learningState = ref.watch(learningSessionControllerProvider);

    return ListenableBuilder(
      listenable: authentication,
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Today'),
          actions: [
            TextButton.icon(
              onPressed: () => context.go('/simulations'),
              icon: const Icon(Icons.record_voice_over),
              label: const Text('Simulation lab'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () => context.go('/insights'),
              icon: const Icon(Icons.insights),
              label: const Text('Learning insights'),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: FilledButton.tonalIcon(
                onPressed: () => _switchProfile(ref, authentication),
                icon: const Icon(Icons.switch_account),
                label: const Text('Switch profile'),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1060),
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Text(
                  'Welcome, ${authentication.user?.displayName ?? 'Learner'}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Continue your occupational English development.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Active private profile: ${authentication.user?.displayName ?? 'Learner'} â€¢ PIN required again after every restart',
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _switchProfile(ref, authentication),
                          icon: const Icon(Icons.lock),
                          label: const Text('Lock now'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _SummaryCard(
                      icon: Icons.person,
                      title: 'Learner profile',
                      body: profileState.when(
                        loading: () => 'Loading...',
                        error: (error, stackTrace) => 'Needs attention',
                        data: (controller) => controller.profile == null
                            ? 'Not created'
                            : controller.profile!.isComplete
                            ? 'Complete'
                            : 'Incomplete',
                      ),
                      actionLabel: 'Open profile',
                      onTap: () => context.go('/profile'),
                    ),
                    _SummaryCard(
                      icon: Icons.flag,
                      title: 'Active goals',
                      body: goalsState.when(
                        loading: () => 'Loading...',
                        error: (error, stackTrace) => 'Needs attention',
                        data: (controller) =>
                            '${controller.goals.where((goal) => goal.status.name == 'active').length} active',
                      ),
                      actionLabel: 'Open goals',
                      onTap: () => context.go('/goals'),
                    ),
                    _SummaryCard(
                      icon: Icons.school,
                      title: 'Next learning action',
                      body: learningState.when(
                        loading: () => 'Preparing learning plan...',
                        error: (error, stackTrace) =>
                            'Learning plan needs attention',
                        data: (controller) {
                          final session = controller.session;
                          if (session?.status == LearningSessionStatus.active) {
                            return 'Resume step ${session!.currentStep + 1} of 3';
                          }
                          if (controller.history.isNotEmpty) {
                            return '${controller.history.length} session completed';
                          }
                          return 'Start today\'s procurement learning plan';
                        },
                      ),
                      actionLabel: 'Open learning plan',
                      emphasized: true,
                      onTap: () => context.go('/learning-plan'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended setup',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        _SetupStep(
                          icon: Icons.person,
                          title: 'Create your learner profile',
                          detail:
                              'Set level, role, industry, session length, and accessibility preferences.',
                          action: 'Open profile',
                          onTap: () => context.go('/profile'),
                        ),
                        const Divider(),
                        _SetupStep(
                          icon: Icons.flag,
                          title: 'Add a practical goal',
                          detail:
                              'Connect daily learning to procurement and workplace communication tasks.',
                          action: 'Open goals',
                          onTap: () => context.go('/goals'),
                        ),
                        const Divider(),
                        _SetupStep(
                          icon: Icons.insights,
                          title: 'Review private learning evidence',
                          detail:
                              'See mastery, completed sessions, todayâ€™s queue, and priority review items.',
                          action: 'View insights',
                          onTap: () => context.go('/insights'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.storage),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Private, learner-scoped progress',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Profiles, goals, learning sessions, and practice '
                                'responses are stored locally and separated by the '
                                'current learner ID. Active sessions can be resumed '
                                'after the application restarts.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _switchProfile(
  WidgetRef ref,
  AuthenticationController authentication,
) async {
  ref.invalidate(learnerProfileControllerProvider);
  ref.invalidate(goalsControllerProvider);
  ref.invalidate(learningSessionControllerProvider);
  await authentication.signOut();
}

final class _SetupStep extends StatelessWidget {
  const _SetupStep({
    required this.action,
    required this.detail,
    required this.icon,
    required this.onTap,
    required this.title,
  });
  final String action;
  final String detail;
  final IconData icon;
  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 28),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 3),
            Text(detail),
          ],
        ),
      ),
      TextButton(onPressed: onTap, child: Text(action)),
    ],
  );
}

final class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.actionLabel,
    required this.body,
    required this.icon,
    required this.onTap,
    required this.title,
    this.emphasized = false,
  });

  final String actionLabel;
  final String body;
  final bool emphasized;
  final IconData icon;
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: '$title. $body. $actionLabel',
      child: SizedBox(
        width: 300,
        child: Card(
          color: emphasized ? colorScheme.primaryContainer : null,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            mouseCursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: emphasized ? colorScheme.onPrimaryContainer : null,
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(body),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          actionLabel,
                          style: TextStyle(
                            color: emphasized
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
