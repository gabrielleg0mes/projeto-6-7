// lib/data/models/bot_message_model.dart
import 'package:meuchat/domain/entities/bot_mensage_entity.dart';

class BotMessageModel extends BotMessageEntity {
  BotMessageModel({required super.content});

  factory BotMessageModel.fromJson(Map<String, dynamic> json) {
    return BotMessageModel(content: json['content']);
  }
}
