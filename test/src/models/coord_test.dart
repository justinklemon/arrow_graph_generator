import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_graph_generator/src/models/coord.dart';

void main() {
  group('Coord', () {
    test('toString returns correct format', () {
      final coord = Coord(x: 3, y: 5);
      expect(coord.toString(), 'Coord(x: 3, y: 5)');
    });
    test('copyWith creates a copy with updated values', () {
      final coord = Coord(x: 3, y: 5);
      final newCoord = coord.copyWith(x: 10);
      expect(newCoord.x, 10);
      expect(newCoord.y, 5);

      final anotherCoord = coord.copyWith(y: 20);
      expect(anotherCoord.x, 3);
      expect(anotherCoord.y, 20);
    });
    test('equality operator works correctly', () {
      final coord1 = Coord(x: 3, y: 5);
      final coord2 = Coord(x: 3, y: 5);
      final coord3 = Coord(x: 4, y: 5);
      final coord4 = Coord(x: 3, y: 6);
      expect(coord1, coord2);
      expect(coord1 == coord3, isFalse);
      expect(coord1 == coord4, isFalse);
    });
    group('neighbor getters', () {
      group('leftNeighbor', () {
        test('returns correct left neighbor', () {
          final coord = Coord(x: 3, y: 5);
          final leftNeighbor = coord.leftNeighbor;
          expect(leftNeighbor, Coord(x: 2, y: 5));
        });
        test('works at boundary conditions', () {
          final coord = Coord(x: 0, y: 5);
          final leftNeighbor = coord.leftNeighbor;
          expect(leftNeighbor, Coord(x: -1, y: 5));
        });
        test('works with negative coordinates', () {
          final coord = Coord(x: -3, y: 5);
          final leftNeighbor = coord.leftNeighbor;
          expect(leftNeighbor, Coord(x: -4, y: 5));
        });
      });
      group('rightNeighbor', () {
        test('returns correct right neighbor', () {
          final coord = Coord(x: 3, y: 5);
          final rightNeighbor = coord.rightNeighbor;
          expect(rightNeighbor, Coord(x: 4, y: 5));
        });
        test('works with negative coordinates', () {
          final coord = Coord(x: -3, y: 5);
          final rightNeighbor = coord.rightNeighbor;
          expect(rightNeighbor, Coord(x: -2, y: 5));
        });
      });
      group('topNeighbor', () {
        test('returns correct top neighbor', () {
          final coord = Coord(x: 3, y: 5);
          final topNeighbor = coord.topNeighbor;
          expect(topNeighbor, Coord(x: 3, y: 4));
        });
        test('works at boundary conditions', () {
          final coord = Coord(x: 3, y: 0);
          final topNeighbor = coord.topNeighbor;
          expect(topNeighbor, Coord(x: 3, y: -1));
        });
        test('works with negative coordinates', () {
          final coord = Coord(x: 3, y: -5);
          final topNeighbor = coord.topNeighbor;
          expect(topNeighbor, Coord(x: 3, y: -6));
        });
      });
      group('bottomNeighbor', () {
        test('returns correct bottom neighbor', () {
          final coord = Coord(x: 3, y: 5);
          final bottomNeighbor = coord.bottomNeighbor;
          expect(bottomNeighbor, Coord(x: 3, y: 6));
        });
        test('works with negative coordinates', () {
          final coord = Coord(x: 3, y: -5);
          final bottomNeighbor = coord.bottomNeighbor;
          expect(bottomNeighbor, Coord(x: 3, y: -4));
        });
      });
      group('neighbors', () {
        test('returns all four neighbors', () {
          final coord = Coord(x: 3, y: 5);
          final neighbors = coord.neighbors.toList();
          expect(neighbors.length, 4);
          expect(neighbors, contains(Coord(x: 2, y: 5))); // left
          expect(neighbors, contains(Coord(x: 4, y: 5))); // right
          expect(neighbors, contains(Coord(x: 3, y: 4))); // top
          expect(neighbors, contains(Coord(x: 3, y: 6))); // bottom
        });
      });
    });
    group('isAdjacent', () {
      test('returns true for vertical adjacency above', () {
        final coord = Coord(x: 3, y: 5);
        final adjacent = Coord(x: 3, y: 6);
        expect(coord.isAdjacent(adjacent), isTrue);
      });

      test('returns true for vertical adjacency below', () {
        final coord = Coord(x: 3, y: 5);
        final adjacent = Coord(x: 3, y: 4);
        expect(coord.isAdjacent(adjacent), isTrue);
      });

      test('returns true for horizontal adjacency right', () {
        final coord = Coord(x: 3, y: 5);
        final adjacent = Coord(x: 4, y: 5);
        expect(coord.isAdjacent(adjacent), isTrue);
      });

      test('returns true for horizontal adjacency left', () {
        final coord = Coord(x: 3, y: 5);
        final adjacent = Coord(x: 2, y: 5);
        expect(coord.isAdjacent(adjacent), isTrue);
      });

      test('returns false for top left diagonal adjacency', () {
        final coord = Coord(x: 3, y: 5);
        final nonAdjacent = Coord(x: 2, y: 4);
        expect(coord.isAdjacent(nonAdjacent), isFalse);
      });

      test('returns false for top right diagonal adjacency', () {
        final coord = Coord(x: 3, y: 5);
        final nonAdjacent = Coord(x: 4, y: 4);
        expect(coord.isAdjacent(nonAdjacent), isFalse);
      });

      test('returns false for bottom left diagonal adjacency', () {
        final coord = Coord(x: 3, y: 5);
        final nonAdjacent = Coord(x: 2, y: 6);
        expect(coord.isAdjacent(nonAdjacent), isFalse);
      });

      test('returns false for bottom right diagonal adjacency', () {
        final coord = Coord(x: 3, y: 5);
        final nonAdjacent = Coord(x: 4, y: 6);
        expect(coord.isAdjacent(nonAdjacent), isFalse);
      });

      test('returns false for non-adjacent coordinates', () {
        final coord = Coord(x: 3, y: 5);
        final nonAdjacent = Coord(x: 5, y: 7);
        expect(coord.isAdjacent(nonAdjacent), isFalse);
      });
    });
    group('calculateNextCoord', () {
      test('calculates next coordinate moving down', () {
        final previous = Coord(x: 2, y: 3);
        final current = Coord(x: 2, y: 4);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: 2, y: 5));
      });
      test('calculates next coordinate moving up', () {
        final previous = Coord(x: 2, y: 4);
        final current = Coord(x: 2, y: 3);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: 2, y: 2));
      });
      test('calculates next coordinate moving right', () {
        final previous = Coord(x: 5, y: 5);
        final current = Coord(x: 6, y: 5);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: 7, y: 5));
      });
      test('calculates next coordinate moving left', () {
        final previous = Coord(x: 6, y: 5);
        final current = Coord(x: 5, y: 5);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: 4, y: 5));
      });
      test('calculates next coordinate moving up with negative values', () {
        final previous = Coord(x: -2, y: -3);
        final current = Coord(x: -2, y: -4);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: -2, y: -5));
      });
      test('calculates next coordinate moving left with negative values', () {
        final previous = Coord(x: -3, y: -5);
        final current = Coord(x: -4, y: -5);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: -5, y: -5));
      });
      test('calculates next coordinate moving down with negative values', () {
        final previous = Coord(x: -1, y: -4);
        final current = Coord(x: -1, y: -3);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: -1, y: -2));
      });
      test('calculates next coordinate moving right with negative values', () {
        final previous = Coord(x: -4, y: -2);
        final current = Coord(x: -3, y: -2);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: -2, y: -2));
      });
      test('calculates next coordinate crossing zero', () {
        final previous = Coord(x: -1, y: 0);
        final current = Coord(x: 0, y: 0);
        final next = current.calculateNextCoord(previous);
        expect(next, Coord(x: 1, y: 0));
      });
      test('throws ArgumentError for non-adjacent coordinates that are aligned vertically', () {
        final previous = Coord(x: 0, y: -1);
        final current = Coord(x: 0, y: 1);
        expect(() => current.calculateNextCoord(previous), throwsArgumentError);
      });
      test('throws ArgumentError for non-adjacent coordinates that are aligned horizontally', () {
        final previous = Coord(x: -1, y: 0);
        final current = Coord(x: 1, y: 0);
        expect(() => current.calculateNextCoord(previous), throwsArgumentError);
      });
      test('throws ArgumentError for non-aligned coordinates', () {
        final previous = Coord(x: 2, y: 2);
        final current = Coord(x: 3, y: 4);
        expect(() => current.calculateNextCoord(previous), throwsArgumentError);
      });
      test('throws ArgumentError for identical coordinates', () {
        final previous = Coord(x: 2, y: 2);
        final current = Coord(x: 2, y: 2);
        expect(() => current.calculateNextCoord(previous), throwsArgumentError);
      });
    });
    group('hashCode', () {
      test('same coordinates have same hashCode', () {
        final coord1 = Coord(x: 3, y: 5);
        final coord2 = Coord(x: 3, y: 5);
        expect(coord1.hashCode, coord2.hashCode);
      });
      test('different coordinates have different hashCodes', () {
        final coord1 = Coord(x: 3, y: 5);
        final coord2 = Coord(x: 4, y: 5);
        final coord3 = Coord(x: 3, y: 6);
        expect(coord1.hashCode == coord2.hashCode, isFalse);
        expect(coord1.hashCode == coord3.hashCode, isFalse);
      });
      test('flipped coordinates have different hashCodes', () {
        final coord1 = Coord(x: 3, y: 5);
        final coord2 = Coord(x: 5, y: 3);
        expect(coord1.hashCode == coord2.hashCode, isFalse);
      });
      test('negative coordinates have different hashCodes then the positive', () {
        final coord1 = Coord(x: -3, y: -5);
        final coord2 = Coord(x: 3, y: 5);
        expect(coord1.hashCode == coord2.hashCode, isFalse);
      });
      test('negative coordinates have consistent hashCodes', () {
        final coord1 = Coord(x: -3, y: -5);
        final coord2 = Coord(x: -3, y: -5);
        expect(coord1.hashCode, coord2.hashCode);
      });
      test('zero coordinates have consistent hashCodes', () {
        final coord1 = Coord(x: 0, y: 0);
        final coord2 = Coord(x: 0, y: 0);
        expect(coord1.hashCode, coord2.hashCode);
      });
    });
  });
}
