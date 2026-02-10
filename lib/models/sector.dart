class Sector {
  final int? sectorId;
  final String sectorName;

  Sector({this.sectorId, required this.sectorName});

  Map<String, dynamic> toMap() {
    return {
      'SectorId': sectorId,
      'SectorName': sectorName,
    };
  }

  factory Sector.fromMap(Map<String, dynamic> map) {
    return Sector(
      sectorId: map['SectorId'],
      sectorName: map['SectorName'],
    );
  }
}
