// lib/data/models/tts_response_model.dart
class TTSResponseModel {
  final String message;
  final String id;
  final String urlToAudio;

  TTSResponseModel({
    required this.message,
    required this.id,
    required this.urlToAudio,
  });

  factory TTSResponseModel.fromJson(Map<String, dynamic> json) {
    return TTSResponseModel(
      message: json['message'],
      id: json['id'],
      urlToAudio: json['url_to_audio'],
    );
  }
}
