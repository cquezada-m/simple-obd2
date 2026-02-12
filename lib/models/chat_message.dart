/// A message in the AI chat conversation.
class ChatMessage {
  final String text;
  final ChatRole role;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.role,
    required this.timestamp,
  });
}

enum ChatRole { user, assistant }
