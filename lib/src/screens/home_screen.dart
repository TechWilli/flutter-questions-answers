import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // para usar o rootBundle

import 'package:flutter_questions_answers/src/components/answer.dart';
import 'package:flutter_questions_answers/src/components/show_score_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<int, String> _selectedAnswers = {};

  List<dynamic> _questionsAndAnswers = [];
  int _currentQuestionIndex = 0;
  bool _showFinalScore = false;

  String get feedbackText => _calculateFinalScore() >= 9
      ? 'Parabéns!'
      : (_calculateFinalScore() >= 5 ? 'Muito bom!' : 'Ops :(');

  bool get allQuestionsAnswered =>
      _selectedAnswers.length == _questionsAndAnswers.length;

  Color get nextQuestionButtonColor =>
      _isValidNextQuestionRange(_questionsAndAnswers)
          ? Colors.black
          : Colors.grey;

  Color get previousQuestionButtonColor =>
      _isValidPreviousQuestionRange(_questionsAndAnswers)
          ? Colors.black
          : Colors.grey;

  /* lógica que pensei para mudar o estilo da resposta selecionada,
  quando o índice da resposta selecionada for igual ao índice da resposta em si
  o estilo mudará apenas para a seleção, deixando-a destacada, e as demais ficam normal */
  bool _isAnswerSelected(String answer) =>
      _questionsAndAnswers[_currentQuestionIndex]['answers'].indexOf(answer) ==
      _questionsAndAnswers[_currentQuestionIndex]['answers']
          .indexOf(_selectedAnswers[_currentQuestionIndex]);

  bool _isValidNextQuestionRange(List<dynamic> qAndA) =>
      _currentQuestionIndex < qAndA.length - 1;
  bool _isValidPreviousQuestionRange(List<dynamic> qAndA) =>
      _currentQuestionIndex > 0;

  void _handleNextQuestion() {
    if (_isValidNextQuestionRange(_questionsAndAnswers)) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _handlePreviousQuestion() {
    if (_isValidPreviousQuestionRange(_questionsAndAnswers)) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  int _calculateFinalScore() {
    int score = 0;
    for (final answer in _questionsAndAnswers) {
      if (_selectedAnswers.containsValue(answer['correctAnswer'])) {
        score++;
      }
    }
    return score;
  }

  Future<void> _loadData() async {
    final String response =
        await rootBundle.loadString('assets/json/questions-and-answers.json');
    final result = json.decode(response);

    setState(() {
      _questionsAndAnswers = [...result['data']];
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !_showFinalScore
            ? Column(
                children: [
                  // Container(
                  //   width: double.infinity,
                  //   margin: const EdgeInsets.all(15),
                  //   padding: const EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //       color: Colors.amber.shade100,
                  //       border: Border.all(color: Colors.amber),
                  //       borderRadius: BorderRadius.circular(5)),
                  //   child: const Text(
                  //     'Existe apenas uma resposta correta para cada pergunta.',
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 60,
                    // truque para colocar borda no avatar
                    child: CircleAvatar(
                      radius: 59,
                      backgroundImage:
                          AssetImage('assets/images/will_avatar.jpg'),
                    ),
                  ),
                  Container(
                    // width: double.infinity,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text(
                      '10 perguntinhas sobre o William',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // padding: const EdgeInsets.all(15),
                      padding: const EdgeInsets.only(
                        bottom: 15,
                        left: 15,
                        right: 15,
                      ),
                      child: _questionsAndAnswers.isNotEmpty
                          ? Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Pergunta ${_currentQuestionIndex + 1}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Text(
                                  _questionsAndAnswers[_currentQuestionIndex]
                                      ['question'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                ..._questionsAndAnswers[_currentQuestionIndex]
                                        ['answers']
                                    .map(
                                  (answer) => Answer(
                                    text: answer,
                                    isSelected: _isAnswerSelected(answer),
                                    handleAnswerChoice: () {
                                      setState(() {
                                        _selectedAnswers[
                                            _currentQuestionIndex] = answer;
                                      });
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                        visible: allQuestionsAnswered,
                                        child: ShowScoreButton(
                                          onPressed: () {
                                            setState(() {
                                              _showFinalScore = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ],
                            )
                          : const Center(
                              child:
                                  CircularProgressIndicator(color: Colors.blue),
                            ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                            onPressed: _isValidPreviousQuestionRange(
                                    _questionsAndAnswers)
                                ? _handlePreviousQuestion
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back,
                                    size: 18,
                                    color: previousQuestionButtonColor),
                                Text(
                                  'Anterior',
                                  style: TextStyle(
                                      color: previousQuestionButtonColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.black,
                                width: 0.2,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                            onPressed:
                                _isValidNextQuestionRange(_questionsAndAnswers)
                                    ? _handleNextQuestion
                                    : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Próximo',
                                  style: TextStyle(
                                    color: nextQuestionButtonColor,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: nextQuestionButtonColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      feedbackText,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Você acertou ${_calculateFinalScore()} das ${_questionsAndAnswers.length} perguntas',
                    ),
                    const SizedBox(height: 15),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFinalScore = false;
                          _currentQuestionIndex = 0;
                          _selectedAnswers.clear();
                        });
                      },
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Reiniciar perguntas'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
