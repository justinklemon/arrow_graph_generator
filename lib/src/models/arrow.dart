import 'package:arrow_graph_generator/src/models/arrow_direction.dart';
import 'package:flutter/foundation.dart' show listEquals;

import 'coord.dart' show Coord;

class Arrow {
  final List<Coord> path;
  /// Use a set to efficiently check if coords are in the arrow path.
  final Set<Coord> _coords;

  /// Each coordinate in the path represents a segment of the arrow.
  /// The first coordinate is the starting point, and each subsequent
  /// coordinate represents the next point in the arrow's path.
  /// For example, an arrow moving right from (0,0) to (2,0) could have a path:
  /// [Coord(x:0, y:0), Coord(x:1, y:0), Coord(x:2, y:0)]
  /// This indicates the arrow starts at (0,0), moves to (1,0), and ends at (2,0).
  /// The path can include turns by changing the x and y values accordingly.
  /// For instance, an arrow that goes right, down, right, and up could have a path:
  /// [Coord(x:0, y:0), Coord(x:1, y:0), Coord(x:1, y:1), Coord(x:2, y:1), Coord(x:2, y:0)]
  /// This indicates the arrow starts at (0,0), moves right to (1,0),
  /// then turns down to (1,1), right to (2,1), and finally up to (2,0).
  /// Both paths are valid. Each node in the path must be adjacent to the previous node,
  /// either horizontally or vertically (no diagonal moves).
  /// The path must contain at least two coordinates to represent a valid arrow.
  /// Every coordinate in the path must be adjacent to the previous one.
  /// Duplicate coordinates in the path are not allowed.
  Arrow({required List<Coord> path})
    : assert(
        path.length >= 2,
        'Path must contain at least two coordinates to form an arrow.',
      ),
      path = List.unmodifiable(path),
      _coords = Set<Coord>.from(path) {
    for (int i = 1; i < path.length; i++) {
      final prev = path[i - 1];
      final curr = path[i];
      final isAdjacent = prev.isAdjacent(curr);
      if (!isAdjacent) {
        throw ArgumentError(
          'All coordinates in the path must be adjacent (horizontally or vertically). '
          'Found non-adjacent coordinates: $prev and $curr at indices ${i - 1} and $i.',
        );
      }
    }
    // Make sure there are no duplicate coordinates in the path
    if (_coords.length != path.length) {
      throw ArgumentError(
        'Path contains duplicate coordinates, which is not allowed.',
      );
    }
  }

  /// The direction the arrow is pointing, determined by the last two coordinates in the path.
  /// If the last coordinate has a greater x value than the second to last,
  /// the direction is right. If it has a smaller x value, the direction is left.
  /// If the last coordinate has a greater y value than the second to last,
  /// the direction is down. Otherwise, the direction is up.
  /// This assumes that the path contains at least two coordinates, which is enforced in the constructor.
  /// It also assumes that the last two coordinates are adjacent, which is also enforced in the constructor.
  ArrowDirection get direction {
    final tip = path.last;
    final beforeTip = path[path.length - 2];
    if (tip.x > beforeTip.x) {
      return ArrowDirection.right;
    } else if (tip.x < beforeTip.x) {
      return ArrowDirection.left;
    } else if (tip.y > beforeTip.y) {
      return ArrowDirection.down;
    } else {
      return ArrowDirection.up;
    }
  }

  /// Checks if the given coordinate is part of the arrow's path.
  bool containsCoord(Coord coord) {
    // Use the set for efficient lookup, rather than searching the list.
    return _coords.contains(coord);
  }

  @override
  String toString() {
    return 'Arrow(path: $path)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Arrow && listEquals(other.path, path);
  }

  @override
  int get hashCode => Object.hashAll(path);
}
