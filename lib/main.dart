import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/maze_page.dart';
import 'services/controllers/maze_controller.dart';

final MazeController maze = MazeController();

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FSI - Labirinto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[700]!),
        useMaterial3: true,
      ),
      home: const MazePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
