import 'package:path/path.dart';
import 'package:proyecto_camiones/models/asociacion.dart';
import 'package:proyecto_camiones/models/camion.dart';
import 'package:sqflite/sqflite.dart';

class ServiceDb {
  static final ServiceDb instance = ServiceDb._();
  ServiceDb._();
  static final String _nombreDB = "camion.db";
  static final int _numVersion = 1;

  Database? _database;

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), _nombreDB),
      version: _numVersion,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE asociacion (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL
);
''');
        await db.execute('''
CREATE TABLE camion (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    matricula TEXT NOT NULL,
    cv INTEGER NOT NULL,
    estado TEXT,
    alta_capacidad INTEGER NOT NULL, 
    asociacion_id INTEGER NOT NULL,
    FOREIGN KEY (asociacion_id) REFERENCES asociacion(id)
);
''');
        await db.insert("asociacion", {"nombre": "Logística Noroeste"});
        await db.insert("asociacion", {"nombre": "TransGalicia"});
        await db.insert("asociacion", {"nombre": "Rutas del Sur"});
      },
    );
  }

  Future<int> insertaCamion(Camion camion) async {
    final database = await db;
    int id = await database.insert("camion", camion.toMap());
    return id;
  }

  Future<List<Camion>> getCamiones() async {
    final database = await db;
    final datos = await database.query("camion");
    return datos.map((e) => Camion.fromMap(e)).toList();
  }

  Future<List<Camion>> getCamionesByAsociacion(int id) async {
    final database = await db;
    final datos = await database.query(
      "camion",
      where: "asociacion_id=?",
      whereArgs: [id],
    );
    return datos.map((e) => Camion.fromMap(e)).toList();
  }

  Future<List<Asociacion>> getAsociaciones() async {
    final database = await db;
    final datos = await database.query("asociacion");
    return datos.map((e) => Asociacion.fromMap(e)).toList();
  }

  Future<void> eliminarCamion(Camion camion) async {
    final database = await db;
    await database.delete("camion", where: "id=?", whereArgs: [camion.id]);
  }

  Future<void> modificarCamion(Camion camion) async {
    final database = await db;
    await database.update(
      "camion",
      camion.toMap(),
      where: "id=?",
      whereArgs: [camion.id],
    );
    
  }
}
