import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/active_clients.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/lost_clients.dart';

enum ClientTab { active, lost }

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  ClientTab selectedTab = ClientTab.active;
  @override
  void initState() {
    super.initState();
    context.read<ClientCubit>().initializePagination();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            heading: 'Clients',
            subHeading: 'Manage your clients',
            buttonText: 'Add Client',
            onButtonPressed: () {},
          ),
          const SizedBox(height: 20),

          CupertinoSlidingSegmentedControl<ClientTab>(
            backgroundColor: AppColors.slateLightGray,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            groupValue: selectedTab,
            children: const {
              ClientTab.active: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.person_2),
                  SizedBox(width: 15),
                  Text("Active Clients"),
                ],
              ),
              ClientTab.lost: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.person_crop_circle_badge_xmark),
                  SizedBox(width: 15),
                  Text("Lost Clients"),
                ],
              ),
            },
            onValueChanged: (val) {
              if (val != null) {
                setState(() {
                  selectedTab = val;
                });
              }
            },
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 600, // Fixed height for better scroll behavior
            child: selectedTab == ClientTab.active
                ? ActiveClients()
                : LostClients(),
          ),
        ],
      ),
    );
  }
}
