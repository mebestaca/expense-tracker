import 'package:expense_tracker/pages/category/category_list.dart';
import 'package:flutter/material.dart';

import '../../services/authentication.dart';
import '../charts/charts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

  final List<Widget> _widgetList = <Widget>[
    const Charts(),
    const Charts(),
    const Charts(),
    const Charts(),
    const CategoryList(),
  ];

  final List<String> _widgetTitles = [
    "Dashboard",
    "Expenses",
    "Today",
    "History",
    "Categories"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_widgetTitles[_currentIndex]),
          actions: [
            IconButton(
                onPressed: () async {
                  await AuthenticationService().signOut();
                },
                icon: const Icon(Icons.logout_sharp )
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue
                ),
                child: Text("Expense Tracker"),
              ),
              ListTile(
                title: Text(_widgetTitles[0]),
                leading: const Icon(Icons.dashboard_outlined ),
                onTap: () {
                  updatePage(0);
                  Navigator.pop(context);
                },
              ),
              ExpansionTile(
                title: Text(_widgetTitles[1]),
                leading: const Icon(Icons.add_card),
                children: [
                  ListTile(
                    title: Text(_widgetTitles[2]),
                    leading: const Icon(Icons.event_available_outlined),
                    onTap: () {
                      updatePage(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(_widgetTitles[3]),
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    onTap: () {
                      updatePage(0);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              ListTile(
                title: Text(_widgetTitles[4]),
                leading: const Icon(Icons.category_outlined),
                onTap: () {
                  updatePage(4);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Container(
          child:_widgetList[_currentIndex],
        )
    );
  }

  void updatePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
