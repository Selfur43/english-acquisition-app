import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/phase2_providers.dart';
import '../curriculum.dart';
import '../learning_session.dart';

final class LearningInsightsPage extends ConsumerWidget {
  const LearningInsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learningSessionControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning insights'),
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home),
            label: const Text('Today'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Insights could not be loaded: $error')),
        data: (controller) => ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final mastery = (controller.overallMastery * 100).round();
            final completed = controller.history
                .where(
                  (session) =>
                      session.status == LearningSessionStatus.completed,
                )
                .length;
            final weak = [...controller.mastery]
              ..sort((a, b) => a.mastery.compareTo(b.mastery));
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1060),
                child: ListView(
                  padding: const EdgeInsets.all(32),
                  children: [
                    Text(
                      'Private learning evidence',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'All metrics belong only to the currently unlocked local profile.',
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _MetricCard(
                          icon: Icons.insights,
                          label: 'Overall mastery',
                          value: '$mastery%',
                        ),
                        _MetricCard(
                          icon: Icons.task_alt,
                          label: 'Completed sessions',
                          value: '$completed',
                        ),
                        _MetricCard(
                          icon: Icons.school,
                          label: 'Curriculum activities',
                          value: '${ProcurementCurriculum.activities.length}',
                        ),
                        _MetricCard(
                          icon: Icons.playlist_play,
                          label: 'Today queue',
                          value: '${controller.queue.length}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt, size: 34),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.session == null
                                        ? 'Start today’s focused session'
                                        : 'Continue today’s active session',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.current == null
                                        ? 'The adaptive planner will prioritize lower-mastery activities.'
                                        : 'Next: ${controller.current!.title}',
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => context.go(
                                controller.session == null
                                    ? '/learning-plan'
                                    : '/session',
                              ),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Continue learning'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Priority review',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    if (weak.isEmpty)
                      const Card(
                        child: ListTile(
                          leading: Icon(Icons.info_outline),
                          title: Text(
                            'Complete activities to build mastery evidence.',
                          ),
                          subtitle: Text(
                            'The weakest skills will appear here automatically.',
                          ),
                        ),
                      )
                    else
                      for (final item in weak.take(5))
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${(item.mastery * 100).round()}%'),
                            ),
                            title: Text(item.activityId),
                            subtitle: Text(
                              '${item.skill} • ${item.attempts} attempts',
                            ),
                            trailing: SizedBox(
                              width: 180,
                              child: LinearProgressIndicator(
                                value: item.mastery,
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => context.go('/progress'),
                      icon: const Icon(Icons.bar_chart),
                      label: const Text('Open detailed skill progress'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 245,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineSmall),
                Text(label),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
