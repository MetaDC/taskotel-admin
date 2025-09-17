import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';

class MasterHotelFilters extends StatelessWidget {
  final String? selectedPropertyType;
  final String searchQuery;
  final bool? isActiveFilter;
  final Function(String?) onPropertyTypeChanged;
  final Function(String) onSearchChanged;
  final Function(bool?) onActiveFilterChanged;

  const MasterHotelFilters({
    super.key,
    required this.selectedPropertyType,
    required this.searchQuery,
    required this.isActiveFilter,
    required this.onPropertyTypeChanged,
    required this.onSearchChanged,
    required this.onActiveFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search master hotels by name or description...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 200,
            child: DropdownButtonFormField<String?>(
              value: selectedPropertyType,
              onChanged: onPropertyTypeChanged,
              decoration: InputDecoration(
                labelText: 'Property Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Types'),
                ),
                ..._propertyTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(
                            _getPropertyTypeIcon(type),
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(type),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 150,
            child: DropdownButtonFormField<bool?>(
              value: isActiveFilter,
              onChanged: onActiveFilterChanged,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                const DropdownMenuItem<bool?>(
                  value: null,
                  child: Text('All Status'),
                ),
                const DropdownMenuItem<bool>(
                  value: true,
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Active'),
                    ],
                  ),
                ),
                const DropdownMenuItem<bool>(
                  value: false,
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        size: 16,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text('Inactive'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              onPropertyTypeChanged(null);
              onActiveFilterChanged(null);
              onSearchChanged('');
            },
            icon: const Icon(Icons.clear, size: 18),
            label: const Text('Clear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.grey[700],
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _propertyTypes = [
    'Luxury Hotel',
    'Business Hotel',
    'Boutique Hotel',
    'Resort',
    'Budget Hotel',
    'Extended Stay',
  ];

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
}
