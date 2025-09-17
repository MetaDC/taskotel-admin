import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/client_entity.dart';
import 'package:intl/intl.dart';

class ClientsTable extends StatelessWidget {
  final List<ClientEntity> clients;
  final bool isLoading;
  final Function(ClientEntity) onClientTap;
  final Function(ClientEntity) onExtendTrial;
  final Function(ClientEntity) onDeleteClient;

  const ClientsTable({
    super.key,
    required this.clients,
    required this.isLoading,
    required this.onClientTap,
    required this.onExtendTrial,
    required this.onDeleteClient,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (clients.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTableHeader(),
          ...clients.map((client) => _buildTableRow(context, client)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No clients found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first client to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              'Client',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Company',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Hotels',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Revenue',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Last Login',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 100), // Actions column
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, ClientEntity client) {
    return InkWell(
      onTap: () => onClientTap(client),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    client.email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                client.companyName,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildStatusChip(client.status),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${client.totalHotels}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '\$${_formatNumber(client.totalRevenue)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                client.lastLogin != null
                    ? _formatDate(client.lastLogin!)
                    : 'Never',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (client.isTrialAccount)
                    IconButton(
                      onPressed: () => onExtendTrial(client),
                      icon: const Icon(Icons.schedule, size: 18),
                      tooltip: 'Extend Trial',
                      color: Colors.blue,
                    ),
                  IconButton(
                    onPressed: () => onDeleteClient(client),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    tooltip: 'Delete Client',
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ClientStatus status) {
    Color color;
    switch (status) {
      case ClientStatus.active:
        color = Colors.green;
        break;
      case ClientStatus.trial:
        color = Colors.blue;
        break;
      case ClientStatus.expired:
        color = Colors.orange;
        break;
      case ClientStatus.churned:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }
}
