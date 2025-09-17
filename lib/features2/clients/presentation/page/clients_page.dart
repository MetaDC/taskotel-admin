import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/client_entity.dart';
import 'package:taskoteladmin/features2/clients/presentation/widgets/clients_table.dart';
import 'package:taskoteladmin/features2/clients/presentation/widgets/client_filters.dart';
import 'package:taskoteladmin/features2/clients/presentation/widgets/add_client_dialog.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  bool _isLoading = true;
  List<ClientEntity> _clients = [];
  ClientStatus? _selectedStatus;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    // TODO: Replace with actual repository call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _clients = _getMockClients();
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
          ClientFilters(
            selectedStatus: _selectedStatus,
            searchQuery: _searchQuery,
            onStatusChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
              _applyFilters();
            },
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
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
              child: ClientsTable(
                clients: _clients,
                isLoading: _isLoading,
                onClientTap: _onClientTap,
                onExtendTrial: _onExtendTrial,
                onDeleteClient: _onDeleteClient,
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
          ClientFilters(
            selectedStatus: _selectedStatus,
            searchQuery: _searchQuery,
            onStatusChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
              _applyFilters();
            },
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
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
              child: ClientsTable(
                clients: _clients,
                isLoading: _isLoading,
                onClientTap: _onClientTap,
                onExtendTrial: _onExtendTrial,
                onDeleteClient: _onDeleteClient,
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
              'Clients Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your clients, subscriptions, and hotel accounts.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _showAddClientDialog,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Client',
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

  void _applyFilters() {
    // TODO: Implement filtering logic
    _loadClients();
  }

  void _onClientTap(ClientEntity client) {
    context.go('/clients/${client.id}');
  }

  void _onExtendTrial(ClientEntity client) {
    // TODO: Implement extend trial functionality
    print('Extend trial for: ${client.name}');
  }

  void _onDeleteClient(ClientEntity client) {
    // TODO: Implement delete client functionality
    print('Delete client: ${client.name}');
  }

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (context) => AddClientDialog(
        onClientAdded: (client) {
          setState(() {
            _clients.add(client);
          });
        },
      ),
    );
  }

  // Mock data for demonstration
  List<ClientEntity> _getMockClients() {
    return [
      ClientEntity(
        id: '1',
        name: 'John Smith',
        email: 'john@grandhotel.com',
        phone: '+1-555-0123',
        companyName: 'Grand Hotel Group',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
        status: ClientStatus.active,
        totalHotels: 3,
        totalRooms: 450,
        totalRevenue: 12500.0,
        isTrialAccount: false,
      ),
      ClientEntity(
        id: '2',
        name: 'Sarah Johnson',
        email: 'sarah@luxuryresorts.com',
        phone: '+1-555-0456',
        companyName: 'Luxury Resorts Inc',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        lastLogin: DateTime.now().subtract(const Duration(days: 1)),
        status: ClientStatus.trial,
        totalHotels: 1,
        totalRooms: 120,
        totalRevenue: 0.0,
        isTrialAccount: true,
        trialEndDate: DateTime.now().add(const Duration(days: 15)),
      ),
      ClientEntity(
        id: '3',
        name: 'Michael Brown',
        email: 'michael@cityhotels.com',
        phone: '+1-555-0789',
        companyName: 'City Hotels Chain',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLogin: DateTime.now().subtract(const Duration(days: 30)),
        status: ClientStatus.expired,
        totalHotels: 2,
        totalRooms: 280,
        totalRevenue: 8900.0,
        isTrialAccount: false,
      ),
      ClientEntity(
        id: '4',
        name: 'Emily Davis',
        email: 'emily@boutiquehotels.com',
        phone: '+1-555-0321',
        companyName: 'Boutique Hotels Ltd',
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        updatedAt: DateTime.now().subtract(const Duration(days: 60)),
        lastLogin: DateTime.now().subtract(const Duration(days: 60)),
        status: ClientStatus.churned,
        totalHotels: 0,
        totalRooms: 0,
        totalRevenue: 3200.0,
        isTrialAccount: false,
      ),
    ];
  }
}
