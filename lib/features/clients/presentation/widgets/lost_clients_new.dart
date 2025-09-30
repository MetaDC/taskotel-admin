import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
                    icon: CupertinoIcons.person_badge_minus,
                    label: "Lost Clients",
                    value: "${state.stats?['lostClients'] ?? 0}",
                    iconColor: Colors.red,
                  ),
                  StatCardIconLeft(
                    icon: CupertinoIcons.building_2_fill,
                    label: "Lost Hotels",
                    value: "${state.stats?['lostHotels'] ?? 0}",
                    iconColor: Colors.orange,
                  ),
                  StatCardIconLeft(
                    icon: CupertinoIcons.money_dollar,
                    label: "Lost Revenue",
                    value: "\$${state.stats?['lostRevenue'] ?? 0}",
                    iconColor: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Header with search
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.blueGreyBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Lost Clients List",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 300,
                          height: 43,
                          child: TextField(
                            controller: _searchController,
                            cursorHeight: 20,
                            // decoration: InputDecoration(
                            //   hintText: "Search lost clients...",
                            //   prefixIcon: const Icon(CupertinoIcons.search),
                            //   border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(8),
                            //     borderSide: BorderSide(
                            //       color: AppColors.slateGray,
                            //     ),
                            //   ),
                            //   contentPadding: const EdgeInsets.symmetric(
                            //     horizontal: 12,
                            //     vertical: 8,
                            //   ),
                            // ),
                            decoration: InputDecoration(
                              fillColor: Color(0xfffafafa),
                              filled: true,
                              hintText: "Search lost clients...",
                              prefixIcon: const Icon(
                                CupertinoIcons.search,
                                color: AppColors.slateGray,
                                size: 20,
                              ),
                              hoverColor: Colors.transparent,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.blueGreyBorder,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.blueGreyBorder,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.blueGreyBorder,
                                ),
                              ),

                              hintStyle: TextStyle(
                                color: AppColors.slateGray,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              // contentPadding: const EdgeInsets.symmetric(
                              //   horizontal: 12,
                              //   vertical: 8,
                              // ),
                            ),
                            onChanged: (value) {
                              context.read<ClientCubit>().searchClients(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 20),

                    // Stats Cards

                    // Loading state
                    if (state.isLoading && state.lostClients.isEmpty)
                      Center(child: CircularProgressIndicator())
                    // Error state
                    else if (state.message != null && state.lostClients.isEmpty)
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
                                  .initializeLostClientsPagination(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    // Clients list
                    else if (state.filteredLostClients.isEmpty)
                      Center(
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
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Table Header
                          SizedBox(height: 40),
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
                          const SizedBox(height: 13),
                          const Divider(
                            color: AppColors.slateGray,
                            thickness: 0.07,
                            height: 0,
                          ),
                          // Table Body
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(
                              color: AppColors.slateGray,
                              thickness: 0.07,
                              height: 0,
                            ),
                            itemCount: state.filteredLostClients.length,
                            itemBuilder: (context, index) {
                              final client = state.filteredLostClients[index];
                              return _buildClientRow(client);
                            },
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),

      child: Row(
        children: [
          SizedBox(width: 30),
          // Client Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,

                    fontSize: 15,
                    color: AppColors.textBlackColor,
                  ),
                ),
                Text(
                  "Lost on ${client.updatedAt.goodDayDate()}",
                  style: TextStyle(fontSize: 13.5, color: AppColors.slateGray),
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
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.mail,
                      size: 15,
                      color: AppColors.slateGray,
                    ),
                    SizedBox(width: 4),
                    Text(
                      client.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBlackColor,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.phone,
                      size: 15,
                      color: AppColors.slateGray,
                    ),
                    SizedBox(width: 4),
                    Text(
                      client.phone,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBlackColor,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Hotels
          Expanded(
            child: Text(
              "${client.totalHotels}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor,
              ),
            ),
          ),

          // Revenue
          Expanded(
            child: Text(
              "\$${client.totalRevenue.toStringAsFixed(0)}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,

                color: AppColors.textBlackColor,
              ),
            ),
          ),
          // Status
          Expanded(child: Row(children: [_buildStatusBadge(client.status)])),
          // Status
          SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    size: 20,
                    color: AppColors.textBlackColor,
                  ),
                  onPressed: () {
                    // Handle view client
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_horiz,
                size: 20,
                color: AppColors.textBlackColor,
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: .8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          letterSpacing: .5,
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
