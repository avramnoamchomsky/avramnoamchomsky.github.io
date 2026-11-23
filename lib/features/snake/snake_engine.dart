import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

/// Cardinal movement directions on the grid.
enum SnakeDirection { up, down, left, right }

/// Current lifecycle phase of a Snake game session.
enum SnakeStatus { ready, running, paused, gameOver, won }

/// Tick cadence presets for the Snake game.
enum SnakeSpeed {
  chill('Chill', Duration(milliseconds: 185)),
  normal('Normal', Duration(milliseconds: 125)),
  turbo('Turbo', Duration(milliseconds: 80));

  const SnakeSpeed(this.label, this.tickDuration);

  final String label;
  final Duration tickDuration;
}

/// Grid cell coordinate `(x, y)` where `(0, 0)` is top-left.
@immutable
class GridPoint {
  const GridPoint(this.x, this.y);

  final int x;
  final int y;

  GridPoint move(SnakeDirection dir) {
    return switch (dir) {
      SnakeDirection.up => GridPoint(x, y - 1),
      SnakeDirection.down => GridPoint(x, y + 1),
      SnakeDirection.left => GridPoint(x - 1, y),
      SnakeDirection.right => GridPoint(x + 1, y),
    };
  }

  @override
  bool operator ==(Object other) =>
      other is GridPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'GridPoint($x, $y)';
}

/// Pure Dart game state & loop controller for the Snake sub-app.
class SnakeEngine extends ChangeNotifier {
  SnakeEngine({
    this._gridSize = 12,
    this._speed = SnakeSpeed.normal,
    this._wrapWalls = true,
    this._showGrid = true,
    Random? random,
  }) : _random = random ?? Random() {
    _resetBoard(status: SnakeStatus.ready);
  }

  final Random _random;
  Timer? _timer;

  int _gridSize;
  SnakeSpeed _speed;
  bool _wrapWalls;
  bool _showGrid;
  SnakeStatus _status = SnakeStatus.ready;
  SnakeDirection _direction = SnakeDirection.right;
  final List<SnakeDirection> _queuedDirections = <SnakeDirection>[];
  late List<GridPoint> _snake;
  late GridPoint _food;
  int _score = 0;
  int _bestScore = 0;

  int get gridSize => _gridSize;
  SnakeSpeed get speed => _speed;
  bool get wrapWalls => _wrapWalls;
  bool get showGrid => _showGrid;
  SnakeStatus get status => _status;
  SnakeDirection get direction => _direction;
  List<GridPoint> get snake => List.unmodifiable(_snake);
  GridPoint get head => _snake.first;
  GridPoint get food => _food;
  int get score => _score;
  int get bestScore => _bestScore;

  static bool isOpposite(SnakeDirection a, SnakeDirection b) {
    return (a == SnakeDirection.up && b == SnakeDirection.down) ||
        (a == SnakeDirection.down && b == SnakeDirection.up) ||
        (a == SnakeDirection.left && b == SnakeDirection.right) ||
        (a == SnakeDirection.right && b == SnakeDirection.left);
  }

  void startOrResume() {
    if (_status == SnakeStatus.gameOver || _status == SnakeStatus.won) {
      restart(autoStart: true);
      return;
    }
    if (_status == SnakeStatus.running) return;
    _status = SnakeStatus.running;
    _startTimer();
    notifyListeners();
  }

  void pause() {
    if (_status != SnakeStatus.running) return;
    _timer?.cancel();
    _timer = null;
    _status = SnakeStatus.paused;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_status == SnakeStatus.running) {
      pause();
    } else {
      startOrResume();
    }
  }

  void restart({bool autoStart = false}) {
    _timer?.cancel();
    _timer = null;
    _resetBoard(status: autoStart ? SnakeStatus.running : SnakeStatus.ready);
    if (autoStart) {
      _startTimer();
    }
    notifyListeners();
  }

  void setSpeed(SnakeSpeed nextSpeed) {
    if (_speed == nextSpeed) return;
    _speed = nextSpeed;
    if (_status == SnakeStatus.running) {
      _startTimer();
    }
    notifyListeners();
  }

  void setGridSize(int nextSize) {
    if (_gridSize == nextSize) return;
    _gridSize = nextSize;
    restart(autoStart: false);
  }

  void setWrapWalls(bool value) {
    if (_wrapWalls == value) return;
    _wrapWalls = value;
    notifyListeners();
  }

  void setShowGrid(bool value) {
    if (_showGrid == value) return;
    _showGrid = value;
    notifyListeners();
  }

  /// Queues a cardinal steering input; starts the game automatically from ready.
  void steer(SnakeDirection next) {
    if (_status == SnakeStatus.gameOver || _status == SnakeStatus.won) {
      return;
    }
    if (_status == SnakeStatus.ready) {
      if (!isOpposite(next, _direction)) {
        _direction = next;
      }
      startOrResume();
      return;
    }
    if (_status == SnakeStatus.paused) {
      return;
    }

    final reference = _queuedDirections.isEmpty
        ? _direction
        : _queuedDirections.last;
    if (next == reference || isOpposite(next, reference)) {
      return;
    }
    if (_queuedDirections.length < 2) {
      _queuedDirections.add(next);
    }
  }

  /// Advances the simulation by one tick. Exposed for deterministic tests.
  bool step() {
    if (_status != SnakeStatus.running) return false;

    if (_queuedDirections.isNotEmpty) {
      _direction = _queuedDirections.removeAt(0);
    }

    var nextHead = _snake.first.move(_direction);

    if (_wrapWalls) {
      nextHead = GridPoint(
        (nextHead.x + _gridSize) % _gridSize,
        (nextHead.y + _gridSize) % _gridSize,
      );
    } else if (nextHead.x < 0 ||
        nextHead.x >= _gridSize ||
        nextHead.y < 0 ||
        nextHead.y >= _gridSize) {
      _endGame(SnakeStatus.gameOver);
      return false;
    }

    final willEat = nextHead == _food;
    // The current tail vacates its cell on non-growth ticks.
    final bodyToCheck = willEat
        ? _snake
        : _snake.sublist(0, _snake.length - 1);

    if (bodyToCheck.contains(nextHead)) {
      _endGame(SnakeStatus.gameOver);
      return false;
    }

    _snake.insert(0, nextHead);
    if (willEat) {
      _score += 10;
      if (_score > _bestScore) {
        _bestScore = _score;
      }
      if (_snake.length >= _gridSize * _gridSize) {
        _endGame(SnakeStatus.won);
        return true;
      }
      _spawnFood();
    } else {
      _snake.removeLast();
    }

    notifyListeners();
    return true;
  }

  void _endGame(SnakeStatus endStatus) {
    _timer?.cancel();
    _timer = null;
    _status = endStatus;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_speed.tickDuration, (_) => step());
  }

  void _resetBoard({required SnakeStatus status}) {
    final centerY = _gridSize ~/ 2;
    final startX = (_gridSize ~/ 2).clamp(3, _gridSize - 1);
    _snake = <GridPoint>[
      GridPoint(startX, centerY),
      GridPoint(startX - 1, centerY),
      GridPoint(startX - 2, centerY),
    ];
    _direction = SnakeDirection.right;
    _queuedDirections.clear();
    _score = 0;
    _status = status;
    _spawnFood();
  }

  void _spawnFood() {
    final occupied = _snake.toSet();
    final emptyCells = <GridPoint>[];
    for (var y = 0; y < _gridSize; y++) {
      for (var x = 0; x < _gridSize; x++) {
        final pt = GridPoint(x, y);
        if (!occupied.contains(pt)) {
          emptyCells.add(pt);
        }
      }
    }
    if (emptyCells.isEmpty) return;
    _food = emptyCells[_random.nextInt(emptyCells.length)];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
