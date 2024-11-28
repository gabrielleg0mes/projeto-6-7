// lib/presentation/controllers/bot_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:meuchat/domain/usecases/call_bot_usecase.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasource/bot_remote_data_source.dart';
import '../../data/repositories/bot_repository_impl.dart';
import '../../domain/entities/bot_mensage_entity.dart';

class UolChatController with ChangeNotifier {
  final ValueNotifier<List<(types.Message, types.Message?)>> messagesNotifier =
      ValueNotifier([]);
  final ValueNotifier<bool> isAudio = ValueNotifier(false);
  final user = const types.User(id: '1');
  final bot = const types.User(id: "2");

  late final CallBotUsecase _callBot;

  UolChatController() {
    _callBot = CallBotUsecase(
        BotRepositoryImpl(remoteDataSource: BotRemoteDataSourceImpl()));
    _loadMessages();
  }

  void _loadMessages() {
    messagesNotifier.value.add((
      types.TextMessage(
        author: bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: "Olá eu sou seu assistente UOL Compass",
      ),
      null
    ));
    messagesNotifier.notifyListeners();
  }

  void _addMessage((types.Message, types.AudioMessage?) message) {
    messagesNotifier.value.insert(0, message);
    messagesNotifier.notifyListeners(); // Notifica os ouvintes
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage((textMessage, null));

    _callBot.execute(message.text).then((response) {
      for (var botMessage in response) {
        _addMessage(botMessageReply(botMessage));
      }
    });
  }

  (types.Message, types.AudioMessage?) botMessageReply(
      BotMessageEntity messageEntity) {
    return (
      types.TextMessage(
        author: bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: messageEntity.content,
      ),
      messageEntity.audioUrl != null
          ? types.AudioMessage(
              duration: const Duration(seconds: 3),
              size: (18.4 * 1024),
              author: bot,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: const Uuid().v4(),
              uri: messageEntity.audioUrl!,
              name: messageEntity.content)
          : null
    );
  }

  void handleAttachmentPressed() {
    isAudio.value = !isAudio.value;
  }
}
