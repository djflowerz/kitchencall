enum MessageSender { customer, cook }

class MessageModel {
  final String id;
  final MessageSender sender;
  final String text;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}
