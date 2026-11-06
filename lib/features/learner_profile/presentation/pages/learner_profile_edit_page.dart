import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/phase2_providers.dart';
import '../../domain/entities/learner_profile.dart';

final class LearnerProfileEditPage extends ConsumerStatefulWidget {
  const LearnerProfileEditPage({super.key});
  @override
  ConsumerState<LearnerProfileEditPage> createState() => _State();
}

final class _State extends ConsumerState<LearnerProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _displayName = TextEditingController();
  final _nativeLanguage = TextEditingController(text: 'Turkish');
  final _role = TextEditingController(text: 'Procurement');
  final _industry = TextEditingController(text: 'Automotive');
  final _experience = TextEditingController(text: '0');
  final _tasks = TextEditingController(
    text: 'Supplier meetings, RFQ clarification, delivery escalation',
  );
  final _accessibility = TextEditingController();
  String _level = 'B1';
  double _minutes = 25;
  bool _seeded = false;

  @override
  void dispose() {
    for (final value in [
      _displayName,
      _nativeLanguage,
      _role,
      _industry,
      _experience,
      _tasks,
      _accessibility,
    ]) {
      value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learnerProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit learner profile')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (controller) {
          if (!_seeded) {
            final p = controller.profile;
            if (p != null) {
              _displayName.text = p.displayName;
              _nativeLanguage.text = p.nativeLanguage;
              _role.text = p.occupationalRole;
              _industry.text = p.industry;
              _experience.text = '${p.procurementExperienceYears}';
              _tasks.text = p.communicationTasks;
              _accessibility.text = p.accessibilityNotes;
              _level = p.englishLevel;
              _minutes = p.preferredSessionMinutes.toDouble();
            }
            _seeded = true;
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    TextFormField(
                      controller: _displayName,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nativeLanguage,
                      decoration: const InputDecoration(
                        labelText: 'Native language',
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _level,
                      decoration: const InputDecoration(
                        labelText: 'Current English level',
                      ),
                      items: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _level = v!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _role,
                      decoration: const InputDecoration(
                        labelText: 'Occupational role',
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _industry,
                      decoration: const InputDecoration(labelText: 'Industry'),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _experience,
                      decoration: const InputDecoration(
                        labelText: 'Procurement experience (years)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tasks,
                      decoration: const InputDecoration(
                        labelText: 'Recurring English communication tasks',
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    Text('Preferred session: ${_minutes.round()} minutes'),
                    Slider(
                      value: _minutes,
                      min: 10,
                      max: 60,
                      divisions: 10,
                      label: '${_minutes.round()}',
                      onChanged: (v) => setState(() => _minutes = v),
                    ),
                    TextFormField(
                      controller: _accessibility,
                      decoration: const InputDecoration(
                        labelText: 'Accessibility preferences or notes',
                      ),
                      minLines: 2,
                      maxLines: 3,
                    ),
                    if (controller.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          controller.errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: controller.isBusy
                          ? null
                          : () => _save(controller),
                      child: Text(
                        controller.isBusy ? 'Saving...' : 'Save profile',
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

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;
  Future<void> _save(dynamic controller) async {
    if (!_formKey.currentState!.validate()) return;
    final value = LearnerProfile(
      accessibilityNotes: _accessibility.text.trim(),
      communicationTasks: _tasks.text.trim(),
      displayName: _displayName.text.trim(),
      englishLevel: _level,
      industry: _industry.text.trim(),
      learnerId: controller.learnerId,
      nativeLanguage: _nativeLanguage.text.trim(),
      occupationalRole: _role.text.trim(),
      preferredSessionMinutes: _minutes.round(),
      procurementExperienceYears: int.tryParse(_experience.text) ?? 0,
      updatedAt: DateTime.now().toUtc(),
    );
    if (await controller.save(value) && mounted) context.go('/profile');
  }
}
