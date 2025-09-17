import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/client_entity.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/hotel_entity.dart';
import 'package:intl/intl.dart';

class ClientDetailPage extends StatefulWidget {
  final String clientId;

  const ClientDetailPage({
    super.key,
    required this.clientId,
  });

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  bool _isLoading = true;
  ClientEntity? _client;
  List<HotelEntity> _hotels = [];

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  Future<void> _loadClientData() async {
    // TODO: Replace with actual repository calls
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _client = _getMockClient();
        _hotels = _getMockHotels();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_client == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Client not found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ResponsiveWid(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildClientInfoCard(),
                    const SizedBox(height: 16),
                    _buildHotelsCard(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildQuickActionsCard(),
                    const SizedBox(height: 16),
                    _buildSubscriptionCard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildClientInfoCard(),
          const SizedBox(height: 16),
          _buildQuickActionsCard(),
          const SizedBox(height: 16),
          _buildSubscriptionCard(),
          const SizedBox(height: 16),
          _buildHotelsCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _client!.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _client!.companyName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(_client!.status),
      ],
    );
  }

  Widget _buildClientInfoCard() {
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
          const Text(
            'Client Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Email', _client!.email),
          _buildInfoRow('Phone', _client!.phone),
          _buildInfoRow('Company', _client!.companyName),
          _buildInfoRow('Total Hotels', '${_client!.totalHotels}'),
          _buildInfoRow('Total Rooms', '${_client!.totalRooms}'),
          _buildInfoRow('Total Revenue', '\$${_formatNumber(_client!.totalRevenue)}'),
          _buildInfoRow('Created', DateFormat('MMM dd, yyyy').format(_client!.createdAt)),
          _buildInfoRow('Last Login', _client!.lastLogin != null 
              ? DateFormat('MMM dd, yyyy HH:mm').format(_client!.lastLogin!)
              : 'Never'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          if (_client!.isTrialAccount) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement extend trial
                },
                icon: const Icon(Icons.schedule),
                label: const Text('Extend Trial'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement send email
              },
              icon: const Icon(Icons.email),
              label: const Text('Send Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement view transactions
              },
              icon: const Icon(Icons.receipt),
              label: const Text('View Transactions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard() {
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
          const Text(
            'Subscription Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          if (_client!.isTrialAccount && _client!.trialEndDate != null) ...[
            Text(
              'Trial ends in ${_client!.trialEndDate!.difference(DateTime.now()).inDays} days',
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Trial End Date: ${DateFormat('MMM dd, yyyy').format(_client!.trialEndDate!)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ] else ...[
            Text(
              'Active Subscription',
              style: TextStyle(
                color: _client!.status == ClientStatus.active ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHotelsCard() {
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
              const Text(
                'Hotels',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement add hotel
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Hotel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_hotels.isEmpty)
            const Center(
              child: Text(
                'No hotels added yet',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ..._hotels.map((hotel) => _buildHotelItem(hotel)),
        ],
      ),
    );
  }

  Widget _buildHotelItem(HotelEntity hotel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.hotel, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${hotel.totalRooms} rooms • ${hotel.propertyType}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hotel.hasActiveSubscription ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              hotel.hasActiveSubscription ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                color: hotel.hasActiveSubscription ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w600,
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

  // Mock data for demonstration
  ClientEntity _getMockClient() {
    return ClientEntity(
      id: widget.clientId,
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
    );
  }

  List<HotelEntity> _getMockHotels() {
    return [
      HotelEntity(
        id: '1',
        name: 'Grand Hotel Downtown',
        clientId: widget.clientId,
        clientName: 'John Smith',
        floors: {'1': 50, '2': 50, '3': 50},
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        masterHotelId: 'master1',
        propertyType: 'Luxury Hotel',
        isActive: true,
        subscriptionEnd: DateTime.now().add(const Duration(days: 300)),
      ),
      HotelEntity(
        id: '2',
        name: 'Grand Hotel Airport',
        clientId: widget.clientId,
        clientName: 'John Smith',
        floors: {'1': 75, '2': 75},
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        masterHotelId: 'master1',
        propertyType: 'Business Hotel',
        isActive: true,
        subscriptionEnd: DateTime.now().add(const Duration(days: 250)),
      ),
    ];
  }
}
