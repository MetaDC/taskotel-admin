import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
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
          final cubit = context.read<ClientFormCubit>();
          return IgnorePointer(
            ignoring: state.isLoading,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: _buildUserDetails(cubit, state),
                      ),
                    ),
                    _buildActionButtons(state, context, cubit),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(
    ClientFormState state,
    BuildContext context,
    ClientFormCubit cubit,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: OutlinedButton(
                onPressed: state.isLoading
                    ? null
                    : () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () => cubit.submitForm(widget.clientToEdit, context),
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
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(ClientFormCubit cubit, ClientFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section: Info
        Text("Client Information", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),

        CustomTextField(
          title: "Full Name",
          hintText: "Enter full name",
          prefixIcon: CupertinoIcons.person,
          controller: cubit.nameController,
          validator: true,
        ),
        const SizedBox(height: 16),

        IgnorePointer(
          ignoring: true,
          child: CustomTextField(
            title: "Email",
            hintText: "Enter email",
            prefixIcon: CupertinoIcons.mail,
            controller: cubit.emailController,
            validator: true,
          ),
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
          initialValue: state.selectedStatus,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: clientStatus.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) => cubit.updateSelectedStatus(value ?? 'active'),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.clientToEdit != null ? "Edit Client" : "Create New Client",
            style: AppTextStyles.dialogHeading,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.xmark),
          ),
        ],
      ),
    );
  }
}
