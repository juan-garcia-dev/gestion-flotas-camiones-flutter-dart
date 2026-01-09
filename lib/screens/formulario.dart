import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_camiones/models/camion.dart';
import 'package:proyecto_camiones/providers/provider_db.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  String? estadoSeleccionado = "Nuevo";
  bool altaCapacidad = false;
  String? matricula;
  int? cv;
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ProviderDb provider = Provider.of<ProviderDb>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Formulario Alta')),
      body: Form(
        key: key,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
              
                validator: (value) {
                  if (value!.isEmpty) {
                    return "El campo no puede estar vacion";
                  }if(value.length<7){
                    return "Especifica la matricula de manera correcta";
                  }
                },
                decoration: InputDecoration(hint: Text("Introduce Matrícula del camión"),labelText: "Matricula"),
                maxLength: 7,
                onChanged: (value) {
                  setState(() {
                    matricula = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                maxLength: 3,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "El campo no puede estar vacion";
                  }
                  int? cv = int.tryParse(value);
                  if (cv == null) {
                    return "El campo debe ser numérico";
                  }
                },
                decoration: InputDecoration(hint: Text("Especifica los cv del camión"),labelText: "cv"),
                onChanged: (value) {
                  setState(() {
                    cv = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            ...provider.estados.map(
              (e) => RadioListTile(
                // ignore: deprecated_member_use
                groupValue: estadoSeleccionado,
                title: Text(e),
                value: e,
                // ignore: deprecated_member_use
                onChanged: (value) {
                  setState(() {
                    estadoSeleccionado = value!;
                  });
                },
              ),
            ),
            SwitchListTile(
              subtitle: Text(altaCapacidad?"Si":"No"),
              title: Text("¿Permite alta capacidad?"),
              value: altaCapacidad,
              onChanged: (value) {
                setState(() {
                  altaCapacidad = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (key.currentState!.validate()) {
                  Camion camion = Camion(
                    matricula: matricula!,
                    altaCapacidad: altaCapacidad,
                    asociacionId: provider.idAsociacionSeleccionada,
                    cv: cv!,
                    estado: estadoSeleccionado!,
                  );
                  await provider.insertarCamion(camion);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Insertado con ID ${camion.id}")),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Añadir"),
            ),
          ],
        ),
      ),
    );
  }
}
