import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';

enum StatCardIconPosition { left, right }

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value; // use String so we can format like "2,847"
  final Color iconColor;
  final Color backgroundColor;
  final StatCardIconPosition iconPosition;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.iconPosition = StatCardIconPosition.left,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );

    return CustomContainer(
      child: Row(
        children: iconPosition == StatCardIconPosition.left
            ? [iconWidget, const SizedBox(width: 15), textWidget]
            : [textWidget, const SizedBox(width: 15), iconWidget],
      ),
    );
  }
}
