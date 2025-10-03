import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-hotel/masterhotel_form_cubit.dart';

class MasterHotelForm extends StatefulWidget {
  MasterHotelModel? editMasterHotel;
  MasterHotelForm({super.key, this.editMasterHotel});

  @override
  State<MasterHotelForm> createState() => _MasterHotelFormState();
}

class _MasterHotelFormState extends State<MasterHotelForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MasterhotelFormCubit(masterHotelRepo: MasterHotelFirebaseRepo())
            ..initializeForm(widget.editMasterHotel),
      child: BlocConsumer<MasterhotelFormCubit, MasterhotelFormState>(
        listener: (context, state) {
          if (state.message != null && state.message!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message ?? "")));
          }
        },
        builder: (context, state) {
          final masterHotelFormCubit = context.read<MasterhotelFormCubit>();
          return IgnorePointer(
            ignoring: state.isLoading,
            child: SingleChildScrollView(
              child: Form(
                key: masterHotelFormCubit.formKey,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header Row
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.building_2_fill,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Create Hotel Master",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Basic Information Section
                      CustomContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Basic Information",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// Franchise + Property Type Row
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: masterHotelFormCubit
                                        .franchiseController,
                                    hintText: "e.g., Marriott",
                                    title: "Franchise Name *",
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomDropDownField(
                                    title: "Property Type *",
                                    hintText: "Select Property Type",
                                    initialValue: state.selectedPropertyType,
                                    validatorText:
                                        "Please select a property type",
                                    items: hotelTypes.map((type) {
                                      return DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      masterHotelFormCubit.setPropertyType(
                                        value,
                                      );
                                    },
                                    validator: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            CustomDescTextField(
                              controller:
                                  masterHotelFormCubit.descriptionController,
                              hintText: "Brief description of the franchise",
                              title: "Description",
                              maxChars: 250,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Brand Assets Section
                      CustomContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Brand Assets",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            const SizedBox(height: 15),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CustomFileUploadField(
                                    title: "Logo",
                                    hintText: state.selectedFile != null
                                        ? "File Selected ${state.selectedFile!.name}"
                                        : "Upload logo or paste URL",
                                    prefixIcon: Icon(Icons.upload_file),
                                    onTap: () {
                                      masterHotelFormCubit.pickFile(context);
                                    },
                                    onDeleteImageTap: () {
                                      masterHotelFormCubit.deletPickFile(false);
                                    },
                                    uploadImg: state.dbFile != null
                                        ? Image.network(
                                            state.dbFile!,
                                            fit: BoxFit.cover,
                                          )
                                        : state.selectedFile != null
                                        ? Image.memory(
                                            state.selectedFile!.uInt8List,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            CustomTextField(
                              controller:
                                  masterHotelFormCubit.websiteUrlController,
                              hintText: "Franchise Website URL",
                              title: "Website URL",
                              prefixIcon: Icons.language,
                              validator: false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              masterHotelFormCubit.submitForm(
                                context,
                                widget.editMasterHotel,
                              );
                            },
                            child: state.isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    widget.editMasterHotel != null
                                        ? "Update Hotel Master"
                                        : "Create Hotel Master",
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
