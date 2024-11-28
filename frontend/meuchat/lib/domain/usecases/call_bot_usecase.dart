// lib/domain/usecases/call_bot.dart
import 'package:meuchat/domain/entities/bot_mensage_entity.dart';

import '../repositories/bot_repository.dart';

class CallBotUsecase {
  final BotRepository repository;

  CallBotUsecase(this.repository);

  Future<List<BotMessageEntity>> execute(String message) {
    return repository.callBot(message);
  }
}
