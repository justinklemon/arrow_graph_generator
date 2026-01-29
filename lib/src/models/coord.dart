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

  Iterable<Coord> get neighbors => [
        leftNeighbor,
        rightNeighbor,
        topNeighbor,
        bottomNeighbor,
      ];

  /// Checks if this coordinate is adjacent to another coordinate
  /// either horizontally or vertically. Diagonal adjacency is not considered.
  /// This is done by comparing the x and y values of both coordinates.
  /// If the x values are the same, it checks if the y values differ by exactly 1.
  /// If the y values are the same, it checks if the x values differ by exactly 1.
  bool isAdjacent(Coord other) {
    return (x == other.x && (y - other.y).abs() == 1) ||
        (y == other.y && (x - other.x).abs() == 1);
  }

  /// Calculates the next coordinate in the same direction as from [previous] to this coordinate.
  /// For example, if [previous] is (2,3) and this coordinate is (2,4),
  /// the next coordinate would be (2,5) (moving down).
  /// If [previous] is (5,5) and this coordinate is (4,5),
  /// the next coordinate would be (3,5) (moving left).
  /// If the coordinates are not adjacent either horizontally or vertically,
  /// an ArgumentError is thrown.
  /// If the coordinates are the same, an ArgumentError is also thrown.
  Coord calculateNextCoord(Coord previous){
    if (this == previous) {
      throw ArgumentError(
        'Cannot calculate next coordinate: $previous and $this are the same.',
      );
    }
    if (!isAdjacent(previous)) {
      throw ArgumentError(
        'Cannot calculate next coordinate: $previous and $this are not adjacent horizontally or vertically.',
      );
    }
    if (x == previous.x) {
      // Vertical movement
      int deltaY = y - previous.y;
      return Coord(x: x, y: y + deltaY);
    } else {
      // Horizontal movement
      int deltaX = x - previous.x;
      return Coord(x: x + deltaX, y: y);
    } 
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
  int get hashCode => Object.hash(x, y);
}
