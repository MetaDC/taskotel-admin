import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/master_hotel_entity.dart';
import 'package:intl/intl.dart';

class MasterHotelsTable extends StatelessWidget {
  final List<MasterHotelEntity> masterHotels;
  final bool isLoading;
  final Function(MasterHotelEntity) onMasterHotelTap;
  final Function(MasterHotelEntity) onEditMasterHotel;
  final Function(MasterHotelEntity) onDeleteMasterHotel;
  final Function(MasterHotelEntity) onToggleActive;

  const MasterHotelsTable({
    super.key,
    required this.masterHotels,
    required this.isLoading,
    required this.onMasterHotelTap,
    required this.onEditMasterHotel,
    required this.onDeleteMasterHotel,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (masterHotels.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTableHeader(),
          ...masterHotels.map((masterHotel) => _buildTableRow(context, masterHotel)),
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
            Icons.hotel_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No master hotels found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first master hotel template to get started',
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
              'Template Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Property Type',
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
              'Departments',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Tasks',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Imports',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Created',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 120), // Actions column
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, MasterHotelEntity masterHotel) {
    return InkWell(
      onTap: () => onMasterHotelTap(masterHotel),
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
                    masterHotel.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    masterHotel.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(
                    _getPropertyTypeIcon(masterHotel.propertyType),
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    masterHotel.propertyType,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildStatusChip(masterHotel.isActive),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${masterHotel.departments.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${masterHotel.tasks.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${masterHotel.totalImports}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${masterHotel.activeImports} active',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                _formatDate(masterHotel.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => onToggleActive(masterHotel),
                    icon: Icon(
                      masterHotel.isActive ? Icons.pause : Icons.play_arrow,
                      size: 18,
                    ),
                    tooltip: masterHotel.isActive ? 'Deactivate' : 'Activate',
                    color: masterHotel.isActive ? Colors.orange : Colors.green,
                  ),
                  IconButton(
                    onPressed: () => onEditMasterHotel(masterHotel),
                    icon: const Icon(Icons.edit, size: 18),
                    tooltip: 'Edit Template',
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () => onDeleteMasterHotel(masterHotel),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    tooltip: 'Delete Template',
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

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12,
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getPropertyTypeIcon(String type) {
    switch (type) {
      case 'Luxury Hotel':
        return Icons.star;
      case 'Business Hotel':
        return Icons.business;
      case 'Boutique Hotel':
        return Icons.local_florist;
      case 'Resort':
        return Icons.beach_access;
      case 'Budget Hotel':
        return Icons.attach_money;
      case 'Extended Stay':
        return Icons.home;
      default:
        return Icons.hotel;
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
