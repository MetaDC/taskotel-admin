# CLAUDE.md — Taskotel (Super Admin) Global Rules

## Purpose

This file defines project-wide rules, coding style, architecture, and expectations for AI-assisted generation and human contributors.

## Tech stack

- Frontend: Flutter (Dart, null-safety) — web-first, mobile-ready.
- State mgmt: Cubit (flutter_bloc).
- Routing:-Go Router.
- Backend: Firebase (Auth, Firestore, Storage).
- Server: Firebase Functions (Node.js + TypeScript).
- Charts: recharts for web equivalent or `fl_chart` in Flutter.
- CI: GitHub Actions.

## Architecture

- Clean Architecture: `lib/core`, `lib/features/<feature>`, `lib/shared`.
- Each `feature` contains:
  - data/ (repositories, ds)
  - domain/ (entities, usecases)
  - presentation/ (cubit/bloc, pages, widgets)
- Keep UI logic in Cubits; repositories talk to Firestore or Functions.


## File /Structure
lib/
├── core/
│   ├── theme/
│   ├── widgets/
├── features/
│   └── auth/
│       ├── domain/
│       │   ├── entity/
│       │   └── repo/
│       ├── data/ → firebase impls
│       └── presentation/
│           └── cubits/
│               └── auth_state.dart
│               └── auth_cubit.dart
│           └── pages/
│               └── login_page.dart


## File / naming conventions
- Dart files: snake_case.dart
- Dart classes: PascalCase
- Cubits: `<Feature>Cubit`, states in `<Feature>State`.
- Collections in Firestore: plural, lower_snake: `clients`, `hotels`, `subscription_plans`, `transactions`, `master_hotels`, `users`, `tasks`, `departments`, `vendors`, `audit_logs`, `metrics`.

# use this syntax for cubit
class AuthState {
  bool isAuthenticated;
  UserModel? currentUser;
  String message;
  bool loading;

  AuthState({
    required this.isAuthenticated,
    required this.currentUser,
    required this.message,
    required this.loading,
  });

  factory AuthState.initial() {
    return AuthState(
      isAuthenticated: false,
      currentUser: null,
      message: "",
      loading: false,
    );
  }
  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? currentUser,
    String? message,
    bool? loading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      message: message ?? this.message,
      loading: loading ?? this.loading,
    );
  }
}

## Security & Roles

- Roles: `super_admin` (SA), `client_admin` (CA), `gm`, `rm`, `dm`, `op`, `vendor`.
- SA operations must be callable only by SA uid list or `isSuperAdmin` custom claim.
- Sensitive writes for clients, subscription plans, and master templates must be done through Cloud Functions.

## UI Guidelines

- Match supplied UI: top KPI cards, large charts, datatables, right-side activity summary.
- Tables support: search, filters, pagination, row actions (view, edit, import).
- Use modals for Add / Edit operations.
- Provide desktop-optimized layout; responsive to mobile with drawer nav.

## Testing

- Unit tests for Cubits and Repositories.
- Widget tests for AddClientDialog and DashboardCard.
- Use Firebase Emulator for integration tests.

## Documentation

- Each feature: README.md with API contract and Firestore document shape.
- Code comments for public functions.

## Deliverables for AI generation

- Create files under `features/<feature>`.
- Include minimal styles that mimic the screenshots (cards, colors, fonts).

## Comments
Give Comments to all logic function what particular function do


## DB
use firebase.dart for Firebase instance