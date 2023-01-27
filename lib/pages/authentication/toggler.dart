import 'package:expense_tracker/pages/authentication/register.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Toggle extends StatefulWidget {
  const Toggle({Key? key}) : super(key: key);

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool toggleView = true;

  void toggle(){
    setState(() {
      toggleView = !toggleView;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (toggleView) {
      return Login(toggleView: toggle);
    }
    else{
      return Register(toggleView: toggle);
    }
  }
}
