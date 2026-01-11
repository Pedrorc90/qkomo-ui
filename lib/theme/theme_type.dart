import 'package:hive/hive.dart';

part 'theme_type.g.dart';

@HiveType(typeId: 10)
enum AppThemeType {
  @HiveField(0)
  forest, // Natural forest green
  @HiveField(1)
  dark, // Dark blue for night mode
}
