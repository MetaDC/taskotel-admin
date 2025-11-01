// ==================== UI FILE ====================
// Path: features/subscription/presentation/dialogs/client_plan_assignment_dialog.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/assignplan_client_cubit.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/assignplan_client_state.dart';

class ClientPlanAssignmentDialog extends StatelessWidget {
  final String clientId;
  final String clientName;
  final String clientEmail;
  final String assignedBy;
  final Function(String planId) onAssignmentComplete;

  const ClientPlanAssignmentDialog({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.assignedBy,
    required this.onAssignmentComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssignPlanCubit()..loadSubscriptionPlans(),
      child: BlocListener<AssignPlanCubit, AssignPlanState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.successMessage!,
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            context.read<AssignPlanCubit>().clearMessages();
            Navigator.of(context).pop();
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.exclamationmark_circle_fill,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            context.read<AssignPlanCubit>().clearMessages();
          }
        },
        child: Dialog(
          insetPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: ResponsiveCustomBuilder(
            mobileBuilder: (width) => _ClientPlanDialogContent(
              clientName: clientName,
              clientEmail: clientEmail,
              clientId: clientId,
              assignedBy: assignedBy,
              onAssignmentComplete: onAssignmentComplete,
              isMobile: true,
            ),
            tabletBuilder: (width) => _ClientPlanDialogContent(
              clientName: clientName,
              clientEmail: clientEmail,
              clientId: clientId,
              assignedBy: assignedBy,
              onAssignmentComplete: onAssignmentComplete,
            ),
            desktopBuilder: (width) => _ClientPlanDialogContent(
              clientName: clientName,
              clientEmail: clientEmail,
              clientId: clientId,
              assignedBy: assignedBy,
              onAssignmentComplete: onAssignmentComplete,
            ),
          ),
        ),
      ),
    );
  }
}

class _ClientPlanDialogContent extends StatelessWidget {
  final String clientName;
  final String clientEmail;
  final String clientId;
  final String assignedBy;
  final Function(String planId) onAssignmentComplete;
  final bool isMobile;

  const _ClientPlanDialogContent({
    required this.clientName,
    required this.clientEmail,
    required this.clientId,
    required this.assignedBy,
    required this.onAssignmentComplete,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            _buildHeader(context, isMobile: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildContent(context, isMobile: true),
              ),
            ),
            _buildActionButtons(context, isMobile: true),
          ],
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 750),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: _buildContent(context),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              CupertinoIcons.gift_fill,
              color: AppColors.primary,
              size: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Assign Client Plan",
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Assign trial or gift plan to client",
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 12 : 13,
                    color: AppColors.slateGray,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(CupertinoIcons.xmark_circle_fill),
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, {bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildClientInfoSection(isMobile: isMobile),
        SizedBox(height: isMobile ? 20 : 28),
        _buildPlanTypeSection(context, isMobile: isMobile),
        SizedBox(height: isMobile ? 20 : 28),
        _buildPlanSelector(context, isMobile: isMobile),
        SizedBox(height: isMobile ? 20 : 28),
        _buildHotelLimitSection(context, isMobile: isMobile),
        SizedBox(height: isMobile ? 20 : 28),
        _buildDurationSection(context, isMobile: isMobile),
        SizedBox(height: isMobile ? 20 : 28),
        _buildDateRangeSection(context, isMobile: isMobile),
      ],
    );
  }

  Widget _buildClientInfoSection({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.person_fill,
                size: 16,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Client Information",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: AppColors.containerGreyColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.blueGreyBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                icon: CupertinoIcons.person_fill,
                label: "Client",
                value: clientName,
                isMobile: isMobile,
              ),
              SizedBox(height: isMobile ? 8 : 12),
              _buildInfoRow(
                icon: CupertinoIcons.mail_solid,
                label: "Email",
                value: clientEmail,
                isMobile: isMobile,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMobile = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: isMobile ? 14 : 16, color: AppColors.slateGray),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: GoogleFonts.inter(
            fontSize: isMobile ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: AppColors.slateGray,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanTypeSection(BuildContext context, {bool isMobile = false}) {
    return BlocBuilder<AssignPlanCubit, AssignPlanState>(
      buildWhen: (previous, current) =>
          previous.selectedPlanType != current.selectedPlanType,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    CupertinoIcons.tag_fill,
                    size: 16,
                    color: Colors.purple.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Plan Type *",
                  style: AppTextStyles.textFieldTitle.copyWith(
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 12),
            if (isMobile) ...[
              _buildPlanTypeOption(
                context,
                'trial',
                'Trial Plan',
                'Time-limited plan for testing',
                CupertinoIcons.clock_fill,
                Colors.orange,
                state.selectedPlanType == 'trial',
                isMobile: true,
              ),
              const SizedBox(height: 8),
              _buildPlanTypeOption(
                context,
                'gift',
                'Gift Plan',
                'Complimentary plan for client',
                CupertinoIcons.gift_fill,
                Colors.green,
                state.selectedPlanType == 'gift',
                isMobile: true,
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: _buildPlanTypeOption(
                      context,
                      'trial',
                      'Trial Plan',
                      'Time-limited plan for testing',
                      CupertinoIcons.clock_fill,
                      Colors.orange,
                      state.selectedPlanType == 'trial',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPlanTypeOption(
                      context,
                      'gift',
                      'Gift Plan',
                      'Complimentary plan for client',
                      CupertinoIcons.gift_fill,
                      Colors.green,
                      state.selectedPlanType == 'gift',
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildPlanTypeOption(
    BuildContext context,
    String type,
    String title,
    String description,
    IconData icon,
    Color color,
    bool isSelected, {
    bool isMobile = false,
  }) {
    return InkWell(
      onTap: () => context.read<AssignPlanCubit>().updatePlanType(type),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : AppColors.blueGreyBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? CupertinoIcons.check_mark_circled_solid
                      : CupertinoIcons.circle,
                  color: isSelected ? color : AppColors.slateGray,
                  size: isMobile ? 18 : 20,
                ),
                const SizedBox(width: 8),
                Icon(icon, color: color, size: isMobile ? 18 : 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: isMobile ? 34 : 38),
              child: Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 11 : 12,
                  color: AppColors.slateGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSelector(BuildContext context, {bool isMobile = false}) {
    return BlocBuilder<AssignPlanCubit, AssignPlanState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.activePlans != current.activePlans ||
          previous.selectedPlan != current.selectedPlan,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    CupertinoIcons.star_fill,
                    size: 16,
                    color: Colors.indigo.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Select Subscription Plan *",
                  style: AppTextStyles.textFieldTitle.copyWith(
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blueGreyBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SubscriptionPlanModel>(
                  value: state.selectedPlan,
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Choose a subscription plan",
                      style: GoogleFonts.inter(
                        color: AppColors.slateGray,
                        fontSize: isMobile ? 13 : 14,
                      ),
                    ),
                  ),
                  items: state.activePlans.map((plan) {
                    return DropdownMenuItem<SubscriptionPlanModel>(
                      value: plan,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              plan.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: isMobile ? 13 : 14,
                              ),
                            ),
                            Text(
                              plan.desc,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 11 : 12,
                                color: AppColors.slateGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (plan) {
                    context.read<AssignPlanCubit>().updateSelectedPlan(plan);
                  },
                ),
              ),
            ),
            if (state.selectedPlan != null) ...[
              SizedBox(height: isMobile ? 12 : 16),
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Plan Details",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: isMobile ? 12 : 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.bed_double_fill,
                          size: isMobile ? 14 : 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Rooms: ${state.selectedPlan!.minRooms} - ${state.selectedPlan!.maxRooms}",
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 12 : 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.money_dollar_circle_fill,
                          size: isMobile ? 14 : 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Monthly: \$${state.selectedPlan!.price['monthly']?.toStringAsFixed(2)} | Yearly: \$${state.selectedPlan!.price['yearly']?.toStringAsFixed(2)}",
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 12 : 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHotelLimitSection(
    BuildContext context, {
    bool isMobile = false,
  }) {
    return BlocBuilder<AssignPlanCubit, AssignPlanState>(
      buildWhen: (previous, current) =>
          previous.allowedHotels != current.allowedHotels,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    CupertinoIcons.building_2_fill,
                    size: 16,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Hotel Limit *",
                  style: AppTextStyles.textFieldTitle.copyWith(
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: AppColors.containerGreyColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.blueGreyBorder),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: state.allowedHotels > 1
                        ? () => context
                              .read<AssignPlanCubit>()
                              .updateAllowedHotels(state.allowedHotels - 1)
                        : null,
                    icon: Icon(
                      CupertinoIcons.minus_circle_fill,
                      color: state.allowedHotels > 1
                          ? AppColors.primary
                          : Colors.grey,
                      size: isMobile ? 24 : 28,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "${state.allowedHotels}",
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          state.allowedHotels == 1
                              ? "Hotel allowed"
                              : "Hotels allowed",
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 11 : 12,
                            color: AppColors.slateGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: state.allowedHotels < 100
                        ? () => context
                              .read<AssignPlanCubit>()
                              .updateAllowedHotels(state.allowedHotels + 1)
                        : null,
                    icon: Icon(
                      CupertinoIcons.plus_circle_fill,
                      color: state.allowedHotels < 100
                          ? AppColors.primary
                          : Colors.grey,
                      size: isMobile ? 24 : 28,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Row(
              children: [
                Icon(
                  CupertinoIcons.info_circle_fill,
                  size: isMobile ? 12 : 14,
                  color: Colors.blue,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Number of hotels that can use this plan",
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 11 : 12,
                      color: AppColors.slateGray,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDurationSection(BuildContext context, {bool isMobile = false}) {
    return BlocBuilder<AssignPlanCubit, AssignPlanState>(
      buildWhen: (previous, current) => previous.duration != current.duration,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    CupertinoIcons.clock_fill,
                    size: 16,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Duration (Days) *",
                  style: AppTextStyles.textFieldTitle.copyWith(
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            // Manual input field
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blueGreyBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.pencil,
                    size: isMobile ? 16 : 18,
                    color: AppColors.slateGray,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller:
                          TextEditingController(text: state.duration.toString())
                            ..selection = TextSelection.fromPosition(
                              TextPosition(
                                offset: state.duration.toString().length,
                              ),
                            ),
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 13 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter days',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.slateGray,
                          fontSize: isMobile ? 13 : 14,
                        ),
                      ),
                      onChanged: (value) {
                        final days = int.tryParse(value);
                        if (days != null && days > 0) {
                          context.read<AssignPlanCubit>().updateDuration(days);
                        }
                      },
                    ),
                  ),
                  Text(
                    'days',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 12 : 13,
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              "Quick Select:",
              style: GoogleFonts.inter(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: AppColors.slateGray,
              ),
            ),
            SizedBox(height: isMobile ? 8 : 12),
            if (isMobile) ...[
              _buildDurationOption(context, 7, isMobile: true),
              const SizedBox(height: 8),
              _buildDurationOption(context, 14, isMobile: true),
              const SizedBox(height: 8),
              _buildDurationOption(context, 30, isMobile: true),
              const SizedBox(height: 8),
              _buildDurationOption(context, 90, isMobile: true),
              const SizedBox(height: 8),
              _buildDurationOption(context, 180, isMobile: true),
              const SizedBox(height: 8),
              _buildDurationOption(context, 365, isMobile: true),
            ] else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildDurationOption(context, 7),
                  _buildDurationOption(context, 14),
                  _buildDurationOption(context, 30),
                  _buildDurationOption(context, 90),
                  _buildDurationOption(context, 180),
                  _buildDurationOption(context, 365),
                ],
              ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              padding: EdgeInsets.all(isMobile ? 10 : 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: isMobile ? 14 : 16,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Duration: ${state.duration} days (${(state.duration / 30).toStringAsFixed(1)} months)",
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 11 : 12,
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateRangeSection(BuildContext context, {bool isMobile = false}) {
    return BlocBuilder<AssignPlanCubit, AssignPlanState>(
      buildWhen: (previous, current) =>
          previous.redeemStartAt != current.redeemStartAt ||
          previous.redeemEndAt != current.redeemEndAt,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    CupertinoIcons.calendar_today,
                    size: 16,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Date Range *",
                  style: AppTextStyles.textFieldTitle.copyWith(
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              "Set specific start and end dates for this plan",
              style: GoogleFonts.inter(
                fontSize: isMobile ? 11 : 12,
                color: AppColors.slateGray,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            // Start Date
            _buildDatePicker(
              context,
              label: 'Start Date',
              date: state.redeemStartAt,
              icon: CupertinoIcons.calendar_badge_plus,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.redeemStartAt ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  context.read<AssignPlanCubit>().updateRedeemStartAt(date);
                }
              },
              isMobile: isMobile,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            // End Date
            _buildDatePicker(
              context,
              label: 'End Date',
              date: state.redeemEndAt,
              icon: CupertinoIcons.calendar_badge_minus,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate:
                      state.redeemEndAt ??
                      (state.redeemStartAt ?? DateTime.now()).add(
                        Duration(days: state.duration),
                      ),
                  firstDate: state.redeemStartAt ?? DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  context.read<AssignPlanCubit>().updateRedeemEndAt(date);
                }
              },
              isMobile: isMobile,
            ),
            if (state.redeemStartAt != null && state.redeemEndAt != null) ...[
              SizedBox(height: isMobile ? 12 : 16),
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.info_circle_fill,
                      size: isMobile ? 14 : 16,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Date range set: ${state.redeemStartAt!.day}/${state.redeemStartAt!.month}/${state.redeemStartAt!.year} to ${state.redeemEndAt!.day}/${state.redeemEndAt!.month}/${state.redeemEndAt!.year}",
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 11 : 12,
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required IconData icon,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    final dateText = date != null
        ? '${date.day}/${date.month}/${date.year}'
        : 'Select date';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: date != null ? AppColors.primary : AppColors.blueGreyBorder,
            width: date != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: date != null
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: isMobile ? 18 : 20,
              color: date != null ? AppColors.primary : AppColors.slateGray,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 11 : 12,
                      color: AppColors.slateGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateText,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: date != null ? Colors.black : AppColors.slateGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: isMobile ? 16 : 18,
              color: AppColors.slateGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationOption(
    BuildContext context,
    int days, {
    bool isMobile = false,
  }) {
    return BlocBuilder<AssignPlanCubit, AssignPlanState>(
      buildWhen: (previous, current) => previous.duration != current.duration,
      builder: (context, state) {
        final isSelected = state.duration == days;
        final label = days == 7
            ? '7 Days'
            : days == 14
            ? '14 Days'
            : days == 30
            ? '1 Month'
            : days == 90
            ? '3 Months'
            : days == 180
            ? '6 Months'
            : '1 Year';

        return InkWell(
          onTap: () => context.read<AssignPlanCubit>().updateDuration(days),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: isMobile ? double.infinity : null,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 20,
              vertical: isMobile ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.amber.withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.amber : AppColors.blueGreyBorder,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Icon(
                  isSelected
                      ? CupertinoIcons.check_mark_circled_solid
                      : CupertinoIcons.circle,
                  color: isSelected ? Colors.amber : AppColors.slateGray,
                  size: isMobile ? 16 : 18,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.amber.shade900 : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, {bool isMobile = false}) {
    return BlocBuilder<AssignPlanCubit, AssignPlanState>(
      buildWhen: (previous, current) =>
          previous.canAssign != current.canAssign ||
          previous.isAssigning != current.isAssigning,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.borderGrey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: isMobile ? 44 : 48,
                  child: OutlinedButton(
                    onPressed: state.isAssigning
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.slateGray.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.inter(
                        color: AppColors.slateGray,
                        fontSize: isMobile ? 13 : 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: isMobile ? 44 : 48,
                  child: ElevatedButton(
                    onPressed: state.canAssign
                        ? () async {
                            final planId = await context
                                .read<AssignPlanCubit>()
                                .assignPlanToClient(
                                  clientId: clientId,
                                  clientName: clientName,
                                  email: clientEmail,
                                  assignedBy: assignedBy,
                                );
                            if (planId != null) {
                              onAssignmentComplete(planId);
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.slateGray.withOpacity(
                        0.2,
                      ),
                    ),
                    child: state.isAssigning
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.gift_fill,
                                size: isMobile ? 16 : 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Assign Plan",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isMobile ? 13 : 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
