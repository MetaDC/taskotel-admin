import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/features/subscription/data/subscription_firebaserepo.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/subscription_form_cubit.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/susbcription_cubit.dart';
import 'package:taskoteladmin/features/subscription/presentation/widgets/subscription_analytics.dart';
import 'package:taskoteladmin/features/subscription/presentation/widgets/subscription_plan_card.dart';
import 'package:taskoteladmin/features/subscription/presentation/widgets/create_plan_form.dart';

class SubscriptionPlansPage extends StatelessWidget {
  const SubscriptionPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubscriptionCubit(subscriptionRepo: SubscriptionFirebaserepo())
            ..loadSubscriptionPlans()
            ..loadAnalytics(),
      child: const _SubscriptionPlansView(),
    );
  }
}

class _SubscriptionPlansView extends StatefulWidget {
  const _SubscriptionPlansView();

  @override
  State<_SubscriptionPlansView> createState() => _SubscriptionPlansViewState();
}

class _SubscriptionPlansViewState extends State<_SubscriptionPlansView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listenWhen: (previous, current) {
        // Only listen when message actually changes and is not null
        return previous.message != current.message && current.message != null;
      },
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: state.message!.contains('success')
                  ? Colors.green
                  : Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          // Clear message immediately to prevent multiple triggers
          context.read<SubscriptionCubit>().clearMessage();
        }
      },
      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                // Page Header
                _buildPageHeader(context),
                const SizedBox(height: 30),

                // Analytics Cards
                _buildSubscriptionAnalytics(state),
                const SizedBox(height: 30),

                // Charts Section
                _buildChartsSection(state),
                const SizedBox(height: 30),

                // Subscription Plans Grid
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.filteredPlans.isEmpty)
                  Center(
                    child: Text(
                      "No subscription plans found",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  StaggeredGrid.extent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: state.filteredPlans
                        .map(
                          (plan) => SubscriptionPlanCard(
                            plan: plan,
                            onEdit: () => _showEditPlanModal(context, plan),
                            onDelete: () =>
                                _showDeleteConfirmation(context, plan),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context) {
    return PageHeaderWithButton(
      heading: "Subscription Plans",
      subHeading: "Manage subscription plans and pricing",
      buttonText: "Create Plan",
      onButtonPressed: () => _showCreatePlanModal(context),
    );
  }

  Widget _buildSubscriptionAnalytics(SubscriptionState state) {
    // Check if analytics is null
    if (state.analytics == null) {
      return const SizedBox.shrink();
    }

    return StaggeredGrid.extent(
      maxCrossAxisExtent: 500,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        StatCardIconLeft(
          icon: CupertinoIcons.doc_text,
          label: "Total Plans",
          value: "${state.analytics!['totalPlans'] ?? 0}",
          iconColor: Colors.blue,
        ),
        StatCardIconLeft(
          icon: CupertinoIcons.person_2,
          label: "Active Subscriptions",
          value: "${state.analytics!['totalSubscribers'] ?? 0}",
          iconColor: Colors.green,
        ),
        StatCardIconLeft(
          icon: CupertinoIcons.money_dollar,
          label: "Monthly Revenue",
          value:
              "\$${(state.analytics!['totalRevenue'] ?? 0.0).toStringAsFixed(0)}",
          iconColor: Colors.orange,
        ),
        StatCardIconLeft(
          icon: CupertinoIcons.star_fill,
          label: "Most Popular",
          value: "${state.analytics!['mostPopular'] ?? 'N/A'}",
          iconColor: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildChartsSection(SubscriptionState state) {
    // Only show charts if we have subscription plans
    if (state.subscriptionPlans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subscriber Distribution Chart
        Expanded(
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SubscriberDistributionChart(plans: state.subscriptionPlans),
          ),
        ),
        const SizedBox(width: 20),

        // Revenue by Plan Chart
        Expanded(
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: RevenueByPlanChart(plans: state.subscriptionPlans),
          ),
        ),
      ],
    );
  }

  void _showCreatePlanModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xffFAFAFA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: BlocProvider(
            create: (context) => SubscriptionFormCubit(
              subscriptionRepo: SubscriptionFirebaserepo(),
            ),
            child: BlocListener<SubscriptionFormCubit, SubscriptionFormState>(
              listener: (formContext, formState) {
                if (formState.isSubmitted && formState.successMessage != null) {
                  // Success - close dialog and refresh main cubit
                  Navigator.of(dialogContext).pop();
                  context.read<SubscriptionCubit>().loadSubscriptionPlans();
                  context.read<SubscriptionCubit>().loadAnalytics();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(formState.successMessage!),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: const CreatePlanForm(planToEdit: null),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditPlanModal(BuildContext context, SubscriptionPlanModel plan) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xffFAFAFA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: BlocProvider(
            create: (context) => SubscriptionFormCubit(
              subscriptionRepo: SubscriptionFirebaserepo(),
            ),
            child: BlocListener<SubscriptionFormCubit, SubscriptionFormState>(
              listener: (formContext, formState) {
                if (formState.isSubmitted && formState.successMessage != null) {
                  // Success - close dialog and refresh main cubit
                  Navigator.of(dialogContext).pop();
                  context.read<SubscriptionCubit>().loadSubscriptionPlans();
                  context.read<SubscriptionCubit>().loadAnalytics();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(formState.successMessage!),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: CreatePlanForm(planToEdit: plan),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    SubscriptionPlanModel plan,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Plan"),
        content: Text("Are you sure you want to delete '${plan.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Close dialog first
              Navigator.of(dialogContext).pop();
              // Then perform delete operation
              await context.read<SubscriptionCubit>().deleteSubscriptionPlan(
                plan.docId,
              );
            },
            child: Text("Delete", style: GoogleFonts.inter(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
