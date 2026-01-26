class Coord {
  final int x;
  final int y;
  Coord({required this.x, required this.y});

  Coord copyWith({int? x, int? y}) {
    return Coord(x: x ?? this.x, y: y ?? this.y);
  }

  Coord get leftNeighbor => Coord(x: x - 1, y: y);
  Coord get rightNeighbor => Coord(x: x + 1, y: y);
  Coord get topNeighbor => Coord(x: x, y: y - 1);
  Coord get bottomNeighbor => Coord(x: x, y: y + 1);

  /// Checks if this coordinate is adjacent to another coordinate
  /// either horizontally or vertically. Diagonal adjacency is not considered.
  /// This is done by comparing the x and y values of both coordinates.
  /// If the x values are the same, it checks if the y values differ by exactly 1.
  /// If the y values are the same, it checks if the x values differ by exactly 1.
  bool isAdjacent(Coord other) {
    return (x == other.x && (y - other.y).abs() == 1) ||
           (y == other.y && (x - other.x).abs() == 1);
  }

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
