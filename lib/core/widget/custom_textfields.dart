import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.enabled = true,
    this.prefixIcon,
    this.validator,
  });

  final TextEditingController controller;
  bool? validator;
  String hintText;
  String title;
  bool enabled;
  IconData? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isEmpty ? SizedBox() : Text(title),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            enabled: enabled,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.slateGray)
                : null,
            hintText: hintText,
            hintStyle: GoogleFonts.inter(color: AppColors.slateGray),

            // Normal border when not focused
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.slateGray),
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.slateGray),
              borderRadius: BorderRadius.circular(8),
            ),
            // Border when focused
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ), // or any color
              borderRadius: BorderRadius.circular(8),
            ),

            // Border when error is shown
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),

            // Border when focused and error is shown
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),

            // Optional: default border
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (validator == false) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return title.isEmpty ? "This field is required" : "Enter $title";
            }
            return null;
          },
        ),
      ],
    );
  }
}

class CustomNumTextField extends StatelessWidget {
  CustomNumTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
  });

  final TextEditingController controller;
  final String hintText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isEmpty ? SizedBox() : Text(title),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            // Normal border when not focused
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.slateGray),
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when focused
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ), // or any color
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when error is shown
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when focused and error is shown
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),

            // Optional: default border
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              color: AppColors.slateGray,
            ), // Use your AppTextStyles.label
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter $title';
            }
            if (double.tryParse(value) == null) {
              return 'Enter a valid number';
            }
            if (double.parse(value) <= 0) {
              return 'Enter a number greater than 0';
            }
            return null;
          },
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class CustomFileUploadField extends StatelessWidget {
  Function onTap;
  String title;
  String hintText;
  Icon prefixIcon;
  Widget? uploadImg;
  Function? onDeleteImageTap;
  CustomFileUploadField({
    super.key,
    required this.hintText,
    required this.title,
    required this.onTap,
    required this.prefixIcon,
    this.uploadImg,
    this.onDeleteImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isEmpty ? SizedBox() : Text(title),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () async => onTap(),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () => onTap(),
                  readOnly: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: hintText,
                    prefixIcon: prefixIcon,
                    suffixIcon: uploadImg != null
                        ? InkWell(
                            onTap: () => onDeleteImageTap!(),
                            child: Icon(CupertinoIcons.xmark_circle),
                          )
                        : Icon(CupertinoIcons.add_circled, color: Colors.black),
                    hintStyle: GoogleFonts.inter(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              if (uploadImg != null) ...[
                const SizedBox(width: 12),
                SizedBox(width: 50, height: 50, child: uploadImg),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class CustomDateField extends StatefulWidget {
  final String? hintText;
  final String title;
  Function onTap;
  final String initialValue;
  bool? validator;

  CustomDateField({
    super.key,
    // required this.taskFormCubit,
    required this.hintText,
    required this.title,
    required this.onTap,
    required this.initialValue,
    this.validator,
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  // final TaskFormCubit taskFormCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        SizedBox(height: 5),
        TextFormField(
          readOnly: true,
          onTap: () {
            widget.onTap();
          },
          decoration: InputDecoration(
            // Normal border when not focused
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.slateGray),
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when focused
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ), // or any color
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when error is shown
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when focused and error is shown
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),

            // Optional: default border
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: widget.hintText,

            suffixIcon: Icon(CupertinoIcons.calendar),

            hintStyle: GoogleFonts.inter(
              color: widget.initialValue.isEmpty
                  ? AppColors.slateGray
                  : Colors.black,
            ),
          ),
          // initialValue: widget.initialValue,
          validator: (value) {
            if (widget.validator != null) {
              if (widget.hintText == null ||
                  widget.hintText!.contains("date")) {
                return "date is required";
              }
            }

            return null;
          },
        ),
      ],
    );
  }
}

class CustomDescTextField extends StatelessWidget {
  CustomDescTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    required this.maxChars,
    this.validator,
  });

  final TextEditingController controller;
  String hintText;
  String title;
  int maxChars;
  bool? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isEmpty ? SizedBox() : Text(title),
        SizedBox(height: 5),
        TextFormField(
          maxLines: 3,
          controller: controller,
          inputFormatters: [LengthLimitingTextInputFormatter(maxChars)],
          decoration: InputDecoration(
            // Normal border when not focused
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.slateGray),
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when focused
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ), // or any color
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when error is shown
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),

            // Border when focused and error is shown
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),

            // Optional: default border
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: hintText,
            hintStyle: GoogleFonts.inter(color: AppColors.slateGray),
          ),
          validator: (value) {
            if (validator == true) {
              if (value == null || value.isEmpty) {
                return title.isEmpty
                    ? "this field is required"
                    : "Enter ${title}";
              }
            }
            return null;
          },
          // validator:
          //     (value) =>
          //         value == null || value.isEmpty
          //             ? 'this field is required'
          //             : null,
        ),
      ],
    );
  }
}

class CustomDropDownField extends StatelessWidget {
  CustomDropDownField({
    super.key,
    required this.title,
    required this.hintText,
    required this.initialValue,
    required this.validatorText,
    this.validator,
    required this.items,
    required this.onChanged,
  });
  String title;
  String hintText;
  dynamic initialValue;
  String validatorText;
  Function onChanged;
  bool? validator;
  List<DropdownMenuItem> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 5),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            value: initialValue,
            validator: (value) {
              if (validator == true) {
                if (value == null || value.isEmpty) {
                  return validatorText;
                }
                return null;
              }
            },
            dropdownColor: AppColors.secondary,

            borderRadius: BorderRadius.all(Radius.circular(25)),
            elevation: 1,

            decoration: InputDecoration(
              // Normal border when not focused
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.slateGray),
                borderRadius: BorderRadius.circular(10),
              ),

              // Border when focused
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ), // or any color
                borderRadius: BorderRadius.circular(10),
              ),

              // Border when error is shown
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),

              // Border when focused and error is shown
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),

              // Optional: default border
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.inter(color: AppColors.slateGray),
            ),
            items: items,
            onChanged: (value) => onChanged(value),
          ),
        ),
      ],
    );
  }
}

class CustomOutlineFileUploadField extends StatelessWidget {
  Function onTap;

  String hintText;
  Icon prefixIcon;
  CustomOutlineFileUploadField({
    super.key,
    required this.hintText,

    required this.onTap,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        textStyle: GoogleFonts.inter(color: Colors.black),
        minimumSize: Size.fromHeight(50),
        side: BorderSide(color: AppColors.slateGray),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => onTap(),
      icon: prefixIcon,
      label: Text(
        hintText,
        style: GoogleFonts.inter(color: AppColors.slateGray),
      ),
    );
  }
}
