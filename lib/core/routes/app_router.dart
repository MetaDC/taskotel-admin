import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/features/clients/presentation/page/clients_page.dart';
import 'package:taskoteladmin/features/clients/presentation/page/client_detail_page.dart';
import 'package:taskoteladmin/features/master_hotels/presentation/pages/master_hotels_page.dart';
import 'package:taskoteladmin/features/subscription_plans/presentation/pages/subscription_plans_page.dart';
import 'package:taskoteladmin/features/transactions/presentation/pages/transactions_page.dart';
import 'package:taskoteladmin/features/reports/presentation/pages/reports_page.dart';
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
          routes: [
            GoRoute(
              path: "/:clientId",
              pageBuilder: (context, state) {
                final clientId = state.pathParameters['clientId']!;
                return NoTransitionPage(
                  child: ClientDetailPage(clientId: clientId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: "/master-hotels",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: MasterHotelsPage());
          },
        ),
        GoRoute(
          path: "/subscription-plans",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: SubscriptionPlansPage());
          },
        ),
        GoRoute(
          path: "/transactions",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: TransactionsPage());
          },
        ),
        GoRoute(
          path: "/reports",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: ReportsPage());
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
