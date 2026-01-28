import 'coord.dart';
import 'arrow_direction.dart';

class Grid {
  /// the width of the grid (number of columns).
  final int width;

  /// the height of the grid (number of rows).
  final int height;

  /// All valid coordinates in this grid. Do not modify.
  final Set<Coord> allCoords;

  /// Whether this grid is solid. i.e., whether running into an invalid coordinate 
  /// on your way to the edge guarantees that there are no more valid coordinates in that direction.
  /// If false, there may be valid coordinates further along in that direction.
  /// For example, a circular grid is solid because once you leave the circle, there are no more valid coordinates.
  /// A rectangular grid is also solid. In the future, we may add other shapes that are not solid, like a donut or a heart.
  /// This affects the behavior of [coordsToEdge].
  final bool _isSolid;

  /// Constructs a Grid with the given width, height, and set of all valid coordinates.
  /// Throws [AssertionError] if [width] or [height] are not positive and greater than zero.
  Grid({
    required this.width,
    required this.height,
    required bool isSolid,
    required Set<Coord> allCoords,
  })  : assert(width > 0, 'Width must be greater than zero.'),
       assert(height > 0, 'Height must be greater than zero.'),
       _isSolid = isSolid,
        allCoords = Set.unmodifiable(allCoords);

  /// Constructs a rectangular grid with all coordinates filled.
  /// [width] and [height] must be greater than zero.
  /// Throws [AssertionError] if [width] or [height] are not positive and greater than zero.
  Grid.rectangle({required int width, required int height})
    : this(
        width: width,
        height: height,
        isSolid: true,
        allCoords: _generateCoordsForRectangle(width, height));
  
  /// Constructs a square grid with all coordinates filled.
  /// [size] must be greater than zero.
  /// Throws [AssertionError] if [size] is not positive and greater than zero.
  /// This is a convenience constructor that calls [Grid.rectangle].
  Grid.square({required int size})
    : this.rectangle(width: size, height: size);

  /// Constructs a circular grid with all coordinates within the given radius filled.
  /// [radius] must be greater than one.
  /// Throws [AssertionError] if [radius] is not greater than one.
  factory Grid.circle({required int radius}) {
    assert(radius > 1, 'Radius must be greater than one.');
    return Grid(
      width: radius * 2 + 1,
      height: radius * 2 + 1,
      isSolid: false,
      allCoords: _generateCoordsForCircle(radius),
    );
  }

  /// Returns all coordinates from [start] (exclusive) to the edge in [direction].
  /// The returned list should not include [start], but should include the edge cell.
  /// Throws [ArgumentError] if [start] is not a valid coordinate in this grid.
  List<Coord> coordsToEdge(Coord start, ArrowDirection direction) {
    if (!isValidCoord(start)) {
      throw ArgumentError('Start coordinate $start is not valid in this grid.');
    }
    final coords = <Coord>[];
    // Beginning at the start coordinate, move in the specified direction one coordinate at a time.
    // Stop when reaching the edge of the grid.
    // If the coordinate is valid, add it to the list.
    // If the coordinate is not part of the grid (not valid) and this is a solid grid, stop early.
    switch (direction) {
      case ArrowDirection.up:
        // Move upwards (decreasing y) as 0 is at the top
        for (int y = start.y - 1; y >= 0; y--) {
          final coord = Coord(x: start.x, y: y);
          if (isValidCoord(coord)) {
            coords.add(coord);
          } else if (_isSolid){
            break;
          }
        }
        break;
      case ArrowDirection.down:
        // Move downwards (increasing y) as 0 is at the top
        for (int y = start.y + 1; y < height; y++) {
          final coord = Coord(x: start.x, y: y);
          if (isValidCoord(coord)) {
            coords.add(coord);
          } else if (_isSolid){
            break;
          }
        }
        break;
      case ArrowDirection.left:
        // Move leftwards (decreasing x) as 0 is at the left
        for (int x = start.x - 1; x >= 0; x--) {
          final coord = Coord(x: x, y: start.y);
          if (isValidCoord(coord)) {
            coords.add(coord);
          } else if (_isSolid){
            break;
          }
        }
        break;
      case ArrowDirection.right:
        // Move rightwards (increasing x) as 0 is at the left
        for (int x = start.x + 1; x < width; x++) {
          final coord = Coord(x: x, y: start.y);
          if (isValidCoord(coord)) {
            coords.add(coord);
          } else if (_isSolid){
            break;
          }
        }
        break;
    }
    return coords;
  }

  /// Returns true if [coord] is a valid coordinate in this grid.
  bool isValidCoord(Coord coord) {
    // Use the allCoords set for efficient lookup, since the grid may not be rectangular.
    return allCoords.contains(coord);
  }

  String get testString {
    final buffer = StringBuffer();
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final coord = Coord(x: x, y: y);
        if (allCoords.contains(coord)) {
          buffer.write(' O');
        } else {
          buffer.write(' X');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  /// Generates all coordinates for a rectangular grid of given width and height.
  static Set<Coord> _generateCoordsForRectangle(int width, int height) {
    final coords = <Coord>{};
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        coords.add(Coord(x: x, y: y));
      }
    }
    return coords;
  }

  /// Generates all coordinates for a circular grid of given radius.
  /// The center of the circle is at (radius, radius).
  /// 0,0 is at the top-left corner.
  /// The width and height of the grid will be radius * 2 + 1.
  static Set<Coord> _generateCoordsForCircle(int radius) {
    final coords = <Coord>{};
    for (int x = -radius; x <= radius; x++) {
      for (int y = -radius; y <= radius; y++) {
        if (x * x + y * y <= radius * radius) {
          // Shift coordinates to be non-negative, with center at (radius, radius).
          coords.add(Coord(x: x + radius, y: y + radius));
        }
      }
    }
    return coords;
  }
}
