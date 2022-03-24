// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ffi';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:async_motor/home.dart';
import 'package:async_motor/model/commande.dart';
//import 'package:async_motor/model/config.dart';
import 'package:flutter/material.dart';
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

    String cycle_100 = commandMotor.tmpDeCycle.toString();
    String cycle_50 =
        double.parse(((commandMotor.tmpDeCycle) * 0.5).toStringAsFixed(2))
            .toString();
    String cycle_25 =
        double.parse(((commandMotor.tmpDeCycle) * 0.25).toStringAsFixed(2))
            .toString();
    String cycle_75 =
        double.parse(((commandMotor.tmpDeCycle) * 0.75).toStringAsFixed(2))
            .toString();

    String tension_100 = commandMotor.tensionMax.toString();
    String tension_50 =
        double.parse(((commandMotor.tensionMax) * 0.5).toStringAsFixed(2))
            .toString();
    String minTension_100 =
        double.parse(((commandMotor.tensionMax) * (-1)).toStringAsFixed(2))
            .toString();
    String minTension_50 = double.parse(
            ((commandMotor.tensionMax) * 0.5 * (-1)).toStringAsFixed(2))
        .toString();

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
                              speed: const Duration(milliseconds: 80),
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
                                      fontSize: 17,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: 210,
                                  child: Text(
                                    'tension : ${tension.toString()} V',
                                    style: const TextStyle(
                                        fontFamily: 'Comfortaa', fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    'fréquence : ${frequence.toString()} Hz ',
                                    style: const TextStyle(
                                        fontFamily: 'Comfortaa', fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: 210,
                                  child: Text(
                                    'vitesse : ${vitesse.toString()} Tours/Min ',
                                    style: const TextStyle(
                                        fontFamily: 'Comfortaa', fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    'Nombre de pole : 0${(pole.toInt() * 2).toString()}  ',
                                    style: const TextStyle(
                                        fontFamily: 'Comfortaa', fontSize: 15),
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
                      height: 30,
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
                                    fontSize: 17,
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
                                  height: 2.5,
                                  fontSize: 15,
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
                                                fontSize: 17,
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
                                                'Votre vitesse desirée était ${commandMotor.vitesse} Tr/Min ,en sachant que mon cher ami ESP_32 fonctionne avec une fréquence MLI de 16000 Hz donc les valeurs envoyées sont les suivantes : ',
                                                style: TextStyle(
                                                  height: 2.5,
                                                  fontSize: 15,
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
                                                      width: 150,
                                                      child: Text(
                                                        'Fréquence : ',
                                                        style: TextStyle(
                                                            height: 2.5,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Text(
                                                    '${(commandMotor.frequence).toString()} Hz',
                                                    style: TextStyle(
                                                      height: 2.5,
                                                      fontSize: 15,
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
                                                      width: 150,
                                                      child: Text(
                                                        'Tension max : ',
                                                        style: TextStyle(
                                                            height: 2.5,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Text(
                                                    '${commandMotor.tensionMax} V',
                                                    style: TextStyle(
                                                      height: 2.5,
                                                      fontSize: 15,
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
                                                      width: 150,
                                                      child: Text(
                                                        'temps de cycle : ',
                                                        style: TextStyle(
                                                            height: 2.5,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Text(
                                                    '${commandMotor.tmpDeCycle} ms',
                                                    style: TextStyle(
                                                      height: 2.5,
                                                      fontSize: 15,
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
                                                      width: 200,
                                                      child: Text(
                                                        'nombre de commande : ',
                                                        style: TextStyle(
                                                            height: 2.5,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Text(
                                                    '${commandMotor.nbrDeCommande} Cmd/Cycle',
                                                    style: TextStyle(
                                                      height: 2.5,
                                                      fontSize: 15,
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
                                            fontSize: 17,
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
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(
                                          'tension : volts',
                                          style: TextStyle(
                                            fontSize: 14,
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
                                    size: const Size(400, 250),
                                    labelX: [
                                      '0',
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      cycle_25,
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      cycle_50,
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      cycle_75,
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      cycle_100,
                                    ],
                                    labelY: [
                                      minTension_100,
                                      '',
                                      '',
                                      minTension_50,
                                      '',
                                      '',
                                      '',
                                      '0',
                                      '',
                                      '',
                                      '',
                                      tension_50,
                                      '',
                                      '',
                                      tension_100
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
                                      fontSize: 15,
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
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 220,
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
                                  height: 30,
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
                                                fontSize: 13),
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
                                          height: 30,
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
                                                  cycle_100 =
                                                      tmpDeCycle.toString();
                                                  cycle_25 = double.parse(
                                                          (tmpDeCycle * 0.25)
                                                              .toStringAsFixed(
                                                                  1))
                                                      .toString();
                                                  cycle_50 = double.parse(
                                                          (tmpDeCycle * 0.50)
                                                              .toStringAsFixed(
                                                                  1))
                                                      .toString();
                                                  cycle_75 = double.parse(
                                                          (tmpDeCycle * 0.75)
                                                              .toStringAsFixed(
                                                                  1))
                                                      .toString();

                                                  setState(() {});
                                                }
                                              },
                                              child: const Text(
                                                'Envoyer',
                                                style: TextStyle(
                                                    color: Colors.black),
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
            });
          },
        ),
      ),
    );
  }
}
