import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/susbcription_cubit.dart';

class HotelSubscriptionAssignmentDialog extends StatefulWidget {
  final HotelModel hotel;
  final String clientName;
  final String clientEmail;
  final Function(String purchaseId) onAssignmentComplete;

  const HotelSubscriptionAssignmentDialog({
    super.key,
    required this.hotel,
    required this.clientName,
    required this.clientEmail,
    required this.onAssignmentComplete,
  });

  @override
  State<HotelSubscriptionAssignmentDialog> createState() =>
      _HotelSubscriptionAssignmentDialogState();
}

class _HotelSubscriptionAssignmentDialogState
    extends State<HotelSubscriptionAssignmentDialog> {
  SubscriptionPlanModel? selectedPlan;
  String selectedBillingCycle = 'monthly';
  String selectedPaymentMethod = 'card';
  bool isAssigning = false;

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().loadSubscriptionPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: ResponsiveCustomBuilder(
        mobileBuilder: (width) => _buildMobileLayout(),
        tabletBuilder: (width) => _buildTabletLayout(),
        desktopBuilder: (width) => _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHeader(isMobile: true),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHotelInfoSection(isMobile: true),
                const SizedBox(height: 20),
                _buildPlanSelector(isMobile: true),
                const SizedBox(height: 20),
                _buildBillingCycleSection(isMobile: true),
                const SizedBox(height: 20),
                _buildPaymentMethodSection(isMobile: true),
              ],
            ),
          ),
        ),
        _buildActionButtons(isMobile: true),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHotelInfoSection(),
                const SizedBox(height: 24),
                _buildPlanSelector(),
                const SizedBox(height: 24),
                _buildBillingCycleSection(),
                const SizedBox(height: 24),
                _buildPaymentMethodSection(),
              ],
            ),
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHotelInfoSection(),
                  const SizedBox(height: 28),
                  _buildPlanSelector(),
                  const SizedBox(height: 28),
                  _buildBillingCycleSection(),
                  const SizedBox(height: 28),
                  _buildPaymentMethodSection(),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader({bool isMobile = false}) {
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
              CupertinoIcons.doc_text_fill,
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
                  "Assign Subscription Plan",
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Select a subscription plan for this hotel",
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

  Widget _buildHotelInfoSection({bool isMobile = false}) {
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
                CupertinoIcons.building_2_fill,
                size: 16,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Hotel Information",
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
                icon: CupertinoIcons.building_2_fill,
                label: "Hotel",
                value: widget.hotel.name,
                isMobile: isMobile,
              ),
              SizedBox(height: isMobile ? 8 : 12),
              _buildInfoRow(
                icon: CupertinoIcons.person_fill,
                label: "Client",
                value: widget.clientName,
                isMobile: isMobile,
              ),
              SizedBox(height: isMobile ? 8 : 12),
              _buildInfoRow(
                icon: CupertinoIcons.mail_solid,
                label: "Email",
                value: widget.clientEmail,
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

  Widget _buildPlanSelector({bool isMobile = false}) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final activePlans = state.subscriptionPlans
            .where((plan) => plan.isActive)
            .toList();

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
                    CupertinoIcons.star_fill,
                    size: 16,
                    color: Colors.purple.shade700,
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
                  value: selectedPlan,
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
                  items: activePlans.map((plan) {
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
                    setState(() {
                      selectedPlan = plan;
                    });
                  },
                ),
              ),
            ),
            if (selectedPlan != null) ...[
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
                          "Rooms: ${selectedPlan!.minRooms} - ${selectedPlan!.maxRooms}",
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
                            "Monthly: \$${selectedPlan!.price['monthly']?.toStringAsFixed(2)} | Yearly: \$${selectedPlan!.price['yearly']?.toStringAsFixed(2)}",
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

  Widget _buildBillingCycleSection({bool isMobile = false}) {
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
                CupertinoIcons.calendar,
                size: 16,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Billing Cycle *",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 8 : 12),
        if (isMobile) ...[
          _buildBillingOption('monthly', isMobile: true),
          const SizedBox(height: 8),
          _buildBillingOption('yearly', isMobile: true),
        ] else
          Row(
            children: [
              Expanded(child: _buildBillingOption('monthly')),
              const SizedBox(width: 12),
              Expanded(child: _buildBillingOption('yearly')),
            ],
          ),
      ],
    );
  }

  Widget _buildBillingOption(String cycle, {bool isMobile = false}) {
    final isSelected = selectedBillingCycle == cycle;
    final price = selectedPlan?.price[cycle];
    final label = cycle == 'monthly' ? 'Monthly' : 'Yearly';
    final period = cycle == 'monthly' ? 'month' : 'year';

    return InkWell(
      onTap: () => setState(() => selectedBillingCycle = cycle),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.blueGreyBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              color: isSelected ? AppColors.primary : AppColors.slateGray,
              size: isMobile ? 18 : 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : Colors.black,
                    ),
                  ),
                  if (price != null)
                    Text(
                      "\$${price.toStringAsFixed(2)}/$period",
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 11 : 12,
                        color: AppColors.slateGray,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.creditcard_fill,
                size: 16,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Payment Method *",
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
            child: DropdownButton<String>(
              value: selectedPaymentMethod,
              isExpanded: true,
              items: [
                _buildPaymentMethodItem(
                  'card',
                  'Credit/Debit Card',
                  CupertinoIcons.creditcard,
                  isMobile,
                ),
                _buildPaymentMethodItem(
                  'upi',
                  'UPI',
                  CupertinoIcons.device_phone_portrait,
                  isMobile,
                ),
                _buildPaymentMethodItem(
                  'bank_transfer',
                  'Bank Transfer',
                  CupertinoIcons.building_2_fill,
                  isMobile,
                ),
                _buildPaymentMethodItem(
                  'cash',
                  'Cash',
                  CupertinoIcons.money_dollar,
                  isMobile,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildPaymentMethodItem(
    String value,
    String label,
    IconData icon,
    bool isMobile,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: isMobile ? 16 : 18, color: AppColors.slateGray),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.inter(fontSize: isMobile ? 13 : 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons({bool isMobile = false}) {
    final canAssign = selectedPlan != null && !isAssigning;
    final amount = selectedPlan?.price[selectedBillingCycle] ?? 0.0;

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
                onPressed: isAssigning
                    ? null
                    : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.slateGray.withOpacity(0.3)),
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
                onPressed: canAssign ? _assignSubscription : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.slateGray.withOpacity(0.2),
                ),
                child: isAssigning
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
                    : Text(
                        "Assign (\$${amount.toStringAsFixed(2)})",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 13 : 14,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _assignSubscription() async {
    if (selectedPlan == null) return;

    setState(() {
      isAssigning = true;
    });

    try {
      final subscriptionRepo = context
          .read<SubscriptionCubit>()
          .subscriptionRepo;

      final purchaseId = await subscriptionRepo.assignSubscriptionToHotel(
        hotelId: widget.hotel.docId,
        hotelName: widget.hotel.name,
        clientId: widget.hotel.clientId,
        email: widget.clientEmail,
        subscriptionPlan: selectedPlan!,
        billingCycle: selectedBillingCycle,
        paymentMethod: selectedPaymentMethod,
      );

      widget.onAssignmentComplete(purchaseId);

      if (mounted) {
        Navigator.of(context).pop();
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
                  "Subscription assigned successfully!",
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
      }
    } catch (e) {
      if (mounted) {
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
                    "Failed to assign subscription: ${e.toString()}",
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
      }
    } finally {
      if (mounted) {
        setState(() {
          isAssigning = false;
        });
      }
    }
  }
}
