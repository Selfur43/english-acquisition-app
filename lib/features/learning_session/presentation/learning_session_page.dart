import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/phase2_providers.dart';
import '../curriculum.dart';
import '../learning_session.dart';

final class LearningSessionPage extends ConsumerStatefulWidget {
  const LearningSessionPage({super.key});
  @override
  ConsumerState<LearningSessionPage> createState() => _S();
}

final class _S extends ConsumerState<LearningSessionPage> {
  final answer = TextEditingController();
  @override
  void dispose() {
    answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learningSessionControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('AI-guided practice')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('$e')),
        data: (c) => ListenableBuilder(
          listenable: c,
          builder: (context, child) {
            final a = c.current, s = c.session;
            if (s == null) {
              return Center(
                child: FilledButton(
                  onPressed: c.start,
                  child: const Text('Start'),
                ),
              );
            }
            if (a == null || s.status == LearningSessionStatus.completed) {
              return Center(
                child: FilledButton(
                  onPressed: () => context.go('/progress'),
                  child: const Text('View progress'),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(28),
              children: [
                LinearProgressIndicator(value: s.currentStep / s.totalSteps),
                Text(
                  'Activity ${s.currentStep + 1} of ${s.totalSteps} • ${a.skill.name}',
                ),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(a.explanation),
                        Text('Türkçe: ${a.translation}'),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(a.prompt),
                  ),
                ),
                if (a.options.isNotEmpty)
                  Wrap(
                    children: [
                      for (final o in a.options)
                        ChoiceChip(
                          label: Text(o),
                          selected: answer.text == o,
                          onSelected: c.feedback == null
                              ? (v) {
                                  if (v) {
                                    setState(() => answer.text = o);
                                  }
                                }
                              : null,
                        ),
                    ],
                  ),
                if (a.options.isEmpty)
                  TextField(
                    controller: answer,
                    enabled: c.feedback == null,
                    minLines:
                        a.kind == ActivityKind.writing ||
                            a.kind == ActivityKind.simulation
                        ? 4
                        : 1,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      labelText: 'Your English response',
                    ),
                  ),
                if (c.errorMessage != null) Text(c.errorMessage!),
                if (c.feedback == null)
                  FilledButton.icon(
                    onPressed: () => c.check(answer.text),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Ask AI Coach'),
                  ),
                if (c.feedback != null)
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Coach • ${c.feedback!.score}/100'),
                          Text(c.feedback!.message),
                          for (final x in c.feedback!.strengths) Text('✓ $x'),
                          for (final x in c.feedback!.targets) Text('• $x'),
                          Text('Model: ${c.feedback!.model}'),
                          FilledButton(
                            onPressed: () {
                              answer.clear();
                              c.next();
                            },
                            child: const Text('Continue'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
