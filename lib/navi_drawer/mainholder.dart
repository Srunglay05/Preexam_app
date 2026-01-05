import 'package:flutter/material.dart';
import 'package:prexam/widgets/mainhome/top_header.dart';
import 'drawer_menus.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      // ✅ DRAWER
      drawer: const DrawerMenus(),

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ✅ PASS KEY TO HEADER
              TopHeader(scaffoldKey: scaffoldKey),

              const SizedBox(height: 20),

              const Expanded(
                child: Center(
                  child: Text(
                    'Home Content',
                    style: TextStyle(
                      fontFamily: 'Teacher',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
