import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/features/clients/data/client_firebaserepo.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';

import 'package:taskoteladmin/features/clients/presentation/cubit/client_form_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/active_clients_new.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/client_form.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/lost_clients_new.dart';

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
    // Initialization is now handled by individual widgets
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeaderWithButton(
            heading: 'Clients',
            subHeading: 'Manage your hotel clients and their subscriptions',
            buttonText: 'Add Client',
            onButtonPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Color(0xffFAFAFA),

                    child: ClientFormModal(),
                  );
                },
              );
              // sendTasksToFirestore();
              // print("---");
            },
          ),
          const SizedBox(height: 25),

          Row(
            children: [
              CupertinoSlidingSegmentedControl<ClientTab>(
                backgroundColor: true
                    ? Color(0xfff1f5f9)
                    : AppColors.slateLightGray,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                groupValue: context.watch<ClientCubit>().state.selectedTab,
                children: {
                  ClientTab.active: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.person_2, size: 20),
                        SizedBox(width: 15),
                        Text("Active Clients"),
                      ],
                    ),
                  ),
                  ClientTab.lost: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.person_crop_circle_badge_xmark,
                          size: 20,
                        ),
                        SizedBox(width: 15),
                        Text("Lost Clients"),
                      ],
                    ),
                  ),
                },
                onValueChanged: (val) {
                  if (val != null) {
                    context.read<ClientCubit>().switchTab(val);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 25),

          context.watch<ClientCubit>().state.selectedTab == ClientTab.active
              ? const ActiveClientsNew()
              : const LostClientsNew(),
        ],
      ),
    );
  }
}
