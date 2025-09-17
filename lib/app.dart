import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/routes/app_router.dart';
import 'package:taskoteladmin/core/theme/app_theme.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveWid(
      mobile: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        builder: (_, __) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: appRoute,
        ),
      ),
      desktop: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRoute,
      ),
    );
  }
}
