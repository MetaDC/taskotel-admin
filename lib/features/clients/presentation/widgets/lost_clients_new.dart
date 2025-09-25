import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/features/clients/data/client_firebaserepo.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_form_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/client_form.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/pagination.dart';

class LostClientsNew extends StatefulWidget {
  const LostClientsNew({super.key});

  @override
  State<LostClientsNew> createState() => _LostClientsNewState();
}

class _LostClientsNewState extends State<LostClientsNew> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize lost clients pagination
    context.read<ClientCubit>().initializeLostClientsPagination();
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search
            Row(
              children: [
                const Text(
                  "Lost Clients List",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const Spacer(),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search lost clients...",
                      prefixIcon: const Icon(CupertinoIcons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.slateGray),
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

            const SizedBox(height: 20),

            // Stats Cards
            if (state.stats != null) ...[
              Row(
                children: [
                  Expanded(
                    child: StatCardIconLeft(
                      icon: CupertinoIcons.person_badge_minus,
                      label: "Lost Clients",
                      value: "${state.stats?['lostClients'] ?? 0}",
                      iconColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCardIconLeft(
                      icon: CupertinoIcons.building_2_fill,
                      label: "Lost Hotels",
                      value: "${state.stats?['lostHotels'] ?? 0}",
                      iconColor: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCardIconLeft(
                      icon: CupertinoIcons.money_dollar,
                      label: "Lost Revenue",
                      value: "\$${state.stats?['lostRevenue'] ?? 0}",
                      iconColor: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Loading state
            if (state.isLoading && state.lostClients.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            // Error state
            else if (state.message != null && state.lostClients.isEmpty)
              Expanded(
                child: Center(
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
                            .initializeLostClientsPagination(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              )
            // Clients list
            else if (state.filteredLostClients.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.person_badge_minus,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No lost clients found",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Client",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Contact",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Hotels",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Revenue",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Status",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Actions",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Table Body
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.filteredLostClients.length,
                          itemBuilder: (context, index) {
                            final client = state.filteredLostClients[index];
                            return _buildClientRow(client);
                          },
                        ),
                      ),

                      // Pagination
                      if (state.lostTotalPages > 1)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: DynamicPagination(
                            currentPage: state.lostCurrentPage,
                            totalPages: state.lostTotalPages,
                            onPageChanged: (page) {
                              context
                                  .read<ClientCubit>()
                                  .fetchNextLostClientsPage(page: page);
                            },
                          ),
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

  Widget _buildClientRow(ClientModel client) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Client Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Lost on ${_formatDate(client.updatedAt)}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
          Expanded(child: _buildStatusBadge(client.status)),

          // Actions
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(CupertinoIcons.eye, size: 18),
                  onPressed: () => _viewClientDetails(client),
                  tooltip: "View Details",
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.pencil, size: 18),
                  onPressed: () => _editClient(client),
                  tooltip: "Edit Client",
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.arrow_clockwise,
                    size: 18,
                    color: Colors.green,
                  ),
                  onPressed: () => _reactivateClient(client),
                  tooltip: "Reactivate Client",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'churned':
        color = Colors.red;
        break;
      case 'inactive':
        color = Colors.orange;
        break;
      case 'suspended':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

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
        context.read<ClientCubit>().fetchNextLostClientsPage(
          page: context.read<ClientCubit>().state.lostCurrentPage,
        );
      }
    });
  }

  void _reactivateClient(ClientModel client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reactivate Client"),
        content: Text("Are you sure you want to reactivate ${client.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Reactivate client logic here
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text("Reactivate"),
          ),
        ],
      ),
    );
  }
}
