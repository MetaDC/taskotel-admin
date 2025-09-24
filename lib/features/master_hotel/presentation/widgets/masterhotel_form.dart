import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';

class MasterHotelForm extends StatelessWidget {
  MasterHotelForm({super.key});

  String? selectedPropertyType;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            children: [
              const Icon(CupertinoIcons.building_2_fill, color: Colors.blue),
              const SizedBox(width: 10),
              const Text(
                "Create Hotel Master",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),

                /// Franchise + Property Type Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: TextEditingController(),
                        hintText: "e.g., Marriott",
                        title: "Franchise Name *",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomDropDownField(
                        title: "Property Type *",
                        hintText: "Select Property Type",
                        initialValue: selectedPropertyType,
                        validatorText: "Please select a property type",
                        items: ["Hotel", "Resort", "Motel", "Villa"].map((
                          type,
                        ) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedPropertyType = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                CustomDescTextField(
                  controller: TextEditingController(),
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

                CustomTextField(
                  controller: TextEditingController(),
                  hintText: "Upload logo or paste URL",
                  title: "Logo URL",
                  enabled: false,
                  prefixIcon: Icons.upload_file,
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  controller: TextEditingController(),
                  hintText: "Brief description of the franchise",
                  title: "Description",
                  prefixIcon: Icons.language,
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
                  // Handle create action here
                  Navigator.pop(context);
                },
                child: const Text("Create Hotel Master"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
