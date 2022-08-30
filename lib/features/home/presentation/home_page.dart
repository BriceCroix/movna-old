import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/features/home/presentation/widgets/history_tab.dart';
import 'package:movna/features/home/presentation/widgets/home_tab.dart';

class MovnaPage extends StatefulWidget {
  const MovnaPage({super.key});

  @override
  State<MovnaPage> createState() => _MovnaPageState();
}

class _MovnaPageState extends State<MovnaPage>{

  int _selectedIndex = 1;

  static const List<Widget> _pages = <Widget>[
    Text('1'),
    HomeTab(),
    HistoryTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child:Text(AppLocalizations.of(context)!.appName))),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: AppLocalizations.of(context)!.profile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: AppLocalizations.of(context)!.history,
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    );
  }
}