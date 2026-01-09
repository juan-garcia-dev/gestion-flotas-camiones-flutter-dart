import 'package:flutter/widgets.dart';
import 'package:proyecto_camiones/models/asociacion.dart';
import 'package:proyecto_camiones/models/camion.dart';
import 'package:proyecto_camiones/services/service_db.dart';

class ProviderDb with ChangeNotifier {
  ServiceDb service = ServiceDb.instance;

  List<Asociacion> asociaciones = [];
  List<Camion> camiones = [];
  List<Camion> todosCamiones = [];
  List<String> estados = ["Nuevo", "Aceptable", "Mal estado"];
  int idAsociacionSeleccionada = 1;
  int? idCamionGenerado;


  Future<void> insertarCamion(Camion camion) async {
    int id = await service.insertaCamion(camion);
    idCamionGenerado = id;
    camion.id = idCamionGenerado;
    notifyListeners();
  }


  Future<List<Camion>> getCamionesByAsociacion() async {
    camiones = await service.getCamionesByAsociacion(idAsociacionSeleccionada);
    return camiones;
  }

  Future<List<Asociacion>> getAsociaciones() async {
    asociaciones = await service.getAsociaciones();
    return asociaciones;
  }

  void cambiarIdAsociacion(int id) {
    idAsociacionSeleccionada = id;
    notifyListeners();
  }

  Future<void> eliminarCamion(Camion camion) async {
    await service.eliminarCamion(camion);
    notifyListeners();
  }

  Future<void> modificarCamion(Camion camion) async {
    await service.modificarCamion(camion);
    notifyListeners();
  }
}
