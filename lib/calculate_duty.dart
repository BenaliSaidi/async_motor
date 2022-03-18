// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_print

import 'dart:math' as math;

import 'package:flutter/foundation.dart';

void main() {}

/// Print Long String
void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((RegExpMatch match) => print(match.group(0)));
}

String duty(int speed, int vitesse, int frequence, int tension) {
  var coif = speed / vitesse;
  var Desired_tension = tension * coif;
  var Desired_frequence = frequence * coif;

  List<int> List_PDC_1 = [];
  List<int> List_PDC_2 = [];
  List<int> List_PDC_3 = [];

  String pdc;

  double V_as = 0;
  double V_bs = 0;
  double V_cs = 0;

  double Pdc_1 = 0;
  double Pdc_2 = 0;
  double Pdc_3 = 0;

  int Pdc_1_To_num = 0;
  int Pdc_2_To_num = 0;
  int Pdc_3_To_num = 0;

  int counter = 0;

  var double_tension = Desired_tension * 2;
  int frequence_PWM = 16000;
  double degre = 0;
  double step = (360 * Desired_frequence) / frequence_PWM;
  var stopwatch = Stopwatch()..start();
  stopwatch.isRunning;
  for (degre = 0; degre < 360; degre = degre + step) {
    counter++;

    double rad_paas = degre * (math.pi / 180);
    double sintheta = math.sin(rad_paas);
    double costheta = math.cos(rad_paas);

    var vAlpha = Desired_tension * sintheta;
    var vBeta = Desired_tension * costheta;

    V_as = vAlpha;
    // V_bs = (-vAlpha / 2) + vBeta * (math.sqrt(3) / 2);
    // V_cs = (-vAlpha / 2) - vBeta * (math.sqrt(3) / 2);

    Pdc_1 = (V_as + Desired_tension) / double_tension;
    // Pdc_2 = (V_bs + Desired_tension) / double_tension; //%
    // Pdc_3 = (V_cs + Desired_tension) / double_tension;

    Pdc_1_To_num = (Pdc_1 * 1024).round();
    // Pdc_2_To_num = (Pdc_2 * 1024).round();
    // Pdc_3_To_num = (Pdc_3 * 1024).round();

    List_PDC_1.add(Pdc_1_To_num);
    // List_PDC_2.add(Pdc_2_To_num);
    // List_PDC_3.add(Pdc_3_To_num);

  }

  pdc = List_PDC_1.join(',');

  print('commande num : ' + counter.toString());
  stopwatch.stop();
  print(' time of cal : ${stopwatch.elapsedMicroseconds}');
  print('frequnce : ' + Desired_frequence.toString());
  print(' tension : ' + Desired_tension.toString());

  printLongString('duty : ' + pdc);
  return pdc;
}
