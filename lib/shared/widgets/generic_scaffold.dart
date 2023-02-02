import 'package:flutter/material.dart';

class GenericScaffold extends StatefulWidget {
  const GenericScaffold({Key? key}) : super(key: key);

  @override
  State<GenericScaffold> createState() => _GenericScaffoldState();
}

class _GenericScaffoldState extends State<GenericScaffold> {

  Widget _widgetBody = Container();
  String _title = "";

  Map _data = {};

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      _data = ModalRoute.of(context)?.settings.arguments as Map;
      setState(() {
        _widgetBody = _data["widget"];
        _title = _data["title"];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _widgetBody,
    );
  }
}
