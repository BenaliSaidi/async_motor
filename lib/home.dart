import 'package:async_motor/commande.dart';
import 'package:async_motor/model/config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

String? name;
String? tension;
String? frequence;
String? vitesse;
List<String> listOfName = [];

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
          const Text(
            'Mes Configurations',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: (Hive.box("config").length == 0)
                ? (const Center(
                    heightFactor: 35,
                    child: Text("Aucune configuration trouvée")))
                : Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box('config').listenable(),
                      builder: (context, box, widget) {
                        return ListView.builder(
                            itemCount: Hive.box('config').length,
                            itemBuilder: (BuildContext context, int index) {
                              final config = Hive.box('config').getAt(index);
                              double pole =
                                  (config.frequence * 60) / config.vitesse;
                              return GestureDetector(
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
                                  margin: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              //width: 200,
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                config.name.toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Comfortaa',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            IconButton(
                                              color: Colors.red[400],
                                              padding: const EdgeInsets.all(0),
                                              iconSize: 20,
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                Hive.box('config')
                                                    .deleteAt(index);
                                                Hive.box('commande')
                                                    .delete(config.name);
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
                                              width: 200,
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              // width: double.infinity,
                                              child: Text(
                                                'tension : ${config.tension.toString()} V',
                                                style: const TextStyle(
                                                    fontFamily: 'Comfortaa',
                                                    fontSize: 13),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              // width: double.infinity,
                                              child: Text(
                                                'fréquence : ${config.frequence.toString()} Hz ',
                                                style: const TextStyle(
                                                    fontFamily: 'Comfortaa',
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 200,
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10),
                                              // width: double.infinity,
                                              child: Text(
                                                'vitesse : ${config.vitesse.toString()} Tours/Min ',
                                                style: const TextStyle(
                                                    fontFamily: 'Comfortaa',
                                                    fontSize: 13),
                                              ),
                                            ),
                                            Container(
                                              //width: 180,
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10),
                                              //width: double.infinity,
                                              child: Text(
                                                'Nombre de pole : 0${pole.round().toString()}  ',
                                                style: const TextStyle(
                                                    fontFamily: 'Comfortaa',
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                return AlertDialog(
                  content: SizedBox(
                    height: 350,
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
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white10,
                                    labelText: 'Nom du moteur',
                                    labelStyle: const TextStyle(
                                        color: Colors.black, fontSize: 13),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Color(0xff2980B9),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onSaved: (value) => name = value,
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
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    //fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white10,
                                    labelText: 'Tension Max',
                                    labelStyle: const TextStyle(
                                        color: Colors.black, fontSize: 13),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Color(0xff2980B9),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onSaved: (value) => tension = value,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'veuillez inserez une tension valide SVP';
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
                                    //fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white10,
                                    labelText: 'Fréquence',
                                    labelStyle: const TextStyle(
                                        color: Colors.black, fontSize: 13),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Color(0xff2980B9),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onSaved: (value) => frequence = value,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'veuillez inserez une fréquence valide SVP';
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
                                    //fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white10,
                                    labelText: 'Vitesee Max',
                                    labelStyle: const TextStyle(
                                        color: Colors.black, fontSize: 13),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Color(0xff2980B9),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onSaved: (value) => vitesse = value,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Veuillez inserez une vitesse valide SVP';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xff1A374D)),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      final newConfig = Config(
                                          name!,
                                          int.parse(tension!),
                                          int.parse(frequence!),
                                          int.parse(vitesse!));
                                      addNewConfig(name!, newConfig);
                                      _formKey.currentState!.reset();
                                      setState(() {});
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
                );
              });
        },
      ),
    );
  }
}
