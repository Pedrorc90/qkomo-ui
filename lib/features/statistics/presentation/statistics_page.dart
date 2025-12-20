import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qkomo_ui/core/widgets/qkomo_navbar.dart';
import 'package:qkomo_ui/features/statistics/application/statistics_controller.dart';
import 'package:qkomo_ui/features/statistics/presentation/widgets/entries_bar_chart.dart';
import 'package:qkomo_ui/features/statistics/presentation/widgets/ingredients_pie_chart.dart';
import 'package:qkomo_ui/features/statistics/presentation/widgets/summary_card.dart';
import 'package:qkomo_ui/theme/app_colors.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statisticsControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const QkomoNavBar(),
      body: state.when(
        data: (data) {
          if (data.totalEntries == 0) {
            return const Center(
              child:
                  Text('No hay datos suficientes para mostrar estadísticas.'),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(statisticsControllerProvider.notifier).refresh(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Entradas',
                          value: data.totalEntries.toString(),
                          icon: Icons.restaurant_menu,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Racha Actual',
                          value: '${data.currentStreak} días',
                          icon: Icons.local_fire_department,
                          color: AppColors.semanticError,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  EntriesBarChart(entriesPerDay: data.entriesPerDay),
                  const SizedBox(height: 24),
                  IngredientsPieChart(topIngredients: data.topIngredients),
                  const SizedBox(height: 24),
                  // Allergen summary could go here
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
