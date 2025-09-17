import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FBAuth {
  static final auth = FirebaseAuth.instance;
}

class FBFireStore {
  static final fb = FirebaseFirestore.instance;

  // Super Admin Collections
  static final clients = fb.collection('clients');
  static final subscriptionPlans = fb.collection('subscription_plans');
  static final masterHotels = fb.collection('master_hotels');
  static final masterTasks = fb.collection('master_tasks');
  static final hotels = fb.collection('hotels');
  static final transactions = fb.collection('transactions');
  static final users = fb.collection('users');
  static final departments = fb.collection('departments');
  static final vendors = fb.collection('vendors');

  // Notification collections
  static final activityNotifications = fb.collection('activity_notifications');
  static final taskNotifications = fb.collection('task_notifications');
  static final notifications = fb.collection('notifications');
}

class FBStorage {
  static final fbstore = FirebaseStorage.instance;
  static final bills = fbstore.ref().child('bills');
  static final project = fbstore.ref().child('project');
  static final documents = fbstore.ref().child('documents');
  static final tasks = fbstore.ref().child('tasks');
  static final activity = fbstore.ref().child('activity');
}

class FBFunctions {
  static final ff = FirebaseFunctions.instance;
}

class FBMessaging {
  static final messaging = FirebaseMessaging.instance;
}
