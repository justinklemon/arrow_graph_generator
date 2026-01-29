import 'package:arrow_graph_generator/src/models/arrow_direction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('arrow direction reversed', () {
    test('up.reversed returns down', () {
      final direction = ArrowDirection.up;
      final reversed = direction.reversed;
      expect(reversed, ArrowDirection.down);
    });
    test('down.reversed returns up', () {
      final direction = ArrowDirection.down;
      final reversed = direction.reversed;
      expect(reversed, ArrowDirection.up);
    });
    test('left.reversed returns right', () {
      final direction = ArrowDirection.left;
      final reversed = direction.reversed;
      expect(reversed, ArrowDirection.right);
    });
    test('right.reversed returns left', () {
      final direction = ArrowDirection.right;
      final reversed = direction.reversed;
      expect(reversed, ArrowDirection.left);
    });
  });
}
