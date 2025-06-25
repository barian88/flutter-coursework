import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../themes/colors.dart';

class AccuracyRateChart extends StatefulWidget {
  const AccuracyRateChart({super.key});

  @override
  State<AccuracyRateChart> createState() => _AccuracyRateChartState();
}

class _AccuracyRateChartState extends State<AccuracyRateChart> {
  static const maxX = 4.0; // 最大 X 值
  static const maxY = 4.0; // 最大 Y 值
  static const dataLength = 6; // 数据点数量

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 270,
      child: LineChart(mainData()),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: AppColors.grey1,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('', style: style);
        break;
      case 1:
        text = Text('', style: style);
        break;
      case 2:
        text = Text('', style: style);
        break;
      case 3:
        text = Text('', style: style);
        break;
      case 4:
        text = Text('Latest', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    final isLast = value == meta.max;

    return SideTitleWidget(
      meta: meta,
      child: Padding(
        padding: EdgeInsets.only(right: isLast ? 48 : 0), // 给最后一个标签加右 padding
        child: text,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: AppColors.grey1,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 1:
        text = '25%';
        break;
      case 2:
        text = '50%';
        break;
      case 3:
        text = '75%';
        break;
      case 4:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.primaryContainer,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.grey1, width: 1.5),
        ),
      ),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(1, 1.7),
            FlSpot(2.6, 2),
            FlSpot(4, 3.2),
            FlSpot(0, 3.1),
            FlSpot(1.8, 2),
            FlSpot(3.5, 3),
            FlSpot(3, 4),
          ]..sort((a, b) => a.x.compareTo(b.x)),
          isCurved: true,
          color: AppColors.bluePurple,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (_, _, _, index) {
              final isLast = (index == dataLength);

              if (isLast) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: Theme.of(context).colorScheme.secondary,
                  strokeWidth: 3.5,
                  // strokeColor: Theme.of(context).colorScheme.primary,
                  strokeColor: AppColors.bluePurple,
                );
              } else {
                return FlDotCirclePainter(radius: 0);
              }
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.bluePurple.withValues(alpha: 0.5),
                AppColors.bluePurple.withValues(alpha: 0.2),
                AppColors.bluePurple.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
