import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notes_laravel/presentation/view/mobile/home_screen.dart';

class NewNoteScreen extends StatelessWidget {
  const NewNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MobileHomeScreen(),
            ),
          ),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('New Note'),
      ),
      body: Container(
        child: const Text('New Note Screen'),
      ),
    );
  }
}
