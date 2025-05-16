import 'package:flutter/material.dart';
import 'package:code_hire/features/auth/models/user_model.dart';
import 'package:code_hire/routes/app_routes.dart';

class ChooseSkillsScreen extends StatefulWidget {
  final UserModel userData;
  const ChooseSkillsScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<ChooseSkillsScreen> createState() => _ChooseSkillsScreenState();
}

class _ChooseSkillsScreenState extends State<ChooseSkillsScreen> {
  final List<String> allSkills = [
    'C/C++', 'JavaScript', 'Python', 'Photoshop', 'Graphic design',
    'PHP', 'MySQL', 'Flutter', 'Kotlin', 'Dart', 'UI/UX', 'Node.js', 'React'
  ];
  final Set<String> selectedSkills = {};
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Initialize with data from widget.userData
    selectedLanguage = widget.userData.description;
    // If you had previous skills, add them to the set
    if (widget.userData.skills.isNotEmpty) {
      selectedSkills.addAll(widget.userData.skills);
    }
  }

 void _goToAboutYourself() {
  if (selectedSkills.length >= 5) {
    final updatedUser = widget.userData.copyWith(
      skills: selectedSkills.toList(),
      description: selectedLanguage,
    );
    
    Navigator.pushNamed(
      context,
      AppRoutes.aboutYourself,
      arguments: updatedUser, // Make sure this is passed
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select at least 5 skills'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/logo.jpg', height: 40),
                  DropdownButton<String>(
                    value: selectedLanguage,
                    underline: const SizedBox(),
                    items: ['EN', 'FR', 'AR'].map((String lang) {
                      return DropdownMenuItem<String>(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedLanguage = value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(child: Image.asset('assets/images/1.jpg', height: 150)),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 4, 26, 134),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose your skills (min 5):',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: allSkills.length,
                  itemBuilder: (context, index) {
                    final skill = allSkills[index];
                    return CheckboxListTile(
                      title: Text(skill),
                      value: selectedSkills.contains(skill),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedSkills.add(skill);
                          } else {
                            selectedSkills.remove(skill);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 4, 26, 134),
                      side: const BorderSide(color: Color.fromARGB(255, 4, 26, 134)),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(''),
                  ),
                  const Text(
                    '2/3',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 4, 26, 134),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _goToAboutYourself,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 4, 26, 134),
                      side: const BorderSide(color: Color.fromARGB(255, 4, 26, 134)),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text(''),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}