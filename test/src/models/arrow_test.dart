import 'package:arrow_graph_generator/src/models/arrow.dart' show Arrow;
import 'package:arrow_graph_generator/src/models/arrow_direction.dart' show ArrowDirection;
import 'package:arrow_graph_generator/src/models/coord.dart' show Coord;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Arrow', () {
    group('constructor tests', () {
      test('empty list constructor assertion', () {
        expect(() => Arrow(path: []), throwsA(isA<AssertionError>()));
      });
      test('single coordinate constructor assertion', () {
        expect(() => Arrow(path: [Coord(x: 0, y: 0)]), throwsA(isA<AssertionError>()));
      });
      test('non-adjacent coordinates in path throws ArgumentError', () {
        final path = [
          Coord(x: 0, y: 0),
          Coord(x: 0, y: 1),
          Coord(x: 2, y: 1), // Non-adjacent to previous
        ];
        expect(() => Arrow(path: path), throwsA(isA<ArgumentError>()));
      });
      test('duplicate coordinates in path throws ArgumentError', () {
        final path = [
          Coord(x: 0, y: 0),
          Coord(x: 0, y: 1),
          Coord(x: 0, y: 0), // Duplicate of first coordinate
        ];
        expect(() => Arrow(path: path), throwsA(isA<ArgumentError>()));
      });
      test('valid path constructs successfully', () {
        final path = [
          Coord(x: 0, y: 0),
          Coord(x: 0, y: 1),
          Coord(x: 1, y: 1),
        ];
        final arrow = Arrow(path: path);
        expect(arrow.path, path);
      });
      test('path is unmodifiable', () {
        final path = [
          Coord(x: 0, y: 0),
          Coord(x: 0, y: 1),
        ];
        final arrow = Arrow(path: path);
        expect(() => arrow.path.add(Coord(x: 1, y: 1)), throwsA(isA<UnsupportedError>()));
      });
    });
    group('direction getter tests', () {
      test('arrow pointing right', () {
        final path = [
          Coord(x: 0, y: 0),
          Coord(x: 1, y: 0),
        ];
        final arrow = Arrow(path: path);
        expect(arrow.direction, ArrowDirection.right);
      });
      test('arrow pointing left', () {
        final path = [
          Coord(x: 1, y: 0),
          Coord(x: 0, y: 0),
        ];
        final arrow = Arrow(path: path);
        expect(arrow.direction, ArrowDirection.left);
      });
      test('arrow pointing down', () {
        final path = [
          Coord(x: 0, y: 0),
          Coord(x: 0, y: 1),
        ];
        final arrow = Arrow(path: path);
        expect(arrow.direction, ArrowDirection.down);
      });
      test('arrow pointing up', () {
        final path = [
          Coord(x: 0, y: 1),
          Coord(x: 0, y: 0),
        ];
        final arrow = Arrow(path: path);
        expect(arrow.direction, ArrowDirection.up);
      });
    });

    group('containsCoord method tests', () {
      test('containsCoord returns true for coordinates in path', () {
        final path = [
          Coord(x: 0, y: 0),
          Coord(x: 0, y: 1),
          Coord(x: 1, y: 1),
        ];
        final arrow = Arrow(path: path);
        expect(arrow.containsCoord(Coord(x: 0, y: 0)), isTrue);
        expect(arrow.containsCoord(Coord(x: 0, y: 1)), isTrue);
        expect(arrow.containsCoord(Coord(x: 1, y: 1)), isTrue);
      });
      test('containsCoord returns false for coordinates not in path', () {
        final path = [
          Coord(x: 0, y: 0),
          Coord(x: 0, y: 1),
        ];
        final arrow = Arrow(path: path);
        expect(arrow.containsCoord(Coord(x: 1, y: 1)), isFalse);
        expect(arrow.containsCoord(Coord(x: -1, y: 0)), isFalse);
      });
    });
    test('toString returns correct format', () {
      final path = [
        Coord(x: 0, y: 0),
        Coord(x: 0, y: 1),
      ];
      final arrow = Arrow(path: path);
      expect(arrow.toString(), 'Arrow(path: $path)');
    });
    test('equality operator and hashCode', () {
      final path1 = [
        Coord(x: 0, y: 0),
        Coord(x: 0, y: 1),
      ];
      final path2 = [
        Coord(x: 0, y: 0),
        Coord(x: 0, y: 1),
      ];
      final path3 = [
        Coord(x: 1, y: 0),
        Coord(x: 1, y: 1),
      ];
      final arrow1 = Arrow(path: path1);
      final arrow2 = Arrow(path: path2);
      final arrow3 = Arrow(path: path3);
      expect(arrow1, equals(arrow2));
      expect(arrow1.hashCode, equals(arrow2.hashCode));
      expect(arrow1, isNot(equals(arrow3)));
      expect(arrow1.hashCode, isNot(equals(arrow3.hashCode)));
    });
  });
}
