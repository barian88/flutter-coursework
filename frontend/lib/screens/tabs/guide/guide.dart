import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'widgets/widgets.dart';
import 'models/models.dart';
import '../../../widgets/widgets.dart';


class Guide extends StatelessWidget {
  const Guide({super.key});

  @override
  Widget build(BuildContext context) {

    final guideList = [
      GuideItem(
        title: "Getting Started",
        description: "Learn how to use the app effectively.",
        imageUrl: "assets/images/guide/guide.png",
      ),
      GuideItem(
        title: "Quiz Features",
        description: "Explore the various quiz features available.",
        imageUrl: "assets/images/guide/guide.png",
      ),
      GuideItem(
        title: "Performance Tracking",
        description: "Understand how to track your performance.",
        imageUrl: "assets/images/guide/guide.png",
      ),
      GuideItem(
        title: "Getting Started",
        description: "Learn how to use the app effectively.",
        imageUrl: "assets/images/guide/guide.png",
      ),
      GuideItem(
        title: "Quiz Features",
        description: "Explore the various quiz features available.",
        imageUrl: "assets/images/guide/guide.png",
      ),
      GuideItem(
        title: "Performance Tracking",
        description: "Understand how to track your performance.",
        imageUrl: "assets/images/guide/guide.png",
      ),
    ];

    final displayList = List.generate(guideList.length, (index){
      final item = guideList[index];
      return Column(
        children: [
          GuideDisplay(guideItem: item),
          Gap(30),
        ],
      );
    });

    return BaseContainer(child: Column(children: displayList,));
  }
}
