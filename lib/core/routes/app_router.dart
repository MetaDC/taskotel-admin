import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/features/clients/presentation/page/clients_page.dart';
import 'package:taskoteladmin/features/dasboard/presentation/pages/dashboard.dart';
import 'package:taskoteladmin/features/dasboard/presentation/pages/dashboard_page.dart';

final GoRouter appRoute = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: Routes.dashboard,
  routes: _routes,
  redirect: (context, state) {
    // Skip redirect for login page
    // if (state.uri.path == Routes.login) {
    //   return null;
    // }
    // return null; // Let the route guard handle authentication
  },
);

List<RouteBase> get _routes {
  return <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return Dashboard(child: child);
      },
      routes: [
        GoRoute(
          path: "${Routes.dashboard}",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: DashboardPage());
          },
        ),
        GoRoute(
          path: Routes.clients,
          pageBuilder: (context, state) {
            return NoTransitionPage(child: ClientsPage());
          },
        ),
        // GoRoute(
        //   path: "${Routes.document}/:id",
        //   pageBuilder: (context, state) {
        //     final projectId = state.pathParameters['id'] ?? "";
        //     return NoTransitionPage(child: DocumentPage(projectId: projectId));
        //   },
        // ),
        // GoRoute(
        //   path: "${Routes.bill}/:id",
        //   pageBuilder: (context, state) {
        //     final projectId = state.pathParameters['id'] ?? "";
        //     return NoTransitionPage(child: BillPage(projectId: projectId));
        //   },
        // ),
      ],
    ),
  ];
}
