import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';

const double mobileMinSize = 768;
const double desktopMinSize = 1024;

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
        return ResponsiveCustomBuilder(
          mobileBuilder: (width) => _buildMobileLayout(state, width),
          tabletBuilder: (width) => _buildTabletLayout(state, width),
          desktopBuilder: (width) => _buildDesktopLayout(state, width),
        );
      },
    );
  }

  // Desktop Layout (>1024px)
  Widget _buildDesktopLayout(ClientDetailState state, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(state),
            const SizedBox(height: 20),
            _buildAnalytics(state),
            const SizedBox(height: 20),
            _buildHotelPortfolioTable(context, state, width),
          ],
        ),
      ),
    );
  }

  // Tablet Layout (768-1024px)
  Widget _buildTabletLayout(ClientDetailState state, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(state),
            const SizedBox(height: 16),
            _buildAnalytics(state),
            const SizedBox(height: 16),
            _buildHotelPortfolioTable(context, state, width),
          ],
        ),
      ),
    );
  }

  // Mobile Layout (<768px)
  Widget _buildMobileLayout(ClientDetailState state, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(state),
            const SizedBox(height: 12),
            _buildAnalytics(state),
            const SizedBox(height: 12),
            _buildHotelPortfolioTable(context, state, width),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ClientDetailState state) {
    return PageHeaderWithTitle(
      heading: state.client?.name ?? '',
      subHeading: "Comprehensive client overview and hotel management",
    );
  }

  Widget _buildAnalytics(ClientDetailState state) {
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
      ],
    );
  }

  Widget _buildHotelPortfolioTable(
    BuildContext context,
    ClientDetailState state,
    double width,
  ) {
    final isMobile = width < mobileMinSize;
    final isTablet = width >= mobileMinSize && width < desktopMinSize;

    return Container(
      padding: EdgeInsets.all(isMobile ? 0 : 20),
      decoration: isMobile
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.blueGreyBorder),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hotel Portfolio",
            style: AppTextStyles.dialogHeading.copyWith(
              fontSize: isMobile ? 18 : null,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 20),
          if (state.hotels.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "No Hotels Found",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.slateGray,
                  ),
                ),
              ),
            )
          else if (isMobile)
            _buildMobileHotelList(context, state)
          else
            _buildDesktopHotelTable(context, state, isTablet),
        ],
      ),
    );
  }

  Widget _buildMobileHotelList(BuildContext context, ClientDetailState state) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.hotels.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final hotel = state.hotels[index];
        final totalRooms = hotel.floors.values.fold<int>(
          0,
          (sum, rooms) => sum + rooms,
        );
        return _buildMobileHotelCard(context, hotel, totalRooms);
      },
    );
  }

  Widget _buildMobileHotelCard(
    BuildContext context,
    HotelModel hotel,
    int totalRooms,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blueGreyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.building_2_fill,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hotel.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                CupertinoIcons.placemark,
                size: 14,
                color: AppColors.slateGray,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "${hotel.addressModel.city}, ${hotel.addressModel.state}",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.slateGray,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff3e85f6).withOpacity(0.1),
              border: Border.all(color: const Color(0xff3e85f6), width: 0.7),
            ),
            child: Text(
              hotel.subscriptionName,
              style: GoogleFonts.inter(
                color: const Color(0xff3e85f6),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  "Start",
                  hotel.subscriptionStart.goodDayDate(),
                  CupertinoIcons.calendar,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  "Expiry",
                  hotel.subscriptionEnd.goodDayDate(),
                  CupertinoIcons.calendar,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  "Users",
                  hotel.totalUser.toString(),
                  CupertinoIcons.person_2,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  "Tasks",
                  hotel.totaltask.toString(),
                  Icons.checklist,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  "Rooms",
                  totalRooms.toString(),
                  CupertinoIcons.bed_double,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  "Revenue",
                  "\$${hotel.totalRevenue}",
                  CupertinoIcons.money_dollar,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.go(Routes.hotelDetail(widget.clientId, hotel.docId));
              },
              icon: const Icon(CupertinoIcons.eye, size: 18),
              label: const Text("View Details"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.slateGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.slateGray),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopHotelTable(
    BuildContext context,
    ClientDetailState state,
    bool isTablet,
  ) {
    return Column(
      children: [
        _buildHotelTableHeader(isTablet),
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
            return _buildHotelRow(context, hotel, totalRooms, isTablet);
          },
        ),
      ],
    );
  }

  Widget _buildHotelTableHeader(bool isTablet) {
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
        if (!isTablet)
          Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
        Expanded(
          flex: 2,
          child: Text("Plan Duration", style: AppTextStyles.tabelHeader),
        ),
        if (!isTablet)
          Expanded(child: Text("Users", style: AppTextStyles.tabelHeader)),
        if (!isTablet)
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
    bool isTablet,
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
          if (!isTablet)
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
          if (!isTablet)
            Expanded(
              child: TableIconTextRow(
                icon: CupertinoIcons.person_2,
                text: hotel.totalUser.toString(),
              ),
            ),

          // Tasks
          if (!isTablet)
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

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taskoteladmin/core/routes/routes.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/utils/helpers.dart';
// import 'package:taskoteladmin/core/widget/custom_container.dart';
// import 'package:taskoteladmin/core/widget/page_header.dart';
// import 'package:taskoteladmin/core/widget/stats_card.dart';
// import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
// import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
// import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';

// class ClientDetailPage extends StatefulWidget {
//   final String clientId;
//   ClientDetailPage({super.key, required this.clientId});

//   @override
//   State<ClientDetailPage> createState() => _ClientDetailPageState();
// }

// class _ClientDetailPageState extends State<ClientDetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ClientDetailCubit, ClientDetailState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(state),
//               const SizedBox(height: 20),
//               _buildAnalytics(state),
//               _buildHotelPortfolioTable(context, (state)),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader(ClientDetailState state) {
//     return PageHeaderWithTitle(
//       heading: state.client?.name ?? '',
//       subHeading: "Comprehensive client overview and hotel management",
//     );
//   }

//   StaggeredGrid _buildAnalytics(ClientDetailState state) {
//     return StaggeredGrid.extent(
//       maxCrossAxisExtent: 400,
//       mainAxisSpacing: 16,
//       crossAxisSpacing: 16,
//       children: [
//         StatCardIconLeft(
//           icon: CupertinoIcons.building_2_fill,
//           label: "Total Hotels",
//           value: "${state.clientAnalytics?.totalHotels ?? 0}",
//           iconColor: Colors.blue,
//         ),

//         StatCardIconLeft(
//           icon: Icons.checklist,
//           label: "Total Tasks",
//           value: "${state.clientAnalytics?.totalTasks ?? 0}",
//           iconColor: Colors.orange,
//         ),
//         StatCardIconLeft(
//           icon: CupertinoIcons.money_dollar,
//           label: "Total Revenue",
//           value: "\$${state.clientAnalytics?.totalRevenue ?? 0}",
//           iconColor: Colors.green,
//         ),

//         StatCardIconLeft(
//           icon: CupertinoIcons.person_2,
//           label: "Active Subscriptions",
//           value: "${state.clientAnalytics?.activeSubscriptions ?? 0}",
//           iconColor: Colors.green,
//         ),

//         StatCardIconLeft(
//           icon: CupertinoIcons.star_fill,
//           label: "Average Hotel Rating",
//           value: "${state.clientAnalytics?.averageHotelRating ?? 0}",
//           iconColor: Colors.green,
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildHotelPortfolioTable(
//     BuildContext context,
//     ClientDetailState state,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.blueGreyBorder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Hotel Portfolio", style: AppTextStyles.dialogHeading),
//           const SizedBox(height: 20),
//           _buildHotelTableHeader(),
//           const SizedBox(height: 10),
//           const Divider(color: AppColors.slateGray, thickness: 0.1),

//           if (state.hotels.isEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child:  Text(
//                   "No Hotels Found",
//                   style: GoogleFonts.inter(
//                     fontSize: 16,
//                     color: AppColors.slateGray,
//                   ),
//                 ),
//               ),
//             )
//           else
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: state.hotels.length,
//               separatorBuilder: (_, __) => const Divider(
//                 color: AppColors.slateGray,
//                 thickness: 0.07,
//                 height: 0,
//               ),
//               itemBuilder: (context, index) {
//                 final hotel = state.hotels[index];
//                 final totalRooms = hotel.floors.values.fold<int>(
//                   0,
//                   (sum, rooms) => sum + rooms,
//                 );
//                 return _buildHotelRow(context, hotel, totalRooms);
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHotelTableHeader() {
//     return Row(
//       children: [
//         const SizedBox(width: 30),
//         Expanded(
//           flex: 2,
//           child: Text("Hotel Name", style: AppTextStyles.tabelHeader),
//         ),
//         Expanded(
//           flex: 2,
//           child: Text("Location", style: AppTextStyles.tabelHeader),
//         ),
//         Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
//         Expanded(
//           flex: 2,
//           child: Text("Plan Duration", style: AppTextStyles.tabelHeader),
//         ),
//         Expanded(child: Text("Users", style: AppTextStyles.tabelHeader)),
//         Expanded(child: Text("Tasks", style: AppTextStyles.tabelHeader)),
//         Expanded(child: Text("Rooms", style: AppTextStyles.tabelHeader)),
//         Expanded(child: Text("Revenue", style: AppTextStyles.tabelHeader)),
//         SizedBox(
//           width: 100,
//           child: Text("View", style: AppTextStyles.tabelHeader),
//         ),
//       ],
//     );
//   }

//   Widget _buildHotelRow(
//     BuildContext context,
//     HotelModel hotel,
//     int totalRooms,
//   ) {
//     return Padding(
//       padding: TableConfig.rowPadding,
//       child: Row(
//         children: [
//           const SizedBox(width: 30),

//           // Hotel Name
//           Expanded(
//             flex: 2,
//             child: TableIconTextRow(
//               icon: CupertinoIcons.building_2_fill,
//               text: hotel.name,
//             ),
//           ),

//           // Location
//           Expanded(
//             flex: 2,
//             child: TableIconTextRow(
//               icon: CupertinoIcons.placemark,
//               text: "${hotel.addressModel.city}, ${hotel.addressModel.state}",
//             ),
//           ),

//           // Plan Name
//           Expanded(
//             child: Text(
//               hotel.subscriptionName,
//               style: AppTextStyles.tableRowBoldValue,
//             ),
//           ),

//           // Plan Duration
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TableIconTextRow(
//                   icon: CupertinoIcons.calendar,
//                   text: "Start: ${hotel.subscriptionStart.goodDayDate()}",
//                 ),
//                 TableIconTextRow(
//                   icon: CupertinoIcons.calendar,
//                   text: "Expiry: ${hotel.subscriptionEnd.goodDayDate()}",
//                 ),
//               ],
//             ),
//           ),

//           // Users
//           Expanded(
//             child: TableIconTextRow(
//               icon: CupertinoIcons.person_2,
//               text: hotel.totalUser.toString(),
//             ),
//           ),

//           // Tasks
//           Expanded(
//             child: TableIconTextRow(
//               icon: Icons.checklist,
//               text: hotel.totaltask.toString(),
//             ),
//           ),

//           // Total Rooms
//           Expanded(
//             child: Text(
//               totalRooms.toString(),
//               style: AppTextStyles.tableRowBoldValue,
//             ),
//           ),

//           // Revenue
//           Expanded(
//             child: Text(
//               "\$${hotel.totalRevenue}",
//               style: AppTextStyles.tableRowBoldValue,
//             ),
//           ),

//           // View Button
//           SizedBox(
//             width: 100,
//             child: TableActionButton(
//               icon: CupertinoIcons.eye,
//               onPressed: () {
//                 context.go(Routes.hotelDetail(widget.clientId, hotel.docId));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
