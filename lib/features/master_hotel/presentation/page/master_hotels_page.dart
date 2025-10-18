import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-hotel/masterhotel_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/widgets/masterhotel_form.dart';

class MasterHotelsPage extends StatefulWidget {
  const MasterHotelsPage({super.key});

  @override
  State<MasterHotelsPage> createState() => _MasterHotelsPageState();
}

class _MasterHotelsPageState extends State<MasterHotelsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MasterHotelCubit>().fetchMasterHotels();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveCustomBuilder(
        mobileBuilder: (width) => _buildMobileLayout(width),
        tabletBuilder: (width) => _buildTabletLayout(width),
        desktopBuilder: (width) => _buildDesktopLayout(width),
      ),
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _buildHeader(context, isMobile: true),
          const SizedBox(height: 16),
          _buildMobileCards(),
        ],
      ),
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        children: [
          _buildHeader(context, isTablet: true),
          const SizedBox(height: 18),
          _buildTabletTable(),
        ],
      ),
    );
  }

  // Desktop Layout
  Widget _buildDesktopLayout(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildDesktopTable(),
        ],
      ),
    );
  }

  // Header
  Widget _buildHeader(
    BuildContext context, {
    bool isMobile = false,
    bool isTablet = false,
  }) {
    return PageHeaderWithButton(
      heading: "Hotel Masters",
      subHeading: isMobile
          ? "Manage hotels"
          : "Manage hotel franchises and their master tasks",
      buttonText: isMobile ? "Add Hotel" : "Add Hotel Master",
      onButtonPressed: () {
        _showCreateMasterHotelModal(context, isMobile);
      },
    );
  }

  _showCreateMasterHotelModal(BuildContext context, bool isMobile) {
    if (isMobile) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const MasterHotelForm(),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xffFAFAFA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? 350 : 600),
                child: MasterHotelForm(),
              ),
            ),
          );
        },
      );
    }
  }

  // Mobile Cards View
  Widget _buildMobileCards() {
    return BlocConsumer<MasterHotelCubit, MasterhotelState>(
      listener: (context, state) {
        if (state.message != null && state.message!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message ?? "")));
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.masterHotels.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.building_2_fill,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No Hotels Found",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.masterHotels.length,
          itemBuilder: (context, index) {
            final masterHotel = state.masterHotels[index];
            return _buildMobileCard(masterHotel, context, state);
          },
        );
      },
    );
  }

  // Mobile Card Widget
  Widget _buildMobileCard(
    MasterHotelModel masterHotel,
    BuildContext context,
    MasterhotelState state,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        masterHotel.franchiseName,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Created ${masterHotel.createdAt.goodDayDate()}",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.slateGray,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: AppColors.textBlackColor,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.list_bullet, size: 16),
                          const SizedBox(width: 8),
                          Text('View Tasks'),
                        ],
                      ),
                      onTap: () {
                        context.go(
                          '/master-hotels/${masterHotel.docId}/tasks?hotelName=${Uri.encodeComponent(masterHotel.franchiseName)}',
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 18),
                          const SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: const Color(0xffFAFAFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 350,
                                  ),
                                  child: MasterHotelForm(
                                    editMasterHotel: masterHotel,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.delete,
                            size: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: GoogleFonts.inter(color: Colors.red),
                          ),
                        ],
                      ),
                      onTap: () {
                        showConfirmDeletDialog<
                          MasterHotelCubit,
                          MasterhotelState
                        >(
                          context: context,
                          onBtnTap: () {
                            context.read<MasterHotelCubit>().deleteMasterHotel(
                              masterHotel.docId,
                            );
                          },
                          title: "Delete Hotel Master",
                          message:
                              "Are you sure you want to delete this hotel master?",
                          btnText: "Delete",
                          isLoadingSelector: (state) => state.isLoading,
                          successMessageSelector: (state) =>
                              state.message ?? "",
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Property Type & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Property Type",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.slateGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      masterHotel.propertyType,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: statusColor(masterHotel.propertyType),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      masterHotel.isActive ? "Active" : "Inactive",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.slateGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        activeColor: AppColors.primary,
                        value: masterHotel.isActive,
                        onChanged: (value) {
                          context
                              .read<MasterHotelCubit>()
                              .updateStatusOfMasterHotel(
                                masterHotel.docId,
                                value,
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatChip(
                    icon: CupertinoIcons.person_2,
                    count: masterHotel.totalClients,
                    label: "clients",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatChip(
                    icon: Icons.checklist,
                    count: masterHotel.totalMasterTasks,
                    label: "tasks",
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 12),

            // const Divider(height: 1),
            // const SizedBox(height: 12),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 2,
            //       child: OutlinedButton.icon(
            //         onPressed: () {
            //           context.go(
            //             '/master-hotels/${masterHotel.docId}/tasks?hotelName=${Uri.encodeComponent(masterHotel.franchiseName)}',
            //           );
            //         },
            //         icon: const Icon(CupertinoIcons.eye, size: 16),
            //         label: const Text("View Tasks"),
            //         style: OutlinedButton.styleFrom(
            //           // backgroundColor: AppColors.primary,
            //           side: BorderSide(
            //             width: .7,
            //             color: AppColors.primary.withAlpha(80),
            //           ),
            //           foregroundColor: AppColors.primary,
            //           padding: const EdgeInsets.symmetric(vertical: 10),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(6),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Spacer(),
            //     const SizedBox(width: 20),
            //     InkWell(
            //       onTap: () => _showEditAndAddDialog(masterHotel, true),
            //       child: Icon(Icons.edit, size: 18),
            //     ),
            //     const SizedBox(width: 12),
            //     InkWell(
            //       onTap: () => _showDeleteDialog(masterHotel),
            //       child: Icon(
            //         CupertinoIcons.delete,
            //         size: 18,
            //         color: Colors.red,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  _showEditAndAddDialog(MasterHotelModel masterHotel, bool isMobile) {
    if (isMobile) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: MasterHotelForm(editMasterHotel: masterHotel),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xffFAFAFA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: MasterHotelForm(editMasterHotel: masterHotel),
          );
        },
      );
    }
  }

  _showDeleteDialog(MasterHotelModel masterHotel) {
    showConfirmDeletDialog<MasterHotelCubit, MasterhotelState>(
      context: context,
      onBtnTap: () {
        context.read<MasterHotelCubit>().deleteMasterHotel(masterHotel.docId);
      },
      title: "Delete Hotel Master",
      message: "Are you sure you want to delete this hotel master?",
      btnText: "Delete",
      isLoadingSelector: (state) => state.isLoading,
      successMessageSelector: (state) => state.message ?? "",
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required int count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            "$count",
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray),
          ),
        ],
      ),
    );
  }

  // Tablet Table View (Simplified)
  Widget _buildTabletTable() {
    return CustomContainer(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Franchise Directory",
                style: AppTextStyles.customContainerTitle,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTabletTableHeader(),
          const SizedBox(height: 10),
          const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
          BlocConsumer<MasterHotelCubit, MasterhotelState>(
            listener: (context, state) {
              if (state.message != null && state.message!.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message ?? "")));
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state.masterHotels.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      "No Hotels Found",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.slateGray,
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.masterHotels.length,
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.slateGray,
                  thickness: 0.07,
                  height: 0,
                ),
                itemBuilder: (context, index) {
                  final masterHotel = state.masterHotels[index];
                  return _buildTabletTableRow(masterHotel, context, state);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabletTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text("Franchise", style: AppTextStyles.tabelHeader),
          ),
          Expanded(child: Text("Type", style: AppTextStyles.tabelHeader)),
          SizedBox(
            width: 80,
            child: Text("Clients", style: AppTextStyles.tabelHeader),
          ),
          SizedBox(
            width: 80,
            child: Text("Tasks", style: AppTextStyles.tabelHeader),
          ),
          SizedBox(
            width: 70,
            child: Text("Status", style: AppTextStyles.tabelHeader),
          ),
          SizedBox(
            width: 60,
            child: Text("", style: AppTextStyles.tabelHeader),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletTableRow(
    MasterHotelModel masterHotel,
    BuildContext context,
    MasterhotelState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TableTwoLineContent(
              primaryText: masterHotel.franchiseName,
              secondaryText: "Created ${masterHotel.createdAt.goodDayDate()}",
            ),
          ),
          Expanded(
            child: Text(
              masterHotel.propertyType,
              style: AppTextStyles.tableRowBoldValue.copyWith(
                color: statusColor(masterHotel.propertyType),
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              "${masterHotel.totalClients}",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              "${masterHotel.totalMasterTasks}",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                activeColor: AppColors.primary,
                value: masterHotel.isActive,
                onChanged: (value) {
                  context.read<MasterHotelCubit>().updateStatusOfMasterHotel(
                    masterHotel.docId,
                    value,
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_horiz,
                size: 20,
                color: AppColors.textBlackColor,
              ),
              itemBuilder: (context) => _buildMenuItems(masterHotel, context),
            ),
          ),
        ],
      ),
    );
  }

  // Desktop Table View (Full)
  Widget _buildDesktopTable() {
    return CustomContainer(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Franchise Directory",
                style: AppTextStyles.customContainerTitle,
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildDesktopTableHeader(),
          const SizedBox(height: 13),
          const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
          BlocConsumer<MasterHotelCubit, MasterhotelState>(
            listener: (context, state) {
              if (state.message != null && state.message!.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message ?? "")));
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state.masterHotels.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      "No Hotels Found",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.slateGray,
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.masterHotels.length,
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.slateGray,
                  thickness: 0.07,
                  height: 0,
                ),
                itemBuilder: (context, index) {
                  final masterHotel = state.masterHotels[index];
                  return _buildDesktopTableRow(
                    masterHotel,
                    context,
                    index,
                    state,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: TableConfig.horizontalSpacing / 2),
        Expanded(child: Text("Franchise", style: AppTextStyles.tabelHeader)),
        Expanded(
          child: Text("Property Type", style: AppTextStyles.tabelHeader),
        ),
        Expanded(
          child: Text("No. of Clients", style: AppTextStyles.tabelHeader),
        ),
        Expanded(child: Text("Master Tasks", style: AppTextStyles.tabelHeader)),
        SizedBox(
          width: TableConfig.viewColumnWidth,
          child: Text("Status", style: AppTextStyles.tabelHeader),
        ),
        SizedBox(
          width: TableConfig.viewColumnWidth,
          child: Text("Actions", style: AppTextStyles.tabelHeader),
        ),
        SizedBox(width: TableConfig.horizontalSpacing / 2),
      ],
    );
  }

  Widget _buildDesktopTableRow(
    MasterHotelModel masterHotel,
    BuildContext context,
    int index,
    MasterhotelState state,
  ) {
    return Padding(
      padding: TableConfig.rowPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: TableConfig.horizontalSpacing / 2),
          Expanded(
            child: TableTwoLineContent(
              primaryText: masterHotel.franchiseName,
              secondaryText: "Created ${masterHotel.createdAt.goodDayDate()}",
            ),
          ),
          Expanded(
            child: Row(
              children: [_buildHotelTypeBadge(masterHotel.propertyType)],
            ),
          ),
          Expanded(
            child: TableIconCountLabel(
              icon: CupertinoIcons.person_2,
              count: masterHotel.totalClients,
              label: "clients",
            ),
          ),
          Expanded(
            child: TableIconCountLabel(
              icon: Icons.checklist,
              count: masterHotel.totalMasterTasks,
              label: "tasks",
            ),
          ),
          SizedBox(
            width: TableConfig.viewColumnWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    activeColor: AppColors.primary,
                    value: masterHotel.isActive,
                    onChanged: (value) {
                      context
                          .read<MasterHotelCubit>()
                          .updateStatusOfMasterHotel(masterHotel.docId, value);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: TableConfig.viewColumnWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_horiz,
                    size: TableConfig.mediumIconSize,
                    color: AppColors.textBlackColor,
                  ),
                  itemBuilder: (context) =>
                      _buildMenuItems(masterHotel, context),
                ),
              ],
            ),
          ),
          SizedBox(width: TableConfig.horizontalSpacing / 2),
        ],
      ),
    );
  }

  List<PopupMenuEntry> _buildMenuItems(
    MasterHotelModel masterHotel,
    BuildContext context,
  ) {
    return [
      PopupMenuItem(
        child: Row(
          children: [
            const Icon(CupertinoIcons.list_bullet, size: 16),
            const SizedBox(width: 8),
            Text('View Tasks'),
          ],
        ),
        onTap: () {
          context.go(
            '/master-hotels/${masterHotel.docId}/tasks?hotelName=${Uri.encodeComponent(masterHotel.franchiseName)}',
          );
        },
      ),
      PopupMenuItem(
        child: Row(
          children: [
            const Icon(Icons.edit, size: 18),
            const SizedBox(width: 8),
            Text('Edit'),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: const Color(0xffFAFAFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: MasterHotelForm(editMasterHotel: masterHotel),
              );
            },
          );
        },
      ),
      PopupMenuItem(
        child: Row(
          children: [
            const Icon(CupertinoIcons.delete, size: 16, color: Colors.red),
            const SizedBox(width: 8),
            Text('Delete', style: GoogleFonts.inter(color: Colors.red)),
          ],
        ),
        onTap: () {
          showConfirmDeletDialog<MasterHotelCubit, MasterhotelState>(
            context: context,
            onBtnTap: () {
              context.read<MasterHotelCubit>().deleteMasterHotel(
                masterHotel.docId,
              );
            },
            title: "Delete Hotel Master",
            message: "Are you sure you want to delete this hotel master?",
            btnText: "Delete",
            isLoadingSelector: (state) => state.isLoading,
            successMessageSelector: (state) => state.message ?? "",
          );
        },
      ),
    ];
  }

  Widget _buildHotelTypeBadge(String hotelType) {
    Color color;
    switch (hotelType) {
      case HotelTypes.hotel:
        color = Colors.purple;
        break;
      case HotelTypes.resort:
        color = Colors.green;
        break;
      case HotelTypes.motel:
        color = Colors.orange;
        break;
      case HotelTypes.villa:
        color = Colors.blue;
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
        hotelType.toUpperCase(),
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/utils/const.dart';
// import 'package:taskoteladmin/core/utils/helpers.dart';
// import 'package:taskoteladmin/core/widget/custom_container.dart';
// import 'package:taskoteladmin/core/widget/page_header.dart';
// import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
// import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
// import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-hotel/masterhotel_cubit.dart';
// import 'package:taskoteladmin/features/master_hotel/presentation/widgets/masterhotel_form.dart';

// class MasterHotelsPage extends StatefulWidget {
//   const MasterHotelsPage({super.key});

//   @override
//   State<MasterHotelsPage> createState() => _MasterHotelsPageState();
// }

// class _MasterHotelsPageState extends State<MasterHotelsPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<MasterHotelCubit>().fetchMasterHotels();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//       child: Column(
//         children: [_buildHeader(context), SizedBox(height: 20), _buildTabel()],
//       ),
//     );
//   }

//   // Header
//   Widget _buildHeader(BuildContext context) {
//     return PageHeaderWithButton(
//       heading: "Hotel Masters",
//       subHeading: "Manage hotel franchises and their master tasks",
//       buttonText: "Add Hotel Master",
//       onButtonPressed: () {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return Dialog(
//               backgroundColor: Color(0xffFAFAFA),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: MasterHotelForm(),
//             );
//           },
//         );
//       },
//     );
//   }

//   // Table
//   Widget _buildTabel() {
//     return CustomContainer(
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text(
//                 "Franchise Directory",
//                 style: GoogleFonts.inter(
//                   fontSize: 21,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 30),

//           _buildTableHeader(),
//           SizedBox(height: 13),
//           const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),

//           BlocConsumer<MasterHotelCubit, MasterhotelState>(
//             listener: (context, state) {
//               if (state.message != null && state.message!.isNotEmpty) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text(state.message ?? "")));
//               }
//             },
//             builder: (context, state) {
//               if (state.isLoading) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (state.masterHotels.isEmpty) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                     child: Text(
//                       "No Hotels Found",
//                       style: GoogleFonts.inter(
//                         fontSize: 16,
//                         color: AppColors.slateGray,
//                       ),
//                     ),
//                   ),
//                 );
//               }
//               return ListView.separated(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: state.masterHotels.length,
//                 separatorBuilder: (context, index) => Divider(
//                   color: AppColors.slateGray,
//                   thickness: 0.07,
//                   height: 0,
//                 ),
//                 itemBuilder: (context, index) {
//                   final masterHotel = state.masterHotels[index];
//                   return _buildHotelMasterRow(
//                     masterHotel,
//                     context,
//                     index,
//                     state,
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Table Header
//   Widget _buildTableHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         // SizedBox(width: TableConfig.horizontalSpacing / 2), // 15px
//         SizedBox(width: TableConfig.horizontalSpacing / 2),
//         Expanded(child: Text("Franchise", style: AppTextStyles.tabelHeader)),
//         Expanded(
//           child: Text("Property Type", style: AppTextStyles.tabelHeader),
//         ),
//         Expanded(
//           child: Text("No. of Clients", style: AppTextStyles.tabelHeader),
//         ),
//         Expanded(child: Text("Master Tasks", style: AppTextStyles.tabelHeader)),
//         SizedBox(
//           width: TableConfig.viewColumnWidth,
//           child: Text("Status", style: AppTextStyles.tabelHeader),
//         ),
//         SizedBox(
//           width: TableConfig.viewColumnWidth,
//           child: Text("Actions", style: AppTextStyles.tabelHeader),
//         ),
//         SizedBox(width: TableConfig.horizontalSpacing / 2), // 15px
//       ],
//     );
//   }

//   // Table Row
//   Widget _buildHotelMasterRow(
//     MasterHotelModel masterHotel,
//     BuildContext context,
//     int index,
//     MasterhotelState state,
//   ) {
//     return Padding(
//       padding: TableConfig.rowPadding,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(width: TableConfig.horizontalSpacing / 2), // 15px
//           // Franchise Name and Created Date
//           Expanded(
//             child: TableTwoLineContent(
//               primaryText: masterHotel.franchiseName,
//               secondaryText: "Created ${masterHotel.createdAt.goodDayDate()}",
//             ),
//           ),

//           // Property Type
//           Expanded(
//             child: Text(
//               masterHotel.propertyType,
//               style: AppTextStyles.tableRowBoldValue.copyWith(
//                 color: statusColor(masterHotel.propertyType),
//               ),
//             ),
//           ),

//           // No. of Clients
//           Expanded(
//             child: TableIconCountLabel(
//               icon: CupertinoIcons.person_2,
//               count: masterHotel.totalClients,
//               label: "clients",
//             ),
//           ),

//           // Master Tasks
//           Expanded(
//             child: TableIconCountLabel(
//               icon: Icons.checklist,
//               count: masterHotel.totalMasterTasks,
//               label: "tasks",
//             ),
//           ),

//           // Status Toggle
//           SizedBox(
//             width: TableConfig.viewColumnWidth,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Transform.scale(
//                   scale: 0.7,
//                   child: CupertinoSwitch(
//                     activeTrackColor: AppColors.primary,
//                     value: masterHotel.isActive,
//                     onChanged: (value) {
//                       context
//                           .read<MasterHotelCubit>()
//                           .updateStatusOfMasterHotel(masterHotel.docId, value);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Actions Menu
//           SizedBox(
//             width: TableConfig.viewColumnWidth,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 PopupMenuButton(
//                   icon: Icon(
//                     Icons.more_horiz,
//                     size: TableConfig.mediumIconSize,
//                     color: AppColors.textBlackColor,
//                   ),
//                   itemBuilder: (context) => [
//                     PopupMenuItem(
//                       child: Row(
//                         children: [
//                           Icon(CupertinoIcons.list_bullet, size: 16),
//                           SizedBox(width: 8),
//                           Text('View Tasks'),
//                         ],
//                       ),
//                       onTap: () {
//                         context.go(
//                           '/master-hotels/${masterHotel.docId}/tasks?hotelName=${Uri.encodeComponent(masterHotel.franchiseName)}',
//                         );
//                       },
//                     ),
//                     PopupMenuItem(
//                       child: Row(
//                         children: [
//                           Icon(Icons.edit, size: 16),
//                           SizedBox(width: 8),
//                           Text('Edit'),
//                         ],
//                       ),
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return Dialog(
//                               backgroundColor: Color(0xffFAFAFA),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: MasterHotelForm(
//                                 editMasterHotel: masterHotel,
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                     PopupMenuItem(
//                       child: Row(
//                         children: [
//                           Icon(
//                             CupertinoIcons.delete,
//                             size: 16,
//                             color: Colors.red,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'Delete',
//                             style: GoogleFonts.inter(color: Colors.red),
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         showConfirmDeletDialog<
//                           MasterHotelCubit,
//                           MasterhotelState
//                         >(
//                           context: context,
//                           onBtnTap: () {
//                             context.read<MasterHotelCubit>().deleteMasterHotel(
//                               masterHotel.docId,
//                             );
//                           },
//                           title: "Delete Hotel Master",
//                           message:
//                               "Are you sure you want to delete this hotel master?",
//                           btnText: "Delete",
//                           isLoadingSelector: (state) => state.isLoading,
//                           successMessageSelector: (state) =>
//                               state.message ?? "",
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: TableConfig.horizontalSpacing / 2), // 15px
//         ],
//       ),
//     );
//   }
// }
