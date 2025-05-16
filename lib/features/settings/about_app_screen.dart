import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: const Text(
          'CodeHire helps you find professional programmers based on your skills. '
          'Easily apply for projects and grow your career!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
