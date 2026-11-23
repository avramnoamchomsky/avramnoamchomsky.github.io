import 'dart:math';

import 'package:chomsky_site/features/snake/snake_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SnakeEngine', () {
    test('starts in ready state with 3 segments and zero score', () {
      final engine = SnakeEngine(gridSize: 14, random: Random(42));

      expect(engine.status, SnakeStatus.ready);
      expect(engine.snake.length, 3);
      expect(engine.score, 0);
      expect(engine.bestScore, 0);
      expect(engine.snake.toSet().contains(engine.food), isFalse);
      engine.dispose();
    });

    test('prevents immediate 180-degree reversal and supports buffered turns', () {
      final engine = SnakeEngine(gridSize: 16, random: Random(7));
      final startHead = engine.head;

      engine.startOrResume();
      // Attempting opposite direction while moving right is ignored.
      engine.steer(SnakeDirection.left);
      engine.step();
      expect(engine.direction, SnakeDirection.right);
      expect(engine.head, GridPoint(startHead.x + 1, startHead.y));

      // Queue two perpendicular inputs in one tick: up, then left.
      engine.steer(SnakeDirection.up);
      engine.steer(SnakeDirection.left);

      engine.step();
      expect(engine.direction, SnakeDirection.up);
      expect(engine.head, GridPoint(startHead.x + 1, startHead.y - 1));

      engine.step();
      expect(engine.direction, SnakeDirection.left);
      expect(engine.head, GridPoint(startHead.x, startHead.y - 1));

      engine.dispose();
    });

    test('wraps around edges when wrapWalls is enabled and hits wall when disabled', () {
      final wrapping = SnakeEngine(
        gridSize: 10,
        wrapWalls: true,
        random: Random(1),
      )..startOrResume();

      for (var i = 0; i < 15; i++) {
        wrapping.step();
        if (wrapping.status == SnakeStatus.gameOver) break;
      }
      expect(wrapping.status, SnakeStatus.running);
      wrapping.dispose();

      final solid = SnakeEngine(
        gridSize: 10,
        wrapWalls: false,
        random: Random(1),
      )..startOrResume();

      for (var i = 0; i < 15; i++) {
        if (!solid.step()) break;
      }
      expect(solid.status, SnakeStatus.gameOver);
      solid.dispose();
    });

    test('grows and updates best score when eating food', () {
      final engine = SnakeEngine(
        gridSize: 12,
        wrapWalls: true,
        random: Random(99),
      );
      final initialLen = engine.snake.length;
      engine.startOrResume();

      // Step toward the food deterministically using Manhattan direction.
      var ate = false;
      for (var stepCount = 0; stepCount < 40; stepCount++) {
        final head = engine.head;
        final food = engine.food;
        if (head.x < food.x && engine.direction != SnakeDirection.left) {
          engine.steer(SnakeDirection.right);
        } else if (head.x > food.x &&
            engine.direction != SnakeDirection.right) {
          engine.steer(SnakeDirection.left);
        } else if (head.y < food.y && engine.direction != SnakeDirection.up) {
          engine.steer(SnakeDirection.down);
        } else if (head.y > food.y &&
            engine.direction != SnakeDirection.down) {
          engine.steer(SnakeDirection.up);
        }

        engine.step();
        if (engine.score > 0) {
          ate = true;
          break;
        }
      }

      expect(ate, isTrue);
      expect(engine.score, 10);
      expect(engine.bestScore, 10);
      expect(engine.snake.length, initialLen + 1);
      engine.dispose();
    });
  });
}
