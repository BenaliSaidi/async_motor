// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ffi';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:async_motor/home.dart';
import 'package:async_motor/model/commande.dart';
//import 'package:async_motor/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:async_motor/calculate_duty.dart';
import 'package:web_socket_channel/io.dart';

// ignore: prefer_typing_uninitialized_variables
var configMotor;
var commandMotor;
bool commande = true;
String? speedy;
var message;
bool? status = false;

getFrequence(String duty) {
  double cmdNmbr = (duty.length / 4);
  double fre = 16000 / cmdNmbr;
  return fre;
}

getdutyForGraph(String duty) {
  int timeCycle = (1 / (0.001 * getFrequence(duty))).round();
  return timeCycle;
}

getIndex(String myValue) {
  configMotor = Hive.box('config').get(myValue);
}

addToCmd(String key, Comnd commande) {
  Hive.box('commande').put(key, commande);
}

getConfig(myValue) {
  commandMotor = Hive.box('commande').get(myValue);
}

checkCmd(String myValue) {
  commande = Hive.box('commande').containsKey(myValue);

  return commande;
}

getTension_100() {
  String tension_100 = commandMotor.tensionMax.toString();
  return tension_100;
}

getTension_50() {
  String tension_50 =
      double.parse(((commandMotor.tensionMax) * 0.5).toStringAsFixed(2))
          .toString();
  return tension_50;
}

getMinTension_100() {
  String minTension_100 =
      double.parse(((commandMotor.tensionMax) * (-1)).toStringAsFixed(2))
          .toString();
  return minTension_100;
}

getMinTension_50() {
  String minTension_50 =
      double.parse(((commandMotor.tensionMax) * 0.5 * (-1)).toStringAsFixed(2))
          .toString();
  return minTension_50;
}

getCycle_100() {
  String cycle_100 = commandMotor.tmpDeCycle.toString();
  return cycle_100;
}

getCycle_75() {
  String cycle_75 =
      double.parse(((commandMotor.tmpDeCycle) * 0.75).toStringAsFixed(2))
          .toString();
  return cycle_75;
}

getCycle_50() {
  String cycle_50 =
      double.parse(((commandMotor.tmpDeCycle) * 0.5).toStringAsFixed(2))
          .toString();

  return cycle_50;
}

getCycle_25() {
  String cycle_25 =
      double.parse(((commandMotor.tmpDeCycle) * 0.25).toStringAsFixed(2))
          .toString();
  return cycle_25;
}

class Commande extends StatefulWidget {
  //const Commande({Key? key}) : super(key: key);
  final String? myValue;
  Commande({this.myValue});

  @override

  // ignore: no_logic_in_create_state
  State<Commande> createState() => _CommandeState(myValue: myValue);
}

class _CommandeState extends State<Commande> {
  String? myValue;
  _CommandeState({this.myValue});
  IOWebSocketChannel? channel;

  void initState() {
    //initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel!.stream.listen(
        (message) {
          print(message);
          status = true;
          setState(() {});
        },
        onDone: () {
          //if WebSocket is disconnected

          print("Web socket is closed");
          status = false;
          setState(() {});
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    channel!.sink.add(cmd); //sending Command to NodeMCU
    print("app : commande envoyée");
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    getIndex(myValue!);
    getConfig(myValue);

    int dutyGraph;
    //String name = configMotor.name;
    int tension = configMotor.tension;
    int frequence = configMotor.frequence;
    int vitesse = configMotor.vitesse;
    double pole = frequence * 60 / vitesse;
    double minVitesse = vitesse / 2;
    double maxVitesse = (vitesse * 0.05) + vitesse;
    double minFrequence = frequence / 2;
    double maxFrequence = (frequence * 0.05) + frequence;

    final List<Feature> features = [
      Feature(
        title: "phase_01",
        color: Colors.blue,
        data: [
          0.5,
          0.65,
          0.77,
          0.86,
          0.94,
          0.98,
          0.99,
          0.98,
          0.94,
          0.86,
          0.77,
          0.65,
          0.5,
          0.35,
          0.23,
          0.14,
          0.06,
          0.02,
          0.01,
          0.02,
          0.06,
          0.14,
          0.23,
          0.35,
          0.5,
        ],
      ),
      Feature(
        title: "phase_02",
        color: Colors.red,
        data: [
          0.94,
          0.86,
          0.77,
          0.65,
          0.5,
          0.35,
          0.23,
          0.14,
          0.06,
          0.02,
          0.01,
          0.02,
          0.06,
          0.14,
          0.23,
          0.35,
          0.5,
          0.65,
          0.77,
          0.86,
          0.94,
          0.98,
          0.99,
          0.98,
          0.94
        ],
      ),
      Feature(
        title: "phase_03",
        color: Colors.green,
        data: [
          0.06,
          0.02,
          0.01,
          0.02,
          0.06,
          0.14,
          0.23,
          0.35,
          0.5,
          0.65,
          0.77,
          0.86,
          0.94,
          0.98,
          0.99,
          0.98,
          0.94,
          0.86,
          0.77,
          0.65,
          0.5,
          0.35,
          0.23,
          0.14,
          0.06
        ],
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1A374D),
          title: const Center(
            child: Text('Async Moteur',
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.bold,
                    fontSize: 23)),
          ),
        ),
        body: Column(
          children: [
            Container(
                height: 20,
                child: (status == true)
                    ? Container(
                        color: Colors.greenAccent,
                        child: const Center(child: Text('Connecter')),
                      )
                    : Container(
                        color: Colors.redAccent[200],
                        child: const Center(
                            child: Text(
                          'Deconnecter',
                          style: TextStyle(color: Colors.white),
                        )),
                      )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 30,
                          color: Color(0xff1A374D),
                          fontWeight: FontWeight.bold),
                      child: AnimatedTextKit(
                          pause: const Duration(milliseconds: 3000),
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TyperAnimatedText(
                              myValue!,
                              speed: const Duration(milliseconds: 120),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                        color: Colors.blue[50],
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 20),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Configuration : ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: 170,
                                  child: Text(
                                    'tension : ${tension.toString()} V',
                                    style: const TextStyle(
                                        fontFamily: 'Comfortaa', fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    'fréquence : ${frequence.toString()} Hz ',
                                    style: const TextStyle(
                                        fontFamily: 'Comfortaa', fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: 170,
                                  child: Text(
                                    'vitesse : ${vitesse.toString()} Tr/Min ',
                                    style: const TextStyle(
                                        fontFamily: 'Comfortaa', fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    'Nombre de pole : 0${(pole.toInt() * 2).toString()}  ',
                                    style: const TextStyle(
                                        fontFamily: 'Comfortaa', fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                        // color: const Color(0xffB1D0E0),
                        color: Colors.blue[50],
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: const Text(
                                'Note : ',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'Pour assurer un bon fonctionnement de ce moteur il faut respecter la plage de la vitesse conseillé (${minVitesse.round()} - ${maxVitesse.round()}) Tours/Min qui correspondent à (${minFrequence.round()} - ${maxFrequence.round()}) Hz afin d\'eviter le phénomene de défluxage.  ',
                                style: const TextStyle(
                                  height: 2,
                                  fontSize: 13,
                                  fontFamily: 'Comfortaa',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: (checkCmd(myValue!))
                          ? Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Card(
                                    color: Colors.blue[50],
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: const Text(
                                            'Ma commande : ',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Votre vitesse desirée était ${commandMotor.vitesse} Tr/Min , sachant que mon cher ami ESP_32 fonctionne avec une fréquence MLI de 16000 Hz donc les valeurs envoyées sont les suivantes : ',
                                                style: TextStyle(
                                                  height: 2,
                                                  fontSize: 13,
                                                  fontFamily: 'Comfortaa',
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 130,
                                                      child: Text(
                                                        'Fréquence : ',
                                                        style: TextStyle(
                                                            height: 2,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Text(
                                                    '${(commandMotor.frequence).toString()} Hz',
                                                    style: TextStyle(
                                                      height: 2,
                                                      fontSize: 13,
                                                      fontFamily: 'Comfortaa',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 130,
                                                      child: Text(
                                                        'Tension max : ',
                                                        style: TextStyle(
                                                            height: 2,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Text(
                                                    '${commandMotor.tensionMax} V',
                                                    style: TextStyle(
                                                      height: 2,
                                                      fontSize: 13,
                                                      fontFamily: 'Comfortaa',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 130,
                                                      child: Text(
                                                        'temps de cycle : ',
                                                        style: TextStyle(
                                                            height: 2,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Text(
                                                    '${commandMotor.tmpDeCycle} ms',
                                                    style: TextStyle(
                                                      height: 2,
                                                      fontSize: 13,
                                                      fontFamily: 'Comfortaa',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 170,
                                                      child: Text(
                                                        'nombre de commande : ',
                                                        style: TextStyle(
                                                            height: 2,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Text(
                                                    '${commandMotor.nbrDeCommande} Cmd/Cycle',
                                                    style: TextStyle(
                                                      height: 2,
                                                      fontSize: 13,
                                                      fontFamily: 'Comfortaa',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(
                                          left: 30, top: 20),
                                      child: const Text(
                                        'Graph : ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'temps : ms  ',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(
                                          'tension : volts',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                LineGraph(
                                    features: features,
                                    size: const Size(400, 220),
                                    labelX: [
                                      '0',
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      getCycle_25(),
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      getCycle_50(),
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      getCycle_75(),
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      getCycle_100(),
                                    ],
                                    labelY: [
                                      getMinTension_100(),
                                      '',
                                      '',
                                      getMinTension_50(),
                                      '',
                                      '',
                                      '',
                                      '0',
                                      '',
                                      '',
                                      '',
                                      getTension_50(),
                                      '',
                                      '',
                                      getTension_100()
                                    ],
                                    showDescription: true,
                                    graphColor: Colors.black,
                                    graphOpacity: 0.0),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            )
                          : Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Card(
                                color: Colors.blue[50],
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, bottom: 10),
                                  child: const Text(
                                    "Ce moteur n'a pas encore reçu une commande ,assurez vous que vous êtes connecter a l'esp32 ,aprés cliquez sur Varier Ma Vitesse pour le commander . ",
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 2,
                                      fontFamily: 'Comfortaa',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.zero,
                color: Color(0xffffab00),
              ),
              height: 47,
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black12, // foreground
                ),
                child: const Text(
                  'Varier Ma vitesse',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 180,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const SizedBox(
                                    // height: 10,
                                    ),
                                const Text(
                                  'Veuillez Inserez la vitesse SVP',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.white10,
                                            labelText: 'Vitesse en Tours/Min',
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 11),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Color(0xff2980B9),
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          onSaved: (value) => speedy = value!,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Veuillez inserer une vitesse valide SVP';
                                            }
                                            if (int.parse(value) > maxVitesse) {
                                              return 'Vous risquez de griller le moteur';
                                            }

                                            if (int.parse(value) < minVitesse) {
                                              return 'Votre vitesse est trop petite';
                                            }

                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        // ignore: prefer_const_constructors
                                        SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(const Color(
                                                            0xffffab00)),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();
                                                  String Duty = duty(
                                                      int.parse(speedy!),
                                                      vitesse,
                                                      frequence,
                                                      tension);

                                                  sendcmd(Duty);
                                                  dutyGraph =
                                                      getdutyForGraph(Duty);

                                                  if (message ==
                                                      "esp32 : executed") {
                                                    print(
                                                        'commande executer avec succees');
                                                  }
                                                  int nbrDeCommande =
                                                      (Duty.length / 4).round();
                                                  double fre = double.parse(
                                                      (16000 / nbrDeCommande)
                                                          .toStringAsFixed(2));

                                                  double tmpDeCycle =
                                                      double.parse((1000 / fre)
                                                          .toStringAsFixed(2));

                                                  double tensionMax =
                                                      double.parse((int.parse(
                                                                  speedy!) /
                                                              vitesse *
                                                              tension)
                                                          .toStringAsFixed(2));

                                                  if (tensionMax > tension) {
                                                    tensionMax =
                                                        tension.toDouble();
                                                  }

                                                  final Cmd = Comnd(
                                                      fre,
                                                      tensionMax,
                                                      tmpDeCycle,
                                                      int.parse(speedy!),
                                                      nbrDeCommande);
                                                  addToCmd(myValue!, Cmd);
                                                  _formKey.currentState!
                                                      .reset();

                                                  setState(() {});
                                                  Navigator.pop(context, false);
                                                }
                                                if (status == true) {
                                                  showToast('Commande envoyée',
                                                      context: context,
                                                      animation:
                                                          StyledToastAnimation
                                                              .scale,
                                                      reverseAnimation:
                                                          StyledToastAnimation
                                                              .fade,
                                                      position:
                                                          StyledToastPosition
                                                              .bottom,
                                                      animDuration:
                                                          Duration(seconds: 1),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      curve: Curves.easeOutExpo,
                                                      reverseCurve:
                                                          Curves.linear,
                                                      backgroundColor:
                                                          Colors.black87);
                                                }
                                                if (status == false) {
                                                  showToast(
                                                      'Vous êtes en mode Offline',
                                                      context: context,
                                                      animation:
                                                          StyledToastAnimation
                                                              .scale,
                                                      reverseAnimation:
                                                          StyledToastAnimation
                                                              .fade,
                                                      position:
                                                          StyledToastPosition
                                                              .bottom,
                                                      animDuration:
                                                          Duration(seconds: 1),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      curve: Curves.easeOutExpo,
                                                      reverseCurve:
                                                          Curves.linear,
                                                      backgroundColor:
                                                          Colors.black);
                                                }
                                              },
                                              child: const Text(
                                                'Envoyer',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontFamily: 'Comfortaa',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ))
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(Icons.refresh, color: Color(0xffffab00)),
          onPressed: () {
            setState(() {
              channelconnect();
              showToast('Actualiser',
                  context: context,
                  animation: StyledToastAnimation.scale,
                  reverseAnimation: StyledToastAnimation.fade,
                  position: StyledToastPosition.center,
                  animDuration: Duration(seconds: 1),
                  duration: Duration(seconds: 2),
                  curve: Curves.easeOutExpo,
                  reverseCurve: Curves.linear,
                  backgroundColor: Colors.black87);
            });
          },
        ),
      ),
    );
  }
}
