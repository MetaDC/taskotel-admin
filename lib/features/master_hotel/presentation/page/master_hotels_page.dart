import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/masterhotel_form_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/widgets/masterhotel_form.dart';

class MasterHotelsPage extends StatelessWidget {
  const MasterHotelsPage({super.key});

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
                    Expanded(
                      child: Text("Status", style: AppTextStyles.tabelHeader),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: AppColors.slateGray, thickness: 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
