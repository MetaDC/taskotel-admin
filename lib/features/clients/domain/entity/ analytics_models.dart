// 1. Analytics Models
class ClientListAnalytics {
  final int totalClients;
  final double totalRevenue;
  final int totalHotels;
  final int activeSubscriptions;

  const ClientListAnalytics({
    required this.totalClients,
    required this.totalRevenue,
    required this.totalHotels,
    required this.activeSubscriptions,
  });
}

class ClientDetailAnalytics {
  final int totalHotels;
  final double totalRevenue;
  final int activeSubscriptions;
  final int totalTasks;
  final double averageHotelRating;

  const ClientDetailAnalytics({
    required this.totalHotels,
    required this.totalRevenue,
    required this.activeSubscriptions,
    required this.totalTasks,
    required this.averageHotelRating,
  });
}

class HotelDetailAnalytics {
  final int totalTasks;
  final int activeTasks;
  final int completedTasks;
  final double taskCompletionRate;
  final int totalRooms;
  final double monthlyRevenue;

  const HotelDetailAnalytics({
    required this.totalTasks,
    required this.activeTasks,
    required this.completedTasks,
    required this.taskCompletionRate,
    required this.totalRooms,
    required this.monthlyRevenue,
  });
}
