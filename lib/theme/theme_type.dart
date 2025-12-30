import 'package:hive/hive.dart';

part 'theme_type.g.dart';

@HiveType(typeId: 10)
enum AppThemeType {
  @HiveField(0)
  warm, // Warm and inviting orange
  @HiveField(1)
  offWhite, // Neutral minimalist gray
  @HiveField(2)
  dark, // Dark blue for night mode
  @HiveField(3)
  forest, // Natural forest green
  @HiveField(4)
  indigo, // Deep and elegant indigo
}
