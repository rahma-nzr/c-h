//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_hire/features/home/request_list_screen.dart';
import 'package:code_hire/features/notifications/notifications_screen.dart';
import 'package:code_hire/features/search/search_screen.dart';
import 'package:code_hire/features/profile/profile_screen.dart';
import 'package:code_hire/features/messages/chat_list_screen.dart';
import 'package:code_hire/features/home/job_details_screen.dart';
import 'package:code_hire/features/auth/models/job_offer_model.dart';

class HomeScreen extends StatefulWidget {
  final bool showSuccessMessage;

  const HomeScreen({Key? key, this.showSuccessMessage = false}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSuccess = false;
  int _currentIndex = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.showSuccessMessage) {
      _showSuccess = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    ChatListScreen(),
    Placeholder(),
    ProfileScreen(),
  ];


  }

  Future<List<JobOffer>> fetchJobsFiltered() async {
    final userSkills = ['C/C++', 'JavaScript', 'Python', 'Photoshop', 'Graphic design', 'PHP', 'MySQL', 'Flutter', 'Kotlin', 'Dart', 'UI/UX', 'Node.js', 'React'];
    final allJobs = await getMockJobs();
    return allJobs.where((job) => job.skills.any((skill) => userSkills.contains(skill))).take(25).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2FA),
      appBar: _currentIndex == 1
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
  // In home_screen.dart - update the leading icon in AppBar
leading: IconButton(
  icon: const Icon(Icons.list_alt, color: Color.fromARGB(255, 4, 26, 134)),
  onPressed: () {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RequestsListScreen(developerId: user.uid),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to view requests')),
      );
    }
  },
),
              title: const Text(
                'CodeHire',
                style: TextStyle(
                  color: Color.fromARGB(255, 4, 26, 134),
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                    );
                  },
                  icon: const Icon(Icons.notifications_none, color: Color.fromARGB(255, 4, 26, 134)),
                ),
              ],
            )
          : null,
      body: _currentIndex == 1 ? buildHomeContent() : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 4, 26, 134),
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for jobs or people...',
                  prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 4, 26, 134)),
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color:Color.fromARGB(255, 4, 26, 134) ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(searchQuery: value),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Suggestions based on your skills:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 4, 26, 134) ,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<JobOffer>>(
              future: fetchJobsFiltered(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No job suggestions found.");
                }

                final suggestions = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final job = suggestions[index];
                    return Card(
                      color: Color.fromARGB(255, 192, 197, 225) ,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Color.fromARGB(255, 4, 26, 134) ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 4, 26, 134) ,
                              ),
                            ),
                            Text(
                              'By: ${job.nameBusinessOwner}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 4, 26, 134) ,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            job.description,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailsScreen(
                                  key: UniqueKey(),
                                  title: job.title,
                                  description: job.description,
                                  clientName: job.nameBusinessOwner,
                                  duration: job.duration,
                                  budget: job.budget,
                                  skills: job.skills,
                                  jobId: job.jobID, clientId: '', companyName: '',
                                ),
                                settings: RouteSettings(arguments: {
                                  'jobId': job.jobID,
                                  'jobData': job.toFirestore(),
                                }),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 4, 26, 134) ,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Learn more...'),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
