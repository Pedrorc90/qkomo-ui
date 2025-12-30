import 'package:hive/hive.dart';

part 'theme_type.g.dart';

@HiveType(typeId: 10)
enum AppThemeType {
  @HiveField(0)
  warm, // Naranja cálido e invitador
  @HiveField(1)
  offWhite, // Gris minimalista neutral
  @HiveField(2)
  dark, // Azul oscuro para modo noche
  @HiveField(3)
  forest, // Verde bosque natural
  @HiveField(4)
  indigo, // Índigo profundo y elegante
}
