class Coord {
  final int x;
  final int y;
  Coord({required this.x, required this.y});

  Coord copyWith({int? x, int? y}) {
    return Coord(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Coord get leftNeighbor => Coord(x: x - 1, y: y);
  Coord get rightNeighbor => Coord(x: x + 1, y: y);
  Coord get topNeighbor => Coord(x: x, y: y - 1);
  Coord get bottomNeighbor => Coord(x: x, y: y + 1);

  @override
  String toString() {
    return 'Coord(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coord && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
