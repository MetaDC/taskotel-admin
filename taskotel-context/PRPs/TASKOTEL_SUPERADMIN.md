# PRP: Taskotel Super Admin — Implementation Steps

## 🏨 **Taskotel – Hotel Management SaaS Platform**

Taskotel is a **SaaS platform** that hotels subscribe to on a **per-hotel basis**.
It helps manage:

- **Tasks** (assigned to GM, RM, DM, OP)
- **Vendors (VN)**
- **Hotel Analytics (performance, usage, revenue, etc.)**
- **Client & Subscription Management**

The subscription model is tied to **room count per hotel** (pricing tiers).
Each hotel = separate subscription.
Example: If a Client Admin owns 10 hotels, each one needs its own subscription plan.

---

## 👥 **Roles in the System**

1. **Super Admin (SA)**

   - Owner of the SaaS platform.
   - Creates subscription plans, manages clients, revenue tracking, churn, etc.

2. **Client Admin (CA)**

   - Pays for subscriptions for their hotels.
   - Can add hotels → assign roles (GM, RM, DM, OP) → manage tasks & vendors.

3. **Hotel Staff Roles (under CA)**

   - **GM (General Manager)**
   - **RM (Regional Manager)**
   - **DM (Department Manager)**
   - **OP (Operators / staff like gardener, maid, etc.)**
   - **VN (Vendors)** (external service providers)

---

## 📊 **Super Admin (SA) Module Overview**

This is your current focus. The SA side has multiple sections:

### 1. **Dashboard**

Analytics & KPIs:

- Active Subscriptions (per hotel basis)
- Monthly Revenue, Total Revenue
- Total Clients
- Total Hotels created
- Total Subscription Plans
- Churn Clients (lost after subscription expiry)
- Most Popular Subscription Tier
- **Graphs/Charts**:

  - Revenue Trend (line)
  - Subscription Growth (line/bar)
  - Active vs Churn Hotels (bar)
  - Subscription Distribution (pie)

- **Quick Insights**:

  - Which plan is selling best
  - Trial → Paid conversion %
  - Average revenue per hotel

---

### 2. **Clients (Active / Lost / Churned)**

- **Onboarding Paths**:

  1. **Self-signup** (CA signs up on SaaS site → adds hotel → buys plan).
  2. **Super Admin creates client manually** (credentials shared).

- **Client List View**:

  - Client name, email, plans, number of hotels, total rooms, status (active/expired/churned).

- **Client Detail View**:

  - Basic Info (name, contact, company)
  - Hotels under client
  - Subscription history (per hotel)
  - Transactions
  - Option to **extend trial (1 month)** to avoid churn.

- **Hotel Detail View (under Client)**:

  1. **Hotel Info** (name, location, plan, subscription validity, performance rating).
  2. **Performance Cards**:

     - Task completion rate
     - On-time delivery
     - Quality score
     - Daily active staff
     - Tasks/day
     - Issues resolved
     - Revenue contribution from hotel
     - Renewal rate

  3. **Task Management (detailed)**:

     - Role-wise task view (RM, GM, DM, OP)
     - Columns: ID, title, desc, frequency, priority, time, status, toggle active/inactive, actions.

  4. **Lifecycle Tracking**:

     - Active / Expired → Trial offer → Churn status.
     - Handle lost client cases (0 hotels subscribed = lost, partial subscription = active but with inactive hotels).

---

### 3. 🏨 Master Hotel Structure (Revised)

- **Purpose**: Templates for franchise-style hotels.
- Contains:

### 1. **Master Hotel**

- Created by **Super Admin**.
- Defines the **base structure** for client hotels.
- Includes:

  - Roles (GM, RM, DM, OP)
  - Departments (Master Departments, e.g., Cleaning, Maintenance, Kitchen)
  - Master Tasks (linked to roles + optionally departments)

---

### 2. **Master Departments**

- Departments inside a Master Hotel (like "Cleaning Department", "Maintenance Department").
- Each department is supervised by a **Department Manager (DM)**.
- Example departments:

  - Cleaning Department
  - Kitchen Department
  - Front Desk
  - Maintenance

---

### 3. **Master Tasks**

- Tasks are defined under either:

  - **Role-only** (e.g., GM → “Weekly Revenue Review”)
  - **Department-specific** (e.g., Cleaning Department → “Daily Room Cleaning”)

- **Assignment Rules**:

  - GM, RM → General role tasks (not tied to department).
  - DM → Can create/manage tasks **inside departments**.
  - OP → Operators get tasks **inside their department** (assigned by DM).

---

## 🔄 Example Flow with Departments

1. **Super Admin Creates Master Hotel** → “Luxury Hotel Template”.

   - Adds **Departments**: Cleaning, Kitchen, Front Desk.

2. **Super Admin Adds Master Tasks**:

   - GM → "Weekly Revenue Review"
   - RM → "Regional Check-in Report"
   - DM (Cleaning Department) → "Check staff schedules"
   - OP (Cleaning Department) → "Daily Room Cleaning"

3. **Client Admin Imports Master Hotel** → creates "Grand Palace Hotel".

   - System imports:

     - Departments: Cleaning, Kitchen, Front Desk
     - Roles: GM, RM, DM, OP
     - Tasks: all predefined Master Tasks assigned to the correct role/department

4. **Grand Palace Hotel (Client)** now has:

   - GM → Weekly Revenue Review
   - RM → Regional Check-in Report
   - Cleaning Department

     - DM (Cleaning) → "Check staff schedules"
     - OP (Cleaning) → "Daily Room Cleaning"

---

### 4. **Subscription Plans**

- Plans are **room-based tiers** (e.g., 1–50 = \$29/mo, 51–100 = \$49/mo, etc.).
- Manage plans: Create / Edit / Delete.
- Each plan has **features** (analytics level, support, mobile app, integrations).
- Analytics:

  - How many hotels subscribed to each plan
  - Revenue breakdown
  - Most popular tier

---

### 5. **Transactions**

- **Transaction List**:

  - Date, Client, Hotel, Plan, Amount, Payment Method, Status.

- **Financial Analytics**:

  - MRR (Monthly Recurring Revenue)
  - ARR (Annual Recurring Revenue)
  - Refunds, failed payments
  - Most profitable clients
  - Revenue split by tier

---

### 6. **Reports / Analytics**

- **Subscription Analytics**:

  - Active hotels
  - Revenue growth
  - Churned clients/hotels
  - Trial → Paid conversion

- **Hotel Usage Analytics**:

  - Avg rooms per hotel
  - Avg staff distribution (RMs, GMs, OPs, etc.)
  - Vendor usage

- **Client Analytics**:

  - Retention rate
  - High-value clients

Ahh got it ✅ — so your **Master Hotel** has another layer: **Master Departments**.
Let me restructure everything with this addition.

---
