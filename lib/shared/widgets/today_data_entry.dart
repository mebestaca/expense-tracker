import 'package:flutter/material.dart';

import '../../models/model_items.dart';

enum ExpenseEntryMode{
  add,
  edit,
  delete
}

class TodayDataEntry extends StatefulWidget {
  const TodayDataEntry({Key? key, required this.entryMode, required this.model, required this.id, required this.path}) : super(key: key);

  final ExpenseEntryMode entryMode;
  final ItemModel model;
  final String id;
  final String path;

  @override
  State<TodayDataEntry> createState() => _TodayDataEntryState();
}

class _TodayDataEntryState extends State<TodayDataEntry> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
