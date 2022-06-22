import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:reproductor/src/controllers/practicas_controller.dart';

class PracticaDetallePage extends StatefulWidget {
  PracticaDetallePage({Key? key}) : super(key: key);

  @override
  State<PracticaDetallePage> createState() => _PracticaDetallePageState();
}

class _PracticaDetallePageState extends State<PracticaDetallePage> {
  final praticas = Get.find<PracticasController>();
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
        body: Obx(
          () => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Text(
                    'Practica de ${praticas.practica.value.clase!.ClaseTitulo!}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    DateTime.parse(
                      praticas.practica.value.fecha!,
                    ).toLocal().toString().split(" ")[0],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final alumno = praticas.practica.value.alumnos![index];
                        final detalle = praticas
                            .practica.value.detallepracticas!
                            .where((detalle) => detalle!.alumno == alumno!.id)
                            .toList();

                        return ListTile(
                          leading: Icon(
                            detalle.isNotEmpty
                                ? detalle.first!.isAcreditada!
                                    ? Icons.check
                                    : Icons.close
                                : Icons.close,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(alumno!.username!),
                          trailing: Checkbox(
                            value: detalle.isNotEmpty,
                            onChanged: (value) {},
                          ),
                          onLongPress: detalle.isEmpty
                              ? () {}
                              : () async {
                                  if (detalle.first!.isAcreditada!) {
                                    return;
                                  }
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          margin: EdgeInsets.all(16),
                                          width: size.width,
                                          height: size.height * 0.3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'ACREDITAR PRACTICA',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
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
                                                  Navigator.pop(context);

                                                  await praticas
                                                      .handleUpdatePracticas(
                                                    detalle.first!.id!,
                                                  );

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                child:
                                                    Text('Acreditar Practica'),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: praticas.practica.value.alumnos!.length,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
