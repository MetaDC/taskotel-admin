import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';

import 'package:taskoteladmin/core/widget/page_header.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          heading: 'Clients',
          subHeading: 'Manage your clients',
          buttonText: 'Add Client',
          onButtonPressed: () {
            // Handle button press
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.group,
                label: 'Total Clients',
                value: '2,847',
                iconColor: Colors.blue,
                iconPosition: StatCardIconPosition.left,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                icon: Icons.group,
                label: 'Total Clients',
                value: '2,847',
                iconColor: Colors.blue,
                iconPosition: StatCardIconPosition.left,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                icon: Icons.group,
                label: 'Total Clients',
                value: '2,847',
                iconColor: Colors.blue,
                iconPosition: StatCardIconPosition.left,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                icon: Icons.group,
                label: 'Total Clients',
                value: '2,847',
                iconColor: Colors.blue,
                iconPosition: StatCardIconPosition.left,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
