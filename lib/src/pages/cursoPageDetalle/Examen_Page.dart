import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:reproductor/src/models/Examenes_Model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class Quiz {
  final String statement;
  final List<QuizOption> options;
  final RespuestaEnum correctOptionId;
  final int id;

  Quiz({
    required this.id,
    required this.statement,
    required this.options,
    required this.correctOptionId,
  });
}

class QuizOption {
  final RespuestaEnum id;
  final String option;

  QuizOption(
    this.id,
    this.option,
  );
}

class ExamenPage extends StatefulWidget {
  ExamenPage({
    Key? key,
    this.renderingEngine = const TeXViewRenderingEngine.katex(),
  }) : super(key: key);

  final TeXViewRenderingEngine renderingEngine;

  @override
  _ExamenPageState createState() => _ExamenPageState();
}

class _ExamenPageState extends State<ExamenPage> {
  late ExamenesDb examen;
  List<Quiz> quizes = [];
  bool isQuizesLoaded = false;
  CountdownController controller = CountdownController(autoStart: true);
  PageController pageController = PageController(
    initialPage: 0,
  );
  int indexPage = 0;
  bool isCorrectOPtion = false;
  List<bool> isCorrect = [];

  @override
  void initState() {
    handleGetExamen();
    super.initState();
  }

  void handleGetExamen() async {
    Future.delayed(Duration.zero, () async {
      final agurments =
          ModalRoute.of(context)!.settings.arguments as ExamenesDb;

      final quizesInit = agurments.examenpreguntas.map<Quiz>((pregunta) {
        return Quiz(
          id: pregunta.id,
          statement: "<h3>${pregunta.pregunta}</h3>",
          options: pregunta.respuestas.map<QuizOption>((e) {
            return QuizOption(e.id, "<h2>${e.option}</h2>");
          }).toList(),
          correctOptionId: pregunta.respuesta,
        );
      }).toList();
      setState(() {
        quizes = quizesInit;
        examen = agurments;
        isQuizesLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isQuizesLoaded
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                examen.examenTitulo,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Expanded(
                child: ListView(
                  children: [
                    Countdown(
                      controller: controller,
                      seconds: examen.tiempo * 60,
                      build: (_, double time) => Text(
                        Duration(seconds: time.toInt())
                            .toString()
                            .substring(0, 7),
                        style: TextStyle(
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      interval: Duration(seconds: 1),
                      onFinished: () {
                        onSubmitExamen();
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      height: size.height * 0.6,
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final quiz = quizes[index];

                          return TeXView(
                            renderingEngine: widget.renderingEngine,
                            child: TeXViewColumn(
                              children: [
                                TeXViewDocument(
                                  quiz.statement,
                                  style: TeXViewStyle(
                                    textAlign: TeXViewTextAlign.Center,
                                  ),
                                ),
                                TeXViewGroup(
                                  children: quiz.options.map(
                                    (QuizOption option) {
                                      return TeXViewGroupItem(
                                        rippleEffect: false,
                                        id: option.id.index.toString(),
                                        child: TeXViewDocument(
                                          option.option,
                                          style: TeXViewStyle(
                                            padding: TeXViewPadding.all(10),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  selectedItemStyle: TeXViewStyle(
                                    borderRadius: TeXViewBorderRadius.all(10),
                                    border: TeXViewBorder.all(
                                      TeXViewBorderDecoration(
                                        borderWidth: 3,
                                        borderColor: Colors.cyan[300],
                                      ),
                                    ),
                                    margin: TeXViewMargin.all(10),
                                  ),
                                  normalItemStyle: TeXViewStyle(
                                    margin: TeXViewMargin.all(10),
                                  ),
                                  onTap: (id) {
                                    print(id);
                                    print(quiz.correctOptionId.index);
                                    if (id ==
                                        quiz.correctOptionId.index.toString()) {
                                      setState(() {
                                        isCorrectOPtion = true;
                                      });
                                    } else {
                                      setState(() {
                                        isCorrectOPtion = false;
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                            style: TeXViewStyle(
                              margin: TeXViewMargin.all(5),
                              padding: TeXViewPadding.all(10),
                              borderRadius: TeXViewBorderRadius.all(10),
                              border: TeXViewBorder.all(
                                TeXViewBorderDecoration(
                                  borderColor: Colors.blue,
                                  borderStyle: TeXViewBorderStyle.Solid,
                                  borderWidth: 5,
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          );
                        },
                        itemCount: quizes.length,
                      ),
                    ),
                    !(isCorrect.length == examen.examenpreguntas.length)
                        ? ElevatedButton(
                            onPressed: () {
                              if (isCorrectOPtion) {
                                setState(() {
                                  isCorrect.add(true);
                                });
                              } else {
                                setState(() {
                                  isCorrect.add(false);
                                });
                              }

                              setState(() {
                                indexPage++;
                                isCorrectOPtion = false;
                                _changePageOnPageView(indexPage);
                              });
                            },
                            child: Text('Guardar Respuesta'),
                          )
                        : ElevatedButton(
                            onPressed: onSubmitExamen,
                            child: Text('Terminar Examen'),
                          ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  void onSubmitExamen() async {
    double puntosPorPreguntas = 100 / quizes.length;
    double calificacion =
        isCorrect.where((element) => element).length * puntosPorPreguntas;
    int alumno = HttpMod.localStorage.getItem('idUser');

    final examenDetalle = await HttpMod.post(
      "detalleexamenes",
      jsonEncode({
        "alumno": alumno,
        'calificacion': calificacion,
        'examen': examen.id,
      }),
    );

    if (examenDetalle.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'examen terminando',
            textAlign: TextAlign.end,
          ),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    }
  }

  void _changePageOnPageView(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
