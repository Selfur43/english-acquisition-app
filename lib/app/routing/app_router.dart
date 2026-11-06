import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/authentication.dart';
import '../../features/goals/presentation/pages/goal_editor_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/home/home.dart';
import '../../features/learner_profile/presentation/pages/learner_profile_edit_page.dart';
import '../../features/learner_profile/presentation/pages/learner_profile_page.dart';
import '../../features/learning_session/presentation/learning_insights_page.dart';
import '../../features/learning_session/presentation/learning_plan_page.dart';
import '../../features/learning_session/presentation/learning_session_page.dart';
import '../../features/learning_session/presentation/progress_page.dart';
import '../../features/simulation/presentation/simulation_lab_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authentication = ref.watch(authenticationControllerProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: authentication,
    redirect: (context, state) {
      if (authentication.status == AuthenticationStatus.initializing) {
        return state.matchedLocation == '/starting' ? null : '/starting';
      }

      final isSigningIn = state.matchedLocation == '/sign-in';
      if (authentication.status == AuthenticationStatus.unauthenticated) {
        return isSigningIn ? null : '/sign-in';
      }

      if (isSigningIn || state.matchedLocation == '/starting') {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/starting',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/simulations',
        builder: (context, state) => const SimulationLabPage(),
      ),
      GoRoute(
        path: '/simulation/:id',
        builder: (context, state) =>
            SimulationRoomPage(id: state.pathParameters['id']!),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const LearnerProfilePage(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const LearnerProfileEditPage(),
      ),
      GoRoute(path: '/goals', builder: (context, state) => const GoalsPage()),
      GoRoute(
        path: '/learning-plan',
        builder: (context, state) => const LearningPlanPage(),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const LearningInsightsPage(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressPage(),
      ),
      GoRoute(
        path: '/session',
        builder: (context, state) => const LearningSessionPage(),
      ),
      GoRoute(
        path: '/goals/edit',
        builder: (context, state) =>
            GoalEditorPage(goalId: state.uri.queryParameters['id']),
      ),
    ],
  );
});
