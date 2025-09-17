import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/subscription_plan_entity.dart';
import 'package:taskoteladmin/features/subscription_plans/presentation/widgets/subscription_plans_table.dart';
import 'package:taskoteladmin/features/subscription_plans/presentation/widgets/subscription_plan_filters.dart';
import 'package:taskoteladmin/features/subscription_plans/presentation/widgets/add_subscription_plan_dialog.dart';
import 'package:taskoteladmin/features/subscription_plans/presentation/widgets/plan_analytics_cards.dart';

class SubscriptionPlansPage extends StatefulWidget {
  const SubscriptionPlansPage({super.key});

  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  bool _isLoading = true;
  List<SubscriptionPlanEntity> _subscriptionPlans = [];
  String _searchQuery = '';
  bool? _isActiveFilter;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionPlans();
  }

  Future<void> _loadSubscriptionPlans() async {
    // TODO: Replace with actual repository call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _subscriptionPlans = _getMockSubscriptionPlans();
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
          PlanAnalyticsCards(subscriptionPlans: _subscriptionPlans),
          const SizedBox(height: 24),
          SubscriptionPlanFilters(
            searchQuery: _searchQuery,
            isActiveFilter: _isActiveFilter,
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
              child: SubscriptionPlansTable(
                subscriptionPlans: _subscriptionPlans,
                isLoading: _isLoading,
                onPlanTap: _onPlanTap,
                onEditPlan: _onEditPlan,
                onDeletePlan: _onDeletePlan,
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
          PlanAnalyticsCards(subscriptionPlans: _subscriptionPlans),
          const SizedBox(height: 16),
          SubscriptionPlanFilters(
            searchQuery: _searchQuery,
            isActiveFilter: _isActiveFilter,
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
              child: SubscriptionPlansTable(
                subscriptionPlans: _subscriptionPlans,
                isLoading: _isLoading,
                onPlanTap: _onPlanTap,
                onEditPlan: _onEditPlan,
                onDeletePlan: _onDeletePlan,
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
              'Subscription Plans',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage room-based subscription tiers and pricing for your SaaS platform.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _showAddPlanDialog,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Create Plan',
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
    _loadSubscriptionPlans();
  }

  void _onPlanTap(SubscriptionPlanEntity plan) {
    context.go('/subscription-plans/${plan.id}');
  }

  void _onEditPlan(SubscriptionPlanEntity plan) {
    // TODO: Implement edit functionality
    print('Edit plan: ${plan.title}');
  }

  void _onDeletePlan(SubscriptionPlanEntity plan) {
    // TODO: Implement delete functionality
    print('Delete plan: ${plan.title}');
  }

  void _onToggleActive(SubscriptionPlanEntity plan) {
    // TODO: Implement toggle active functionality
    print('Toggle active for: ${plan.title}');
  }

  void _showAddPlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AddSubscriptionPlanDialog(
        onPlanAdded: (plan) {
          setState(() {
            _subscriptionPlans.add(plan);
          });
        },
      ),
    );
  }

  // Mock data for demonstration
  List<SubscriptionPlanEntity> _getMockSubscriptionPlans() {
    return [
      SubscriptionPlanEntity(
        id: '1',
        title: 'Starter',
        description: 'Perfect for small hotels and bed & breakfasts',
        minRooms: 1,
        maxRooms: 50,
        pricing: const PricingModel(monthly: 29.0, yearly: 290.0),
        features: [
          'Basic task management',
          'Staff role management',
          'Email support',
          'Mobile app access',
          'Basic analytics',
        ],
        isActive: true,
        totalSubscribers: 45,
        totalRevenue: 15600.0,
        forGeneral: true,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      SubscriptionPlanEntity(
        id: '2',
        title: 'Professional',
        description: 'Ideal for medium-sized hotels and hotel chains',
        minRooms: 51,
        maxRooms: 100,
        pricing: const PricingModel(monthly: 49.0, yearly: 490.0),
        features: [
          'Advanced task management',
          'Department management',
          'Vendor management',
          'Priority support',
          'Advanced analytics',
          'Custom integrations',
        ],
        isActive: true,
        totalSubscribers: 28,
        totalRevenue: 18200.0,
        forGeneral: true,
        createdAt: DateTime.now().subtract(const Duration(days: 75)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      SubscriptionPlanEntity(
        id: '3',
        title: 'Enterprise',
        description: 'For large hotels and resort chains',
        minRooms: 101,
        maxRooms: 500,
        pricing: const PricingModel(monthly: 99.0, yearly: 990.0),
        features: [
          'Full task automation',
          'Multi-hotel management',
          'Advanced vendor portal',
          '24/7 phone support',
          'Custom reporting',
          'API access',
          'White-label options',
        ],
        isActive: true,
        totalSubscribers: 12,
        totalRevenue: 14850.0,
        forGeneral: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      SubscriptionPlanEntity(
        id: '4',
        title: 'Legacy Basic',
        description: 'Deprecated plan - no longer available for new signups',
        minRooms: 1,
        maxRooms: 25,
        pricing: const PricingModel(monthly: 19.0, yearly: 190.0),
        features: [
          'Basic features only',
          'Limited support',
        ],
        isActive: false,
        totalSubscribers: 8,
        totalRevenue: 2280.0,
        forGeneral: false,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }
}
