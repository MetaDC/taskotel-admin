import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';

class ClientDetailPage extends StatefulWidget {
  final String clientId;
  ClientDetailPage({super.key, required this.clientId});

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientDetailCubit, ClientDetailState>(
      builder: (context, state) {
        print("Client loaded: ${state.client?.name}");
        return Column(children: [Text(state.client?.name ?? '')]);
      },
    );
  }
}
