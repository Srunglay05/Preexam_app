import 'package:flutter/material.dart';
import 'package:prexam/admin/add_task/addtask_screen.dart';
import 'option_button.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              /// Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Admin, Zengg',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(thickness: 1.5),


              /// Illustration
              SizedBox(
                height: 180,
                child: Image.asset(
                  'assets/images/timez.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),
              const Divider(thickness: 1.5),
              const SizedBox(height: 10),

              /// Title
              const Center(
                child: Text(
                  'Options',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Buttons
              OptionButton(
                icon: Icons.assignment,
                text: 'Add New Task',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTaskScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),


              OptionButton(
                icon: Icons.lightbulb_outline,
                text: 'Add New Solution',
                onPressed: () {},
              ),
              const SizedBox(height: 14),

              OptionButton(
                icon: Icons.menu_book,
                text: 'Add New Course',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
