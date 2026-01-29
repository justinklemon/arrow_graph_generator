import 'package:arrow_graph_generator/src/models/arrow_direction.dart';
import 'package:arrow_graph_generator/src/models/coord.dart';
import 'package:arrow_graph_generator/src/models/grid.dart' show Grid;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Grid tests', () {
    test('allCoords is unmodifiable', () {
      final Grid grid = Grid(
        width: 3,
        height: 3,
        isSolid: true,
        allCoords: {
          Coord(x: 0, y: 0),
          Coord(x: 1, y: 0),
          Coord(x: 2, y: 0),
          Coord(x: 0, y: 1),
          Coord(x: 1, y: 1),
          Coord(x: 2, y: 1),
          Coord(x: 0, y: 2),
          Coord(x: 1, y: 2),
          Coord(x: 2, y: 2),
        },
      );
      expect(
        () => grid.allCoords.add(Coord(x: 3, y: 3)),
        throwsUnsupportedError,
      );
      expect(
        () => grid.allCoords.remove(Coord(x: 0, y: 0)),
        throwsUnsupportedError,
      );
    });
    test('isValidCoord works correctly', () {
      final Grid grid = Grid(
        width: 2,
        height: 2,
        isSolid: true,
        allCoords: {
          Coord(x: 0, y: 0),
          Coord(x: 1, y: 0),
          Coord(x: 0, y: 1),
          Coord(x: 1, y: 1),
        },
      );
      expect(grid.isValidCoord(Coord(x: 0, y: 0)), isTrue);
      expect(grid.isValidCoord(Coord(x: 1, y: 1)), isTrue);
      expect(grid.isValidCoord(Coord(x: 2, y: 2)), isFalse);
      expect(grid.isValidCoord(Coord(x: -1, y: 0)), isFalse);
    });
    group('CircleGrid tests', () {
      group('constructor radius', () {
        test(
          'constructor uses radius to initialize width and height correctly',
          () {
            final grid = Grid.circle(radius: 5);
            expect(grid.width, 11); // radius * 2 + 1
            expect(grid.height, 11); // radius * 2 + 1
            final grid2 = Grid.circle(radius: 10);
            expect(grid2.width, 21); // radius * 2 + 1
            expect(grid2.height, 21); // radius * 2 + 1
          },
        );
        test('constructor throws assertion error for non-positive radius', () {
          expect(() => Grid.circle(radius: 0), throwsA(isA<AssertionError>()));
          expect(() => Grid.circle(radius: -3), throwsA(isA<AssertionError>()));
        });
        test('constructor throws assertion error for radius of 1', () {
          expect(() => Grid.circle(radius: 1), throwsA(isA<AssertionError>()));
        });
      });
      group('circle allCoords', () {
        test('allCoords contains only coordinates within the circle', () {
          final radiiToTest = [2, 5, 10, 50, 500, 1000];
          for (final radius in radiiToTest) {
            final grid = Grid.circle(radius: radius);
            for (final coord in grid.allCoords) {
              final x = coord.x - radius;
              final y = coord.y - radius;
              expect(
                x * x + y * y <= radius * radius,
                isTrue,
                reason:
                    'Coordinate $coord is outside the circle of radius $radius',
              );
            }
          }
        });
        test('circle allCoords is unmodifiable', () {
          final grid = Grid.circle(radius: 3);
          expect(
            () => grid.allCoords.add(Coord(x: 0, y: 0)),
            throwsUnsupportedError,
          );
          expect(
            () => grid.allCoords.remove(Coord(x: 3, y: 3)),
            throwsUnsupportedError,
          );
        });
      });
      group('circle coordsToEdge', () {
        final grid = Grid.circle(radius: 3);

        test('throws ArgumentError for invalid start coordinate', () {
          final invalidCoords = [
            Coord(x: -1, y: -1),
            Coord(x: 7, y: 7),
            Coord(x: 0, y: 0),
          ];
          for (final coord in invalidCoords) {
            expect(
              () => grid.coordsToEdge(coord, ArrowDirection.up),
              throwsA(isA<ArgumentError>()),
            );
          }
        });
        test(
          'correctly computes coords to edge in all directions from center',
          () {
            final start = Coord(x: 3, y: 3); // center of the grid
            final upCoords = grid.coordsToEdge(start, ArrowDirection.up);
            final downCoords = grid.coordsToEdge(start, ArrowDirection.down);
            final leftCoords = grid.coordsToEdge(start, ArrowDirection.left);
            final rightCoords = grid.coordsToEdge(start, ArrowDirection.right);

            expect(upCoords, [
              Coord(x: 3, y: 2),
              Coord(x: 3, y: 1),
              Coord(x: 3, y: 0),
            ]);
            expect(downCoords, [
              Coord(x: 3, y: 4),
              Coord(x: 3, y: 5),
              Coord(x: 3, y: 6),
            ]);
            expect(leftCoords, [
              Coord(x: 2, y: 3),
              Coord(x: 1, y: 3),
              Coord(x: 0, y: 3),
            ]);
            expect(rightCoords, [
              Coord(x: 4, y: 3),
              Coord(x: 5, y: 3),
              Coord(x: 6, y: 3),
            ]);
          },
        );
        test(
          'correctly computes coords to edge from off-center coordinate',
          () {
            final start = Coord(x: 5, y: 3);
            final upCoords = grid.coordsToEdge(start, ArrowDirection.up);
            final downCoords = grid.coordsToEdge(start, ArrowDirection.down);
            final leftCoords = grid.coordsToEdge(start, ArrowDirection.left);
            final rightCoords = grid.coordsToEdge(start, ArrowDirection.right);

            expect(upCoords, [Coord(x: 5, y: 2), Coord(x: 5, y: 1)]);
            expect(downCoords, [Coord(x: 5, y: 4), Coord(x: 5, y: 5)]);
            expect(leftCoords, [
              Coord(x: 4, y: 3),
              Coord(x: 3, y: 3),
              Coord(x: 2, y: 3),
              Coord(x: 1, y: 3),
              Coord(x: 0, y: 3),
            ]);
            expect(rightCoords, [Coord(x: 6, y: 3)]);
          },
        );
        test('coordsToEdge from edge coordinate returns empty list', () {
          final start = Coord(x: 6, y: 3); // right edge
          final resultLeft = grid.coordsToEdge(start, ArrowDirection.left);
          final resultRight = grid.coordsToEdge(start, ArrowDirection.right);
          final expectedLeft = [
            Coord(x: 5, y: 3),
            Coord(x: 4, y: 3),
            Coord(x: 3, y: 3),
            Coord(x: 2, y: 3),
            Coord(x: 1, y: 3),
            Coord(x: 0, y: 3),
          ];
          final expectedRight = <Coord>[];
          expect(resultLeft, expectedLeft);
          expect(resultRight, expectedRight);
        });
      });
    });
    group('RectangleGrid', () {
      group('constructor width/height', () {
        test('constructor initializes width and height correctly', () {
          final grid = Grid.rectangle(width: 5, height: 10);
          expect(grid.width, 5);
          expect(grid.height, 10);
        });
        test('square constructor sets width and height to size', () {
          final grid = Grid.square(size: 7);
          expect(grid.width, 7);
          expect(grid.height, 7);
        });
        test(
          'constructor throws assertion error for non-positive dimensions',
          () {
            expect(
              () => Grid.rectangle(width: 0, height: 5),
              throwsA(isA<AssertionError>()),
            );
            expect(
              () => Grid.rectangle(width: 5, height: 0),
              throwsA(isA<AssertionError>()),
            );
            expect(
              () => Grid.rectangle(width: -3, height: 5),
              throwsA(isA<AssertionError>()),
            );
            expect(
              () => Grid.rectangle(width: 5, height: -2),
              throwsA(isA<AssertionError>()),
            );
          },
        );
      });
      group('constructor allCoords', () {
        test(
          'allCoords contains all valid coordinates for given width and height',
          () {
            final width = 3;
            final height = 2;
            final grid = Grid.rectangle(width: width, height: height);
            final expectedCoords = <Coord>{};
            for (int x = 0; x < width; x++) {
              for (int y = 0; y < height; y++) {
                expectedCoords.add(Coord(x: x, y: y));
              }
            }
            expect(setEquals(grid.allCoords, expectedCoords), isTrue);
          },
        );
        test('allCoords works for larger grids', () {
          final width = 1000;
          final height = 1000;
          final grid = Grid.rectangle(width: width, height: height);
          final expectedCoords = <Coord>{};
          for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
              expectedCoords.add(Coord(x: x, y: y));
            }
          }
          // Use setEquals to compare as this is much faster than expect(a, b)
          expect(setEquals(expectedCoords, grid.allCoords), isTrue);
        });
        test('allCoords works for 1x1 grid', () {
          final grid = Grid.rectangle(width: 1, height: 1);
          final expectedCoords = {Coord(x: 0, y: 0)};
          expect(setEquals(grid.allCoords, expectedCoords), isTrue);
        });
        test('rectangle allCoords is unmodifiable', () {
          final grid = Grid.rectangle(width: 2, height: 2);
          expect(
            () => grid.allCoords.add(Coord(x: 0, y: 0)),
            throwsUnsupportedError,
          );
          expect(
            () => grid.allCoords.remove(Coord(x: 1, y: 1)),
            throwsUnsupportedError,
          );
        });
      });
    });
    group('RectangleGrid coordsToEdge', () {
      final grid = Grid.rectangle(width: 5, height: 5);
      test('coordsToEdge upwards from center', () {
        final start = Coord(x: 2, y: 2);
        final result = grid.coordsToEdge(start, ArrowDirection.up);
        final expected = [Coord(x: 2, y: 1), Coord(x: 2, y: 0)];
        expect(result, expected);
      });
      test('coordsToEdge downwards from center', () {
        final start = Coord(x: 2, y: 2);
        final result = grid.coordsToEdge(start, ArrowDirection.down);
        final expected = [Coord(x: 2, y: 3), Coord(x: 2, y: 4)];
        expect(result, expected);
      });
      test('coordsToEdge leftwards from center', () {
        final start = Coord(x: 2, y: 2);
        final result = grid.coordsToEdge(start, ArrowDirection.left);
        final expected = [Coord(x: 1, y: 2), Coord(x: 0, y: 2)];
        expect(result, expected);
      });
      test('coordsToEdge rightwards from center', () {
        final start = Coord(x: 2, y: 2);
        final result = grid.coordsToEdge(start, ArrowDirection.right);
        final expected = [Coord(x: 3, y: 2), Coord(x: 4, y: 2)];
        expect(result, expected);
      });
      test('coordsToEdge throws error for invalid start coordinate', () {
        final start = Coord(x: 5, y: 5); // outside the grid
        expect(
          () => grid.coordsToEdge(start, ArrowDirection.up),
          throwsA(isA<ArgumentError>()),
        );
      });
      test('coordsToEdge from edge coordinate top/left', () {
        final start = Coord(x: 0, y: 0); // top-left corner
        final resultUp = grid.coordsToEdge(start, ArrowDirection.up);
        final resultLeft = grid.coordsToEdge(start, ArrowDirection.left);
        final expectedUp = <Coord>[];
        final expectedLeft = <Coord>[];
        expect(resultUp, expectedUp);
        expect(resultLeft, expectedLeft);
      });
      test('coordsToEdge from edge coordinate down/right', () {
        final start = Coord(x: 4, y: 4); // bottom-right corner
        final resultDown = grid.coordsToEdge(start, ArrowDirection.down);
        final resultRight = grid.coordsToEdge(start, ArrowDirection.right);
        final expectedDown = <Coord>[];
        final expectedRight = <Coord>[];
        expect(resultDown, expectedDown);
        expect(resultRight, expectedRight);
      });
      test('coordsToEdge from top/center edge coordinate ', () {
        final start = Coord(x: 2, y: 0); // top edge
        final resultUp = grid.coordsToEdge(start, ArrowDirection.up);
        final resultDown = grid.coordsToEdge(start, ArrowDirection.down);
        final expectedUp = <Coord>[];
        final expectedDown = [
          Coord(x: 2, y: 1),
          Coord(x: 2, y: 2),
          Coord(x: 2, y: 3),
          Coord(x: 2, y: 4),
        ];
        expect(resultUp, expectedUp);
        expect(resultDown, expectedDown);
      });
      test('coordsToEdge from left/center edge coordinate ', () {
        final start = Coord(x: 0, y: 2); // left edge
        final resultLeft = grid.coordsToEdge(start, ArrowDirection.left);
        final resultRight = grid.coordsToEdge(start, ArrowDirection.right);
        final expectedLeft = <Coord>[];
        final expectedRight = [
          Coord(x: 1, y: 2),
          Coord(x: 2, y: 2),
          Coord(x: 3, y: 2),
          Coord(x: 4, y: 2),
        ];
        expect(resultLeft, expectedLeft);
        expect(resultRight, expectedRight);
      });
      test('coordsToEdge from right/center edge coordinate ', () {
        final start = Coord(x: 4, y: 2); // right edge
        final resultLeft = grid.coordsToEdge(start, ArrowDirection.left);
        final resultRight = grid.coordsToEdge(start, ArrowDirection.right);
        final expectedLeft = [
          Coord(x: 3, y: 2),
          Coord(x: 2, y: 2),
          Coord(x: 1, y: 2),
          Coord(x: 0, y: 2),
        ];
        final expectedRight = <Coord>[];
        expect(resultLeft, expectedLeft);
        expect(resultRight, expectedRight);
      });
      test('coordsToEdge from bottom/center edge coordinate ', () {
        final start = Coord(x: 2, y: 4); // bottom edge
        final resultUp = grid.coordsToEdge(start, ArrowDirection.up);
        final resultDown = grid.coordsToEdge(start, ArrowDirection.down);
        final expectedUp = [
          Coord(x: 2, y: 3),
          Coord(x: 2, y: 2),
          Coord(x: 2, y: 1),
          Coord(x: 2, y: 0),
        ];
        final expectedDown = <Coord>[];
        expect(resultUp, expectedUp);
        expect(resultDown, expectedDown);
      });
      test('coordsToEdge from non-middle, non-edge coordinat', () {
        final coordToTest = Coord(x: 1, y: 1);
        final resultUp = grid.coordsToEdge(coordToTest, ArrowDirection.up);
        final resultDown = grid.coordsToEdge(coordToTest, ArrowDirection.down);
        final resultLeft = grid.coordsToEdge(coordToTest, ArrowDirection.left);
        final resultRight = grid.coordsToEdge(
          coordToTest,
          ArrowDirection.right,
        );
        final expectedUp = [Coord(x: 1, y: 0)];
        final expectedDown = [
          Coord(x: 1, y: 2),
          Coord(x: 1, y: 3),
          Coord(x: 1, y: 4),
        ];
        final expectedLeft = [Coord(x: 0, y: 1)];
        final expectedRight = [
          Coord(x: 2, y: 1),
          Coord(x: 3, y: 1),
          Coord(x: 4, y: 1),
        ];
        expect(resultUp, expectedUp);
        expect(resultDown, expectedDown);
        expect(resultLeft, expectedLeft);
        expect(resultRight, expectedRight);
      });
    });
  });
}
