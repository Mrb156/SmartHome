import 'package:flutter/material.dart';
import 'package:smart_home/pages/colorPicker2.dart';
import 'package:smart_home/pages/homePage.dart';

import 'heating.dart';

//ezen az oldalon van az app váza, ami körülfogja a megfelelő oldalakat

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _currentPage = "Home";
  List<String> pageKeys = ["Color Picker", "Home", "Heating"];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Color Picker": GlobalKey<NavigatorState>(),
    "Home": GlobalKey<NavigatorState>(),
    "Heating": GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 1;

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  //létrehozzuk a megfelelő változókat, és függvényeket
  final List<Widget> _pages = const [ColorPickerPage(), AlertPage(), Heating()];

  //ez a metódus vezérli a bottom navigation bar-t, hogy tudjunk váltogatni az oldalak között
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Home") {
            _selectTab("Home", 1);

            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(children: <Widget>[
          _buildOffstageNavigator("Color Picker"),
          _buildOffstageNavigator("Home"),
          _buildOffstageNavigator("Heating"),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            _selectTab(pageKeys[index], index);
          },
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.colorize_outlined),
              label: 'Color Picker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.waves_outlined),
              label: 'Heating',
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child = AlertPage();
    if (tabItem == "Color Picker")
      child = ColorPickerPage();
    else if (tabItem == "Home")
      child = AlertPage();
    else if (tabItem == "Heating") child = Heating();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
