import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String jobTitle;
  final String jobId;

  const ChatScreen({
    Key? key,
    required this.contactName,
    required this.jobTitle,
    required this.jobId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  final List<ChatMessage> messages = [];
  bool isUploading = false;

  void _sendMessage() {
    if (messageController.text.trim().isEmpty) return;
    
    setState(() {
      messages.add(ChatMessage(
        type: 'text',
        content: messageController.text,
        isMe: true,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      ));
      messageController.clear();
    });
    messages.last.animationController.forward();
  }

  Future<void> _sendImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _sendFile(pickedImage.path, 'image');
    }
  }

  Future<void> _sendDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      _sendFile(result.files.single.path!, 'file');
    }
  }

  void _sendFile(String filePath, String type) async {
    setState(() => isUploading = true);
    
    // محاكاة عملية رفع الملف
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      messages.add(ChatMessage(
        type: type,
        content: filePath,
        isMe: true,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      ));
      isUploading = false;
    });
    messages.last.animationController.forward();
  }

  @override
  void dispose() {
    for (var message in messages) {
      message.animationController.dispose();
    }
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 4, 26, 134)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contactName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.jobTitle,
              style: const TextStyle(
                color: Color.fromARGB(255, 4, 26, 134),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return _buildMessageItem(message);
              },
            ),
          ),
          if (isUploading)
            const LinearProgressIndicator(
              color: Color.fromARGB(255, 4, 26, 134),
              minHeight: 2,
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: message.animationController,
        curve: Curves.easeOut,
      ),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: message.isMe ? Colors.deepPurple[100] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color.fromARGB(255, 4, 26, 134).withOpacity(0.3),
            ),
          ),
          child: message.type == 'text'
              ? Text(
                  message.content,
                  style: TextStyle(
                    color: message.isMe ? Colors.deepPurple[800] : Colors.black,
                  ),
                )
              : message.type == 'image'
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(message.content),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.insert_drive_file, 
                            size: 40, color:Color.fromARGB(255, 4, 26, 134)),
                        const SizedBox(height: 8),
                        Text(
                          message.content.split('/').last,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Color.fromARGB(255, 4, 26, 134)),
            onPressed: _sendDocument,
          ),
          IconButton(
            icon: const Icon(Icons.photo_camera, color: Color.fromARGB(255, 4, 26, 134)),
            onPressed: _sendImage,
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Colors.deepPurple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color.fromARGB(255, 4, 26, 134)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String type; // 'text', 'image', 'file'
  final String content;
  final bool isMe;
  final AnimationController animationController;

  ChatMessage({
    required this.type,
    required this.content,
    required this.isMe,
    required this.animationController,
  });
}

