import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/screens/home/home.dart';
import 'package:payment_getway/screens/login/bloc/login_bloc.dart';
import 'package:payment_getway/screens/login/repository/authentication_repository.dart';
import 'package:payment_getway/screens/profile_page.dart';
import 'package:payment_getway/screens/home/menu_botttom_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ProfilePageView(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return BlocProvider(
            create: (context) => LoginBloc(
                authenticationRepository: context.read<AuthenticationRepository>()),
            child: MenuBottomSheetContent(),
          );
        },
      );
    } else {
      setState(() {
        _pageIndex = (index == 2) ? 1 : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "You",
          ),
        ],
        // The current index should map back to the visual selection
        currentIndex: _pageIndex == 1 ? 2 : 0,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        selectedFontSize: 14,
        iconSize: 35,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
