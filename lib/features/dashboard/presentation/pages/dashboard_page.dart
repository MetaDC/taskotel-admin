import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          // Stats Cards Grid
          StaggeredGrid.extent(
            maxCrossAxisExtent: 400,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              StatCardIconRight(
                icon: CupertinoIcons.person_2,
                label: "Active Subscriptions",
                value: "2,847",
                iconColor: Colors.blue,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.money_dollar,
                label: "Total Revenue",
                value: "\$742,580",
                iconColor: Colors.green,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.building_2_fill,
                label: "Total Master Hotels",
                value: "1,234",
                iconColor: Colors.teal,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.cube_box,
                label: "Total Subscription Plans",
                value: "4",
                iconColor: Colors.orange,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.star_fill,
                label: "Top Selling Plan",
                value: "Premium",
                iconColor: Colors.amber,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Revenue Overview - Use regular Container instead of StaggeredGridTile
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Revenue Overview",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Monthly revenue performance",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(child: Text("Revenue Chart Here")),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Unsubscribed / Not Renewed - Use regular Container instead of StaggeredGridTile
          CustomContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Unsubscribed / Not Renewed",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Clients who registered but haven't subscribed or renewed",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                        softWrap: true,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "147 clients",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Lost clients this month",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text("View All")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
