import '../models/sector.dart';
import '../database/database_helper.dart';

class SectorRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertSector(Sector sector) async {
    return await _dbHelper.insert('Sector', sector.toMap());
  }

  Future<Sector?> getSectorById(int sectorId) async {
    final result = await _dbHelper.query(
      'Sector',
      where: 'SectorId = ?',
      whereArgs: [sectorId],
    );
    if (result.isNotEmpty) {
      return Sector.fromMap(result.first);
    }
    return null;
  }

  Future<List<Sector>> getAllSectors() async {
    final result = await _dbHelper.query('Sector');
    return result.map((map) => Sector.fromMap(map)).toList();
  }

  Future<int> updateSector(Sector sector) async {
    return await _dbHelper.update(
      'Sector',
      sector.toMap(),
      where: 'SectorId = ?',
      whereArgs: [sector.sectorId],
    );
  }

  Future<int> deleteSector(int sectorId) async {
    return await _dbHelper.delete(
      'Sector',
      where: 'SectorId = ?',
      whereArgs: [sectorId],
    );
  }
}
