import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_launcher.dart';
import '../../models/message_model.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.cookId, required this.cookName});
  final String cookId;
  final String cookName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<MessageModel> _messages = [
    MessageModel(id: '1', sender: MessageSender.cook, text: 'Hi! Thanks for booking with me 👋', timestamp: DateTime.now().subtract(const Duration(minutes: 10))),
    MessageModel(id: '2', sender: MessageSender.customer, text: 'Hi! Looking forward to it. Could you make it less spicy?', timestamp: DateTime.now().subtract(const Duration(minutes: 8))),
    MessageModel(id: '3', sender: MessageSender.cook, text: 'No problem at all, I will make it perfect for you 😊', timestamp: DateTime.now().subtract(const Duration(minutes: 6))),
  ];

  Future<void> _attachImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image == null) return;
    setState(() {
      _messages.add(MessageModel(
        id: DateTime.now().toIso8601String(),
        sender: MessageSender.customer,
        text: '📷 Photo: ${image.name}',
        timestamp: DateTime.now(),
      ));
    });
    // TODO: upload `image` to Firebase Storage / your media bucket and
    // send the resulting URL as an image message, not just its filename.
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(MessageModel(
        id: DateTime.now().toIso8601String(),
        sender: MessageSender.customer,
        text: _controller.text.trim(),
        timestamp: DateTime.now(),
      ));
      _controller.clear();
    });
    // TODO: send via Firestore/Stream Chat; also trigger a push
    // notification to the cook's app.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(radius: 16, backgroundColor: AppColors.primaryGreenLight, child: Icon(Icons.person, size: 18, color: AppColors.primaryGreen)),
            const SizedBox(width: 10),
            Text(widget.cookName, style: AppTextStyles.h3),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () => AppLauncher.call(context, '+254712345678'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final message = _messages[_messages.length - 1 - i];
                final isMe = message.sender == MessageSender.customer;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primaryGreen : context.surfaceColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: isMe ? null : Border.all(color: context.surfaceColors.divider),
                    ),
                    child: Text(
                      message.text,
                      style: AppTextStyles.bodyMedium.copyWith(color: isMe ? Colors.white : AppColors.textDark),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: AppColors.textMuted),
                    onPressed: _attachImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Type a message...'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen,
                    child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: _send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
