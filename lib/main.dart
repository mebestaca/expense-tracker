import 'package:expense_tracker/pages/authentication/auth_controller.dart';
import 'package:expense_tracker/services/authentication.dart';
import 'package:expense_tracker/shared/main_theme.dart';
import 'package:expense_tracker/shared/widgets/category_data_entry.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value: AuthenticationService().userInfo,
      child: MaterialApp(
        theme: mainTheme,
        home: const AuthController(),
        routes: {
          Routes.categoryMaintenance : (context) =>  const CategoryDataEntry(),
        },
      ),
    );
  }
}
