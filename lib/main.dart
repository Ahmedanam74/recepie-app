import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/injector.dart';
import 'package:recepies_app/layers/presentation/home/view/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MealDetailsAdapter());
  await Hive.openBox('recepies');
  await initializeGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      debugShowCheckedModeBanner: false,
      
      home: const HomePage(),
    );
  }
}
