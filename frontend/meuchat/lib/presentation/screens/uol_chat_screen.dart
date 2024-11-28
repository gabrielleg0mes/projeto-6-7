// lib/presentation/screens/uol_chat_screen.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meuchat/presentation/controller/uol_chat.controller.dart';

class UolChatScreen extends StatelessWidget {
  final UolChatController controller = UolChatController();
  final AudioPlayer audioPlayer = AudioPlayer(); // Instância do AudioPlayer

  UolChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Column(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/compass-uol.svg',
                      width: 25.0, // Largura desejada
                      height: 25.0, // Altura desejada
                    ),
                  ),
                  const Text(
                    "grupo 4",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: controller.isAudio,
                  builder: (context, isAudio, child) {
                    return ValueListenableBuilder<
                        List<(types.Message, types.Message?)>>(
                      valueListenable: controller.messagesNotifier,
                      builder: (context, messages, child) {
                        final List<types.Message> messageList = isAudio
                            ? messages
                                .map((item) =>
                                    item.$2 ??
                                    item.$1) // Se $2 for nulo, pega $1
                                .toList()
                            : messages.map((item) => item.$1).toList();
                        return Chat(
                          messages: messageList,
                          audioMessageBuilder: (types.AudioMessage audioMessage,
                              {required int messageWidth}) {
                            return GestureDetector(
                              onTap: () async {
                                // Tocar o áudio ao tocar na mensagem
                                await audioPlayer
                                    .play(UrlSource(audioMessage.uri));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .blueAccent, // Cor de fundo do botão
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.play_arrow,
                                        color: Colors.white), // Ícone de play
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        audioMessage.createdAt
                                            .toString(), // Nome ou descrição do áudio
                                        style: const TextStyle(
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onSendPressed: controller.handleSendPressed,
                          showUserAvatars: false,
                          showUserNames: true,
                          user: controller.user,
                          theme: DefaultChatTheme(
                            inputBackgroundColor: Colors.black,
                            inputBorderRadius: BorderRadius.circular(
                                15), // Arredondar as arestas
                            inputTextColor: Colors.white,
                            inputTextStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
