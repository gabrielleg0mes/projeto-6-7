// lib/domain/entities/bot_message.dart
class BotMessageEntity {
  final String content;
  String? audioUrl;

  BotMessageEntity({this.audioUrl, required this.content});
}
