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
    // V7 security policy requires an explicit PIN after every process start.
    // Starting directly on the sign-in route also removes the possibility of
    // an indefinite startup progress indicator.
    initialLocation: '/sign-in',
    refreshListenable: authentication,
    redirect: (context, state) {
      final isSigningIn = state.matchedLocation == '/sign-in';
      final isAuthenticated =
          authentication.status == AuthenticationStatus.authenticated;

      if (!isAuthenticated) {
        return isSigningIn ? null : '/sign-in';
      }

      if (isSigningIn) {
        return '/home';
      }

      return null;
    },
    routes: <RouteBase>[
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
