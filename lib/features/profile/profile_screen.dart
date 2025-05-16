//import 'package:code_hire/core/constants.dart';
import 'package:code_hire/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:code_hire/features/auth/models/user_model.dart';
import 'package:code_hire/features/auth/models/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository _userRepo = UserRepository();
  UserModel? _user;
  bool _isLoading = true;
  bool _isEditingAbout = false;
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userRepo.getCurrentUser();
      setState(() {
        _user = user;
        _aboutController.text = user!.about;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('load_profile_failed'.tr() + ': $e')),
      );
    }
  }

  Future<void> _saveAbout() async {
    try {
      final updatedUser = _user!.copyWith(about: _aboutController.text);
      await _userRepo.updateUserProfile(updatedUser);
      setState(() {
        _user = updatedUser;
        _isEditingAbout = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('about_updated'.tr())),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('update_failed'.tr() + ': $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 26, 134),
        elevation: 0,
        title: Text(
          'profile'.tr(),
          style: const TextStyle(
            color: Color.fromARGB(255, 248, 248, 250),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color.fromARGB(255, 247, 247, 249)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? Center(child: Text('no_user_data'.tr()))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'personal_info'.tr(),
                        children: [
                          _buildInfoItem('full_name'.tr(), _user!.fullName),
                          _buildInfoItem('email'.tr(), _user!.email),
                          _buildInfoItem('phone'.tr(), _user!.phoneNo),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'about_me'.tr(),
                        children: [
                          if (!_isEditingAbout) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                _user!.about,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() => _isEditingAbout = true);
                                },
                                child: Text(
                                  'edit'.tr(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 4, 26, 134),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            TextFormField(
                              controller: _aboutController,
                              maxLines: 5,
                              maxLength: 500,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color.fromARGB(255, 192, 197, 225)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color.fromARGB(255, 4, 26, 134)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditingAbout = false;
                                      _aboutController.text = _user!.about;
                                    });
                                  },
                                  child: Text(
                                    'cancel'.tr(),
                                    style: const TextStyle(color: Color.fromARGB(255, 4, 26, 134)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _saveAbout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 4, 26, 134),
                                  ),
                                  child: Text(
                                    'save'.tr(),
                                    style: const TextStyle(color: Color.fromARGB(255, 249, 249, 251)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_user!.skills.isNotEmpty)
                        _buildInfoCard(
                          title: 'my_skills'.tr(),
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _user!.skills
                                  .map((skill) => Chip(
                                        label: Text(skill),
                                        backgroundColor: const Color.fromARGB(255, 118, 131, 207),
                                        labelStyle: const TextStyle(color: Color.fromARGB(255, 4, 26, 134)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 192, 197, 225),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 4, 26, 134)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 4, 26, 134),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 4, 26, 134),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Divider(color: Color.fromARGB(255, 4, 26, 134), height: 24),
        ],
      ),
    );
  }
}