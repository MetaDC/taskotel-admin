import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [_buildHeader(context), SizedBox(height: 20), _buildTabel()],
      ),
    );
  }

  // Header
  Widget _buildHeader(BuildContext context) {
    return PageHeaderWithButton(
      heading: "Hotel Masters",
      subHeading: "Manage hotel franchises and their master tasks",
      buttonText: "Add Hotel Master",
      onButtonPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Color(0xffFAFAFA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: MasterHotelForm(),
            );
          },
        );
      },
    );
  }

  // Table
  Widget _buildTabel() {
    return CustomContainer(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Franchise Directory",
                style: GoogleFonts.inter(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          _buildTableHeader(),
          SizedBox(height: 13),
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
                return Center(child: CircularProgressIndicator());
              }
              if (state.masterHotels.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.masterHotels.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.slateGray,
                  thickness: 0.07,
                  height: 0,
                ),
                itemBuilder: (context, index) {
                  final masterHotel = state.masterHotels[index];
                  return _buildHotelMasterRow(
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

  // Table Header
  Widget _buildTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // SizedBox(width: TableConfig.horizontalSpacing / 2), // 15px
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
        SizedBox(width: TableConfig.horizontalSpacing / 2), // 15px
      ],
    );
  }

  // Table Row
  Widget _buildHotelMasterRow(
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
          SizedBox(width: TableConfig.horizontalSpacing / 2), // 15px
          // Franchise Name and Created Date
          Expanded(
            child: TableTwoLineContent(
              primaryText: masterHotel.franchiseName,
              secondaryText: "Created ${masterHotel.createdAt.goodDayDate()}",
            ),
          ),

          // Property Type
          Expanded(
            child: Text(
              masterHotel.propertyType,
              style: AppTextStyles.tableRowBoldValue.copyWith(
                color: statusColor(masterHotel.propertyType),
              ),
            ),
          ),

          // No. of Clients
          Expanded(
            child: TableIconCountLabel(
              icon: CupertinoIcons.person_2,
              count: masterHotel.totalClients,
              label: "clients",
            ),
          ),

          // Master Tasks
          Expanded(
            child: TableIconCountLabel(
              icon: Icons.checklist,
              count: masterHotel.totalMasterTasks,
              label: "tasks",
            ),
          ),

          // Status Toggle
          SizedBox(
            width: TableConfig.viewColumnWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    activeTrackColor: AppColors.primary,
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

          // Actions Menu
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
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.list_bullet, size: 16),
                          SizedBox(width: 8),
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
                          Icon(CupertinoIcons.pencil, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Color(0xffFAFAFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: MasterHotelForm(
                                editMasterHotel: masterHotel,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.delete,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
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
          ),
          SizedBox(width: TableConfig.horizontalSpacing / 2), // 15px
        ],
      ),
    );
  }
}
