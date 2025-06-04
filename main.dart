import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Full-screen mode
  runApp(const SudokuSolverApp());
}

class SudokuSolverApp extends StatelessWidget {
  const SudokuSolverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver | PRINCE',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SudokuSolverHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SudokuSolverHomePage extends StatefulWidget {
  const SudokuSolverHomePage({Key? key}) : super(key: key);

  @override
  State<SudokuSolverHomePage> createState() => _SudokuSolverHomePageState();
}

class _SudokuSolverHomePageState extends State<SudokuSolverHomePage> {
  static const int size = 9;
  final List<List<TextEditingController>> _controllers = List.generate(
    size,
        (_) => List.generate(size, (_) => TextEditingController()),
  );
  late List<List<Color>> _gridColors;

  @override
  void initState() {
    super.initState();
    _shuffleGridColors();
  }

  void _shuffleGridColors() {
    final List<Color> colors = [
      Colors.pink.shade100,
      const Color(0xFFE6E6FA), // Custom lavender color
      Colors.lightBlue.shade100,
      Colors.teal.shade100,
      Colors.yellow.shade100,
      Colors.lightGreen.shade100,
      Colors.orange.shade100,
      Colors.amber.shade100,
      Colors.purple.shade100,
    ];
    colors.shuffle();

    _gridColors = List.generate(
      size,
          (row) => List.generate(size, (col) {
        int blockIndex = (row ~/ 3) * 3 + (col ~/ 3);
        return colors[blockIndex];
      }),
    );
  }

  void _resetBoard() {
    setState(() {
      for (var row in _controllers) {
        for (var controller in row) {
          controller.clear();
        }
      }
      _shuffleGridColors();
    });
  }

  void _solveSudoku() {
    List<List<int>> board = List.generate(size, (i) {
      return List.generate(size, (j) {
        String val = _controllers[i][j].text;
        return val.isEmpty ? 0 : int.parse(val);
      });
    });

    if (!_isValidSudoku(board)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid input: Duplicate numbers found!")),
      );
      return;
    }

    bool solve(List<List<int>> grid) {
      for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
          if (grid[row][col] == 0) {
            for (int num = 1; num <= 9; num++) {
              if (_isSafe(grid, row, col, num)) {
                grid[row][col] = num;
                if (solve(grid)) return true;
                grid[row][col] = 0;
              }
            }
            return false;
          }
        }
      }
      return true;
    }

    if (solve(board)) {
      setState(() {
        for (int row = 0; row < size; row++) {
          for (int col = 0; col < size; col++) {
            _controllers[row][col].text = board[row][col].toString();
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No solution exists for this Sudoku!")),
      );
    }
  }

  bool _isSafe(List<List<int>> grid, int row, int col, int num) {
    for (int i = 0; i < size; i++) {
      if (grid[row][i] == num || grid[i][col] == num) return false;
    }

    int startRow = row - row % 3, startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[startRow + i][startCol + j] == num) return false;
      }
    }
    return true;
  }

  bool _isValidSudoku(List<List<int>> grid) {
    Set<String> seen = {};
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        int num = grid[row][col];
        if (num != 0) {
          if (!seen.add('$num in row $row') ||
              !seen.add('$num in col $col') ||
              !seen.add('$num in block ${row ~/ 3}-${col ~/ 3}')) {
            return false;
          }
        }
      }
    }
    return true;
  }

  Widget _buildSudokuGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: size,
      ),
      itemCount: size * size,
      itemBuilder: (context, index) {
        int row = index ~/ size;
        int col = index % size;

        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: _gridColors[row][col],
            border: Border.all(color: Colors.black45),
          ),
          alignment: Alignment.center, // Center the content inside the container
          child: TextField(
            controller: _controllers[row][col],
            textAlign: TextAlign.center, // Center text horizontally
            textAlignVertical: TextAlignVertical.center, // Center text vertically
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '', // Hide character counter
              isCollapsed: true, // Ensures no extra height
              contentPadding: EdgeInsets.zero, // Remove padding
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sudoku Solver | PRINCE',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Responsive title size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Sudoku Grid
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1, // Ensures the grid stays square
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildSudokuGrid(),
                  ),
                ),
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _solveSudoku,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Solve"),
                  ),
                  ElevatedButton(
                    onPressed: _resetBoard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10), // Spacing
          ],
        ),
      ),
    );
  }
}
