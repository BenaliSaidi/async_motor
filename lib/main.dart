import 'package:async_motor/model/commande.dart';
import 'package:async_motor/model/config.dart';
import 'package:async_motor/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(ConfigAdapter());
  Hive.registerAdapter(ComndAdapter());

  await Hive.openBox('config');
  await Hive.openBox('commande');

  runApp(const MaterialApp(home: SplashScreen()));
}
