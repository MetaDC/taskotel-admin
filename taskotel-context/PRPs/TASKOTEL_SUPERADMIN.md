Perfect ✅ — so you want a **detailed PRD-style project requirement prompt (PRP)** that you can give to an AI agent, and it should generate the full SaaS project (with **Firebase backend** + **Cubit for state management**).

Here’s the **final structured PRP** you can directly copy-paste into your agent:

---

# 🚀 PRP: Taskotel – Hotel Management SaaS Platform (with Firebase + Cubit)

## 📌 Overview

Taskotel is a **SaaS platform** for hotel management, provided on a **per-hotel subscription basis**.
Each hotel has **staff roles, departments, tasks, vendors, and analytics**, all centrally managed.
The platform is powered by **Firebase** (Firestore, Auth, Storage, Functions) and uses **Cubit** for state management in Flutter.

The **subscription model** is tied to **room count per hotel**.
Example: If a Client Admin has 10 hotels, each requires its own subscription plan.

---

## 👥 User Roles

1. **Super Admin (SA)** – Owner of the SaaS platform.

   - Manages clients, subscriptions, revenue, churn, master hotels, master departments, master tasks.
   - Defines subscription plans.

2. **Client Admin (CA)** – Owns hotels.

   - Pays for subscriptions.
   - Adds/manages hotels.
   - Assigns staff roles (GM, RM, DM, OP).
   - Manages vendors.

3. **Hotel Roles** (under CA):

   - **GM** – General Manager (hotel-wide tasks).
   - **RM** – Regional Manager.
   - **DM** – Department Manager.
   - **OP** – Operators (maids, cleaners, etc.).
   - **VN** – Vendors (external service providers).

---

## 🏨 Master Hotel Structure

The **Super Admin** defines **Master Hotels**, which act as **templates**.
Each Master Hotel contains:

### 1. **Master Departments**

- Example: Cleaning, Kitchen, Maintenance, Front Desk.
- Each supervised by a **Department Manager (DM)**.

### 2. **Master Tasks**

- Predefined tasks for roles & departments:

  - GM → General tasks (not tied to department).
  - RM → Regional-level tasks.
  - DM → Department-level tasks.
  - OP → Operator tasks inside their department.

- Can be **role-only** or **department-specific**.

---

## 🔄 Import Flow

1. **Client Admin imports a Master Hotel** to create a real hotel.

   - Imports: departments, roles, tasks.

2. **Imported Master Tasks**:

   - Default: **linked** to Master Task (auto-updated if SA edits).
   - If CA/GM edits → a **copy** is created → becomes independent (no sync).

3. **Example**:

   - SA defines “Daily Room Cleaning” under Cleaning Department (OP).
   - CA imports Master Hotel → OPs in Cleaning Department get this task.
   - If CA edits → new copy stored as `ClientTask`, detached from master.

---

## 📊 Super Admin Module (Web Dashboard)

### 1. **Dashboard**

- KPIs:

  - Active subscriptions
  - Monthly & Total revenue
  - Total clients, hotels, subscription plans
  - Churned clients

- Charts:

  - Revenue trend
  - Subscription growth
  - Active vs Churn hotels
  - Subscription distribution

- Insights:

  - Best-selling plan
  - Trial → Paid conversion %
  - Average revenue per hotel

---

### 2. **Clients**

- Onboarding:

  1. Self-signup by CA.
  2. SA creates manually (sends credentials).

- Client List View:

  - Name, email, plans, hotels, rooms, status.

- Client Detail:

  - Hotels under client
  - Subscription history
  - Transactions
  - Option to **extend trial**

- Hotel Detail:

  - Info (plan, rooms, expiry, location)
  - Performance cards:

    - Task completion rate
    - On-time delivery
    - Quality score
    - Active staff/day
    - Tasks/day
    - Issues resolved
    - Renewal rate

  - Task Management (role-wise)
  - Lifecycle tracking (active → trial → expired → churn)

---

### 3. **Master Hotels**

- **Purpose**: Provides pre-built hotel structures for clients.

- **Entities**

  - **Master Hotel**:

    - Base structure, created by SA

  - **Master Departments**:

    - E.g., Cleaning, Kitchen, Maintenance, Front Desk
    - Managed by DM role

  - **Master Tasks**:

    - Role-only tasks (GM/RM)
    - Department-specific tasks (DM/OP inside departments)

- **Import Flow**

  - When CA creates a hotel → option to **Import Master Hotel**
  - Imports: roles, departments, tasks

- **Task Import Behavior**

  - Imported tasks are **linked** to Master Tasks by default (auto-update if SA changes them).
  - If CA edits a task → system creates a **copy (Client Task)** that overrides the Master Task for that hotel.
  - Client sees only one version (linked or edited copy).

---

---

### 4. **Subscription Plans**

- Room-based tiers:

  - 1–50 rooms → \$29/mo per hotel
  - 51–100 rooms → \$49/mo per hotel
  - 101–200 rooms → \$99/mo per hotel

- CRUD: Create / Edit / Delete plans
- Plan Features:

  - Analytics level (basic/advanced)
  - Email / priority support
  - Mobile app access
  - Multi-language support
  - Custom integrations

- Analytics:

  - Hotels subscribed per plan
  - Revenue breakdown per plan
  - Most popular tier

---

### 5. **Transactions**

- Track: Date, Client, Hotel, Plan, Amount, Method, Status.
- Analytics: MRR, ARR, refunds, failed payments, top clients.

---

### 6. **Reports**

- Subscription Analytics: active hotels, churn, trial → paid.
- Hotel Usage: avg rooms, staff, vendor usage.
- Client Analytics: retention, high-value clients.

---

## 🗄 Firebase Data Models (Firestore Collections)

---

## ⚙️ Tech Stack

- **Frontend**: Flutter (Web + Mobile)
- **State Management**: Cubit (Bloc library)
- **Backend**: Firebase

  - Firestore (database)
  - Firebase Auth (email/password, Google login)
  - Firebase Functions (subscription handling, scheduled jobs)
  - Firebase Storage (media/files)
  - Firebase Hosting (web app)

- **Payments**: CashFree

---

## 🎯 Deliverables

- Super Admin Web Dashboard (Flutter Web + mobile Web)
- Cubit-based state management for:

  - Auth
  - Clients
  - Hotels
  - Master Hotels
  - Tasks
  - Plans
  - Transactions

- Analytics dashboards with charts
