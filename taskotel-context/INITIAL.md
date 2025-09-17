# INITIAL.md — Taskotel Super Admin (complete)

Goal: Build the Super Admin portal for Taskotel — SaaS hotel operations. Start with full SA module: Dashboard, Clients (list + detail + onboarding), Master Hotels, Subscription Plans, Transactions, Reports, and admin utilities. Use Flutter web and Firebase (Firestore, Auth, Functions).

Primary requirements:

- SA auth (email/password)
- Dashboard with KPI cards, revenue graph (line), subscription growth (bar), churn list.
- Clients list + detail pages: hotels under client, per-hotel subscription, transaction history, ability to grant trial/extend subscription, import master hotel template into client's hotel.
- Master Hotels: create franchise templates (departments, default tasks), track imports & uses.
- Subscription Plans: room-based tiers, CRUD, analytics per-tier.
- Transactions: list, filters, CSV export, MRR/ARR calculations.
- Reports: prebuilt charts and CSV exports.
- Cloud Functions: create client account (Auth + firestore), delete user, payment webhook (Stripe or any), monthly aggregations.
- Firestore rules and seed data.
- UI should follow the supplied screenshots (card layout, tables, modals). Use the models image as data reference.

Deliverables:

- PRP for AI execution.
- Firestore model definitions and JSON seed.
- Cloud Functions TypeScript code.
- Flutter skeleton with key pages + Cubits + repo layer matching the UI.
- Tests & CI/Deploy instructions.
