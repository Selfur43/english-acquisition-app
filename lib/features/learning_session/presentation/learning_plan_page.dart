import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/phase2_providers.dart';
import '../learning_session.dart';

final class LearningPlanPage extends ConsumerWidget {
  const LearningPlanPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learningSessionControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive learning plan'),
        actions: [
          IconButton(
            onPressed: () => context.go('/progress'),
            icon: const Icon(Icons.insights),
          ),
          IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('$e')),
        data: (c) => ListenableBuilder(
          listenable: c,
          builder: (context, child) => ListView(
            padding: const EdgeInsets.all(28),
            children: [
              Text(
                '8 activities from an 18-activity curriculum',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text('Mastery ${(c.overallMastery * 100).round()}%'),
              for (var i = 0; i < c.queue.length; i++)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(c.queue[i].title),
                    subtitle: Text(
                      '${c.queue[i].skill.name} • ${c.queue[i].translation}',
                    ),
                  ),
                ),
              FilledButton.icon(
                onPressed: () {
                  if (c.session == null ||
                      c.session!.status == LearningSessionStatus.completed) {
                    c.start();
                  }
                  context.go('/session');
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  c.session?.status == LearningSessionStatus.active
                      ? 'Resume session'
                      : 'Start adaptive session',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
