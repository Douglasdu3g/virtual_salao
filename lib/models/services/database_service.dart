import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../agendamento.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'virtual_salao.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE agendamentos(
        id TEXT PRIMARY KEY,
        barbeiroid TEXT,
        data TEXT,
        servico TEXT,
        preco REAL,
        status TEXT
      )
    ''');
  }

  // Salvar agendamento
  Future<void> salvarAgendamento(Agendamento agendamento) async {
    final Database db = await database;
    await db.insert(
      'agendamentos',
      agendamento.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Buscar todos agendamentos de um barbeiro
  Future<List<Agendamento>> buscarAgendamentosPorBarbeiro(
      String barbeiroid) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'agendamentos',
      where: 'barbeiroid = ?',
      whereArgs: [barbeiroid],
    );
    return List.generate(maps.length, (i) => Agendamento.fromJson(maps[i]));
  }

  // Verificar se horário está disponível
  Future<bool> horarioDisponivel(String barbeiroid, DateTime data) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'agendamentos',
      where: 'barbeiroid = ? AND data = ?',
      whereArgs: [barbeiroid, data.toIso8601String()],
    );
    return result.isEmpty;
  }

  // Atualizar status do agendamento
  Future<void> atualizarStatusAgendamento(String id, String novoStatus) async {
    final Database db = await database;
    await db.update(
      'agendamentos',
      {'status': novoStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
