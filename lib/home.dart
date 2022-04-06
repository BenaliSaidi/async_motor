import 'package:async_motor/commande.dart';
import 'package:async_motor/model/config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

String? name;
String? tension;
String? frequence;
int? vitesse;
String? glissement;
String? PairePole;
List<String> listOfName = [];

String? couplage;
int option = 1;

void addNewConfig(String key, Config config) {
  final configsBox = Hive.box('config');
  configsBox.put(key, config);
}

List getName() {
  final nameList = Hive.box('config').values.toList();
  nameList.forEach((element) {
    listOfName.add(element.name);
  });
  return listOfName;
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Color? myColor_1 = Colors.grey[300];
    Color? myColor_2 = Colors.grey[300];
    Color? myColor_3 = Colors.grey[300];
    Color mytextColor_1 = Colors.black;
    Color mytextColor_2 = Colors.black;
    Color mytextColor_3 = Colors.black;
    var myConfigs;

    chooseOption() {
      if (option == 1) {
        myColor_1 = Color(0xff1A374D);
        mytextColor_1 = Colors.white;
        myConfigs = Hive.box('config').values.toList();
      }
      if (option == 2) {
        myColor_2 = Color(0xff1A374D);
        mytextColor_2 = Colors.white;
        myConfigs = Hive.box('config')
            .values
            .where((myConfig) => myConfig.couplage == 'Etoile')
            .toList();
      }
      if (option == 3) {
        myColor_3 = Color(0xff1A374D);
        mytextColor_3 = Colors.white;
        myConfigs = Hive.box('config')
            .values
            .where((myConfig) => myConfig.couplage == 'Triangle')
            .toList();
      }
    }

    chooseOption();
    return Scaffold(
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
          const SizedBox(
            height: 30,
          ),
          Container(
              height: 30,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      option = 1;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: myColor_1,
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                            width: 2.0,
                            color: Color(0xff1A374D),
                          )),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Tous",
                        style: TextStyle(
                            color: mytextColor_1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      option = 2;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: myColor_2,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 2.0,
                            color: Color(0xff1A374D),
                          )),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Etoile",
                        style: TextStyle(
                            color: mytextColor_2,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      option = 3;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: myColor_3,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 2.0,
                            color: Color(0xff1A374D),
                          )),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Triangle",
                        style: TextStyle(
                            color: mytextColor_3,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito'),
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          const Text(
            'Mes Configurations',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Container(
            child: (Hive.box("config").length == 0)
                ? (const Center(
                    heightFactor: 30,
                    child: Text("Aucune configuration trouvée")))
                : Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box('config').listenable(),
                      builder: (context, box, widget) {
                        return ListView.builder(
                            itemCount: myConfigs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final config = myConfigs[index];
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Commande(myValue: config.name),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.blue[50],
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: SizedBox(
                                        height: 120,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  //width: 200,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    config.name.toString(),
                                                    style: const TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                IconButton(
                                                  color: Colors.red[400],
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  iconSize: 20,
                                                  icon: const Icon(Icons.clear),
                                                  onPressed: () {
                                                    Hive.box('config')
                                                        .delete(config.name);
                                                    Hive.box('commande')
                                                        .delete(config.name);
                                                    showToast(
                                                      'Configuration supprimée',
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
                                                    );
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 170,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  // width: double.infinity,
                                                  child: Text(
                                                    'Tension : ${config.tension.toString()} V',
                                                    style: const TextStyle(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  // width: double.infinity,
                                                  child: Text(
                                                    'Fréquence : ${config.frequence.toString()} Hz ',
                                                    style: const TextStyle(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 170,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, left: 10),
                                                  // width: double.infinity,
                                                  child: Text(
                                                    'Vitesse : ${config.vitesse.toString()} Tours/Min ',
                                                    style: const TextStyle(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Container(
                                                  //width: 180,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, left: 10),
                                                  //width: double.infinity,
                                                  child: Text(
                                                    'Paire de Pole : 0${config.pole.toString()}  ',
                                                    style: const TextStyle(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 170,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, left: 10),
                                                  // width: double.infinity,
                                                  child: Text(
                                                    'Couplage : ${config.couplage.toString()}  ',
                                                    style: const TextStyle(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1A374D),
        child: const Text(
          '+',
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                          content: SizedBox(
                            height: 400,
                            // ignore: prefer_const_literals_to_create_immutables
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const Center(
                                            child: Text(
                                          'Ajouter une configuration',
                                          style: TextStyle(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold),
                                        )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.white10,
                                            labelText: 'Nom du moteur',
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
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
                                          onSaved: (value) => name = value!,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Veuillez inserez un nom valide SVP';
                                            }
                                            if (getName().contains(value)) {
                                              return 'Ce nom existe Déja ';
                                            }

                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: DropdownButton(
                                              //   borderRadius: ,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                              hint: Text('Couplage'),
                                              icon: Icon(
                                                  Icons.keyboard_arrow_down),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  couplage =
                                                      newValue.toString();
                                                });
                                              },
                                              value: couplage,
                                              isExpanded: true,
                                              items: <String>[
                                                'Etoile',
                                                'Triangle'
                                              ].map((e) {
                                                return DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            suffixStyle:
                                                TextStyle(fontSize: 11),
                                            suffixText: "Volt",
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.white10,
                                            labelText: 'Tension Max',
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
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
                                          onSaved: (value) => tension = value!,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Veuillez inserez une tension valide SVP';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            suffixStyle:
                                                TextStyle(fontSize: 11),
                                            suffixText: "Hz",
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.white10,
                                            labelText: 'Fréquence Max',
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
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
                                          onSaved: (value) =>
                                              frequence = value!,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Veuillez inserez une fréquence valide SVP';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            suffixStyle:
                                                TextStyle(fontSize: 11),
                                            suffixText: "pole",
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.white10,
                                            labelText: 'Paire de Pole',
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
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
                                          onSaved: (value) =>
                                              PairePole = value!,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Veuillez inserez un nombre valide SVP';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xff1A374D)),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              vitesse =
                                                  ((int.parse(frequence!) /
                                                              int.parse(
                                                                  PairePole!)) *
                                                          60)
                                                      .round();
                                              final newConfig = Config(
                                                  name!,
                                                  int.parse(tension!),
                                                  int.parse(frequence!),
                                                  vitesse!,
                                                  int.parse(PairePole!),
                                                  couplage!);

                                              addNewConfig(name!, newConfig);

                                              _formKey.currentState!.reset();

                                              setState(() {
                                                option = 1;
                                                chooseOption();
                                              });
                                              showToast(
                                                'Configuration ajoutée',
                                                context: context,
                                                animation:
                                                    StyledToastAnimation.scale,
                                                reverseAnimation:
                                                    StyledToastAnimation.fade,
                                                position:
                                                    StyledToastPosition.bottom,
                                                animDuration:
                                                    Duration(seconds: 1),
                                                duration: Duration(seconds: 2),
                                                curve: Curves.easeOutExpo,
                                                reverseCurve: Curves.linear,
                                              );
                                              Navigator.pop(context, false);
                                            }
                                          },
                                          child: const Text("Sauvegarder"),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
              });
        },
      ),
    );
  }
}
