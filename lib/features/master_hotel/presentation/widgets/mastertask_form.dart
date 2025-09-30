import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/master_task_form_cubit.dart';

class MasterTaskFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MasterTaskFormCubit(masterHotelRepo: MasterHotelFirebaseRepo()),
      child: BlocBuilder<MasterTaskFormCubit, MasterTaskFormState>(
        builder: (context, state) {
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 800),
              margin: EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(Icons.business, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Create Master Tasks - Marriott International',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),

                      // Step 1: User Category
                      Text(
                        'Step 1: Select User Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          true
                              ? CustomDropDownField(
                                  title: "User Category",
                                  hintText: "Select user category",
                                  initialValue: state.selectedCategory,
                                  validatorText:
                                      "Please select a user category",
                                  items: roles.map((item) {
                                    return DropdownMenuItem(
                                      value: item['key'],
                                      child: Text(item['name'] ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    print("value: $value");
                                    if (value != null) {
                                      context
                                          .read<MasterTaskFormCubit>()
                                          .selectUserCategory(value);
                                    }
                                  },
                                )
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: state.selectedCategory,
                                    hint: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        'Select user category for these tasks',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    icon: Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[400],
                                      ),
                                    ),

                                    items:
                                        [
                                          'Regional Manager',
                                          'Operations Manager',
                                          'General Manager',
                                          'Department Head',
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              child: Text(
                                                value,
                                                style: TextStyle(),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (String? newValue) {
                                      print("newValue: $newValue");
                                      if (newValue != null) {
                                        context
                                            .read<MasterTaskFormCubit>()
                                            .selectUserCategory(newValue);
                                      }
                                    },
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 32),

                      // Step 2: Import Tasks
                      Text(
                        'Step 2: Import Tasks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Import from Excel section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFF4A90E2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF22C55E),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(Icons.table_chart, size: 20),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Import tasks from Excel',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Download the template, fill in your tasks, and upload the file',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                ElevatedButton.icon(
                                  onPressed: state.isDownloadingTemplate
                                      ? null
                                      : () => context
                                            .read<MasterTaskFormCubit>()
                                            .downloadTemplate(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF4A90E2),

                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  icon: state.isDownloadingTemplate
                                      ? SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(Icons.download, size: 16),
                                  label: Text(
                                    'Download Template',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            // File Upload Section
                            Text(
                              'Upload Excel File',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12),

                            Container(
                              width: double.infinity,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Color(0xFF555555)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        state.selectedFile?.name ??
                                            'No file chosen',
                                        style: TextStyle(
                                          color: state.selectedFile != null
                                              ? Colors.white
                                              : Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                                'xlsx',
                                                'xls',
                                              ],
                                            );
                                        print(
                                          'result!=null: ${result != null}',
                                        );
                                        if (result != null) {
                                          print(
                                            'result.files.first.name: ${result.files.first.name}',
                                          );
                                          // context
                                          //     .read<MasterTaskFormCubit>()
                                          //     .selectFile(result.files.first);
                                          state.selectedFile =
                                              result.files.first;
                                          print("Creating tasks...");
                                          print(
                                            'state.selectedCategory!=null : ${state.selectedCategory != null}',
                                          );
                                          await Future.delayed(
                                            Duration(seconds: 2),
                                          );
                                          await context
                                              .read<MasterTaskFormCubit>()
                                              .createMasterTasks(
                                                context,
                                                'random docId',
                                              );
                                        }
                                        // if (result != null) {
                                        //   context
                                        //       .read<MasterTaskFormCubit>()
                                        //       .selectFile(result.files.first);
                                        // }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6),
                                          ),
                                        ),
                                      ),
                                      child: Text('Choose file'),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (state.selectedCategory == null)
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Please select a user category first',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[400],
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            // (state.selectedCategory != null &&
                            //     state.selectedFile != null &&
                            //     !state.isCreating)
                            // ? () => context
                            //       .read<MasterTaskFormCubit>()
                            //       .createMasterTasks()
                            // : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4A90E2),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              elevation: 0,
                            ),
                            child: state.isCreating
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Creating...'),
                                    ],
                                  )
                                : Text('Create Master Tasks'),
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
