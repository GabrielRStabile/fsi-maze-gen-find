import 'package:flutter/material.dart';

import '../../main.dart';

class MazeWidget extends StatefulWidget {
  const MazeWidget({Key? key}) : super(key: key);

  @override
  State<MazeWidget> createState() => _MazeWidgetState();
}

class _MazeWidgetState extends State<MazeWidget> {
  @override
  void initState() {
    super.initState();
    maze.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var mazeWidgets = <Widget>[];

    for (int i = 0; i < maze.getSize(); i++) {
      var row = <Widget>[];
      for (int j = 0; j < maze.getSize(); j++) {
        row.add(
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: maze.getTileColor(i, j),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Text(maze.getTitlePathOrder(i, j)),
                ),
              ),
            ),
          ),
        );
      }
      mazeWidgets.add(Row(children: row));
    }

    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: mazeWidgets,
      ),
    );
  }
}
