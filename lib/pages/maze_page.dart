import 'package:flutter/material.dart';

import '../main.dart';
import 'widgets/maze_widget.dart';
import 'widgets/timer_widget.dart';

class MazePage extends StatefulWidget {
  const MazePage({Key? key}) : super(key: key);

  @override
  State<MazePage> createState() => _MazePageState();
}

class _MazePageState extends State<MazePage> {
  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      FilledButton.icon(
        onPressed: () {
          maze.generate();
        },
        icon: const Icon(Icons.autorenew),
        label: const Text('Gerar novo labirinto'),
      ),
      FilledButton.icon(
        onPressed: () {
          maze.solveByBFS();
        },
        icon: const Icon(Icons.photo_size_select_small_rounded),
        label: const Text('Resolver por busca em largura'),
      ),
      FilledButton.icon(
        onPressed: () {
          maze.solveByAStart();
        },
        icon: const Icon(Icons.star),
        label: const Text('Resolver por a estrela'),
      ),
      ElevatedButton.icon(
        onPressed: () {
          maze.changeBeginAndExit();
        },
        icon: const Icon(Icons.door_sliding_outlined),
        label: const Text('Gerar nova entrada e saída do labirinto'),
      ),
      ElevatedButton.icon(
        icon: const Icon(Icons.cleaning_services_outlined),
        label: const Text('Limpar caminho'),
        onPressed: () {
          maze.clearPath();
          setState(() {});
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('FSI - Labirinto'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                children: [
                  const Text(
                    'Feito por:\nAmanda Faria\nGabriel Stabile\nIsadora Fernandes',
                  ),
                ],
              );
            },
            icon: const Icon(Icons.info_rounded),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              height: 400,
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ResultWidget(),
                  ...children,
                ],
              ),
            ),
          ),
          const Flexible(child: MazeWidget()),
        ],
      ),
    );
  }
}
