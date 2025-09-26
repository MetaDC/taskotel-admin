import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/features/clients/data/client_firebaserepo.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_form_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/client_form.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/pagination.dart';

class ActiveClientsNew extends StatefulWidget {
  const ActiveClientsNew({super.key});

  @override
  State<ActiveClientsNew> createState() => _ActiveClientsNewState();
}

class _ActiveClientsNewState extends State<ActiveClientsNew> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize active clients pagination
    context.read<ClientCubit>().initializeActiveClientsPagination();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Active Clients List",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search active clients...",
                              prefixIcon: const Icon(CupertinoIcons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppColors.slateGray,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (value) {
                              context.read<ClientCubit>().searchClients(value);
                            },
                          ),
                        ),
                      ],
                    ),

                    if (state.isLoading && state.activeClients.isEmpty)
                      Center(child: CircularProgressIndicator())
                    // Error state
                    else if (state.message != null &&
                        state.activeClients.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.exclamationmark_triangle,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<ClientCubit>()
                                  .initializeActiveClientsPagination(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    // Clients list
                    else if (state.filteredActiveClients.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.person_2,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No active clients found",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          // Table Header
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Client",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Contact",
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
                                  "Status",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "View",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: Text(
                                  "Actions",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),

                              SizedBox(width: 100),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Divider(
                            color: AppColors.slateGray,
                            thickness: 0.1,
                          ),

                          // Table Body
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: state.filteredActiveClients.length,
                            itemBuilder: (context, index) {
                              final client = state.filteredActiveClients[index];
                              return _buildClientRow(client);
                            },
                          ),

                          const SizedBox(height: 20),

                          // Pagination
                          if (state.activeTotalPages > 1)
                            DynamicPagination(
                              currentPage: state.activeCurrentPage,
                              totalPages: state.activeTotalPages,
                              onPageChanged: (page) {
                                context
                                    .read<ClientCubit>()
                                    .fetchNextActiveClientsPage(page: page);
                              },
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClientRow(ClientModel client) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 30),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Joined ${client.createdAt.goodDayDate()}",
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),

              // Contact
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.email, style: const TextStyle(fontSize: 14)),
                    Text(
                      client.phone,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Hotels
              Expanded(
                child: Text(
                  "${client.totalHotels}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              // Revenue
              Expanded(
                child: Text(
                  "\$${client.totalRevenue.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              // Status
              Expanded(
                child: Row(
                  children: [_buildStatusBadge(client.status), Spacer(flex: 3)],
                ),
              ),
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(CupertinoIcons.eye),
                      onPressed: () {
                        context.go('${Routes.clients}/${client.docId}');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: PopupMenuButton(
                  icon: Icon(Icons.more_horiz),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Edit'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Color(0xffFAFAFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: BlocProvider(
                                create: (context) => ClientFormCubit(
                                  clientRepo: ClientFirebaseRepo(),
                                ),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 600),
                                  child: ClientFormModal(clientToEdit: client),
                                ),
                              ),
                            );
                          },
                        );
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

              SizedBox(width: 100),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.slateGray, thickness: 0.1),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == 'active' ? Colors.green : Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _viewClientDetails(ClientModel client) {
    // Navigate to client details
  }

  void _editClient(ClientModel client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => ClientFormCubit(clientRepo: ClientFirebaseRepo()),
        child: ClientFormModal(clientToEdit: client),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh the current page
        context.read<ClientCubit>().fetchNextActiveClientsPage(
          page: context.read<ClientCubit>().state.activeCurrentPage,
        );
      }
    });
  }

  void _deleteClient(ClientModel client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Client"),
        content: Text("Are you sure you want to delete ${client.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Delete client logic here
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
