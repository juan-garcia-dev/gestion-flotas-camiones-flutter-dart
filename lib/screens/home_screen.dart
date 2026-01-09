import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_camiones/providers/provider_db.dart';
import 'package:proyecto_camiones/screens/formulario.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Formulario()),
          );
        },
        child: Icon(Icons.add),
      ),

      appBar: AppBar(
        title: Text('Flota camiones'),
        
      ),
      body: Column(
        children: [
          DesplegableAsociaciones(),
          Expanded(child: ListaCamiones()),
        ],
      ),
    );
  }
}

class DesplegableAsociaciones extends StatelessWidget {
  const DesplegableAsociaciones({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderDb provider = Provider.of<ProviderDb>(context, listen: true);
    return FutureBuilder(
      future: provider.getAsociaciones(),
      builder: (context, snapshot) {
        final datos = snapshot.data ?? [];
        return Center(
          child: DropdownButton(
            barrierDismissible: false,
            iconSize: 20,
            icon: Icon(Icons.arrow_downward_rounded),
            style: TextStyle(fontSize: 20, color: Colors.black),
            padding: EdgeInsets.all(10),
            elevation: 4,
            dropdownColor: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            hint: Text("Selecciona asociacion"),
            value: provider.idAsociacionSeleccionada,
            items: datos
                .map(
                  (e) =>
                      DropdownMenuItem<int>(value: e.id, child: Text(e.nombre)),
                )
                .toList(),
            onChanged: (value) {
              provider.cambiarIdAsociacion(value!);
            },
          ),
        );
      },
    );
  }
}

class ListaCamiones extends StatelessWidget {
  const ListaCamiones({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderDb provider = Provider.of<ProviderDb>(context, listen: true);

    return FutureBuilder(
      future: provider.getCamionesByAsociacion(),
      builder: (context, snapshot) {
        final datos = snapshot.data ?? [];
        return datos.isEmpty
            ? Center(child: Text("No hay camiones en esta Asociacion"))
            : ListView.builder(
                itemCount: datos.length,
                itemBuilder: (context, index) {
                  final camion = datos[index];
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      tileColor: const Color.fromARGB(255, 231, 245, 252),
                      title: Text(camion.matricula),
                      trailing: IconButton(
                        onPressed: () async {
                          await provider.eliminarCamion(camion);
                        },
                        icon: Icon(Icons.delete),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(camion.estado),
                          Text(
                            camion.altaCapacidad
                                ? "Alta Capacidad"
                                : "Baja Capacidad",
                            style: TextStyle(
                              color: camion.altaCapacidad
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
