import 'package:flutter/material.dart';

import '../../main.dart';

class ResultWidget extends StatefulWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  @override
  void initState() {
    super.initState();
    maze.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Tempo de execução: ${maze.timer.inMicroseconds / 1000} ms\nNós visitados: ${maze.visitedNodes}",
    );
  }
}
