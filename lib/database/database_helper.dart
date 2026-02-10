import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'civic_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    final batch = db.batch();
    await db.execute('PRAGMA foreign_keys = ON');

    batch.execute('''
      CREATE TABLE Ministry (
        MinistryId INTEGER PRIMARY KEY AUTOINCREMENT,
        MinistryName TEXT NOT NULL
      )''');

    batch.execute('''
      INSERT INTO Ministry (MinistryName) VALUES
        ('Chief Ministry'),
        ('Agricultural Ministry'),
        ('Fishery Ministry'),
        ('Sports Ministry'),
        ('Education Ministry')
      ''');

    batch.execute('''
      CREATE TABLE Sector (
        SectorId INTEGER PRIMARY KEY AUTOINCREMENT,
        SectorName TEXT NOT NULL
      )
    ''');

    batch.execute('''
      INSERT INTO Sector (SectorName) VALUES
        ('Planning Sector'),
        ('Evaluation Sector')
      ''');

    batch.execute('''
      CREATE TABLE User (
        UserId INTEGER PRIMARY KEY AUTOINCREMENT,
        Username TEXT UNIQUE NOT NULL,
        Password TEXT NOT NULL,
        MinistryId INTEGER,
        SectorId INTEGER,
        FOREIGN KEY (MinistryId) REFERENCES Ministry(MinistryId),
        FOREIGN KEY (SectorId) REFERENCES Sector(SectorId)
      )''');

    batch.execute('''
      CREATE TABLE Response (
        ResponseId INTEGER PRIMARY KEY AUTOINCREMENT,
        FormId INTEGER,
        UserId INTEGER,
        ResponseStatus TEXT,
        FOREIGN KEY (FormId) REFERENCES Form(FormId),
        FOREIGN KEY (UserId) REFERENCES User(UserId)
      )''');

    batch.execute('''
      CREATE TABLE Question (
        QuestionId INTEGER PRIMARY KEY AUTOINCREMENT,
        QuestionText TEXT NOT NULL,
        QuestionType TEXT,
        FormId INTEGER,
        FOREIGN KEY (FormId) REFERENCES Form(FormId)
      )''');

    batch.execute('''
      CREATE TABLE Answer (
        AnswerId INTEGER PRIMARY KEY AUTOINCREMENT,
        AnswerText TEXT,
        QuestionId INTEGER,
        ResponseId INTEGER,
        FOREIGN KEY (QuestionId) REFERENCES Question(QuestionId),
        FOREIGN KEY (ResponseId) REFERENCES Response(ResponseId)
      )''');

    batch.execute('''
      CREATE TABLE Media (
        MediaId INTEGER PRIMARY KEY AUTOINCREMENT,
        MediaName TEXT,
        MediaType TEXT,
        Extension TEXT,
        Location TEXT,
        AnswerId INTEGER,
        FOREIGN KEY (AnswerId) REFERENCES Answer(AnswerId)
      )''');

    batch.execute('''
      CREATE TABLE Choice (
        ChoiceId INTEGER PRIMARY KEY AUTOINCREMENT,
        ChoiceText TEXT,
        QuestionId INTEGER,
        FOREIGN KEY (QuestionId) REFERENCES Question(QuestionId)
      )''');

    batch.execute('''
      CREATE TABLE AnswerChoice (
        AnswerId INTEGER,
        ChoiceId INTEGER,
        PRIMARY KEY (AnswerId, ChoiceId),
        FOREIGN KEY (AnswerId) REFERENCES Answer(AnswerId),
        FOREIGN KEY (ChoiceId) REFERENCES Choice(ChoiceId)
      )''');

    batch.execute('''
      CREATE TABLE Form (
        FormId INTEGER PRIMARY KEY AUTOINCREMENT,
        ProjectId INTEGER,
        FOREIGN KEY (ProjectId) REFERENCES Project(ProjectId)
      )''');

    batch.execute('''
      CREATE TABLE Project(
        ProjectId INTEGER PRIMARY KEY AUTOINCREMENT,
        ProjectName TEXT,
        ProjectLocation TEXT,
        ProjectDescription TEXT,
        ProjectStatus TEXT,
        MinistryId INTEGER,
        FundSource TEXT,
        UserId INTEGER,
        StartedDate TEXT,
        FinishedDate TEXT
      )''');

    batch.execute('''
      CREATE TABLE ProjectAssignment (
        ProjectAssignmentId INTEGER PRIMARY KEY AUTOINCREMENT,
        ProjectId INTEGER,
        UserId INTEGER
      )
    ''');

    batch.execute('''
      CREATE TABLE UserCreatesProject (
          UCPId INTEGER PRIMARY KEY,
          UserId INTEGER,
          ProjectId INTEGER,
          FOREIGN KEY (UserId) REFERENCES User(UserId),
          FOREIGN KEY (ProjectId) REFERENCES Project(ProjectId)
      )''');

    // batch.execute(
    //     ''' CREATE TABLE MinistrySector ( MinistryId INTEGER NOT NULL, SectorId INTEGER NOT NULL, PRIMARY KEY (MinistryId, SectorId), FOREIGN KEY (MinistryId) REFERENCES Ministry (MinistryId) ON DELETE CASCADE, FOREIGN KEY (SectorId) REFERENCES Sector (SectorId) ON DELETE CASCADE ) ''');

    // batch.execute('''
    //   INSERT INTO MinistrySector (MinistryId, SectorId) VALUES
    //     (1, 1),
    //     (1, 2),
    //     (2, 1),
    //     (2, 2),
    //     (3, 1),
    //     (3, 2),
    //     (4, 1),
    //     (4, 2),
    //     (5, 1),
    //     (5, 2)
    //   ''');

    await batch.commit();
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
