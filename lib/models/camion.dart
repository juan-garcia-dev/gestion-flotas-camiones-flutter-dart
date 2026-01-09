class Camion {
  int? id;
  String matricula;
  int cv;
  String estado;
  bool altaCapacidad;
  int asociacionId;

  Camion({
    this.id,
    required this.matricula,
    required this.altaCapacidad,
    required this.asociacionId,
    required this.cv,
    required this.estado,
  });
  factory Camion.fromMap(Map<String, dynamic> mapa) => Camion(
    matricula: mapa["matricula"],
    altaCapacidad: mapa["alta_capacidad"] == 1 ? true : false,
    asociacionId: mapa["asociacion_id"],
    cv: mapa["cv"],
    estado: mapa["estado"],
    id: mapa["id"]
  );
  Map<String, dynamic> toMap() => {
    "matricula": matricula,
    "cv": cv,
    "estado": estado,
    "alta_capacidad": altaCapacidad ? 1 : 0,
    "asociacion_id": asociacionId,
  };
}
