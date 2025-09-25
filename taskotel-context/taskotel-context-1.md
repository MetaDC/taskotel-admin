# Flutter Hotel Management System - Development Prompt (Using Existing Models)

## Context

I have existing models for both Subscription Plans and Hotel Master systems. Build the folloeing thing give under

## What I Need You to Build

## use existing file structure for cubit and repo and model and make all thing connected with database and check the whole code

## Part 1: Subscription Plan Management System

### 1.1 Cubit Implementation

```dart


  // Methods to implement:
  Future<Stream> loadSubscriptionPlans();
  Future<void> createSubscriptionPlan(SubscriptionPlan plan);
  Future<void> updateSubscriptionPlan(SubscriptionPlan plan);
  Future<void> deleteSubscriptionPlan(String planId);
  Future<void> loadAnalytics();
  void searchPlans(String query);
  void filterByStatus(String status);



```

### 1.2 UI Pages to Build

#### A. Subscription Dashboard Page

Build exactly like :

- **Heading**: "Subscription Plans" title with "+ Create Plan" button
- **Analytics Cards Row**:
  - Total Subscription Plans (4)
  - Active Subscriptions (683)
  - Monthly Revenue ($68,487)
  - Most Popular (Standard)
- **Charts Section**:
  - Subscriber Distribution (Pie Chart using fl_chart)
  - Revenue by Plan (Bar Chart using fl_chart)
- **Subscription Plans Grid**: 4 cards in row showing all plans

#### B. Subscription Plan Cards

Create cards matching the UI:

- **Plan Header**: Name and monthly price
- **Metrics**: Subscriber count and revenue
- **Features List**: Checkmarks and crosses for each feature
- **Status**: Active badge
- **Actions**: Edit/Delete buttons

#### C. Create/Edit Plan Modal

Bottom sheet or dialog with:

- **Form Fields**: base on model
- **Features Section**: Toggle switches for all features
- **Popular Plan Toggle**
- **Save/Cancel Actions**

## Part 2: Hotel Master Management System

```dart

  // Methods to implement:
  master hotle alreday created
```

### 2.2 UI Pages to Build for hotel master

it is already created

now click on hotel master ho in detail page of -> master tasks of that hotel

#### B. Master Task Management Page

// Methods to implement:
Future<Stream> loadTasksByRole(String role, String hotelId);
Future<void> createTask(MasterTask task);
Future<void> updateTask(MasterTask task);
Future<void> deleteTask(String taskId);
Future<void> importTasksFromExcel(File file, String userCategory);
Future<void> toggleTaskStatus(String taskId, bool status);
void searchTasks(String query);

Build the task management system with:

- **Heading**: "Master Tasks" title with "+ Create Task(import task from excel)" button
- **Tab Bar**: Regional Manager, General Manager, Department Manager, Operators
- **Task List Table** for each tab:
  - Task ID, Title, Description
  - Frequency badges (Weekly/Monthly/etc.)
  - Priority badges (High/Medium/Low)
  - Completion Time
  - Department (for Department Manager tab)
  - Status toggles
  - Actions menu
