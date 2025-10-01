import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';

// ============================================
// TABLE CONFIGURATION CLASS
// ============================================
class TableConfig {
  // Standard row padding
  static const EdgeInsets rowPadding = EdgeInsets.symmetric(vertical: 15.0);
  static const EdgeInsets transactionRowPadding = EdgeInsets.all(16);

  // Standard spacing
  static const double horizontalSpacing = 30.0;
  static const double iconSpacing = 4.0;
  static const double verticalSpacing = 3.0;

  // Icon sizes
  static const double smallIconSize = 15.0;
  static const double mediumIconSize = 20.0;

  // Action column widths
  static const double viewColumnWidth = 100.0;
  static const double actionColumnWidth = 50.0;

  // Border decoration
  static BoxDecoration getRowBorder() {
    return BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
    );
  }
}

class TableIconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const TableIconTextRow({Key? key, required this.icon, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: TableConfig.smallIconSize, color: AppColors.slateGray),
        SizedBox(width: TableConfig.iconSpacing),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.tableRowNormal,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Widget for displaying two-line content (primary + secondary)
class TableTwoLineContent extends StatelessWidget {
  final String primaryText;
  final String secondaryText;

  const TableTwoLineContent({
    Key? key,
    required this.primaryText,
    required this.secondaryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(primaryText, style: AppTextStyles.tableRowPrimary),
        Text(secondaryText, style: AppTextStyles.tableRowSecondary),
      ],
    );
  }
}

// Widget for icon + number + label (e.g., "5 clients", "12 tasks")
class TableIconCountLabel extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const TableIconCountLabel({
    Key? key,
    required this.icon,
    required this.count,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: TableConfig.smallIconSize, color: AppColors.slateGray),
        SizedBox(width: 5),
        Text(count.toString(), style: AppTextStyles.tableRowPrimary),
        SizedBox(width: 5),
        Text(label, style: AppTextStyles.tableRowRegular),
      ],
    );
  }
}

// Widget for action buttons
class TableActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const TableActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: TableConfig.mediumIconSize,
        color: color ?? AppColors.textBlackColor,
      ),
      onPressed: onPressed,
    );
  }
}
