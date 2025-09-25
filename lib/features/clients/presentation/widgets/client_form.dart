import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
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
  void initState() {
    super.initState();
    context.read<ClientFormCubit>().initializeForm(widget.clientToEdit);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ClientFormCubit>();

    return BlocConsumer<ClientFormCubit, ClientFormState>(
      listener: (context, state) {
        // Only show message when not loading and message is not empty
        if (!state.isLoading && state.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: state.message.toLowerCase().contains('success')
                  ? Colors.green
                  : Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: cubit.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderGrey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.clientToEdit != null
                          ? "Edit Client"
                          : "Create New Client",
                      style: AppTextStyles.dialogHeading,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(CupertinoIcons.xmark),
                    ),
                  ],
                ),
              ),

              // Form Content
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Section: Info
                    Text(
                      "Client Information",
                      style: AppTextStyles.textFieldTitle,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      title: "Full Name",
                      hintText: "Enter full name",
                      prefixIcon: CupertinoIcons.person,
                      controller: cubit.nameController,
                      validator: true,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      title: "Email",
                      hintText: "Enter email",
                      prefixIcon: CupertinoIcons.mail,
                      controller: cubit.emailController,
                      validator: true,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      title: "Phone Number",
                      hintText: "Enter phone number",
                      controller: cubit.phoneController,
                      prefixIcon: CupertinoIcons.phone,
                      validator: true,
                    ),
                    const SizedBox(height: 16),

                    // Section: Status
                    Text("Account Status", style: AppTextStyles.textFieldTitle),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: state.selectedStatus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items:
                          const [
                            'active',
                            'inactive',
                            'suspended',
                            'trial',
                            'churned',
                          ].map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item.toUpperCase()),
                            );
                          }).toList(),
                      onChanged: (value) =>
                          cubit.updateSelectedStatus(value ?? 'active'),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.borderGrey)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            cubit.submitForm(widget.clientToEdit, context),
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
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
