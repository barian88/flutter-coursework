import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/themes/themes.dart';

class ErrorDistributionChart extends StatefulWidget {
  const ErrorDistributionChart({super.key});

  @override
  State<StatefulWidget> createState() => ErrorDistributionChartState();
}

class ErrorDistributionChartState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          startDegreeOffset: 180,
          sectionsSpace: 2,
          centerSpaceRadius: 0,
          sections: showingSections(colorScheme),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(ColorScheme colorScheme) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final color0 = colorScheme.primary;
      final color1 = colorScheme.secondary;
      final color2 = colorScheme.red;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: color0,
            value: 42,
            title: isTouched ? '25%' : '',
            radius: 70,
            titlePositionPercentageOffset: 0.55,
          );
        case 1:
          return PieChartSectionData(
            color: color1,
            value: 33,
            title: '',
            radius: 65,
            titlePositionPercentageOffset: 0.55,
          );
        case 2:
          return PieChartSectionData(
            color: color2,
            value: 25,
            title: '',
            radius: 60,
            titlePositionPercentageOffset: 0.6,
          );
        default:
          throw Error();
      }
    });
  }
}
