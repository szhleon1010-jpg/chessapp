import 'dart:math' as math;

import 'package:chessapp/widgets/GameData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartSample2 extends StatefulWidget {
  final List<GameData> gameData;
  const LineChartSample2({super.key, required this.gameData});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.greenAccent, Colors.green
  ];
  late int lowestRating = 5000;
  late int highestRating = 100;

  List<FlSpot> ratingPoints(){
    List<FlSpot> points = [];
    DateTime oldest  = widget.gameData [widget.gameData.length -1 ].date.toDate();
    for(int i = widget.gameData.length - 1; i >= 0; i -= 1){
      GameData game = widget.gameData [i];
      lowestRating = math.min(lowestRating, game.rating);
      highestRating = math.max(highestRating, game.rating);

      DateTime date =  game.date.toDate();
      double x = ((date.year - oldest.year)*12+date.month - 1) + (date.day / 30.0);
      double y = game.rating.toDouble();
      points.add(FlSpot(x, y));
      print("$x, $y");
    }

    return points;
  }
  int monthRange(){
    GameData recent = widget.gameData [0];
    GameData oldest  = widget.gameData [widget.gameData.length -1 ];
    int years = recent.date.toDate().year - oldest.date.toDate().year;
    int months = ((years + 1 )*12);
    return months;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
       Text(
          'rating',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    final dateTime = DateTime(2000, value.toInt(), 1);
    final abbreviation = DateFormat('MMM').format(dateTime);
    String text = (value % 3 == 0) ? abbreviation : "";
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = "";
    if(value == lowestRating){
      text = lowestRating.toString();
    } else if (value == highestRating) {
      text = highestRating.toString();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 3,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.cyan,
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.cyan,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
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
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: monthRange().toDouble(),
      minY: lowestRating.toDouble(),
      maxY: highestRating.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: ratingPoints(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }


}