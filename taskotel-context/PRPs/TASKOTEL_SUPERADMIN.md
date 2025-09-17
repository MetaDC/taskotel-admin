# PRP: Taskotel Super Admin — Implementation Steps

## Overview

Implement SA portal incrementally. Each numbered step should be a separate commit and tested before moving to the next.

## Step 0 — Repo bootstrap

- Create `flutter` project `taskotel_admin`.
- Create `functions` directory with javascript (npm init, install firebase-admin, firebase-functions).
- Add `.claire` files for command usage if needed.

## Step 1 — Firestore model & seed

- Create Firestore `subscription_plans`, `clients`, `masterhotels`, `mastertask` , `hotels`, `users`, `transactions`, `master_hotels`, `tasks`, `departments`, `vendors`, `audit_logs`, `metrics`.
- Add JSON seed file (3 clients, 5 hotels, 3 plans, 20 transactions).
- Acceptance: `seed_data.json` imports into emulator successfully.

## Step 2 — Cloud Functions: user lifecycle & webhook

- Implement `createClientAccount` callable function:
  - Validate SA auth (custom claim or UID).
  - Create Auth user, create `clients` doc, create `users` doc (role=client_admin), send email stub (log).
- Implement `deleteClientUser`.
- Implement `paymentWebhook(req)` (webhook).
- Implement `generateMonthlyReport` (scheduled).
- Acceptance: functions compile and run on emulator. `createClientAccount` creates auth + docs.

## Step 3 — Firestore rules

- Implement and deploy rules restricting writes for `subscription_plans`, `clients` to SA or cloud functions.
- Acceptance: rules pass basic tests in emulator.

## Step 4 — Flutter Auth + SA login

- Implement `AuthRepository` that uses Firebase Auth emulator.
- Implement `AuthCubit`, `LoginPage`.
- Protect routes with `SAOnlyRouteGuard` reading user doc or custom claim.
- Acceptance: SA can login locally.

## Step 5 — Dashboard

- Implement `DashboardCubit` that reads metrics in `metrics/monthly` and returns KPI state.
- UI: top cards (Active Subs, Revenue, Master Hotels, Top Plan), line chart for revenue (last 12 months), churn list on right.
- Acceptance: UI renders seed metrics, charts use seed data.

## Step 6 — Clients Page (CRUD)

- Implement `ClientsRepository` for clients collection.
- Implement `ClientsCubit` (fetch, addClient, editClient).
- UI: datatable with columns: Client, Email, Plans, #Hotels, #Rooms, Status, Actions.
- AddClient modal calls Cloud Function `createClientAccount`.
- Acceptance: Add Client creates auth user + client doc in emulator.

## Step 7 — Client Detail & Hotels

- Client detail page shows list of hotels, per-hotel plan, subscription dates, import master hotel.
- Implement hotel import endpoint (Cloud Function `importMasterHotel(masterId, clientId)`).
- Acceptance: importing a master adds hotel and copies default tasks.

## Step 8 — Master Hotels & Tasks

- UI: List of master hotels with import count and manage template.
- SA can create predefined tasks and departments in a master hotel.
- Acceptance: creating master templates writes to `master_hotels`.

## Step 9 — Subscription Plans & Transactions

- SA can CRUD plans; assign plan to hotel (planStartDate/EndDate).
- Transactions page shows payments with filters and export CSV.
- Acceptance: Create plan, simulate payment (create transaction), UI shows transaction.

## Step 10 — Reports

- Implement `ReportsCubit` to aggregate active vs churn, MRR, ARR.
- UI: charts consistent with screenshots; export CSV.
- Acceptance: sample reports generated and exported CSV matches metrics.

## Step 11 — Tests & CI

- Unit tests for AuthCubit, ClientsCubit, DashboardCubit.
- GitHub Actions: on push run `flutter analyze`, `flutter test`, and `npm test` for functions.
- Acceptance: CI passes.

## Final Acceptance Criteria

- SA can login, create a client, assign subscriptions per hotel, view transactions and reports, import master hotels, and all sensitive operations are done via cloud functions.
