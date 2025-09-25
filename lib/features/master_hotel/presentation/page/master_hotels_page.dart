import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/masterhotel_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/masterhotel_form_cubit.dart';
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
        children: [
          PageHeader(
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

                    child: BlocProvider(
                      create: (context) => MasterhotelFormCubit(
                        masterHotelRepo: MasterHotelFirebaseRepo(),
                      ),
                      child: MasterHotelForm(),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 20),
          CustomContainer(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Franchise Directory",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Franchise",
                        style: AppTextStyles.tabelHeader,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Property Type",
                        style: AppTextStyles.tabelHeader,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "No. of Clients",
                        style: AppTextStyles.tabelHeader,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Master Tasks",
                        style: AppTextStyles.tabelHeader,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text("Status", style: AppTextStyles.tabelHeader),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text("Actions", style: AppTextStyles.tabelHeader),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: AppColors.slateGray, thickness: 0.2),

                BlocConsumer<MasterHotelCubit, MasterhotelState>(
                  listener: (context, state) {
                    if (state.message != null && state.message!.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message ?? "")),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(state.masterHotels.length, (
                        index,
                      ) {
                        final masterHotel = state.masterHotels[index];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 15),
                                // Franchise Name and Created Date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        masterHotel.franchiseName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "Created ${masterHotel.createdAt.goodDayDate()}",
                                        style: TextStyle(
                                          color: AppColors.slateGray,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Property Type
                                Expanded(
                                  child: Text(
                                    masterHotel.propertyType,
                                    style: AppTextStyles.tabelHeader.copyWith(
                                      color: statusColor(
                                        masterHotel.propertyType,
                                      ),
                                    ),
                                  ),
                                ),

                                // No. of Clients
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
                                        masterHotel.totalClients.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("clients"),
                                    ],
                                  ),
                                ),

                                // Master Tasks
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
                                        masterHotel.totalMasterTasks.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("tasks"),
                                    ],
                                  ),
                                ),

                                // Status
                                SizedBox(
                                  width: 100,
                                  child: CupertinoSwitch(
                                    activeTrackColor: AppColors.primary,
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

                                // Actions
                                SizedBox(
                                  width: 100,
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
                                                backgroundColor: Color(
                                                  0xffFAFAFA,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: BlocProvider(
                                                  create: (context) =>
                                                      MasterhotelFormCubit(
                                                        masterHotelRepo:
                                                            MasterHotelFirebaseRepo(),
                                                      ),
                                                  child: MasterHotelForm(
                                                    editMasterHotel:
                                                        masterHotel,
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
                                          showConfirmDeletDialog(
                                            context,
                                            () {
                                              context
                                                  .read<MasterHotelCubit>()
                                                  .deleteMasterHotel(
                                                    masterHotel.docId,
                                                  );
                                            },
                                            "Delete Hotel Master",
                                            "Are you sure you want to delete this hotel master?",
                                            "Delete",
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15),
                              ],
                            ),

                            if (index != state.masterHotels.length - 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Divider(
                                  color: AppColors.slateGray,
                                  thickness: 0.2,
                                ),
                              ),
                          ],
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
