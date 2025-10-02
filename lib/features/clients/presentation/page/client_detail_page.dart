import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';

class ClientDetailPage extends StatefulWidget {
  final String clientId;
  ClientDetailPage({super.key, required this.clientId});

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientDetailCubit, ClientDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(state),
              const SizedBox(height: 20),
              _buildAnalytics(state),
              _buildHotelPortfolioTable(context, (state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ClientDetailState state) {
    return PageHeaderWithTitle(
      heading: state.client?.name ?? '',
      subHeading: "Comprehensive client overview and hotel management",
    );
  }

  StaggeredGrid _buildAnalytics(ClientDetailState state) {
    return StaggeredGrid.extent(
      maxCrossAxisExtent: 400,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        StatCardIconLeft(
          icon: CupertinoIcons.building_2_fill,
          label: "Total Hotels",
          value: "${state.clientAnalytics?.totalHotels ?? 0}",
          iconColor: Colors.blue,
        ),

        StatCardIconLeft(
          icon: Icons.checklist,
          label: "Total Tasks",
          value: "${state.clientAnalytics?.totalTasks ?? 0}",
          iconColor: Colors.orange,
        ),
        StatCardIconLeft(
          icon: CupertinoIcons.money_dollar,
          label: "Total Revenue",
          value: "\$${state.clientAnalytics?.totalRevenue ?? 0}",
          iconColor: Colors.green,
        ),

        StatCardIconLeft(
          icon: CupertinoIcons.person_2,
          label: "Active Subscriptions",
          value: "${state.clientAnalytics?.activeSubscriptions ?? 0}",
          iconColor: Colors.green,
        ),

        StatCardIconLeft(
          icon: CupertinoIcons.star_fill,
          label: "Average Hotel Rating",
          value: "${state.clientAnalytics?.averageHotelRating ?? 0}",
          iconColor: Colors.green,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHotelPortfolioTable(
    BuildContext context,
    ClientDetailState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blueGreyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hotel Portfolio", style: AppTextStyles.dialogHeading),
          const SizedBox(height: 20),
          _buildHotelTableHeader(),
          const SizedBox(height: 10),
          const Divider(color: AppColors.slateGray, thickness: 0.1),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.hotels.length,
            separatorBuilder: (_, __) => const Divider(
              color: AppColors.slateGray,
              thickness: 0.07,
              height: 0,
            ),
            itemBuilder: (context, index) {
              final hotel = state.hotels[index];
              final totalRooms = hotel.floors.values.fold<int>(
                0,
                (sum, rooms) => sum + rooms,
              );
              return _buildHotelRow(context, hotel, totalRooms);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHotelTableHeader() {
    return Row(
      children: [
        const SizedBox(width: 30),
        Expanded(
          flex: 2,
          child: Text("Hotel Name", style: AppTextStyles.tabelHeader),
        ),
        Expanded(
          flex: 2,
          child: Text("Location", style: AppTextStyles.tabelHeader),
        ),
        Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
        Expanded(
          flex: 2,
          child: Text("Plan Duration", style: AppTextStyles.tabelHeader),
        ),
        Expanded(child: Text("Users", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Tasks", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Rooms", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Revenue", style: AppTextStyles.tabelHeader)),
        SizedBox(
          width: 100,
          child: Text("View", style: AppTextStyles.tabelHeader),
        ),
      ],
    );
  }

  Widget _buildHotelRow(
    BuildContext context,
    HotelModel hotel,
    int totalRooms,
  ) {
    return Padding(
      padding: TableConfig.rowPadding,
      child: Row(
        children: [
          const SizedBox(width: 30),

          // Hotel Name
          Expanded(
            flex: 2,
            child: TableIconTextRow(
              icon: CupertinoIcons.building_2_fill,
              text: hotel.name,
            ),
          ),

          // Location
          Expanded(
            flex: 2,
            child: TableIconTextRow(
              icon: CupertinoIcons.placemark,
              text: "${hotel.addressModel.city}, ${hotel.addressModel.state}",
            ),
          ),

          // Plan Name
          Expanded(
            child: Text(
              hotel.subscriptionName,
              style: AppTextStyles.tableRowBoldValue,
            ),
          ),

          // Plan Duration
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableIconTextRow(
                  icon: CupertinoIcons.calendar,
                  text: "Start: ${hotel.subscriptionStart.goodDayDate()}",
                ),
                TableIconTextRow(
                  icon: CupertinoIcons.calendar,
                  text: "Expiry: ${hotel.subscriptionEnd.goodDayDate()}",
                ),
              ],
            ),
          ),

          // Users
          Expanded(
            child: TableIconTextRow(
              icon: CupertinoIcons.person_2,
              text: hotel.totalUser.toString(),
            ),
          ),

          // Tasks
          Expanded(
            child: TableIconTextRow(
              icon: Icons.checklist,
              text: hotel.totaltask.toString(),
            ),
          ),

          // Total Rooms
          Expanded(
            child: Text(
              totalRooms.toString(),
              style: AppTextStyles.tableRowBoldValue,
            ),
          ),

          // Revenue
          Expanded(
            child: Text(
              "\$${hotel.totalRevenue}",
              style: AppTextStyles.tableRowBoldValue,
            ),
          ),

          // View Button
          SizedBox(
            width: 100,
            child: TableActionButton(
              icon: CupertinoIcons.eye,
              onPressed: () {
                context.go(Routes.hotelDetail(widget.clientId, hotel.docId));
              },
            ),
          ),
        ],
      ),
    );
  }
}
