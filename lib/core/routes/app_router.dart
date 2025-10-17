import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/features/auth/presentation/pages/login_page.dart';
import 'package:taskoteladmin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskoteladmin/features/clients/data/client_firebaserepo.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';
import 'package:taskoteladmin/features/subscription/data/subscription_firebaserepo.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/susbcription_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/page/hotel_detail_page.dart';
import 'package:taskoteladmin/features/dashboard/presentation/pages/dashboard.dart';
import 'package:taskoteladmin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:taskoteladmin/features/clients/presentation/page/clients_page.dart';
import 'package:taskoteladmin/features/clients/presentation/page/client_detail_page.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/page/master_hotel_task_page.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/page/master_hotels_page.dart';
import 'package:taskoteladmin/features/report/presentation/pages/reports_page.dart';
import 'package:taskoteladmin/features/report/presentation/cubit/report_cubit.dart';
import 'package:taskoteladmin/features/subscription/presentation/pages/subscription_plans_page.dart';
import 'package:taskoteladmin/features/transactions/presentation/pages/transactions_page.dart';
import 'package:taskoteladmin/features/transactions/presentation/cubit/transaction_cubit.dart';

final GoRouter appRoute = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: Routes.dashboard,

  // Improved redirect logic
  redirect: (context, state) {
    final authCubit = context.read<AuthCubit>();
    final currentPath = state.matchedLocation;
    final isAuthenticated = authCubit.state.isAuthenticated;

    // If user is not authenticated and trying to access protected routes
    if (!isAuthenticated && currentPath != Routes.login) {
      return Routes.login;
    }

    // If user is authenticated and on login page, redirect to dashboard
    if (isAuthenticated && currentPath == Routes.login) {
      return Routes.dashboard;
    }

    // No redirect needed
    return null;
  },

  routes: [
    // Login route outside ShellRoute
    GoRoute(path: Routes.login, builder: (context, state) => const LoginPage()),

    // Protected dashboard + nested routes
    ShellRoute(
      builder: (context, state, child) {
        return Dashboard(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.dashboard,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardPage()),
        ),
        GoRoute(
          path: Routes.clients,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ClientsPage()),
          routes: [
            // Use ShellRoute to maintain cubit across nested routes
            ShellRoute(
              builder: (context, state, child) {
                final clientId = state.pathParameters['clientId'];
                if (clientId != null) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            ClientDetailCubit(clientRepo: ClientFirebaseRepo())
                              ..loadClientDetails(clientId),
                      ),
                      BlocProvider(
                        create: (context) => SubscriptionCubit(
                          subscriptionRepo: SubscriptionFirebaserepo(),
                        ),
                      ),
                    ],
                    child: child,
                  );
                }
                return child;
              },
              routes: [
                GoRoute(
                  path: ":clientId",
                  pageBuilder: (context, state) {
                    final clientId = state.pathParameters['clientId']!;
                    return NoTransitionPage(
                      child: ClientDetailPage(clientId: clientId),
                    );
                  },
                ),
                GoRoute(
                  path: ":clientId/hotels/:hotelId",
                  pageBuilder: (context, state) {
                    final clientId = state.pathParameters['clientId']!;
                    final hotelId = state.pathParameters['hotelId']!;

                    return NoTransitionPage(
                      child: HotelDetailPage(
                        hotelId: hotelId,
                        clientId: clientId,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: Routes.masterHotels,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MasterHotelsPage()),
          routes: [
            GoRoute(
              path: ":hotelId/tasks",
              pageBuilder: (context, state) {
                final hotelId = state.pathParameters['hotelId']!;
                final hotelName =
                    state.uri.queryParameters['hotelName'] ?? 'Hotel';
                return NoTransitionPage(
                  child: MasterHotelTaskPage(
                    hotelId: hotelId,
                    HotelName: hotelName,
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.subscriptionPlans,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SubscriptionPlansPage()),
        ),
        GoRoute(
          path: Routes.transactions,
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider(
              create: (context) => TransactionCubit(),
              child: const TransactionsPage(),
            ),
          ),
        ),
        GoRoute(
          path: Routes.reports,
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider(
              create: (context) => ReportCubit(),
              child: const ReportsPage(),
            ),
          ),
        ),
      ],
    ),
  ],
);
