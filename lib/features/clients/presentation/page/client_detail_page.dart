import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
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
              // PageHeader(
              //   heading: "heading",
              //   subHeading: "subHeading",
              //   buttonText: "buttonText",
              //   onButtonPressed: () {
              //     print("ONTAO");
              //     Future<void> seedDummyHotels() async {
              //       print("RUN");
              //       final hotelsCollection = FBFireStore.hotels;

              //       for (final hotel in dummyHotels) {
              //         final docRef = hotelsCollection.doc(); // auto-generate ID
              //         await docRef.set(hotel);
              //         print("Added hotel: ${hotel['name']} (${docRef.id})");
              //       }
              //     }

              //     seedDummyHotels();
              //     print("--- Added");
              //   },
              // ),
              Text(
                state.client?.name ?? '',
                style: AppTextStyles.headerHeading,
              ),
              Text(
                "Comprehensive client overview and hotel management",
                style: AppTextStyles.headerSubheading,
              ),
              const SizedBox(height: 20),
              StaggeredGrid.extent(
                maxCrossAxisExtent: 500,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  StatCardIconLeft(
                    icon: CupertinoIcons.building_2_fill,
                    label: "Total Hotels",
                    value: "20",
                    iconColor: Colors.blue,
                  ),
                  StatCardIconLeft(
                    icon: CupertinoIcons.person_2,
                    label: "Total Users",
                    value: "30",
                    iconColor: Colors.green,
                  ),
                  StatCardIconLeft(
                    icon: Icons.checklist,
                    label: "Total Tasks",
                    value: "40",
                    iconColor: Colors.orange,
                  ),
                  StatCardIconLeft(
                    icon: CupertinoIcons.money_dollar,
                    label: "Total Revenue",
                    value: "50",
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hotel Portfolio",
                            style: AppTextStyles.dialogHeading,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 30), // Optional left padding
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Hotel Name",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Location",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Plan",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Plan Duration",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Users",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Tasks",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Rooms",
                                  style: AppTextStyles.tabelHeader,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Revenue",
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
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: AppColors.slateGray,
                            thickness: 0.1,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.hotels.length,
                            itemBuilder: (context, index) {
                              final hotel = state.hotels[index];

                              // Calculate total rooms
                              final totalRooms = hotel.floors.values.fold<int>(
                                0,
                                (sum, rooms) => sum + rooms,
                              );

                              return Column(
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const SizedBox(width: 30),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.building_2_fill,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              hotel.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.placemark,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "${hotel.addressModel.city}, ${hotel.addressModel.state}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          hotel.subscriptionName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.calendar,
                                                  size: 15,
                                                  color: AppColors.slateGray,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Start: ${hotel.subscriptionStart.goodDayDate()}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.calendar,
                                                  size: 15,
                                                  color: AppColors.slateGray,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Expiry: ${hotel.subscriptionEnd.goodDayDate()}",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.person_2,
                                              size: 15,
                                              color: AppColors.slateGray,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              hotel.totalUser.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.checklist,
                                              size: 15,
                                              color: AppColors.slateGray,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              hotel.totaltask.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          totalRooms.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ), // 🔹 Display total rooms/ Performance
                                      Expanded(
                                        child: Text(
                                          "\$ ${hotel.totalRevenue.toString()}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                context.go(
                                                  Routes.hotelDetail(
                                                    widget.clientId,
                                                    hotel.docId,
                                                  ),
                                                );
                                              },
                                              child: Icon(CupertinoIcons.eye),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  const Divider(
                                    color: AppColors.slateGray,
                                    thickness: 0.1,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
