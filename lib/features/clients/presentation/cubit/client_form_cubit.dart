import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_cubit.dart';

part 'client_form_state.dart';

class ClientFormCubit extends Cubit<ClientFormState> {
  final ClientRepo clientRepo;

  ClientFormCubit({required this.clientRepo})
    : super(ClientFormState.initial());

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Initialize form for editing
  void initializeForm(ClientModel? client) {
    if (client != null) {
      nameController.text = toTitleCase(client.name);
      emailController.text = client.email;
      phoneController.text = client.phone;
      emit(state.copyWith(selectedStatus: client.status));
    } else {
      // Clear controllers for new client
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      emit(ClientFormState.initial());
    }
  }

  // Submit form with proper loading states
  Future<void> submitForm(ClientModel? editClient, BuildContext context) async {
    if (state.isLoading) {
      return;
    }

    // Validate form first
    if (!(formKey.currentState?.validate() ?? false)) {
      emit(
        state.copyWith(message: 'Please fill all required fields correctly'),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, message: ''));
    try {
      final client = ClientModel(
        docId: editClient?.docId ?? '',
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        createdAt: editClient?.createdAt ?? DateTime.now(),
        status: state.selectedStatus,
        lastPaymentExpiry: editClient?.lastPaymentExpiry,
        updatedAt: DateTime.now(),
        lastLogin: editClient?.lastLogin,
        totalHotels: editClient?.totalHotels ?? 0,
        totalRevenue: editClient?.totalRevenue ?? 0.0,
      );

      if (editClient != null) {
        await clientRepo.updateClient(client);

        final updatedClient = await FBFireStore.clients
            .doc(editClient.docId)
            .get();

        context.read<ClientCubit>().updateClientInList(
          ClientModel.fromSnap(updatedClient),
        );

        emit(
          state.copyWith(
            isLoading: false,
            message: 'Client updated successfully',
          ),
        );
      } else {
        // Create new client
        final res = await clientRepo.createAndRegisterClient(
          client,
          genStrongPassword(),
        );
        client.docId = res;
        context.read<ClientCubit>().addClientToList(client);
        emit(
          state.copyWith(
            isLoading: false,
            message: 'Client created successfully',
          ),
        );
      }

      // Small delay to ensure state is properly updated before closing
      await Future.delayed(const Duration(milliseconds: 100));

      // Close modal only after success
      if (context.mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: 'Error: ${e.toString()}'));
    }
  }

  // Update status dropdown
  void updateSelectedStatus(String? status) {
    emit(state.copyWith(selectedStatus: status));
  }

  // Clear message
  void clearMessage() {
    emit(state.copyWith(message: null));
  }
}
