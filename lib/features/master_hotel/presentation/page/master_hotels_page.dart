import 'package:flutter/widgets.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';

class MasterHotelsPage extends StatelessWidget {
  const MasterHotelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          heading: "Hotel Masters",
          subHeading: "Manage hotel franchises and their master tasks",
          buttonText: "Add Hotel Master",
          onButtonPressed: () {},
        ),
      ],
    );
  }
}
