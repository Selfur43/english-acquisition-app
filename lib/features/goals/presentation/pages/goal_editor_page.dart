import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/phase2_providers.dart';
import '../../domain/entities/learner_goal.dart';

final class GoalEditorPage extends ConsumerStatefulWidget {
  const GoalEditorPage({this.goalId, super.key});
  final String? goalId;
  @override
  ConsumerState<GoalEditorPage> createState() => _State();
}

final class _State extends ConsumerState<GoalEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _context = TextEditingController(text: 'Procurement communication');
  int _priority = 1;
  GoalStatus _status = GoalStatus.active;
  bool _seeded = false;
  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _context.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goalId == null ? 'Create goal' : 'Edit goal'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('$e')),
        data: (controller) {
          LearnerGoal? existing;
          if (widget.goalId != null) {
            for (final g in controller.goals) {
              if (g.id == widget.goalId) existing = g;
            }
          }
          if (!_seeded && existing != null) {
            _title.text = existing.title;
            _description.text = existing.description;
            _context.text = existing.occupationalContext;
            _priority = existing.priority;
            _status = existing.status;
            _seeded = true;
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    TextFormField(
                      controller: _title,
                      decoration: const InputDecoration(
                        labelText: 'Goal title',
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _context,
                      decoration: const InputDecoration(
                        labelText: 'Occupational context',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: [1, 2, 3, 4, 5]
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text('$e')),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _priority = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<GoalStatus>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: GoalStatus.values
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text(e.name)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _status = v!),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: controller.isBusy
                          ? null
                          : () => _save(controller, existing),
                      child: Text(
                        controller.isBusy ? 'Saving...' : 'Save goal',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _save(dynamic controller, LearnerGoal? existing) async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now().toUtc();
    final goal = LearnerGoal(
      createdAt: existing?.createdAt ?? now,
      description: _description.text.trim(),
      id:
          existing?.id ??
          '${controller.learnerId}-${now.microsecondsSinceEpoch}',
      learnerId: controller.learnerId,
      occupationalContext: _context.text.trim(),
      priority: _priority,
      status: _status,
      title: _title.text.trim(),
      updatedAt: now,
    );
    if (await controller.save(goal) && mounted) context.go('/goals');
  }
}
