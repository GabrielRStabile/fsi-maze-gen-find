// ignore_for_file: unused_field

import 'package:flutter/material.dart';

import '../../entities/maze_entity.dart';
import '../../entities/tile_entity.dart';

class MazeController extends ChangeNotifier {
  Duration timer = Duration.zero;
  int visitedNodes = 0;

  late Maze _maze;
  int _size = 100;

  static MazeController? _instance;

  MazeController._internal();

  factory MazeController() {
    MazeController instance = MazeController._internal();
    instance._maze = Maze(instance._size);
    return instance;
  }

  void generate() {
    _maze.generate();
    notifyListeners();
  }

  int getSize() {
    return _size;
  }

  Color getTileColor(int i, int j) {
    return _maze.tiles[i][j].getColor();
  }

  String getTitlePathOrder(int i, int j) {
    return _maze.tiles[i][j].pathOrder != 0
        ? _maze.tiles[i][j].pathOrder.toString()
        : '';
  }

  void setSize(int size) {
    _size = size;
    _maze = Maze(_size);
    generate();
  }

  void clearPath() {
    _maze.clean();
    timer = Duration.zero;
    visitedNodes = 0;
    notifyListeners();
  }

  void changeBeginAndExit() {
    clearPath();
    _maze.generateBeginAndEnd();
    notifyListeners();
  }

  void solveByBFS() {
    clearPath();
    List<Tile> pathOrder = _maze.breadthFirstSearch();
    _maze.setPathOrder(pathOrder);
    timer = _maze.time;
    visitedNodes = _maze.visitedNodes;
    notifyListeners();
  }

  void solveByAStart() {
    clearPath();
    List<Tile> pathOrder = _maze.aStar();
    _maze.setPathOrder(pathOrder);
    timer = _maze.time;
    visitedNodes = _maze.visitedNodes;
    notifyListeners();
  }
}
