// 7. Updated LostClients Widget (Similar structure)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/pagination.dart';

class LostClients extends StatefulWidget {
  const LostClients({super.key});

  @override
  State<LostClients> createState() => _LostClientsState();
}

class _LostClientsState extends State<LostClients> {
  @override
  void initState() {
    super.initState();
    // context.read<ClientCubit>().loadClients(isActive: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        if (state.isLoading && state.clients.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.message != null && state.clients.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // context.read<ClientCubit>().refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            StaggeredGrid.extent(
              maxCrossAxisExtent: 500,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                StatCardIconLeft(
                  icon: CupertinoIcons.person_2,
                  label: "Lost Clients",
                  value: "${state.stats?['lostClients'] ?? 0}",
                  iconColor: Colors.red,
                ),
                StatCardIconLeft(
                  icon: CupertinoIcons.money_dollar,
                  label: "Lost Revenue",
                  value: "\$${state.stats?['totalLostRevenue'] ?? 0}",
                  iconColor: Colors.orange,
                ),
                StatCardIconLeft(
                  icon: CupertinoIcons.clock,
                  label: "Lost Hotels",
                  value: "${state.stats?['lostHotels'] ?? 0}",
                  iconColor: Colors.blue,
                ),
                StatCardIconLeft(
                  icon: CupertinoIcons.cube_box,
                  label: "Never Paid",
                  value: "0", // You can add this logic
                  iconColor: AppColors.slateGray,
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: CustomContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lost Clients List",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     if (state.isLoading)
                        //       Padding(
                        //         padding: const EdgeInsets.only(right: 8.0),
                        //         child: SizedBox(
                        //           width: 20,
                        //           height: 20,
                        //           child: CircularProgressIndicator(
                        //             strokeWidth: 2,
                        //           ),
                        //         ),
                        //       ),
                        //     IconButton(
                        //       onPressed: state.isLoading
                        //           ? null
                        //           : () {
                        //               context.read<ClientCubit>().refresh();
                        //             },
                        //       icon: Icon(CupertinoIcons.refresh),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Expanded(
                    //   child: state.clients.isEmpty
                    //       ? const Center(child: Text("No lost clients found"))
                    //       : Column(
                    //           children: [
                    //             Expanded(
                    //               child: ListView.separated(
                    //                 itemCount: state.clients.length,
                    //                 separatorBuilder: (context, index) =>
                    //                     Divider(
                    //                       color: AppColors.slateGray
                    //                           .withOpacity(0.3),
                    //                       height: 1,
                    //                     ),
                    //                 itemBuilder: (context, index) {
                    //                   final client = state.clients[index];
                    //                   return ListTile(
                    //                     leading: CircleAvatar(
                    //                       backgroundColor: Colors.red
                    //                           .withOpacity(0.1),
                    //                       child: Text(
                    //                         client.name.isNotEmpty
                    //                             ? client.name[0].toUpperCase()
                    //                             : 'C',
                    //                         style: TextStyle(color: Colors.red),
                    //                       ),
                    //                     ),
                    //                     title: Text(client.name),
                    //                     subtitle: Column(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: [
                    //                         Text(client.email),
                    //                         Text('Phone: ${client.phone}'),
                    //                       ],
                    //                     ),
                    //                     trailing: Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.end,
                    //                       children: [
                    //                         Text("Status: ${client.status}"),
                    //                         Text(
                    //                           "Revenue: \$${client.totalRevenue.toStringAsFixed(2)}",
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     isThreeLine: true,
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
