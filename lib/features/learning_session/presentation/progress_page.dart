import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/phase2_providers.dart';
import '../curriculum.dart';
import '../learning_session.dart';

final class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learningSessionControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: [
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
                'Overall mastery ${(c.overallMastery * 100).round()}%',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              for (final skill in LearningSkill.values)
                Card(
                  child: ListTile(
                    title: Text(skill.name),
                    subtitle: LinearProgressIndicator(
                      value: _v(c.mastery, skill.name),
                    ),
                    trailing: Text(
                      '${(_v(c.mastery, skill.name) * 100).round()}%',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _v(List<MasteryRecord> r, String s) {
    final v = r.where((x) => x.skill == s).map((x) => x.mastery).toList();
    return v.isEmpty ? 0 : v.reduce((a, b) => a + b) / v.length;
  }
}
