import 'tile_entity.dart';

// Classe responsável por armazenar os elementos da pilha
class Stack {
  final List<Tile> _list = [];
  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  void push(Tile tile) {
    // Adiciona um elemento na pilha
    _list.add(tile);
  }

  Tile pop() {
    // Remove o topo da pilha
    Tile res = _list.last;
    _list.removeLast();
    return res;
  }

  Tile top() {
    // Pega o topo da pilha
    return _list.last;
  }

  void sort() {
    // Faz a ordenação da lista de acordo com o custo
    _list.sort((a, b) => (b.cost > a.cost) ? 1 : 0);
  }
}
