import 'package:hive/hive.dart';
part 'commande.g.dart';

@HiveType(typeId: 2)
class Comnd {
  @HiveField(1)
  final double frequence;

  @HiveField(2)
  final double tensionMax;

  @HiveField(3)
  final double tmpDeCycle;

  @HiveField(4)
  final int vitesse;

  @HiveField(5)
  final int nbrDeCommande;

  Comnd(this.frequence, this.tensionMax, this.tmpDeCycle, this.vitesse,
      this.nbrDeCommande);
}
