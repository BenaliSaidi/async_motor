import 'package:hive/hive.dart';
part 'config.g.dart';

@HiveType(typeId: 1)
class Config {
  @HiveField(1)
  final String name;

  @HiveField(2)
  final int tension;

  @HiveField(3)
  final int frequence;

  @HiveField(4)
  final int vitesse;

  @HiveField(5)
  final int pole;

  @HiveField(6)
  final String couplage;

  Config(this.name, this.tension, this.frequence, this.vitesse, this.pole,
      this.couplage);
}
