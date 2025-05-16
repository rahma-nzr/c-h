import 'package:flutter/material.dart';
import 'package:code_hire/features/messages/chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> chatList = [
    {
      'name': 'Mouhamed Ali',
      'jobTitle': 'Mobile App Development',
      'jobId': 'project_001',
      'unread': false,
      'time': '10:30 AM',
    },
    {
      'name': 'Farouk',
      'jobTitle': 'Website Redesign',
      'jobId': 'project_002',
      'unread': false,
      'time': 'Yesterday',
    },
    {
      'name': 'Houssam Ibrahim',
      'jobTitle': 'E-commerce Solution',
      'jobId': 'project_003',
      'unread': false,
      'time': '2 days ago',
    },
    {
      'name': 'Nour Elhouda',
      'jobTitle': 'Logo Design',
      'jobId': 'project_004',
      'unread': false,
      'time': '1 week ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2FA),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 4, 26, 134),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: ListView.separated(
              itemCount: chatList.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = chatList[index];
                return Dismissible(
                  key: Key(chat['jobId']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Conversation'),
                        content: const Text('Are you sure you want to delete this conversation?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    setState(() {
                      chatList.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Conversation deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              chatList.insert(index, chat);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            contactName: chat['name'],
                            jobTitle: chat['jobTitle'],
                            jobId: chat['jobId'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: chat['unread'] ? Color.fromARGB(255, 4, 26, 134).withOpacity(0.05) : Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color.fromARGB(255, 4, 26, 134),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chat['name'],
                                      style: TextStyle(
                                        fontWeight: chat['unread'] ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      chat['time'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  chat['jobTitle'],
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 4, 26, 134),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                          if (chat['unread'])
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 4, 26, 134),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}