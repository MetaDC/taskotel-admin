class Routes {
  //auht route
  static const login = '/login';
  static const registration = '/registration';
  static const deletedAccount = '/deletedAccount';
  static const update = '/update';
  static const noInternet = '/noInternet';

  //shell route

  //--clients route
  static const clients = '/clients';
  // Inside Routes class

  static String clientDetail(String clientId) => '/clients/$clientId';
  static String hotelDetail(String clientId, String hotelId) =>
      '/clients/$clientId/hotels/$hotelId';

  //--master hotel route
  static const masterHotels = '/master-hotels';
  static const masterTasks = '/master-hotels/:hotelId/tasks';

  //--subscription route
  static const subscriptionPlans = '/subscription-plans';

  //--transactions route
  static const transactions = '/transactions';
  static const reports = '/reports';
  static const dashboard = '/';

  static const testClinet = "/testClient";
}
