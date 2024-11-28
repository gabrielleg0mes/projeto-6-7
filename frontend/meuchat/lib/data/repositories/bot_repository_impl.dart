// lib/data/repositories/bot_repository_impl.dart
import 'package:meuchat/domain/entities/bot_mensage_entity.dart';

import '../../domain/repositories/bot_repository.dart';
import '../datasource/bot_remote_data_source.dart';

class BotRepositoryImpl implements BotRepository {
  final BotRemoteDataSource remoteDataSource;

  BotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BotMessageEntity>> callBot(String message) async {
    final botMessages = await remoteDataSource.callBot(message);
    return botMessages;
  }
}
