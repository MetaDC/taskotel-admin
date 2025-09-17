import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/master_hotel_entity.dart';
import 'package:taskoteladmin/features/master_hotels/presentation/widgets/master_hotels_table.dart';
import 'package:taskoteladmin/features/master_hotels/presentation/widgets/master_hotel_filters.dart';
import 'package:taskoteladmin/features/master_hotels/presentation/widgets/add_master_hotel_dialog.dart';

class MasterHotelsPage extends StatefulWidget {
  const MasterHotelsPage({super.key});

  @override
  State<MasterHotelsPage> createState() => _MasterHotelsPageState();
}

class _MasterHotelsPageState extends State<MasterHotelsPage> {
  bool _isLoading = true;
  List<MasterHotelEntity> _masterHotels = [];
  String? _selectedPropertyType;
  String _searchQuery = '';
  bool? _isActiveFilter;

  @override
  void initState() {
    super.initState();
    _loadMasterHotels();
  }

  Future<void> _loadMasterHotels() async {
    // TODO: Replace with actual repository call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _masterHotels = _getMockMasterHotels();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ResponsiveWid(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          MasterHotelFilters(
            selectedPropertyType: _selectedPropertyType,
            searchQuery: _searchQuery,
            isActiveFilter: _isActiveFilter,
            onPropertyTypeChanged: (type) {
              setState(() {
                _selectedPropertyType = type;
              });
              _applyFilters();
            },
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _applyFilters();
            },
            onActiveFilterChanged: (isActive) {
              setState(() {
                _isActiveFilter = isActive;
              });
              _applyFilters();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
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
              child: MasterHotelsTable(
                masterHotels: _masterHotels,
                isLoading: _isLoading,
                onMasterHotelTap: _onMasterHotelTap,
                onEditMasterHotel: _onEditMasterHotel,
                onDeleteMasterHotel: _onDeleteMasterHotel,
                onToggleActive: _onToggleActive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildStatsCards(),
          const SizedBox(height: 16),
          MasterHotelFilters(
            selectedPropertyType: _selectedPropertyType,
            searchQuery: _searchQuery,
            isActiveFilter: _isActiveFilter,
            onPropertyTypeChanged: (type) {
              setState(() {
                _selectedPropertyType = type;
              });
              _applyFilters();
            },
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _applyFilters();
            },
            onActiveFilterChanged: (isActive) {
              setState(() {
                _isActiveFilter = isActive;
              });
              _applyFilters();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
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
              child: MasterHotelsTable(
                masterHotels: _masterHotels,
                isLoading: _isLoading,
                onMasterHotelTap: _onMasterHotelTap,
                onEditMasterHotel: _onEditMasterHotel,
                onDeleteMasterHotel: _onDeleteMasterHotel,
                onToggleActive: _onToggleActive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Master Hotels',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage hotel templates that clients can import to create their hotels.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _showAddMasterHotelDialog,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Create Template',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    final totalTemplates = _masterHotels.length;
    final activeTemplates = _masterHotels.where((h) => h.isActive).length;
    final totalImports = _masterHotels.fold(0, (sum, h) => sum + h.totalImports);
    final totalDepartments = _masterHotels.fold(0, (sum, h) => sum + h.departments.length);

    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Templates', totalTemplates.toString(), Icons.hotel, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Active Templates', activeTemplates.toString(), Icons.check_circle, Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Total Imports', totalImports.toString(), Icons.download, Colors.orange)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Total Departments', totalDepartments.toString(), Icons.business, Colors.purple)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // TODO: Implement filtering logic
    _loadMasterHotels();
  }

  void _onMasterHotelTap(MasterHotelEntity masterHotel) {
    context.go('/master-hotels/${masterHotel.id}');
  }

  void _onEditMasterHotel(MasterHotelEntity masterHotel) {
    // TODO: Implement edit functionality
    print('Edit master hotel: ${masterHotel.name}');
  }

  void _onDeleteMasterHotel(MasterHotelEntity masterHotel) {
    // TODO: Implement delete functionality
    print('Delete master hotel: ${masterHotel.name}');
  }

  void _onToggleActive(MasterHotelEntity masterHotel) {
    // TODO: Implement toggle active functionality
    print('Toggle active for: ${masterHotel.name}');
  }

  void _showAddMasterHotelDialog() {
    showDialog(
      context: context,
      builder: (context) => AddMasterHotelDialog(
        onMasterHotelAdded: (masterHotel) {
          setState(() {
            _masterHotels.add(masterHotel);
          });
        },
      ),
    );
  }

  // Mock data for demonstration
  List<MasterHotelEntity> _getMockMasterHotels() {
    return [
      MasterHotelEntity(
        id: '1',
        name: 'Luxury Hotel Template',
        description: 'Complete template for luxury hotels with premium amenities',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isActive: true,
        propertyType: 'Luxury Hotel',
        departments: [],
        tasks: [],
        totalImports: 15,
        activeImports: 12,
      ),
      MasterHotelEntity(
        id: '2',
        name: 'Business Hotel Template',
        description: 'Efficient template for business-focused hotels',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isActive: true,
        propertyType: 'Business Hotel',
        departments: [],
        tasks: [],
        totalImports: 8,
        activeImports: 7,
      ),
      MasterHotelEntity(
        id: '3',
        name: 'Boutique Hotel Template',
        description: 'Personalized template for boutique hotels',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        isActive: false,
        propertyType: 'Boutique Hotel',
        departments: [],
        tasks: [],
        totalImports: 3,
        activeImports: 1,
      ),
    ];
  }
}
