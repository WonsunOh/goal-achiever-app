import 'package:drift/drift.dart';
import '../local/database.dart';
import '../models/motivation_message.dart' as model;
import '../models/enums.dart';

class MotivationMessageRepository {
  final AppDatabase _database;

  MotivationMessageRepository(this._database);

  Future<List<model.MotivationMessage>> getAllMessages() async {
    final messages = await _database.getAllMotivationMessages();
    return messages.map(_mapToModel).toList();
  }

  Future<List<model.MotivationMessage>> getMessagesByType(
      MotivationType type) async {
    final messages = await _database.getMessagesByType(type);
    return messages.map(_mapToModel).toList();
  }

  Future<void> createMessage(model.MotivationMessage message) async {
    await _database.insertMotivationMessage(_mapToCompanion(message));
  }

  Future<void> deleteMessage(String id) async {
    await _database.deleteMotivationMessage(id);
  }

  Future<model.MotivationMessage?> getRandomMessage(MotivationType type) async {
    final messages = await getMessagesByType(type);
    if (messages.isEmpty) return null;
    messages.shuffle();
    return messages.first;
  }

  model.MotivationMessage _mapToModel(MotivationMessage dbMessage) {
    return model.MotivationMessage(
      id: dbMessage.id,
      message: dbMessage.message,
      type: dbMessage.type,
      createdAt: dbMessage.createdAt,
    );
  }

  MotivationMessagesCompanion _mapToCompanion(model.MotivationMessage message) {
    return MotivationMessagesCompanion(
      id: Value(message.id),
      message: Value(message.message),
      type: Value(message.type),
      createdAt: Value(message.createdAt),
    );
  }
}
