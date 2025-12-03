import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IngredientsPieChart extends StatefulWidget {
  const IngredientsPieChart({super.key, required this.topIngredients});

  final Map<String, int> topIngredients;

  @override
  State<IngredientsPieChart> createState() => _IngredientsPieChartState();
}

class _IngredientsPieChartState extends State<IngredientsPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.topIngredients.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedEntries = widget.topIngredients.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Colors for the pie sections
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Ingredientes más comunes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: List.generate(sortedEntries.length, (i) {
                            final isTouched = i == touchedIndex;
                            final fontSize = isTouched ? 25.0 : 16.0;
                            final radius = isTouched ? 60.0 : 50.0;
                            final entry = sortedEntries[i];

                            return PieChartSectionData(
                              color: colors[i % colors.length],
                              value: entry.value.toDouble(),
                              title: '${entry.value}',
                              radius: radius,
                              titleStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(sortedEntries.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors[i % colors.length],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                sortedEntries[i].key,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
