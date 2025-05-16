import 'package:code_hire/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';

class EditSettingScreen extends StatelessWidget {
  const EditSettingScreen({super.key, required UserModel user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // حفظ التغييرات هنا
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
