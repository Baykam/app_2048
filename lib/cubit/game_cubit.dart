import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class GameCubit extends Cubit<List<List<int>>> {
  late List<List<int>> board;
  bool isGameOver = false;

  GameCubit() : super([]) {
    resetGame();
  }

  void resetGame() {
    board = List.generate(4, (_) => List<int>.filled(4, 0));
    addRandomTile();
    addRandomTile();
    emit(List<List<int>>.from(board));
  }

  void addRandomTile() {
    List<Point<int>> availableCells = [];
    for (int i = 0; i < 4; i++) {
      for (int y = 0; y < 4; y++) {
        if (board[i][y] == 0) {
          availableCells.add(Point(i, y));
        }
      }
    }

    if (availableCells.isEmpty) {
      isGameOver = true;
      return;
    }

    final random = Random();
    final randomIndex = random.nextInt(availableCells.length);
    final randomCell = availableCells[randomIndex];
    final randomValue = random.nextInt(10) < 9 ? 2 : 4;

    board[randomCell.x][randomCell.y] = randomValue;
    emit(List<List<int>>.from(board));
  }

  void swipeLeft() {
    bool hasChanged = false;
    for (int i = 0; i < 4; i++) {
      int currentPos = 0;
      int lastMerged = -1;
      List<int> newi = List<int>.filled(4, 0);
      for (int y = 0; y < 4; y++) {
        if (board[i][y] != 0) {
          if (currentPos > 0 &&
              newi[currentPos - 1] == board[i][y] &&
              lastMerged != currentPos - 1) {
            newi[currentPos - 1] *= 2;
            board[i][y] = 0;
            lastMerged = currentPos - 1;
            hasChanged = true;
          } else {
            newi[currentPos] = board[i][y];
            if (currentPos != y) {
              hasChanged = true;
            }
            currentPos++;
          }
        }
      }
      for (int y = 0; y < 4; y++) {
        board[i][y] = newi[y];
      }
    }
    if (hasChanged) {
      addRandomTile();
    }
    emit(List<List<int>>.from(board));
  }

  void swipeRight() {
    bool hasChanged = false;
    for (int i = 0; i < 4; i++) {
      int currentPos = 3;
      int lastMerged = -1;
      List<int> newi = List<int>.filled(4, 0);
      for (int y = 3; y >= 0; y--) {
        if (board[i][y] != 0) {
          if (currentPos < 3 &&
              newi[currentPos + 1] == board[i][y] &&
              lastMerged != currentPos + 1) {
            newi[currentPos + 1] *= 2;
            board[i][y] = 0;
            lastMerged = currentPos + 1;
            hasChanged = true;
          } else {
            newi[currentPos] = board[i][y];
            if (currentPos != y) {
              hasChanged = true;
            }
            currentPos--;
          }
        }
      }
      for (int y = 3; y >= 0; y--) {
        board[i][y] = newi[3 - y];
      }
    }
    if (hasChanged) {
      addRandomTile();
    }
    emit(List<List<int>>.from(board));
  }

  void swipeUp() {
    bool hasChanged = false;
    for (int y = 0; y < 4; y++) {
      int currentPos = 0;
      int lastMerged = -1;
      List<int> newy = List<int>.filled(4, 0);
      for (int i = 0; i < 4; i++) {
        if (board[i][y] != 0) {
          if (currentPos > 0 &&
              newy[currentPos - 1] == board[i][y] &&
              lastMerged != currentPos - 1) {
            newy[currentPos - 1] *= 2;
            board[i][y] = 0;
            lastMerged = currentPos - 1;
            hasChanged = true;
          } else {
            newy[currentPos] = board[i][y];
            if (currentPos != i) {
              hasChanged = true;
            }
            currentPos++;
          }
        }
      }
      for (int i = 0; i < 4; i++) {
        board[i][y] = newy[i];
      }
    }
    if (hasChanged) {
      addRandomTile();
    }
    emit(List<List<int>>.from(board));
  }

  void swipeDown() {
    bool hasChanged = false;
    for (int y = 0; y < 4; y++) {
      int currentPos = 3;
      int lastMerged = -1;
      List<int> newy = List<int>.filled(4, 0);
      for (int i = 3; i >= 0; i--) {
        if (board[i][y] != 0) {
          if (currentPos < 3 &&
              newy[currentPos + 1] == board[i][y] &&
              lastMerged != currentPos + 1) {
            newy[currentPos + 1] *= 2;
            board[i][y] = 0;
            lastMerged = currentPos + 1;
            hasChanged = true;
          } else {
            newy[currentPos] = board[i][y];
            if (currentPos != i) {
              hasChanged = true;
            }
            currentPos--;
          }
        }
      }
      for (int i = 3; i >= 0; i--) {
        board[i][y] = newy[3 - i];
      }
    }
    if (hasChanged) {
      addRandomTile();
    }
    emit(List<List<int>>.from(board));
  }
}
