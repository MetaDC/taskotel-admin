import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/clients/data/client_firebaserepo.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_form_cubit.dart';

class ClientFormModal extends StatefulWidget {
  final ClientModel? clientToEdit;

  const ClientFormModal({super.key, this.clientToEdit});

  @override
  State<ClientFormModal> createState() => _ClientFormModalState();
}

class _ClientFormModalState extends State<ClientFormModal> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ClientFormCubit(clientRepo: ClientFirebaseRepo())
            ..initializeForm(widget.clientToEdit),
      child: BlocConsumer<ClientFormCubit, ClientFormState>(
        listener: (context, state) {
          if (!state.isLoading && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: state.message.toLowerCase().contains('success')
                    ? Colors.green
                    : Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ClientFormCubit>();

          return ResponsiveCustomBuilder(
            mobileBuilder: (width) => _buildMobileForm(context, cubit, state),
            tabletBuilder: (width) => _buildTabletForm(context, cubit, state),
            desktopBuilder: (width) => _buildDesktopForm(context, cubit, state),
          );
        },
      ),
    );
  }

  // Mobile Form Layout
  Widget _buildMobileForm(
    BuildContext context,
    ClientFormCubit cubit,
    ClientFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context, cubit, state, isMobile: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClientInfoSection(cubit, state, isMobile: true),
                    const SizedBox(height: 20),
                    _buildAccountStatusSection(cubit, state, isMobile: true),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(context, cubit, state),
        ],
      ),
    );
  }

  // Tablet Form Layout
  Widget _buildTabletForm(
    BuildContext context,
    ClientFormCubit cubit,
    ClientFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 650),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(context, cubit, state),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClientInfoSection(cubit, state),
                    const SizedBox(height: 24),
                    _buildAccountStatusSection(cubit, state),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(context, cubit, state),
        ],
      ),
    );
  }

  // Desktop Form Layout
  Widget _buildDesktopForm(
    BuildContext context,
    ClientFormCubit cubit,
    ClientFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, cubit, state),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClientInfoSection(cubit, state),
                    const SizedBox(height: 28),
                    _buildAccountStatusSection(cubit, state),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(context, cubit, state),
        ],
      ),
    );
  }

  // Header Section
  Widget _buildHeader(
    BuildContext context,
    ClientFormCubit cubit,
    ClientFormState state, {
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              CupertinoIcons.person_2_fill,
              color: AppColors.primary,
              size: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.clientToEdit != null ? "Edit Client" : "Create New Client",
              style: GoogleFonts.inter(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(CupertinoIcons.xmark_circle_fill),
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  // Client Information Section
  Widget _buildClientInfoSection(
    ClientFormCubit cubit,
    ClientFormState state, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.info_circle_fill,
                size: 16,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Client Information",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),

        // Full Name
        CustomTextField(
          title: "Full Name *",
          hintText: "Enter full name",
          prefixIcon: CupertinoIcons.person,
          controller: cubit.nameController,
          validator: true,
        ),
        SizedBox(height: isMobile ? 16 : 20),

        // Email - disabled when editing
        IgnorePointer(
          ignoring: widget.clientToEdit != null,
          child: Opacity(
            opacity: widget.clientToEdit != null ? 0.6 : 1.0,
            child: CustomTextField(
              title: "Email *",
              hintText: "Enter email",
              prefixIcon: CupertinoIcons.mail,
              controller: cubit.emailController,
              validator: true,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 16 : 20),

        // Phone Number
        CustomTextField(
          title: "Phone Number *",
          hintText: "Enter phone number",
          controller: cubit.phoneController,
          prefixIcon: CupertinoIcons.phone,
          validator: true,
        ),
      ],
    );
  }

  // Account Status Section
  Widget _buildAccountStatusSection(
    ClientFormCubit cubit,
    ClientFormState state, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.checkmark_shield_fill,
                size: 16,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Account Status",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),

        // Status Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status *",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: state.selectedStatus,
              decoration: InputDecoration(
                hintText: "Select status",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              items: clientStatus.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: item == 'active' ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) =>
                  cubit.updateSelectedStatus(value ?? 'active'),
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        ),

        // Optional: Add status description
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.info_circle,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.selectedStatus == 'active'
                      ? "Active clients can access all services"
                      : "Inactive clients have limited access",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Action Buttons
  Widget _buildActionButtons(
    BuildContext context,
    ClientFormCubit cubit,
    ClientFormState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Cancel"),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => cubit.submitForm(widget.clientToEdit, context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.clientToEdit != null
                            ? "Update Client"
                            : "Create Client",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/utils/const.dart';
// import 'package:taskoteladmin/core/widget/custom_textfields.dart';
// import 'package:taskoteladmin/features/clients/data/client_firebaserepo.dart';
// import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
// import 'package:taskoteladmin/features/clients/presentation/cubit/client_form_cubit.dart';

// class ClientFormModal extends StatefulWidget {
//   final ClientModel? clientToEdit;

//   const ClientFormModal({super.key, this.clientToEdit});

//   @override
//   State<ClientFormModal> createState() => _ClientFormModalState();
// }

// class _ClientFormModalState extends State<ClientFormModal> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           ClientFormCubit(clientRepo: ClientFirebaseRepo())
//             ..initializeForm(widget.clientToEdit),
//       child: BlocConsumer<ClientFormCubit, ClientFormState>(
//         listener: (context, state) {
//           // Only show message when not loading and message is not empty
//           if (!state.isLoading && state.message.isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: state.message.toLowerCase().contains('success')
//                     ? Colors.green
//                     : Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final cubit = context.read<ClientFormCubit>();
//           return IgnorePointer(
//             ignoring: state.isLoading,
//             child: Container(
//               constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Form(
//                 key: cubit.formKey,
//                 child: Column(
//                   children: [
//                     _buildHeader(context),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: const EdgeInsets.all(20),
//                         child: _buildUserDetails(cubit, state),
//                       ),
//                     ),
//                     _buildActionButtons(state, context, cubit),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildActionButtons(
//     ClientFormState state,
//     BuildContext context,
//     ClientFormCubit cubit,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: AppColors.borderGrey)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: SizedBox(
//               height: 40,
//               child: OutlinedButton(
//                 onPressed: state.isLoading
//                     ? null
//                     : () => Navigator.pop(context),
//                 child: const Text("Cancel"),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: SizedBox(
//               height: 40,
//               child: ElevatedButton(
//                 onPressed: () => cubit.submitForm(widget.clientToEdit, context),
//                 child: state.isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Text(
//                         widget.clientToEdit != null
//                             ? "Update Client"
//                             : "Create Client",
//                       ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserDetails(ClientFormCubit cubit, ClientFormState state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Section: Info
//         Text("Client Information", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),

//         CustomTextField(
//           title: "Full Name *",
//           hintText: "Enter full name",
//           prefixIcon: CupertinoIcons.person,
//           controller: cubit.nameController,
//           validator: true,
//         ),
//         const SizedBox(height: 16),

//         IgnorePointer(
//           ignoring: widget.clientToEdit != null,
//           child: CustomTextField(
//             title: "Email *",
//             hintText: "Enter email",
//             prefixIcon: CupertinoIcons.mail,
//             controller: cubit.emailController,
//             validator: true,
//           ),
//         ),
//         const SizedBox(height: 16),

//         CustomTextField(
//           title: "Phone Number *",
//           hintText: "Enter phone number",
//           controller: cubit.phoneController,
//           prefixIcon: CupertinoIcons.phone,
//           validator: true,
//         ),
//         const SizedBox(height: 16),

//         // Section: Status
//         Text("Account Status", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 12),

//         DropdownButtonFormField<String>(
//           initialValue: state.selectedStatus,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//           items: clientStatus.map((item) {
//             return DropdownMenuItem<String>(
//               value: item,
//               child: Text(item.toUpperCase()),
//             );
//           }).toList(),
//           onChanged: (value) => cubit.updateSelectedStatus(value ?? 'active'),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             widget.clientToEdit != null ? "Edit Client" : "Create New Client",
//             style: AppTextStyles.dialogHeading,
//           ),
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(CupertinoIcons.xmark),
//           ),
//         ],
//       ),
//     );
//   }
// }
