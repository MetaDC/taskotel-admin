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
  //Common
  static final users = fb.collection('users');
  static final projects = fb.collection('projects');
  static final commonTasks = fb.collection('commonTasks');
  //Admin
  static final masterTasks = fb.collection('masterTasks');
  static final adminTasks = fb.collection('adminTasks');
  //project
  static final activities = fb.collection('activities');
  static final tasks = fb.collection('tasks');
  static final bills = fb.collection('bills');
  static final documents = fb.collection('documents');
  static final settings = fb.collection('setting').doc("sets");
  //Attendance
  static final punches = fb.collection('punches');
  static final records = fb.collection('records');
  static final requests = fb.collection('requests');

  //Notification
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
