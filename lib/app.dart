import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/routes/app_router.dart';
import 'package:taskoteladmin/core/theme/app_theme.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskoteladmin/features/auth/data/auth_firebaserepo.dart';
import 'package:taskoteladmin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskoteladmin/features/clients/data/client_firebaserepo.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: AuthFirebaseRepo())..checkAuth(),
      child: BlocBuilder<AuthCubit, AuthState>(
        // Only rebuild when authentication status changes
        buildWhen: (previous, current) =>
            previous.isAuthenticated != current.isAuthenticated,
        builder: (context, state) {
          return ResponsiveWid(
            mobile: ScreenUtilInit(
              designSize: const Size(430, 932),
              minTextAdapt: true,
              builder: (_, __) => MaterialApp.router(
                title: 'Taskotel Admin',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                routerConfig: appRoute,
              ),
            ),
            desktop: MaterialApp.router(
              title: 'Taskotel Admin',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: appRoute,
            ),
          );
        },
      ),
    );
  }
}
