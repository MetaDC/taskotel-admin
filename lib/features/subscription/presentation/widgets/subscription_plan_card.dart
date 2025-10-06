import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  CupertinoIcons.ellipsis,
                  color: AppColors.primary,
                  size: 20,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.pencil, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.delete,
                          size: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: GoogleFonts.inter(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // const SizedBox(height: 5),

          // Price
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  children: [
                    TextSpan(
                      text: "\$",
                      style: GoogleFonts.inter(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    TextSpan(
                      text: plan.price['monthly']?.toStringAsFixed(0) ?? '0',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: " /month",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.slateGray,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const SizedBox(height: 8),

          // Description
          Text(
            plan.desc,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray),
          ),
          const SizedBox(height: 24),

          // Metrics Row
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "${plan.totalSubScribers}",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    // const SizedBox(height: 4),
                    Text(
                      "Subscribers",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.slateGray,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "\$${plan.totalRevenue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    // const SizedBox(height: 4),
                    Text(
                      "Revenue",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.slateGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Features
          Row(
            children: [
              Icon(
                CupertinoIcons.checkmark_alt,
                size: 17,
                color: Color(0xff35c662),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Up to ${plan.maxRooms} rooms per hotels",
                  style: GoogleFonts.inter(
                    fontSize: 13.8,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ...plan.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.checkmark_alt,
                    size: 17,
                    color: Color(0xff35c662),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: GoogleFonts.inter(
                        fontSize: 13.8,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: plan.isActive
                  ? Color(0xff35c662).withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: plan.isActive ? Color(0xff35c662) : Colors.red,
                width: .7,
              ),
            ),
            child: Text(
              plan.isActive ? "Active" : "Inactive",
              style: GoogleFonts.inter(
                color: plan.isActive ? Color(0xff35c662) : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFeatureIcon(String feature) {
    // Define which features are included vs excluded
    final includedFeatures = [
      "Up to ${plan.minRooms} Hotels",
      "Basic Reporting",
      "Email Support",
      "Mobile App Access",
    ];

    if (_isFeatureIncluded(feature)) {
      return CupertinoIcons.checkmark;
    } else {
      return CupertinoIcons.xmark;
    }
  }

  bool _isFeatureIncluded(String feature) {
    // This should be based on your plan tier logic
    // For now, assuming first 4 features are included for basic plans
    final includedFeatures = [
      "Up to 2 Hotels",
      "Basic Reporting",
      "Email Support",
      "Mobile App Access",
    ];

    return includedFeatures.any(
      (included) => feature.toLowerCase().contains(included.toLowerCase()),
    );
  }
}

// Alternative version with more customization based on plan type
class EnhancedSubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EnhancedSubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Price
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "\$${plan.price['monthly']?.toInt() ?? 0}",
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: " /month",
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              plan.desc,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Metrics
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "${plan.totalSubScribers}",
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Subscribers",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "\$${_formatNumber(plan.totalRevenue)}",
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Revenue",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Features
            ...plan.features.asMap().entries.map((entry) {
              final index = entry.key;
              final feature = entry.value;
              final isIncluded = _isFeatureIncluded(index, plan.title);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      isIncluded ? Icons.check : Icons.close,
                      size: 16,
                      color: isIncluded ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isIncluded ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Active",
                style: GoogleFonts.inter(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(0)}k";
    }
    return number.toStringAsFixed(0);
  }

  bool _isFeatureIncluded(int index, String planTitle) {
    // Define feature inclusion logic based on plan type
    switch (planTitle.toLowerCase()) {
      case 'basic':
        return index < 4; // First 4 features included
      case 'standard':
        return index < 6; // First 6 features included
      case 'premium':
        return index < 7; // First 7 features included
      case 'enterprise':
        return true; // All features included
      default:
        return index < 3;
    }
  }
}
