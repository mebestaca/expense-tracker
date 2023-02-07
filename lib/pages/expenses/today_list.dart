import 'package:expense_tracker/models/model_items.dart';
import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../shared/widgets/today_data_entry.dart';

class TodayList extends StatefulWidget {
  const TodayList({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<TodayList> createState() => _TodayListState();
}

class _TodayListState extends State<TodayList> {



  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          color: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                color: Theme.of(context).primaryColor,
                child: const Text("0000.00")
              ),
            ),
          ),
        ),
        const Expanded(
          child: Placeholder(),
        ),
        Container(
          color: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.genericRoute,
                        arguments: {
                          "widget" : TodayDataEntry(
                            entryMode: ExpenseEntryMode.add,
                            id: "",
                            model: ItemModel(),
                            path: widget.path,
                          ),
                          "title" : "New Entry",
                        }
                    );
                  },
                  child: const Text("Add New Entry",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  )
              ),
            ),
          ),
        )
      ],
    );
  }
}
