import '../models/media.dart';
import '../database/database_helper.dart';

class MediaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertMedia(Media media) async {
    return await _dbHelper.insert('Media', media.toMap());
  }

  Future<Media?> getMediaById(int mediaId) async {
    final result = await _dbHelper.query(
      'Media',
      where: 'MediaId = ?',
      whereArgs: [mediaId],
    );
    if (result.isNotEmpty) {
      return Media.fromMap(result.first);
    }
    return null;
  }

  Future<List<Media>> getAllMedia() async {
    final result = await _dbHelper.query('Media');
    return result.map((map) => Media.fromMap(map)).toList();
  }

  Future<List<Media>> getMediaByAnswerId(int answerId) async {
    final result = await _dbHelper.query(
      'Media',
      where: 'AnswerId = ?',
      whereArgs: [answerId],
    );
    return result.map((map) => Media.fromMap(map)).toList();
  }

  Future<int> updateMedia(Media media) async {
    return await _dbHelper.update(
      'Media',
      media.toMap(),
      where: 'MediaId = ?',
      whereArgs: [media.mediaId],
    );
  }

  Future<int> deleteMedia(int mediaId) async {
    return await _dbHelper.delete(
      'Media',
      where: 'MediaId = ?',
      whereArgs: [mediaId],
    );
  }
}
