import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/clients/data/client_firebaserepo.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
import 'package:taskoteladmin/features/dashboard/presentation/widgets/navbar.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/masterhotel_cubit.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Add your cubits here
        //client cubit
        BlocProvider(
          create: (context) => ClientCubit(clientRepo: ClientFirebaseRepo()),
        ),
        //master hotel cubit
        BlocProvider(
          create: (context) =>
              MasterHotelCubit(masterHotelRepo: MasterHotelFirebaseRepo()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Navbar(),
        ),
        body: ResponsiveWid(
          mobile: Column(children: [Expanded(child: child)]),
          desktop: Column(children: [Expanded(child: child)]),
        ),
      ),
    );
  }
}
