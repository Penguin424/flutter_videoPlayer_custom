import 'dart:convert';

import 'package:conditional_questions/conditional_questions.dart';
import 'package:flutter/material.dart';
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
  }) : super(key: key);

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
  final _key = GlobalKey<QuestionFormState>();

  @override
  void initState() {
    handleGetExamen();
    super.initState();
  }

  void handleGetExamen() async {
    Future.delayed(Duration.zero, () async {
      final agurments =
          ModalRoute.of(context)!.settings.arguments as ExamenesDb;

      final quizesInit = agurments.examenpreguntas.map<Quiz>(
        (pregunta) {
          return Quiz(
            id: pregunta.id,
            statement: pregunta.pregunta,
            options: pregunta.respuestas.map<QuizOption>(
              (e) {
                return QuizOption(e.id, e.option.replaceAll(" ", "\n") + "\n");
              },
            ).toList(),
            correctOptionId: pregunta.respuesta,
          );
        },
      ).toList();
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
              backgroundColor: Color.fromRGBO(76, 170, 177, 1.0),
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
                    child: ConditionalQuestions(
                      key: _key,
                      children: quizes.map(
                        (quiz) {
                          return PolarQuestion(
                            question: quiz.statement,
                            answers: quiz.options
                                .map(
                                  (e) => e.option,
                                )
                                .toList(),
                            isMandatory: true,
                          );
                        },
                      ).toList(),
                      trailing: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(76, 170, 177, 1.0),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(20.0),
                            // ),
                          ),
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              final respuestas = _key.currentState!.toMap();

                              respuestas.forEach((key, value) {
                                final index = quizes.indexWhere(
                                  (e) => e.statement == key,
                                );

                                final idRespuesta = quizes[index]
                                    .options
                                    .firstWhere(
                                      (option) => option.option == value,
                                    )
                                    .id;

                                if (quizes[index].correctOptionId ==
                                    idRespuesta) {
                                  setState(() {
                                    isCorrect.add(true);
                                  });
                                } else {
                                  setState(() {
                                    isCorrect.add(false);
                                  });
                                }
                              });

                              onSubmitExamen();
                            }
                          },
                          child: Text("TERMINAR EXAMEN"),
                        )
                      ],
                    ),
                  ),
                ],
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
