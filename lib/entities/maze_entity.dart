import 'dart:collection';
import 'dart:core';
import 'dart:math';

import 'stack_entity.dart';
import 'tile_entity.dart';

class Maze {
  int size = 0;
  late List<List<Tile>> tiles;
  int visitedNodes = 0;
  Tile beginTile = Tile();
  Tile endTile = Tile();
  Duration time = Duration.zero;

  Maze(this.size) {
    tiles = List.generate(size, (i) => List.generate(size, (j) => Tile()));
  }

  void divideChamber(
    int posX,
    int posY,
    int width,
    int height,
    bool isVertical,
  ) async {
    if (width <= 1 || height <= 1) return;

    var halfWallX = (width / 2).floor();
    var halfWallY = (height / 2).floor();

    if ((posX + halfWallX) % 2 == 0) halfWallX--;
    if ((posY + halfWallY) % 2 == 0) halfWallY--;

    var r = Random().nextInt(isVertical ? height : width);
    while (r % 2 != 0) {
      r = Random().nextInt(isVertical ? height : width);
    }

    for (int i = 0; i < (isVertical ? height : width); i++) {
      if (r != i) {
        var x = posX + (isVertical ? halfWallX : i);
        var y = posY + (isVertical ? i : halfWallY);
        tiles[x][y].type = TileType.wall;
      }
    }

    var nextWidth = isVertical ? halfWallX : width;
    var nextHeight = isVertical ? height : halfWallY;

    if (halfWallX >= 1 || halfWallY >= 2) {
      divideChamber(posX, posY, nextWidth, nextHeight, !isVertical);

      if (!isVertical) {
        divideChamber(
          posX,
          posY + nextHeight + 1,
          nextWidth,
          height - nextHeight - 1,
          !isVertical,
        );
      } else {
        divideChamber(
          posX + nextWidth + 1,
          posY,
          width - nextWidth - 1,
          nextHeight,
          !isVertical,
        );
      }
    }
  }

  void generate() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        tiles[i][j].type = TileType.empty;
        tiles[i][j].i = i;
        tiles[i][j].j = j;
      }
    }

    divideChamber(0, 0, size, size, true);
  }

  /// Retorna uma [List] de [Tile]s de vizinhos não visitados
  ///
  /// Recebe um [Tile] e retorna uma [List] de [Tile]s de vizinhos não visitados
  /// considerando que os visinhos de [Tile] não são paredes.
  List<Tile> getNotVisitedNeighbors(Tile cell) {
    var neighbors = List<Tile>.empty(growable: true);
    int i = cell.i!;
    int j = cell.j!;
    if (i > 0 &&
        !tiles[i - 1][j].isVisited &&
        tiles[i - 1][j].type != TileType.wall) {
      neighbors.add(tiles[i - 1][j]);
    }
    if (j < size - 1 &&
        !tiles[i][j + 1].isVisited &&
        tiles[i][j + 1].type != TileType.wall) {
      neighbors.add(tiles[i][j + 1]);
    }
    if (i < size - 1 &&
        !tiles[i + 1][j].isVisited &&
        tiles[i + 1][j].type != TileType.wall) {
      neighbors.add(tiles[i + 1][j]);
    }
    if (j > 0 &&
        !tiles[i][j - 1].isVisited &&
        tiles[i][j - 1].type != TileType.wall) {
      neighbors.add(tiles[i][j - 1]);
    }
    return neighbors;
  }

  List<Tile> breadthFirstSearch() {
    Stopwatch watch = Stopwatch();

    Queue<Tile> queue = Queue<Tile>();
    List<Tile> path = [];
    watch.start();

    // Define o início e o fim da busca
    beginTile.isVisited = true;
    queue.add(beginTile);

    while (queue.isNotEmpty) {
      Tile currentTile = queue.removeFirst();
      visitedNodes++;

      if (currentTile == endTile) {
        // Encontrou o fim do labirinto, então adiciona o caminho em path
        while (currentTile.parent != null) {
          path.add(currentTile);
          currentTile = currentTile.parent!;
          watch.stop();
          time = watch.elapsed;
        }
        // Retorna o caminho em ordem reversa (do fim ao início)
        return path.reversed.toList();
      }

      // Adiciona os vizinhos não visitados na fila
      for (Tile neighbor in getNotVisitedNeighbors(currentTile)) {
        neighbor.isVisited = true;
        neighbor.parent = currentTile;
        queue.add(neighbor);
      }
    }

    // Não encontrou o fim do labirinto
    return path;
  }

  List<Tile> aStar() {
    Stopwatch watch = Stopwatch();
    Stack s = Stack();
    watch.start();
    beginTile.isVisited = true;
    visitedNodes++;
    s.push(beginTile);
    Tile current;
    while (s.isNotEmpty) {
      current = s.pop();
      var neighbors = getNotVisitedNeighbors(current);
      for (var neighbor in neighbors) {
        neighbor.parent = current;
        neighbor.isVisited = true;
        visitedNodes++;
        neighbor.cost = getCost(neighbor);
        s.push(neighbor);
        if (neighbor.type == TileType.goal) {
          watch.stop();
          time = watch.elapsed;
          return getPath(neighbor);
        }
      }
      s.sort();
    }
    return List<Tile>.empty();
  }

  double getCost(Tile neighbor) {
    var distanceFromBegin =
        pow(beginTile.i! - neighbor.i!, 2) + pow(beginTile.j! - neighbor.j!, 2);
    var distanceUntilEnd =
        pow(endTile.i! - neighbor.i!, 2) + pow(endTile.j! - neighbor.j!, 2);
    var cost = sqrt(distanceFromBegin) + sqrt(distanceUntilEnd);
    return cost;
  }

  List<Tile> getPath(Tile cell) {
    var path = List<Tile>.empty(growable: true);
    while (cell.parent != null) {
      path.add(cell);
      cell = cell.parent!;
    }

    return path;
  }

  void setPathOrder(List<Tile> path) {
    int count = path.length;
    for (var cell in path) {
      int i = cell.i!;
      int j = cell.j!;
      tiles[i][j].pathOrder = count;
      count--;
    }
  }

  /// Limpa os tiles visitados do labirinto.
  ///
  /// Faz uma varredura em todos os tiles do labirinto setando os atributos
  /// como vazios.
  void clean() {
    visitedNodes = 0;
    time = Duration.zero;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        tiles[i][j].isVisited = false;
        tiles[i][j].pathOrder = 0;
        tiles[i][j].parent = null;

        if (tiles[i][j].type != TileType.wall &&
            tiles[i][j].type != TileType.start &&
            tiles[i][j].type != TileType.goal) {
          tiles[i][j].type = TileType.empty;
        }
      }
    }
  }

  void generateBeginAndEnd() {
    int i = Random().nextInt(size);
    int j = Random().nextInt(size);

    while (tiles[i][j].type == TileType.wall) {
      i = Random().nextInt(size);
      j = Random().nextInt(size);
    }

    beginTile = tiles[i][j];
    beginTile.type = TileType.start;

    i = Random().nextInt(size);
    j = Random().nextInt(size);

    while (tiles[i][j].type == TileType.wall) {
      i = Random().nextInt(size);
      j = Random().nextInt(size);
    }

    endTile = tiles[i][j];
    endTile.type = TileType.goal;
  }
}
