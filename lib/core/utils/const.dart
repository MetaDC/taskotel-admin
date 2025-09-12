import 'package:flutter/material.dart';

class MonthYear {
  final int month;
  final int year;

  MonthYear(this.month, this.year);

  @override
  String toString() => '$month-$year';
}

DateTime reqPunchOutTime = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
  13,
  00,
  00,
);

final Map<int, String> monthMap = const {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

// Variables you can change dynamically
final int startMonth =
    6; // July — you can set this based on user input or logic
final int currentMonth = DateTime.now().month;

// Calculate the total number of months to show
final int monthCount =
    currentMonth >= startMonth
        ? (currentMonth - startMonth + 1)
        : (12 - startMonth + 1) + currentMonth;

// Build the dropdown items in order
final dropdownItems = List.generate(monthCount, (index) {
  // Wrap around year if needed
  final monthIndex = ((startMonth + index - 1) % 12) + 1;
  return DropdownMenuItem<int>(
    value: monthIndex,
    child: Text(monthMap[monthIndex] ?? ''),
  );
});

class NotificationType {
  static const String activity = 'activity';
  static const String task = 'task';
  static const String request = 'request';
  static const String sumbitTask = 'sumbitTask';
  static const String approveTask = 'approveTask';
  static const String commontask = 'commontask';
  static const String attendence = 'attendence';
}

class TaskCompletionScore {
  static const String average = 'Average';
  static const String good = 'Good';
  static const String excellent = "Excellent";
}

class Role {
  static const String designer = 'designer';
  static const String supervisor = 'supervisor';
  static const String accountant = "accountant";
  static const String admin = 'admin';
}

class ProjectStatus {
  static const String active = 'Active';
  static const String onHold = 'on-Hold';
  static const String finished = 'Finished';
}

class ProjectFilter {
  static const String All = 'All';
  static const String finished = 'Finished';
}

class FinishedProjectFilter {
  static const String Monthly = 'Monthly';
  static const String Months3 = '3 Months';
  static const String Custom = 'Custom';
}

class AllProjectFilter {
  static const String ongoing = 'Ongoing';
  static const String upcoming = 'Upcoming';
}

class TaskStatus {
  static const String pending = 'Pending';
  static const String ongoing = 'Ongoing';
  static const String submitted = 'Submitted';
  static const String approved = 'Approved';
}

class TaskSPrioritytatus {
  static const String low = 'Low';
  static const String mid = 'Mid';
  static const String high = 'High';
}

class TaskTypes {
  static const String All = 'All';
  static const String mytask = 'My Task';
  static const String onGoing = 'Ongoing';
  static const String submitted = 'Submitted';
  static const String approved = 'Approved';
}

class AdminTaskTypes {
  static const String All = 'All';
  static const String completed = 'Completed';
  static const String onGoing = 'Ongoing';
}

class CommonTaskTypes {
  static const String All = 'All';
  static const String mytask = 'My Task';
  static const String completed = 'Completed';
  static const String onGoing = 'Ongoing';
}

class docTypes {
  static const String All = 'All';
  static const String PDF = 'Pdf';
  static const String Images = 'Images';
  static const String Others = 'Others';
}

class AttendanceFilter {
  static const String today = 'Today';
  static const String month = 'Month';
  static const String custom = 'Custom';
}

class AnalyticsFilter {
  static const String month = 'Month';
  static const String year = 'Yearly';
  static const String custom = 'Custom';
}

final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
