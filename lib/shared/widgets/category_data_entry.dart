import 'package:flutter/material.dart';

class CategoryDataEntry extends StatefulWidget {
  const CategoryDataEntry({Key? key}) : super(key: key);

  @override
  State<CategoryDataEntry> createState() => _CategoryDataEntryState();
}

class _CategoryDataEntryState extends State<CategoryDataEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category")
      ),
    );
  }
}
