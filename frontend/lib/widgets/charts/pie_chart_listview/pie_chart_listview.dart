import 'package:flutter/material.dart';
import 'package:frontend/themes/themes.dart';
import 'package:gap/gap.dart';
import 'pie_chart_item.dart';
import 'error_distribution_chart.dart';

class PieChartListview extends StatefulWidget {
  const PieChartListview({super.key});

  @override
  State<PieChartListview> createState() => _PieChartListviewState();
}

class _PieChartListviewState extends State<PieChartListview> {

  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    // 容器的高度定义为了200，根据此定义半径
    final List<PieChartItem> pieChartItemsByType = [
      PieChartItem(
        title: 'Truth Table',
        value: 42,
        color: colorScheme.primary,
        radius: 90,
      ),
      PieChartItem(
        title: 'Equivalence',
        value: 33,
        color: colorScheme.secondary,
        radius: 80,
      ),
      PieChartItem(
        title: 'Validity',
        value: 25,
        color: colorScheme.blue,
        radius: 75,
      ),
    ];
    final List<PieChartItem> pieChartItemsByDifficulty = [
      PieChartItem(
        title: 'simple',
        value: 12,
        color: colorScheme.green,
        radius: 80,
      ),
      PieChartItem(
        title: 'medium',
        value: 35,
        color: colorScheme.secondary,
        radius: 90,
      ),
      PieChartItem(
        title: 'hard',
        value: 53,
        color: colorScheme.red,
        radius: 75,
      ),
    ];

    List <Widget> pages = [
      ErrorDistributionChart(pieChartItems: pieChartItemsByType),
      ErrorDistributionChart(pieChartItems: pieChartItemsByDifficulty),
    ];

    return Column(
      children: [
        // 横向 PageView（和 ListView.builder 类似）
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Card(elevation: 1, child: pages[index]);
            },
          ),
        ),
        Gap(10),
        // 底部圆点指示器
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pages.length, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: isActive ? 10 : 6,
              height: isActive ? 10 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isActive
                        ? colorScheme.primary
                        : Colors.grey.withAlpha(128),
              ),
            );
          }),
        ),
      ],
    );
  }
}
