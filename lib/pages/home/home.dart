import 'package:expense_tracker/shared/widgets/generic_pathfinder.dart';
import 'package:flutter/material.dart';

import '../../services/authentication.dart';
import '../../shared/widgets/background.dart';
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
    const Placeholder(),
    const GenericPathfinder(pages: Pages.today),
    const GenericPathfinder(pages: Pages.history),
    const GenericPathfinder(pages: Pages.category),
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
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  image: const DecorationImage(
                    image: AssetImage("assets/expense-tracker-drawer.png"),
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomLeft
                  )
                ),
                child: Container(),
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
                      updatePage(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(_widgetTitles[3]),
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    onTap: () {
                      updatePage(3);
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
        body: Stack(
          children: [
            const Background(),
            Container(
              child:_widgetList[_currentIndex],
            ),
          ],
        )
    );
  }

  void updatePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
