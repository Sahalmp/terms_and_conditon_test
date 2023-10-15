import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pidilite_assignment/screens/terms_and_condition_page.dart';
import 'package:pidilite_assignment/service/ml_kit_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MlkitService().setup();
  await GetStorage.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      home: const TermsAndConditionPage(),
    );
  }
}
