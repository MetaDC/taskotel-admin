import 'package:taskoteladmin/features/super_admin/domain/entities/client_entity.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/dashboard_analytics_entity.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/hotel_entity.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/master_hotel_entity.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/subscription_plan_entity.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/transaction_entity.dart';

abstract class SuperAdminRepository {
  // Dashboard Analytics
  Future<DashboardAnalyticsEntity> getDashboardAnalytics();
  Future<KPIMetrics> getKPIMetrics();
  Future<List<RevenueDataPoint>> getRevenueData({
    required DateTime startDate,
    required DateTime endDate,
  });

  // Clients Management
  Future<List<ClientEntity>> getClients({
    ClientStatus? status,
    String? searchQuery,
    int? limit,
    String? lastDocumentId,
  });
  Future<ClientEntity> getClientById(String clientId);
  Future<ClientEntity> createClient({
    required String name,
    required String email,
    required String phone,
    required String companyName,
    required String password,
    bool isTrialAccount = true,
  });
  Future<ClientEntity> updateClient(ClientEntity client);
  Future<void> deleteClient(String clientId);
  Future<void> extendTrial(String clientId, int days);

  // Hotels Management
  Future<List<HotelEntity>> getHotelsByClient(String clientId);
  Future<HotelEntity> getHotelById(String hotelId);
  Future<List<HotelEntity>> getAllHotels({
    String? searchQuery,
    bool? isActive,
    int? limit,
    String? lastDocumentId,
  });

  // Master Hotels Management
  Future<List<MasterHotelEntity>> getMasterHotels({
    bool? isActive,
    String? searchQuery,
  });
  Future<MasterHotelEntity> getMasterHotelById(String masterHotelId);
  Future<MasterHotelEntity> createMasterHotel({
    required String name,
    required String description,
    required String propertyType,
    required List<MasterDepartmentEntity> departments,
    required List<MasterTaskEntity> tasks,
  });
  Future<MasterHotelEntity> updateMasterHotel(MasterHotelEntity masterHotel);
  Future<void> deleteMasterHotel(String masterHotelId);
  Future<void> importMasterHotelToClient({
    required String masterHotelId,
    required String clientId,
    required String hotelName,
  });

  // Subscription Plans Management
  Future<List<SubscriptionPlanEntity>> getSubscriptionPlans({
    bool? isActive,
    String? searchQuery,
  });
  Future<SubscriptionPlanEntity> getSubscriptionPlanById(String planId);
  Future<SubscriptionPlanEntity> createSubscriptionPlan({
    required String title,
    required String description,
    required int minRooms,
    required int maxRooms,
    required PricingModel pricing,
    required List<String> features,
    bool forGeneral = true,
  });
  Future<SubscriptionPlanEntity> updateSubscriptionPlan(
      SubscriptionPlanEntity plan);
  Future<void> deleteSubscriptionPlan(String planId);

  // Transactions Management
  Future<List<TransactionEntity>> getTransactions({
    String? clientId,
    String? hotelId,
    TransactionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? lastDocumentId,
  });
  Future<TransactionEntity> getTransactionById(String transactionId);
  Future<double> getMRR(); // Monthly Recurring Revenue
  Future<double> getARR(); // Annual Recurring Revenue
  Future<Map<String, double>> getRevenueByPlan();
  Future<List<TransactionEntity>> getFailedTransactions();

  // Reports and Analytics
  Future<Map<String, dynamic>> getSubscriptionAnalytics();
  Future<Map<String, dynamic>> getHotelUsageAnalytics();
  Future<Map<String, dynamic>> getClientAnalytics();
  Future<List<Map<String, dynamic>>> exportTransactionsToCSV({
    DateTime? startDate,
    DateTime? endDate,
  });
}
