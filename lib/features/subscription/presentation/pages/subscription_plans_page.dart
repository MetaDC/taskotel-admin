import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/features/subscription/data/subscription_firebaserepo.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/subscription_form_cubit.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/susbcription_cubit.dart';
import 'package:taskoteladmin/features/subscription/presentation/widgets/subscription_plan_card.dart';
import 'package:taskoteladmin/features/subscription/presentation/widgets/create_plan_form.dart';

class SubscriptionPlansPage extends StatefulWidget {
  const SubscriptionPlansPage({super.key});

  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  @override
  void initState() {
    super.initState();
    // Initialize subscription cubit and load data
    context.read<SubscriptionCubit>().loadSubscriptionPlans();
    context.read<SubscriptionCubit>().loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubscriptionCubit(subscriptionRepo: SubscriptionFirebaserepo())
            ..loadSubscriptionPlans()
            ..loadAnalytics(),
      child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: state.message!.contains('success')
                    ? Colors.green
                    : Colors.red,
              ),
            );
            context.read<SubscriptionCubit>().clearMessage();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                // Page Header
                PageHeader(
                  heading: "Subscription Plans",
                  subHeading: "Manage subscription plans and pricing",
                  buttonText: "Create Plan",
                  onButtonPressed: () => _showCreatePlanModal(context),
                ),
                const SizedBox(height: 30),

                // Analytics Cards
                if (state.analytics != null) ...[
                  StaggeredGrid.extent(
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
                  ),
                  const SizedBox(height: 30),
                ],

                // Search and Filter Row
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         decoration: InputDecoration(
                //           hintText: "Search plans...",
                //           prefixIcon: const Icon(CupertinoIcons.search),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(8),
                //             borderSide: BorderSide(color: AppColors.slateGray),
                //           ),
                //         ),
                //         onChanged: (value) {
                //           context.read<Subscription1Cubit>().searchPlans(value);
                //         },
                //       ),
                //     ),
                //     const SizedBox(width: 16),
                //     DropdownButton<bool?>(
                //       value: state.statusFilter,
                //       hint: const Text("Filter by Status"),
                //       items: const [
                //         DropdownMenuItem(value: null, child: Text("All")),
                //         DropdownMenuItem(value: true, child: Text("Active")),
                //         DropdownMenuItem(value: false, child: Text("Inactive")),
                //       ],
                //       onChanged: (value) {
                //         context.read<Subscription1Cubit>().filterByStatus(value);
                //       },
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 30),

                // Subscription Plans Grid
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.filteredPlans.isEmpty)
                  const Center(
                    child: Text(
                      "No subscription plans found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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

  void _showCreatePlanModal(
    BuildContext context, {
    SubscriptionPlanModel? planToEdit,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xffFAFAFA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: BlocProvider(
            create: (context) => SubscriptionFormCubit(
              subscriptionRepo: SubscriptionFirebaserepo(),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: CreatePlanForm(planToEdit: planToEdit),
            ),
          ),
        );
      },
    );

    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => CreatePlanForm(),
    // );
  }

  void _showEditPlanModal(BuildContext context, SubscriptionPlanModel plan) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xffFAFAFA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: BlocProvider(
            create: (context) => SubscriptionFormCubit(
              subscriptionRepo: SubscriptionFirebaserepo(),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: CreatePlanForm(planToEdit: plan),
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
      builder: (context) => AlertDialog(
        title: const Text("Delete Plan"),
        content: Text("Are you sure you want to delete '${plan.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<SubscriptionCubit>().deleteSubscriptionPlan(
                plan.docId,
              );
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
