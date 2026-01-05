import 'package:flutter/material.dart';
import 'wave_clipper.dart';

class DrawerMenus extends StatelessWidget {
  const DrawerMenus({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 240,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.lightBlueAccent,
                  ],
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Teacher',
                    ),
                  ),
                  Text(
                    'user@email.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text('Home', style: TextStyle(fontFamily: 'Teacher')),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text('Settings', style: TextStyle(fontFamily: 'Teacher')),
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue),
            title: Text('About', style: TextStyle(fontFamily: 'Teacher')),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(fontFamily: 'Teacher')),
          ),
        ],
      ),
    );
  }
}
