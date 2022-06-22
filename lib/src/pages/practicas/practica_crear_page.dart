import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:reproductor/src/controllers/practicas_controller.dart';
import 'package:reproductor/src/models/Curso.dart';

class PracticaCrearPage extends StatefulWidget {
  PracticaCrearPage({Key? key}) : super(key: key);

  @override
  State<PracticaCrearPage> createState() => _PracticaCrearPageState();
}

class _PracticaCrearPageState extends State<PracticaCrearPage> {
  final practicas = Get.find<PracticasController>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Practica'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => DropdownButton<CursoClase>(
                    value: practicas.cursoClase.value,
                    items: practicas.curso.value.cursoClases
                        .map(
                          (data) => DropdownMenuItem(
                            child: Text(data.claseTitulo),
                            value: data,
                          ),
                        )
                        .toList(),
                    onChanged: (option) {
                      practicas.cursoClase.value = option!;
                      practicas.update();
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Autocomplete<CursoAlumno>(
                  displayStringForOption: (option) => option.username,
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return <CursoAlumno>[];
                    }
                    return practicas.curso.value.cursoAlumnos
                        .where((element) =>
                            element.alumnoStatus == 'ACTIVO' &&
                            element.role == 3)
                        .toList()
                        .where((element) => element.username
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .toList();
                  },
                  onSelected: (option) {
                    practicas.handleAddAlumno(option);
                  },
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Obx(
                  () => Container(
                    width: size.width,
                    height: size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final alumno = practicas.cursoAlumnos[index];

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              alumno.username.substring(0, 2),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(alumno.username),
                          subtitle: Text(alumno.email),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              practicas.cursoAlumnos.removeAt(index);
                              practicas.update();
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: practicas.cursoAlumnos.length,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Precio',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      practicas.precio.value = double.parse(value);
                    } else {
                      practicas.precio.value = 0;
                    }

                    practicas.update();
                  },
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                // DATE PICKER PARA SELECCIONAR LA FECHA DE LA PRACTICA
                Obx(
                  () => TextButton(
                    onPressed: () async {
                      try {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: practicas.fechaPractica.value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2050),
                        );

                        if (date != null) {
                          practicas.fechaPractica.value = date;
                          practicas.update();
                        }
                      } catch (e) {}
                    },
                    child: Text(
                      'Practica Pautada para el dia ${practicas.fechaPractica.value.day}/${practicas.fechaPractica.value.month}/${practicas.fechaPractica.value.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await practicas.handleCreatePractica(context);

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text('Pautar Practica'),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
