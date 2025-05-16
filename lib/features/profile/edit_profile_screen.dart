import 'package:flutter/material.dart';
import 'package:code_hire/features/auth/models/user_model.dart';
import 'package:code_hire/features/auth/models/user_repository.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _aboutController;
  late TextEditingController _phoneController;
  final UserRepository _userRepo = UserRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _aboutController = TextEditingController(text: widget.user.about);
    _phoneController = TextEditingController(text: widget.user.phoneNo);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _aboutController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final updatedUser = widget.user.copyWith(
        fullName: _fullNameController.text,
        about: _aboutController.text,
        phoneNo: _phoneController.text,
      );
      await _userRepo.updateUserProfile(updatedUser);
      Navigator.pop(context, updatedUser);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _aboutController,
                    decoration: const InputDecoration(labelText: 'About Yourself'),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
    );
  }
}