import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: const Text(
          'If you have any questions or need help, please contact us at support@codehire.com.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
