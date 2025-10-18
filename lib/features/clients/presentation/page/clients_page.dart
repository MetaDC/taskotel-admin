import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
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
  @override
  Widget build(BuildContext context) {
    final selectedTab = context.watch<ClientCubit>().state.selectedTab;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine if this is desktop view
    final isDesktop = screenWidth >= 1024;

    // Adjust values based on screen size
    double horizontalPadding = isDesktop ? 20 : 12;
    double iconSize = isDesktop ? 20 : 16;
    double fontSize = isDesktop ? 14 : 12;
    double spacing = isDesktop ? 15 : 8;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeaderWithButton(
            heading: 'Clients',
            subHeading: 'Manage your hotel clients and their subscriptions',
            buttonText: 'Add Client',
            onButtonPressed: () {
              _showCreateClientModal(context, isDesktop);
            },
          ),
          const SizedBox(height: 25),

          Align(
            alignment: screenWidth >= 500
                ? Alignment.centerLeft
                : Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: CupertinoSlidingSegmentedControl<ClientTab>(
                backgroundColor: isDarkMode
                    ? AppColors.slateLightGray
                    : const Color(0xfff1f5f9),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                groupValue: selectedTab,
                children: {
                  ClientTab.active: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.person_2, size: iconSize),
                        SizedBox(width: spacing),
                        Text(
                          "Active Clients",
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ],
                    ),
                  ),
                  ClientTab.lost: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.person_crop_circle_badge_xmark,
                          size: iconSize,
                        ),
                        SizedBox(width: spacing),
                        Text(
                          "Lost Clients",
                          style: TextStyle(fontSize: fontSize),
                        ),
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
            ),
          ),
          const SizedBox(height: 25),

          selectedTab == ClientTab.active
              ? const ActiveClientsNew()
              : const LostClientsNew(),
        ],
      ),
    );
  }

  void _showCreateClientModal(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      showDialog(
        context: context,
        builder: (context) {
          return const Dialog(
            backgroundColor: Color(0xffFAFAFA),
            child: ClientFormModal(),
          );
        },
      );
    } else {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const ClientFormModal(),
          );
        },
      );
    }
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/widget/page_header.dart';
// import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
// import 'package:taskoteladmin/features/clients/presentation/widgets/active_clients_new.dart';
// import 'package:taskoteladmin/features/clients/presentation/widgets/client_form.dart';
// import 'package:taskoteladmin/features/clients/presentation/widgets/lost_clients_new.dart';

// enum ClientTab { active, lost }

// class ClientsPage extends StatefulWidget {
//   const ClientsPage({super.key});

//   @override
//   State<ClientsPage> createState() => _ClientsPageState();
// }

// class _ClientsPageState extends State<ClientsPage> {
//   ClientTab selectedTab = ClientTab.active;
//   @override
//   void initState() {
//     super.initState();
//     // Initialization is now handled by individual widgets
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           PageHeaderWithButton(
//             heading: 'Clients',
//             subHeading: 'Manage your hotel clients and their subscriptions',
//             buttonText: 'Add Client',
//             onButtonPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return Dialog(
//                     backgroundColor: Color(0xffFAFAFA),

//                     child: ClientFormModal(),
//                   );
//                 },
//               );
//               // sendTasksToFirestore();
//               // print("---");
//             },
//           ),
//           const SizedBox(height: 25),

//           Row(
//             children: [
//               CupertinoSlidingSegmentedControl<ClientTab>(
//                 backgroundColor: true
//                     ? Color(0xfff1f5f9)
//                     : AppColors.slateLightGray,
//                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                 groupValue: context.watch<ClientCubit>().state.selectedTab,
//                 children: {
//                   ClientTab.active: Padding(
//                     padding: EdgeInsetsGeometry.symmetric(
//                       horizontal: 20,
//                       vertical: 5,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(CupertinoIcons.person_2, size: 20),
//                         SizedBox(width: 15),
//                         Text("Active Clients"),
//                       ],
//                     ),
//                   ),
//                   ClientTab.lost: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           CupertinoIcons.person_crop_circle_badge_xmark,
//                           size: 20,
//                         ),
//                         SizedBox(width: 15),
//                         Text("Lost Clients"),
                        
//                       ],
//                     ),
//                   ),
//                 },
//                 onValueChanged: (val) {
//                   if (val != null) {
//                     context.read<ClientCubit>().switchTab(val);
//                   }
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 25),

//           context.watch<ClientCubit>().state.selectedTab == ClientTab.active
//               ? const ActiveClientsNew()
//               : const LostClientsNew(),
//         ],
//       ),
//     );
//   }
// }
