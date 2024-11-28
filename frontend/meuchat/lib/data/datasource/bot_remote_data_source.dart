// lib/data/sources/bot_remote_data_source.dart

import 'dart:convert';
import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meuchat/domain/entities/bot_mensage_entity.dart';
import '../models/bot_message_model.dart';
import 'package:http/http.dart' as http;
import '../models/tts_response_model.dart';

// Interface para a fonte de dados remota do bot
abstract class BotRemoteDataSource {
  Future<List<BotMessageEntity>> callBot(String message);
}

// Implementação da fonte de dados remota do bot
class BotRemoteDataSourceImpl implements BotRemoteDataSource {
  // Carrega as configurações do ambiente
  final String kRegion = dotenv.env['AWS_REGION'] ?? '';
  final String botID = dotenv.env['AWS_BOT_ID'] ?? '';
  final String botAlias = dotenv.env['AWS_BOT_ALIAS'] ?? '';

  @override
  Future<List<BotMessageEntity>> callBot(String message) async {
    // Configura as credenciais AWS
    final credentials = AWSCredentials(
      dotenv.env['AWS_ACCESS_KEY_ID'] ?? '',
      dotenv.env['AWS_SECRET_ACCESS_KEY'] ?? '',
      dotenv.env['AWS_SESSION_TOKEN'],
    );

    // Configura o assinador AWS SigV4
    final signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(credentials),
    );

    // Define o escopo das credenciais
    final scope = AWSCredentialScope(
      region: kRegion,
      service: AWSService.lexRuntimeService,
    );

    // Cria a requisição HTTP para o AWS Lex
    final request = AWSHttpRequest(
      method: AWSHttpMethod.post,
      uri: Uri.https(
        'runtime-v2-lex.$kRegion.amazonaws.com',
        '/bots/$botID/botAliases/$botAlias/botLocales/pt_BR/sessions/user/text',
      ),
      headers: const {
        AWSHeaders.contentType: 'application/json',
      },
      body: json.encode({"text": message}).codeUnits,
    );

    // Assina a requisição
    final signedRequest = await signer.sign(
      request,
      credentialScope: scope,
    );

    // Envia a requisição e obtém a resposta
    final resp = await signedRequest.send().response;
    final respBody = await resp.decodeBody();
    final response = json.decode(respBody);

    // Processa a resposta e converte em uma lista de mensagens
    List<BotMessageEntity> messagesList = [];
    if (response.containsKey("messages")) {
      for (var msg in response["messages"]) {
        var message = BotMessageModel.fromJson(msg);
        final ttsResponse = await sendTextToTTS(message.content);
        message.audioUrl = ttsResponse?.urlToAudio;
        messagesList.add(message);
      }
    }

    return messagesList;
  }

  // Envia texto para o serviço TTS e retorna a resposta
  Future<TTSResponseModel?> sendTextToTTS(String phrase) async {
    final response = await http.post(
      Uri.parse(dotenv.env['AWS_API_TTS_URL'] ?? ''),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({"phrase": phrase}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return TTSResponseModel.fromJson(responseData);
    }
    return null;
  }
}
