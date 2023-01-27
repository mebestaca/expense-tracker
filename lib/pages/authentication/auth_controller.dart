import 'package:expense_tracker/pages/authentication/toggler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/model_user.dart';
import '../home/home.dart';

class AuthController extends StatefulWidget {
  const AuthController({Key? key}) : super(key: key);

  @override
  State<AuthController> createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  @override
  Widget build(BuildContext context) {
    final loginInfo = Provider.of<UserModel?>(context);

    if (loginInfo == null) {
      return const Toggle();
    }
    else{
      return const Home();
    }
  }
}
