import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class SimulationScenario {
  const SimulationScenario({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.minutes,
    required this.context,
    required this.objective,
    required this.roles,
    required this.pressure,
    required this.opening,
    required this.keyPhrases,
  });

  final String id;
  final String title;
  final String category;
  final String level;
  final int minutes;
  final String context;
  final String objective;
  final List<String> roles;
  final String pressure;
  final String opening;
  final List<String> keyPhrases;
}

const simulationScenarios = <SimulationScenario>[
  SimulationScenario(
    id: 'face-meeting',
    title: 'Face-to-face supplier negotiation',
    category: 'Business English',
    level: 'B2–C1',
    minutes: 18,
    context:
        'A supplier requests an 8% price increase two weeks before the quarterly review.',
    objective:
        'Clarify the cost drivers, protect continuity, and agree documented next steps.',
    roles: <String>[
      'You: Procurement specialist',
      'AI: Supplier account manager',
      'Observer: Finance partner',
    ],
    pressure:
        'The supplier may reduce allocation unless a decision is reached.',
    opening:
        'Thank you for meeting today. Our raw-material costs have increased, so we need an 8% adjustment from next month.',
    keyPhrases: <String>[
      'Could you break down the cost drivers?',
      'What evidence supports that increase?',
      'Let us separate urgent continuity from the longer-term price review.',
    ],
  ),
  SimulationScenario(
    id: 'factory-tour',
    title: 'Factory visit and production walk',
    category: 'Industrial English',
    level: 'B1–C1',
    minutes: 20,
    context:
        'You are visiting a supplier plant before approving a new production line.',
    objective:
        'Ask about capacity, quality controls, safety, maintenance, and bottlenecks.',
    roles: <String>[
      'You: Visiting buyer',
      'AI: Plant manager',
      'AI: Quality engineer',
    ],
    pressure:
        'A recent delivery was late and the customer launch date cannot move.',
    opening:
        'Welcome to the plant. We will begin at incoming inspection and then follow the complete production flow.',
    keyPhrases: <String>[
      'What is the current utilization rate?',
      'Where is the main bottleneck?',
      'How do you contain a non-conforming batch?',
    ],
  ),
  SimulationScenario(
    id: 'teams-delay',
    title: 'Teams meeting: delivery recovery',
    category: 'Business English',
    level: 'B1–B2',
    minutes: 14,
    context:
        'A cross-functional Teams call is held after a critical shipment missed the confirmed date.',
    objective:
        'Chair the call, distinguish facts from assumptions, assign owners, and confirm deadlines.',
    roles: <String>[
      'You: Meeting chair',
      'AI: Supplier planner',
      'AI: Logistics lead',
      'AI: Quality lead',
    ],
    pressure: 'Production may stop in 36 hours.',
    opening:
        'We have twenty minutes. Please state the confirmed quantity, location, and earliest realistic arrival time.',
    keyPhrases: <String>[
      'Let us verify the facts first.',
      'Who owns that action and by when?',
      'I will summarize the recovery plan before we close.',
    ],
  ),
  SimulationScenario(
    id: 'email-thread',
    title: 'Email chain: quotation clarification',
    category: 'Written English',
    level: 'A2–B2',
    minutes: 12,
    context:
        'A quotation contains unclear tooling, freight, payment, and lead-time assumptions.',
    objective:
        'Write a concise clarification email and respond to a partially helpful supplier reply.',
    roles: <String>['You: Buyer', 'AI: Sales representative'],
    pressure: 'The sourcing decision is due tomorrow at noon.',
    opening: 'Subject: Clarification required for quotation Q-4821',
    keyPhrases: <String>[
      'Could you please confirm whether…',
      'For comparison purposes, please separate…',
      'Unless otherwise stated, we will assume…',
    ],
  ),
  SimulationScenario(
    id: 'daily-small-talk',
    title: 'Everyday conversation and small talk',
    category: 'General English',
    level: 'A1–B1',
    minutes: 10,
    context:
        'You meet an international colleague before a workshop and continue over lunch.',
    objective:
        'Open, maintain, and close natural conversation without memorized scripts.',
    roles: <String>['You: Colleague', 'AI: International teammate'],
    pressure:
        'The conversation changes topic twice and includes an unfamiliar phrase.',
    opening:
        'Hi, I do not think we have met in person before. How was your journey?',
    keyPhrases: <String>[
      'How did you find…?',
      'That reminds me of…',
      'What do you mean by…?',
    ],
  ),
  SimulationScenario(
    id: 'presentation-qa',
    title: 'Presentation and challenging Q&A',
    category: 'Business English',
    level: 'B2–C1',
    minutes: 18,
    context:
        'You present a supplier-risk recommendation to senior stakeholders.',
    objective:
        'Structure the recommendation, explain data, handle interruption, and answer objections.',
    roles: <String>[
      'You: Presenter',
      'AI: Operations leader',
      'AI: Finance reviewer',
    ],
    pressure:
        'A stakeholder challenges the evidence and asks for a cheaper alternative.',
    opening:
        'You have five minutes. Please explain the recommendation, the risk, and the decision required.',
    keyPhrases: <String>[
      'The key decision today is…',
      'The evidence indicates…',
      'That is a fair challenge; the trade-off is…',
    ],
  ),
  SimulationScenario(
    id: 'quality-8d',
    title: 'Quality incident and 8D discussion',
    category: 'Industrial English',
    level: 'B2–C1',
    minutes: 20,
    context:
        'A dimensional defect has reached assembly and an 8D containment call starts.',
    objective:
        'Describe the defect precisely, request containment, challenge root-cause assumptions, and confirm evidence.',
    roles: <String>[
      'You: Customer quality representative',
      'AI: Supplier quality engineer',
    ],
    pressure: 'The next shipment departs in four hours.',
    opening:
        'We have quarantined 240 parts. Please confirm immediate containment at your plant and in transit.',
    keyPhrases: <String>[
      'What is the verified escape point?',
      'How will effectiveness be validated?',
      'Please distinguish correction from corrective action.',
    ],
  ),
  SimulationScenario(
    id: 'phone-call',
    title: 'Phone call: urgent logistics update',
    category: 'Listening & Speaking',
    level: 'A2–B2',
    minutes: 10,
    context:
        'The connection is imperfect and a carrier updates you about a customs delay.',
    objective:
        'Use clarification, read-back, spelling, dates, and numbers accurately.',
    roles: <String>['You: Shipment owner', 'AI: Carrier agent'],
    pressure: 'A wrong reference number will delay release by another day.',
    opening:
        'I am calling about shipment GML-7842. Customs needs one additional document before release.',
    keyPhrases: <String>[
      'Could you repeat the reference slowly?',
      'Let me read that back to you.',
      'Did you say fifteen or fifty?',
    ],
  ),
  SimulationScenario(
    id: 'performance-chat',
    title: 'One-to-one feedback conversation',
    category: 'General & Workplace English',
    level: 'B1–C1',
    minutes: 15,
    context:
        'A teammate repeatedly dominates meetings and misses follow-up actions.',
    objective:
        'Give specific respectful feedback, listen, and agree a measurable change.',
    roles: <String>['You: Project colleague', 'AI: Teammate'],
    pressure: 'The teammate disagrees with your first example.',
    opening:
        'You said you wanted to discuss how our project meetings are working. What would you like to raise?',
    keyPhrases: <String>[
      'When this happens, the impact is…',
      'I would like to understand your view.',
      'Can we agree to try…?',
    ],
  ),
  SimulationScenario(
    id: 'audit',
    title: 'Supplier audit interview',
    category: 'Industrial English',
    level: 'B2–C1',
    minutes: 22,
    context:
        'You audit traceability, change control, calibration, and training records.',
    objective:
        'Ask open and closed questions, request evidence, and record a neutral finding.',
    roles: <String>['You: Auditor', 'AI: Process owner', 'AI: Operator'],
    pressure:
        'The documented procedure and shop-floor practice do not fully match.',
    opening:
        'Please show how this batch is traced from incoming material to final inspection.',
    keyPhrases: <String>[
      'Could you show objective evidence?',
      'How is this change authorized?',
      'I will record this as an observation pending evidence.',
    ],
  ),
  SimulationScenario(
    id: 'travel',
    title: 'Travel disruption and hotel problem',
    category: 'General English',
    level: 'A2–B2',
    minutes: 12,
    context:
        'A cancelled flight causes a missed connection and the hotel cannot find the booking.',
    objective:
        'Explain the problem, compare options, make requests, and confirm arrangements.',
    roles: <String>[
      'You: Traveler',
      'AI: Airline agent',
      'AI: Hotel receptionist',
    ],
    pressure: 'The last alternative flight closes in twelve minutes.',
    opening:
        'Your original flight has been cancelled. I can check tomorrow morning or a connection via Frankfurt tonight.',
    keyPhrases: <String>[
      'What is the earliest confirmed option?',
      'Is accommodation included?',
      'Could you confirm that in writing?',
    ],
  ),
  SimulationScenario(
    id: 'networking',
    title: 'Conference networking',
    category: 'General & Business English',
    level: 'B1–C1',
    minutes: 12,
    context: 'You meet suppliers and professionals during a conference break.',
    objective:
        'Introduce yourself, explain your work, ask meaningful questions, and exchange follow-up details.',
    roles: <String>['You: Participant', 'AI: Industry professional'],
    pressure:
        'The conversation must end naturally when the next session begins.',
    opening:
        'Hello, I noticed your question about supply resilience. Are you working on that area as well?',
    keyPhrases: <String>[
      'What are you currently focusing on?',
      'We have seen something similar in…',
      'Would it be useful to continue this conversation by email?',
    ],
  ),
  SimulationScenario(
    id: 'crisis-call',
    title: 'Executive crisis call: production stop',
    category: 'Business English',
    level: 'B2–C1',
    minutes: 20,
    context:
        'A component shortage may stop two production lines and senior leaders require a decision.',
    objective:
        'Give a concise status, quantify exposure, compare options, and request a decision.',
    roles: <String>[
      'You: Procurement lead',
      'AI: Plant director',
      'AI: Finance controller',
      'AI: Supplier executive',
    ],
    pressure: 'New information invalidates the first recovery estimate.',
    opening:
        'We need a verified status in three minutes. What is the exposure, the earliest recovery, and the decision required?',
    keyPhrases: <String>[
      'The confirmed facts are…',
      'The remaining uncertainty is…',
      'I recommend option B because…',
    ],
  ),
  SimulationScenario(
    id: 'customer-complaint',
    title: 'Customer complaint and service recovery',
    category: 'General & Workplace English',
    level: 'B1–C1',
    minutes: 16,
    context:
        'A customer received an incomplete order and rejects the first proposed solution.',
    objective:
        'Acknowledge the issue, clarify impact, propose options, and rebuild confidence without overpromising.',
    roles: <String>['You: Account coordinator', 'AI: Customer representative'],
    pressure: 'The customer asks for a commitment outside your authority.',
    opening:
        'This is the second issue this month. Why should we accept another uncertain recovery date?',
    keyPhrases: <String>[
      'I understand the operational impact.',
      'What outcome would resolve the immediate issue?',
      'I can commit to an update by…',
    ],
  ),
  SimulationScenario(
    id: 'interview',
    title: 'International job interview',
    category: 'General & Business English',
    level: 'B1–C1',
    minutes: 18,
    context:
        'You interview for a role requiring cross-functional communication and problem solving.',
    objective:
        'Give structured examples, clarify questions, discuss strengths, and ask thoughtful questions.',
    roles: <String>['You: Candidate', 'AI: Hiring manager'],
    pressure:
        'The interviewer challenges a vague achievement and asks for measurable evidence.',
    opening:
        'Tell me about a difficult cross-functional problem and exactly what you contributed.',
    keyPhrases: <String>[
      'The situation was…',
      'My specific responsibility was…',
      'The measurable result was…',
    ],
  ),
  SimulationScenario(
    id: 'safety-briefing',
    title: 'Factory safety briefing and incident response',
    category: 'Industrial English',
    level: 'A2–B2',
    minutes: 15,
    context:
        'Before a factory visit, you receive a safety briefing and later report a near miss.',
    objective:
        'Confirm instructions, describe location and sequence accurately, and request immediate control.',
    roles: <String>[
      'You: Visitor',
      'AI: Safety coordinator',
      'AI: Area supervisor',
    ],
    pressure: 'Noise and similar equipment names create misunderstanding.',
    opening:
        'Before entering the area, confirm the emergency route, mandatory PPE, and reporting procedure.',
    keyPhrases: <String>[
      'Let me repeat the instruction.',
      'The near miss occurred beside…',
      'Please isolate the area until…',
    ],
  ),
];

final class SimulationLabPage extends StatefulWidget {
  const SimulationLabPage({super.key});

  @override
  State<SimulationLabPage> createState() => _SimulationLabPageState();
}

final class _SimulationLabPageState extends State<SimulationLabPage> {
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    final categories = <String>[
      'All',
      ...{for (final scenario in simulationScenarios) scenario.category},
    ];
    final visible = filter == 'All'
        ? simulationScenarios
        : simulationScenarios
              .where((scenario) => scenario.category == filter)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-world simulation lab'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home),
            label: const Text('Today'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: <Widget>[
              Text(
                'Practice English under realistic pressure',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'General English, workplace communication, procurement, manufacturing, meetings, calls, email, presentations, and travel. Each simulation includes roles, context, objectives, changing pressure, and structured feedback.',
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final category in categories)
                    ChoiceChip(
                      label: Text(category),
                      selected: filter == category,
                      onSelected: (_) => setState(() => filter = category),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 355,
                  mainAxisExtent: 260,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final scenario = visible[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.go('/simulation/${scenario.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(child: Icon(_icon(scenario.id))),
                                const Spacer(),
                                Chip(label: Text(scenario.level)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              scenario.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              scenario.context,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.schedule, size: 18),
                                const SizedBox(width: 6),
                                Text('${scenario.minutes} min'),
                                const Spacer(),
                                Text(
                                  scenario.category,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text('Open scenario'),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _icon(String id) {
    if (id.contains('factory')) {
      return Icons.precision_manufacturing;
    }
    if (id.contains('email')) {
      return Icons.email;
    }
    if (id.contains('teams')) {
      return Icons.groups;
    }
    if (id.contains('travel')) {
      return Icons.flight;
    }
    if (id.contains('phone')) {
      return Icons.call;
    }
    if (id.contains('presentation')) {
      return Icons.present_to_all;
    }
    return Icons.record_voice_over;
  }
}

final class SimulationRoomPage extends StatefulWidget {
  const SimulationRoomPage({required this.id, super.key});

  final String id;

  @override
  State<SimulationRoomPage> createState() => _SimulationRoomPageState();
}

final class _SimulationRoomPageState extends State<SimulationRoomPage> {
  final TextEditingController answer = TextEditingController();
  final List<String> transcript = <String>[];
  int turn = 0;
  String? feedback;

  SimulationScenario get scenario => simulationScenarios.firstWhere(
    (item) => item.id == widget.id,
    orElse: () => simulationScenarios.first,
  );

  @override
  void dispose() {
    answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentScenario = scenario;
    return Scaffold(
      appBar: AppBar(
        title: Text(currentScenario.title),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => context.go('/simulations'),
            icon: const Icon(Icons.grid_view),
            label: const Text('All simulations'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: <Widget>[
                    Text(
                      'Briefing',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    _Info('Context', currentScenario.context),
                    _Info('Your objective', currentScenario.objective),
                    _Info('Pressure', currentScenario.pressure),
                    _Info('Roles', currentScenario.roles.join('\n')),
                    const SizedBox(height: 12),
                    Text(
                      'Useful language',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    for (final phrase in currentScenario.keyPhrases)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.chat_bubble_outline),
                        title: Text(phrase),
                      ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Live role-play',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Turn ${turn + 1} • Respond naturally. The scenario develops from your answer.',
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Card(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: ListView(
                            padding: const EdgeInsets.all(18),
                            children: <Widget>[
                              _Bubble(
                                'Scenario partner',
                                turn == 0
                                    ? currentScenario.opening
                                    : _promptFor(turn),
                                false,
                              ),
                              for (
                                var index = 0;
                                index < transcript.length;
                                index++
                              )
                                _Bubble(
                                  index.isEven ? 'You' : 'Scenario partner',
                                  transcript[index],
                                  index.isEven,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: answer,
                        minLines: 2,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Your English response',
                          hintText:
                              'Write what you would say or send in this situation…',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          OutlinedButton.icon(
                            onPressed: _hint,
                            icon: const Icon(Icons.lightbulb_outline),
                            label: const Text('Coaching hint'),
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.send),
                            label: Text(
                              turn >= 3 ? 'Finish and review' : 'Send response',
                            ),
                          ),
                        ],
                      ),
                      if (feedback != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(feedback!),
                            ),
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
    );
  }

  void _submit() {
    final text = answer.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      transcript.add(text);
      answer.clear();
      final score = _score(text);
      transcript.add(_reply());
      turn++;
      feedback = 'Coach snapshot: $score/100 • ${_feedback(text)}';
      if (turn >= 4) {
        feedback =
            'Simulation review: $score/100 • You completed $turn response turns. ${_feedback(text)} Repeat the scenario using one clarification question, one evidence-based statement, and one explicit next action.';
      }
    });
  }

  int _score(String text) {
    var score = 45;
    final wordCount = text.split(RegExp(r'\s+')).length;
    if (wordCount >= 12) {
      score += 15;
    }
    if (text.contains('?')) {
      score += 10;
    }
    if (RegExp(
      r'\b(please|could|would|confirm|because|therefore|next|deadline|evidence)\b',
      caseSensitive: false,
    ).hasMatch(text)) {
      score += 20;
    }
    if (RegExp(
      r'\b(I think|maybe|thing|stuff)\b',
      caseSensitive: false,
    ).hasMatch(text)) {
      score -= 5;
    }
    return score.clamp(0, 100);
  }

  String _feedback(String text) {
    final parts = <String>[];
    if (!text.contains('?')) {
      parts.add('Add a focused clarification question.');
    }
    if (text.split(RegExp(r'\s+')).length < 12) {
      parts.add('Develop the answer with context and a clear action.');
    }
    if (!RegExp(
      r'\b(confirm|agree|send|review|deadline|next)\b',
      caseSensitive: false,
    ).hasMatch(text)) {
      parts.add('Close with an owner, action, or deadline.');
    }
    if (parts.isEmpty) {
      return 'Clear, purposeful language. Now improve precision by paraphrasing the partner’s key point.';
    }
    return parts.join(' ');
  }

  String _reply() {
    const replies = <String>[
      'I understand your point, but what specific evidence or commitment do you need from us?',
      'That may be possible. We need to consider cost, timing, and operational risk. Which point should we resolve first?',
      'I can offer a partial solution, although the deadline remains difficult. How would you like to document the next step?',
      'Before we close, please summarize the agreement, owner, and due date.',
    ];
    final index = turn < replies.length ? turn : replies.length - 1;
    return replies[index];
  }

  String _promptFor(int currentTurn) {
    const prompts = <String>[
      'Please clarify your priority and the evidence you need.',
      'A new constraint has appeared. The original deadline may not be possible.',
      'One participant disagrees and asks for a lower-cost alternative.',
      'Close the interaction with a precise summary and next actions.',
    ];
    final index = currentTurn < prompts.length
        ? currentTurn
        : prompts.length - 1;
    return prompts[index];
  }

  void _hint() {
    setState(() {
      feedback =
          'Hint: ${scenario.keyPhrases[turn % scenario.keyPhrases.length]}';
    });
  }
}

final class _Info extends StatelessWidget {
  const _Info(this.title, this.text);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(text),
        ],
      ),
    );
  }
}

final class _Bubble extends StatelessWidget {
  const _Bubble(this.label, this.text, this.mine);

  final String label;
  final String text;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.32,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: mine
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 5),
            Text(text),
          ],
        ),
      ),
    );
  }
}
