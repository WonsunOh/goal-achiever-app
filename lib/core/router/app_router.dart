import 'package:go_router/go_router.dart';
import '../../presentation/views/home_view.dart';
import '../../presentation/views/goals_view.dart';
import '../../presentation/views/tasks_view.dart';
import '../../presentation/views/statistics_view.dart';
import '../../presentation/views/settings_view.dart';

class AppRouter {
  static const String home = '/';
  static const String goals = '/goals';
  static const String tasks = '/tasks';
  static const String statistics = '/statistics';
  static const String settings = '/settings';

  static final router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: goals,
        builder: (context, state) => const GoalsView(),
      ),
      GoRoute(
        path: tasks,
        builder: (context, state) => const TasksView(),
      ),
      GoRoute(
        path: statistics,
        builder: (context, state) => const StatisticsView(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
