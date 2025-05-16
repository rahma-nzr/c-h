import 'package:flutter/material.dart';
import '../../core/constants.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required String searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            searchField(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  projectItem('Hassan Wall', 'We are looking for a professional C++ developer...'),
                  projectItem('Karim Kassem', 'We are looking for a skilled C++ developer...'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: customBottomNavBar(),
    );
  }

  Widget searchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search skills...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget projectItem(String name, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: AppColors.accentColor),
        title: Text(name),
        subtitle: Text(description),
        trailing: TextButton(
          onPressed: () {},
          child: const Text('Learn more...'),
        ),
      ),
    );
  }

  Widget customBottomNavBar() {
    return BottomNavigationBar(
      selectedItemColor: AppColors.primaryColor,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
