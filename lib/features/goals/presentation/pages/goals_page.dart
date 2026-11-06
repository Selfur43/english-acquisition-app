import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/phase2_providers.dart';

final class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning goals'),
        actions: [
          IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home),
            tooltip: 'Home',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/goals/edit'),
        icon: const Icon(Icons.add),
        label: const Text('New goal'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Goals could not be loaded: $error')),
        data: (controller) => ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            if (controller.goals.isEmpty) {
              return const Center(
                child: Text(
                  'No goals yet. Create the first occupational English goal.',
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: controller.goals.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final goal = controller.goals[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${goal.priority}')),
                    title: Text(goal.title),
                    subtitle: Text(
                      '${goal.occupationalContext}\n${goal.status.name}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          context.go('/goals/edit?id=${goal.id}');
                        }
                        if (value == 'delete') {
                          controller.delete(goal.id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
