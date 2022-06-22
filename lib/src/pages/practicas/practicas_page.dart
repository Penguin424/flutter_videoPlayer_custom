import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/practicas_controller.dart';

class PracticasPage extends StatefulWidget {
  PracticasPage({Key? key}) : super(key: key);

  @override
  State<PracticasPage> createState() => _PracticasPageState();
}

class _PracticasPageState extends State<PracticasPage> {
  final practicas = Get.find<PracticasController>();

  @override
  void initState() {
    practicas.handleGetPracticas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/practicas/crear',
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Text('Practicas'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              practicas.handleGetPracticas();
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Obx(
        () => ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: practicas.practicas.length,
          itemBuilder: (context, index) {
            final practica = practicas.practicas[index];
            return ListTile(
              leading: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    practica.alumnos!.length.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              title: Text(
                'Practica de: ${practica.clase!.ClaseTitulo!}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Fecha de la practica ${DateTime.parse(practica.fecha!).toLocal().toString().split(' ')[0]}',
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
                practicas.practica = practica.obs;
                practicas.update();

                Navigator.pushNamed(
                  context,
                  '/practicas/detalle',
                  arguments: practica,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
