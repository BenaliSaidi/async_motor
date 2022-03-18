// ignore_for_file: avoid_print

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:async_motor/model/config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:async_motor/calculate_duty.dart';
import 'package:web_socket_channel/io.dart';

// ignore: prefer_typing_uninitialized_variables
var configMotor;
String? speedy;
var message;

getIndex(int index) {
  configMotor = Hive.box('config').getAt(index);
}

class Commande extends StatefulWidget {
  const Commande({Key? key}) : super(key: key);

  @override
  State<Commande> createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
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
        },
        onDone: () {
          //if WebSocket is disconnected

          print("Web socket is closed");
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
    getIndex(0);
    String name = configMotor.name;
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
        title: "Tension",
        color: Colors.blue,
        data: [
          0.5,
          0.65,
          0.78,
          .89,
          0.95,
          1,
          0.95,
          0.89,
          0.78,
          0.65,
          0.5,
          0.35,
          0.22,
          0.11,
          0.05,
          .0,
          0.05,
          0.11,
          0.22,
          0.35,
          0.5,
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
                color: Colors.greenAccent,
                child: const Center(child: Text('Connceter'))),
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
                              name,
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
                                    'Nombre de pole : 0${pole.toInt().toString()}  ',
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
                      height: 40,
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
                      height: 40,
                    ),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 30),
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: LineGraph(
                          features: features,
                          size: const Size(650, 300),
                          labelX: const [
                            '0',
                            '',
                            '',
                            '',
                            '',
                            '5',
                            '',
                            '',
                            '',
                            '',
                            '10',
                            '',
                            '',
                            '',
                            '',
                            '15',
                            '',
                            '',
                            '',
                            '',
                            '20',
                          ],
                          labelY: const [
                            '-220',
                            '',
                            '',
                            '-110',
                            '',
                            '',
                            '',
                            '0',
                            '',
                            '',
                            '',
                            '110',
                            '',
                            '',
                            '220'
                          ],
                          showDescription: true,
                          graphColor: Colors.black,
                          graphOpacity: 0.0),
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
                // style: ButtonStyle(
                //   shadowColor:
                //       MaterialStateProperty.all<Color>(const Color(0xffffffff)),
                // ),
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

                                                  sendcmd(duty(
                                                      int.parse(speedy!),
                                                      vitesse,
                                                      frequence,
                                                      tension));
                                                  if (message ==
                                                      '"esp32 : executed"') {
                                                    print(
                                                        'commande executer avec succees');
                                                  }
                                                  _formKey.currentState!
                                                      .reset();
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
