import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/game_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => GameCubit(),
        child: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<GameCubit, List<List<int>>>(
              builder: (context, state) {
                bool isGameOver = state.any((i) => i.contains(0));
                return Text(
                  isGameOver ? 'Game Over' : 'Swipe to move',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragEnd: (DragEndDetails details) {
                if (details.velocity.pixelsPerSecond.dy < 0) {
                  context.read<GameCubit>().swipeUp();
                } else if (details.velocity.pixelsPerSecond.dy > 0) {
                  context.read<GameCubit>().swipeDown();
                }
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                if (details.velocity.pixelsPerSecond.dx < 0) {
                  context.read<GameCubit>().swipeLeft();
                } else if (details.velocity.pixelsPerSecond.dx > 0) {
                  context.read<GameCubit>().swipeRight();
                }
              },
              child: BlocBuilder<GameCubit, List<List<int>>>(
                builder: (context, state) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      final i = index ~/ 4;
                      final y = index % 4;
                      final tileValue = state[i][y];

                      return Container(
                        color: _getTileColor(tileValue),
                        child: Center(
                          child: Text(
                            tileValue != 0 ? tileValue.toString() : '',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GameCubit>().resetGame();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 8:
        return Colors.red;
      case 16:
        return Colors.purple;
      case 32:
        return Colors.blue;
      case 64:
        return Colors.green;
      case 128:
        return Colors.teal;
      case 256:
        return Colors.cyan;
      case 512:
        return Colors.deepPurple;
      case 1024:
        return Colors.deepOrange;
      case 2048:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
