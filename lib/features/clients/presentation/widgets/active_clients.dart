// 6. Updated ActiveClients Widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/pagination.dart';

class ActiveClients extends StatefulWidget {
  const ActiveClients({super.key});

  @override
  State<ActiveClients> createState() => _ActiveClientsState();
}

class _ActiveClientsState extends State<ActiveClients> {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        // Show loading for initial load
        if (state.isLoading && state.clients.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error state
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
            // Stats Cards
            StaggeredGrid.extent(
              maxCrossAxisExtent: 500,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                StatCardIconLeft(
                  icon: CupertinoIcons.person_2,
                  label: "Total Clients",
                  value: "${state.stats?['totalClients'] ?? 0}",
                  iconColor: Colors.blue,
                ),
                StatCardIconLeft(
                  icon: CupertinoIcons.circle_fill,
                  label: "Active Clients",
                  value: "${state.stats?['activeClients'] ?? 0}",
                  iconColor: Colors.green,
                ),
                StatCardIconLeft(
                  icon: CupertinoIcons.building_2_fill,
                  label: "Total Hotels",
                  value: "${state.stats?['totalHotels'] ?? 0}",
                  iconColor: Colors.teal,
                ),
                StatCardIconLeft(
                  icon: CupertinoIcons.cube_box,
                  label: "Total Revenue",
                  value: "\$${state.stats?['totalActiveRevenue'] ?? 0}",
                  iconColor: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Clients Table
            Expanded(
              child: CustomContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active Clients List",
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

                    // Table Header
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            "Client Name",
                            style: AppTextStyles.tabelHeader,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Contact",
                            style: AppTextStyles.tabelHeader,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Expiry Date",
                            style: AppTextStyles.tabelHeader,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Hotels",
                            style: AppTextStyles.tabelHeader,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Revenue",
                            style: AppTextStyles.tabelHeader,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Last Login",
                            style: AppTextStyles.tabelHeader,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text("View", style: AppTextStyles.tabelHeader),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Actions",
                            style: AppTextStyles.tabelHeader,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(color: AppColors.slateGray, thickness: 0.1),
                    const SizedBox(height: 10),

                    // Clients List
                    Expanded(
                      child: state.filteredClients.isNotEmpty
                          ? ListView.separated(
                              itemCount: state.filteredClients.length,
                              separatorBuilder: (context, index) => Divider(
                                color: AppColors.slateGray.withOpacity(0.3),
                                height: 1,
                              ),
                              itemBuilder: (context, index) {
                                final client = state.filteredClients[index];
                                return buildClientRow(client);
                              },
                            )
                          : Center(child: Text("No active clients found")),
                    ),
                    DynamicPagination(
                      currentPage: state.currentPage,
                      totalPages: state.totalPages,
                      onPageChanged: (page) => {
                        context.read<ClientCubit>().fetchNextPage(page: page),
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildClientRow(ClientModel client) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  "Joined ${_formatDate(client.createdAt)}",
                  style: TextStyle(color: AppColors.slateGray),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.phone, size: 15),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        client.phone,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(CupertinoIcons.mail, size: 15),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        client.email,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: Text(_formatDate(client.lastPaymentExpiry))),
          Expanded(child: Text("${client.totalHotels}")),
          Expanded(child: Text("\$${client.totalRevenue.toStringAsFixed(2)}")),
          Expanded(
            child: Text(
              client.lastLogin != null
                  ? _formatDate(client.lastLogin!)
                  : "Never",
            ),
          ),
          SizedBox(
            width: 100,
            child: IconButton(
              icon: Icon(CupertinoIcons.eye),
              onPressed: () {
                // Handle view client
              },
            ),
          ),
          SizedBox(
            width: 100,
            child: PopupMenuButton(
              icon: Icon(Icons.more_horiz),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Edit'),
                  onTap: () {
                    // Handle edit client
                  },
                ),
                PopupMenuItem(
                  child: Text('Delete'),
                  onTap: () {
                    // Handle delete client
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}

// 7. U
