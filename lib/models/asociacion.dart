class Asociacion {
  int id;
  String nombre;

  Asociacion({required this.id, required this.nombre});
  factory Asociacion.fromMap(Map<String, dynamic> mapa) =>
      Asociacion(id: mapa["id"], nombre: mapa["nombre"]);
  Map<String, dynamic> toMap() => {"nombre": nombre};
}
