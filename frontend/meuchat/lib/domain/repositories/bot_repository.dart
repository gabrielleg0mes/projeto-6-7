// lib/domain/repositories/bot_repository.dart
import 'package:meuchat/domain/entities/bot_mensage_entity.dart';

abstract class BotRepository {
  Future<List<BotMessageEntity>> callBot(String message);
}
