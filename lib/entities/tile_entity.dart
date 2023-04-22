import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TileType { empty, wall, start, goal }

class Tile {
  TileType? type;
  Tile? parent;
  int? i;
  int? j;
  num cost = 0;
  int pathOrder = 0;
  bool isVisited = false;

  Color getColor() {
    if (type == TileType.start) {
      return Theme.of(Get.context!).colorScheme.error;
    } else if (type == TileType.goal) {
      return Colors.green;
    } else if (type == TileType.wall) {
      return Theme.of(Get.context!).colorScheme.onBackground;
    } else if (pathOrder != 0) {
      return Colors.cyan;
    } else if (isVisited == true) {
      return Theme.of(Get.context!).colorScheme.secondary;
    } else {
      return Theme.of(Get.context!).colorScheme.surface;
    }
  }
}
