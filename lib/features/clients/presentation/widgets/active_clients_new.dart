import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/client_form.dart';
import 'package:taskoteladmin/features/clients/presentation/widgets/pagination.dart';

class ActiveClientsNew extends StatefulWidget {
  const ActiveClientsNew({super.key});

  @override
  State<ActiveClientsNew> createState() => _ActiveClientsNewState();
}

class _ActiveClientsNewState extends State<ActiveClientsNew> {
  @override
  void initState() {
    super.initState();
    context.read<ClientCubit>().initializeActiveClientsPagination();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientCubit, ClientState>(
      listener: (context, state) {
        // print("Message: ${state.message}--${state.selectedTab}");
        if (state.message == "Client Deleted") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Client deleted successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder<ClientCubit, ClientState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnalytics(state),
                const SizedBox(height: 20),
                ResponsiveWid(
                  mobile: _buildMobileClientList(context, state),
                  tablet: _buildMobileClientList(context, state),
                  desktop: _buildActiveClientTabel(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalytics(ClientState state) {
    return StaggeredGrid.extent(
      maxCrossAxisExtent: 500,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        StatCardIconLeft(
          icon: CupertinoIcons.person_2,
          label: "Total Clients",
          value: "${state.stats?.totalClients.toString() ?? 0}",
          iconColor: Colors.blue,
        ),
        StatCardIconLeft(
          icon: CupertinoIcons.circle_fill,
          label: "Active Clients",
          value: "${state.stats?.activeClients ?? 0}",
          iconColor: Colors.green,
        ),
        StatCardIconLeft(
          icon: CupertinoIcons.building_2_fill,
          label: "Total Hotels",
          value: "${state.stats?.totalHotels ?? 0}",
          iconColor: Colors.teal,
        ),
        StatCardIconLeft(
          icon: CupertinoIcons.money_dollar,
          label: "Total Revenue",
          value: "\$${state.stats?.totalRevenue ?? 0}",
          iconColor: Colors.orange,
        ),
      ],
    );
  }

  // Mobile View
  Widget _buildMobileClientList(BuildContext context, ClientState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Active Clients List", style: AppTextStyles.customContainerTitle),
        const SizedBox(height: 16),
        TextField(
          controller: context.read<ClientCubit>().searchController,
          decoration: InputDecoration(
            fillColor: Color(0xfffafafa),
            filled: true,
            hintText: "Search clients...",
            prefixIcon: const Icon(CupertinoIcons.search, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.blueGreyBorder),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          onChanged: (value) {
            context.read<ClientCubit>().searchClients(value);
          },
        ),
        const SizedBox(height: 20),
        if (state.isLoading && state.activeClients.isEmpty)
          Center(child: CircularProgressIndicator())
        else if (state.message != null &&
            state.activeClients.isEmpty &&
            state.message != "Client Deleted")
          _buildErrorState(state.message!)
        else if (state.filteredActiveClients.isEmpty)
          _buildEmptyState()
        else
          Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemCount: state.filteredActiveClients.length,
                itemBuilder: (context, index) {
                  final client = state.filteredActiveClients[index];
                  return _buildMobileClientCard(client);
                },
              ),
              const SizedBox(height: 20),
              if (state.activeTotalPages > 1 &&
                  context.read<ClientCubit>().searchController.text.isEmpty)
                DynamicPagination(
                  currentPage: state.activeCurrentPage,
                  totalPages: state.activeTotalPages,
                  onPageChanged: (page) {
                    context.read<ClientCubit>().fetchNextActiveClientsPage(
                      page: page,
                    );
                  },
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildMobileClientCard(ClientModel client) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.blueGreyBorder, width: 1),
      ),
      child: InkWell(
        onTap: () => context.go(Routes.clientDetail(client.docId)),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Joined ${client.createdAt.convertToDDMMYY()}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(client.status),
                  /*  SizedBox(width: 8),
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert, size: 20),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'view',
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(CupertinoIcons.eye, size: 20),
                          title: Text('View'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.edit, size: 18),
                          title: Text('Edit'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          title: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      Future.delayed(Duration.zero, () {
                        if (value == 'view') {
                          context.go(Routes.clientDetail(client.docId));
                        } else if (value == 'edit') {
                          _showEditDialog(client);
                        } else if (value == 'delete') {
                          _showDeleteDialog(client);
                        }
                      });
                    },
                  ),
                 */
                ],
              ),
              Divider(height: 24, color: AppColors.blueGreyBorder),
              Row(
                children: [
                  Icon(CupertinoIcons.mail, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      client.email,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(CupertinoIcons.phone, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 6),
                  Text(
                    client.phone,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Divider(height: 24, color: AppColors.blueGreyBorder),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                alignment: WrapAlignment.start,
                children: [
                  _buildInfoChip(
                    CupertinoIcons.building_2_fill,
                    "${client.totalHotels} Hotels",
                  ),
                  _buildInfoChip(
                    CupertinoIcons.money_dollar,
                    "\$${client.totalRevenue.toStringAsFixed(0)}",
                  ),
                  _buildInfoChip(
                    CupertinoIcons.calendar,
                    client.lastPaymentExpiry?.goodDayDate() ?? 'N/A',
                  ),
                ],
              ),
              Divider(height: 24, color: AppColors.blueGreyBorder),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.go(Routes.clientDetail(client.docId));
                      },
                      icon: const Icon(CupertinoIcons.eye, size: 16),
                      label: const Text("View Details"),
                      style: OutlinedButton.styleFrom(
                        // backgroundColor: AppColors.primary,
                        side: BorderSide(
                          width: .7,
                          color: AppColors.primary.withAlpha(80),
                        ),
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () => _showEditDialog(client),
                    child: Icon(Icons.edit, size: 18),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => _showDeleteDialog(client),
                    child: Icon(
                      CupertinoIcons.delete,
                      size: 18,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Desktop Table View
  Widget _buildActiveClientTabel(BuildContext context, ClientState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blueGreyBorder),
      ),
      child: Column(
        children: [
          _buildTabelHeading(context),
          if (state.isLoading && state.activeClients.isEmpty)
            Center(child: CircularProgressIndicator())
          else if (state.message != null &&
              state.activeClients.isEmpty &&
              state.message != "Client Deleted")
            _buildErrorState(state.message!)
          else if (state.filteredActiveClients.isEmpty)
            _buildEmptyState()
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                _buildTabelHeader(),
                const SizedBox(height: 13),
                const Divider(
                  color: AppColors.slateGray,
                  thickness: 0.07,
                  height: 0,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.slateGray,
                    thickness: 0.07,
                    height: 0,
                  ),
                  physics: ClampingScrollPhysics(),
                  itemCount: state.filteredActiveClients.length,
                  itemBuilder: (context, index) {
                    final client = state.filteredActiveClients[index];
                    return _buildClientRow(client);
                  },
                ),
                const SizedBox(height: 20),
                if (state.activeTotalPages > 1 &&
                    context.read<ClientCubit>().searchController.text.isEmpty)
                  DynamicPagination(
                    currentPage: state.activeCurrentPage,
                    totalPages: state.activeTotalPages,
                    onPageChanged: (page) {
                      context.read<ClientCubit>().fetchNextActiveClientsPage(
                        page: page,
                      );
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(message, style: GoogleFonts.inter(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<ClientCubit>()
                  .initializeActiveClientsPagination(),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.person_2, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No active clients found",
              style: GoogleFonts.inter(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildTabelHeading(BuildContext context) {
    return Row(
      children: [
        Text("Active Clients List", style: AppTextStyles.customContainerTitle),
        const Spacer(),
        SizedBox(
          width: 300,
          height: 43,
          child: TextField(
            controller: context.read<ClientCubit>().searchController,
            cursorHeight: 20,
            decoration: InputDecoration(
              fillColor: Color(0xfffafafa),
              filled: true,
              hintText: "Search active clients...",
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: AppColors.slateGray,
                size: 20,
              ),
              hoverColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.blueGreyBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.blueGreyBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.blueGreyBorder),
              ),
              hintStyle: GoogleFonts.inter(
                color: AppColors.slateGray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: (value) {
              context.read<ClientCubit>().searchClients(value);
            },
          ),
        ),
      ],
    );
  }

  Row _buildTabelHeader() {
    return Row(
      children: [
        SizedBox(width: TableConfig.horizontalSpacing),
        Expanded(
          flex: 2,
          child: Text("Client", style: AppTextStyles.tabelHeader),
        ),
        Expanded(
          flex: 2,
          child: Text("Contact", style: AppTextStyles.tabelHeader),
        ),
        Expanded(child: Text("Hotels", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Revenue", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Expiry", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Status", style: AppTextStyles.tabelHeader)),
        SizedBox(
          width: TableConfig.viewColumnWidth,
          child: Text("View", style: AppTextStyles.tabelHeader),
        ),
        SizedBox(
          width: TableConfig.actionColumnWidth,
          child: Text("Actions", style: AppTextStyles.tabelHeader),
        ),
      ],
    );
  }

  Widget _buildClientRow(ClientModel client) {
    return Padding(
      padding: TableConfig.rowPadding,
      child: Row(
        children: [
          SizedBox(width: TableConfig.horizontalSpacing),
          Expanded(
            flex: 2,
            child: TableTwoLineContent(
              primaryText: client.name,
              secondaryText: "Joined ${client.createdAt.goodDayDate()}",
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableIconTextRow(icon: CupertinoIcons.mail, text: client.email),
                SizedBox(height: TableConfig.verticalSpacing),
                TableIconTextRow(
                  icon: CupertinoIcons.phone,
                  text: client.phone,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              "${client.totalHotels}",
              style: AppTextStyles.tableRowBoldValue,
            ),
          ),
          Expanded(
            child: Text(
              "\$${client.totalRevenue.toStringAsFixed(0)}",
              style: AppTextStyles.tableRowBoldValue,
            ),
          ),
          Expanded(
            child: Text(
              client.lastPaymentExpiry?.goodDayDate() ?? 'N/A',
              style: AppTextStyles.tableRowBoldValue,
            ),
          ),
          Expanded(child: Row(children: [_buildStatusBadge(client.status)])),
          SizedBox(
            width: TableConfig.viewColumnWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TableActionButton(
                  icon: Icons.remove_red_eye_outlined,
                  onPressed: () {
                    context.go(Routes.clientDetail(client.docId));
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: TableConfig.actionColumnWidth,
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_horiz,
                size: TableConfig.mediumIconSize,
                color: AppColors.textBlackColor,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, size: 18),
                    title: Text('Edit'),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(CupertinoIcons.delete, color: Colors.red),
                    title: Text(
                      'Delete',
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                  ),
                ),
              ],
              onSelected: (value) {
                Future.delayed(Duration.zero, () {
                  if (value == 'edit') {
                    _showEditDialog(client);
                  } else if (value == 'delete') {
                    _showDeleteDialog(client);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(ClientModel client) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Color(0xffFAFAFA),
          child: ClientFormModal(clientToEdit: client),
        );
      },
    );
  }

  void _showDeleteDialog(ClientModel client) {
    showConfirmDeletDialog<ClientCubit, ClientState>(
      context: context,
      onBtnTap: () {
        context.read<ClientCubit>().deleteClient(client.docId);
      },
      title: "Delete Client",
      message: "Are you sure you want to delete ${client.name}?",
      btnText: "Delete",
      isLoadingSelector: (state) => state.isLoading,
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == 'active' ? Colors.green : Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: .8),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          letterSpacing: .5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
