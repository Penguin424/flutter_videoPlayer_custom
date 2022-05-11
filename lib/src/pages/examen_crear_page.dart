import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:reproductor/src/models/Examenes_Model.dart';
import 'package:reproductor/src/pages/cursoPageDetalle/Examen_Page.dart';
import 'package:reproductor/src/utils/Http.dart';

class ExamenCrearPage extends StatefulWidget {
  ExamenCrearPage({Key? key}) : super(key: key);

  @override
  State<ExamenCrearPage> createState() => _ExamenCrearPageState();
}

class _ExamenCrearPageState extends State<ExamenCrearPage> {
  List<Quiz> quizes = [];
  bool isLoading = false;
  bool isOverlayVisible = false;
  double progress = 0;
  String titulo = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return LoadingOverlay(
      isLoading: isOverlayVisible,
      progressIndicator: Container(
        height: size.height / 3,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'CREANDO EXAMEN Y PREGUNTAS',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
            ),
          ],
        ),
      ),
      color: Theme.of(context).colorScheme.primary,
      opacity: 0.5,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              setState(() {
                isOverlayVisible = true;
              });

              final examenCreate = await HttpMod.post(
                'examenes',
                jsonEncode({
                  'examenTitulo': titulo,
                  'published_at': null,
                  'tiempo': quizes.length,
                  'curso': arguments['idCurso'],
                }),
              );

              for (var i = 0; i < quizes.length; i++) {
                final pregunta = quizes[i];
                await HttpMod.post(
                  'examenpreguntas',
                  jsonEncode(
                    {
                      'examen': jsonDecode(examenCreate.body)['id'],
                      'respuestas': pregunta.options
                          .map(
                            (option) => {
                              'id': option.id.name.toLowerCase(),
                              'option': option.option,
                            },
                          )
                          .toList(),
                      'pregunta': pregunta.statement,
                      'respuesta': pregunta.correctOptionId.name.toLowerCase(),
                    },
                  ),
                );

                setState(() {
                  progress = (i + 1) / quizes.length;
                });
              }

              setState(() {
                isOverlayVisible = false;
              });

              Navigator.pop(context);
            } catch (e) {
              setState(() {
                isOverlayVisible = false;
              });
            }
          },
          child: Icon(
            Icons.save,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          title: TextFormField(
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Titulo',
              hintStyle: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                titulo = value;
              });
            },
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          height: size.height * 0.75,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...quizes.map(
                                  (quiz) {
                                    return cardForCreateQuiz(
                                      quiz,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        quizes.add(
                          Quiz(
                            id: quizes.length,
                            statement: DateTime.now().toLocal().toString(),
                            options: [
                              QuizOption(RespuestaEnum.ID_1, ''),
                              QuizOption(RespuestaEnum.ID_2, ''),
                              QuizOption(RespuestaEnum.ID_3, ''),
                            ],
                            correctOptionId: RespuestaEnum.ID_1,
                          ),
                        );
                      });
                    },
                    child: Text('Agregar pregunta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cardForCreateQuiz(Quiz pregunta) {
    return GestureDetector(
      onLongPress: () async {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Eliminar pregunta ${pregunta.statement}'),
              content: Text('¿Está seguro de eliminar la pregunta?'),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Eliminar'),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    Navigator.of(context).pop();

                    await Future.delayed(Duration(seconds: 1));

                    setState(() {
                      final newquiz = quizes
                          .where((quiz) => quiz.id != pregunta.id)
                          .toList();
                      quizes = newquiz;
                      isLoading = false;
                    });
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Pregunta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              initialValue: pregunta.statement,
              onChanged: (value) {
                pregunta.statement = value;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: pregunta.correctOptionId == RespuestaEnum.ID_1,
                  onChanged: (value) {
                    setState(() {
                      pregunta.correctOptionId = RespuestaEnum.ID_1;
                    });
                  },
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: pregunta.options[0].option,
                    onChanged: (value) {
                      pregunta.options[0].option = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: pregunta.correctOptionId == RespuestaEnum.ID_2,
                  onChanged: (value) {
                    setState(() {
                      pregunta.correctOptionId = RespuestaEnum.ID_2;
                    });
                  },
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: pregunta.options[1].option,
                    onChanged: (value) {
                      pregunta.options[1].option = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: pregunta.correctOptionId == RespuestaEnum.ID_3,
                  onChanged: (value) {
                    setState(() {
                      pregunta.correctOptionId = RespuestaEnum.ID_3;
                    });
                  },
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: pregunta.options[2].option,
                    onChanged: (value) {
                      pregunta.options[2].option = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
