import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/phase2_providers.dart';

final class LearnerProfilePage extends ConsumerWidget {
  const LearnerProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learnerProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learner profile'),
        actions: [
          IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home),
            tooltip: 'Home',
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Profile could not be loaded: $error')),
        data: (controller) => ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final profile = controller.profile;
            if (profile == null) {
              return Center(
                child: FilledButton(
                  onPressed: () => context.go('/profile/edit'),
                  child: const Text('Create profile'),
                ),
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      profile.displayName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        title: const Text('English level'),
                        subtitle: Text(profile.englishLevel),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Occupational role'),
                        subtitle: Text(
                          '${profile.occupationalRole} • ${profile.industry}',
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Communication priorities'),
                        subtitle: Text(profile.communicationTasks),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Preferred session'),
                        subtitle: Text(
                          '${profile.preferredSessionMinutes} minutes',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => context.go('/profile/edit'),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit profile'),
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
