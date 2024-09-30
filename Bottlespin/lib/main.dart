import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(SpinBottleApp());
}

class SpinBottleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PlayerInputScreen(),
    );
  }
}

// 1. Player Input Screen
class PlayerInputScreen extends StatefulWidget {
  @override
  _PlayerInputScreenState createState() => _PlayerInputScreenState();
}

class _PlayerInputScreenState extends State<PlayerInputScreen> {
  final _playerNames = <String>[];
  final _playerController = TextEditingController();

  void _addPlayer() {
    if (_playerController.text.isNotEmpty && _playerNames.length < 10) {
      setState(() {
        _playerNames.add(_playerController.text);
        _playerController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Players')),
      body: Column(
        children: [
          TextField(
            controller: _playerController,
            decoration: InputDecoration(labelText: 'Player Name'),
          ),
          ElevatedButton(onPressed: _addPlayer, child: Text('Add Player')),
          Expanded(
            child: ListView.builder(
              itemCount: _playerNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_playerNames[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _playerNames.length >= 2
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BottleSelectionScreen(players: _playerNames),
                ),
              );
            }
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

// 2. Bottle Selection Screen
class BottleSelectionScreen extends StatelessWidget {
  final List<String> players;
  final List<String> bottleImages = [
    'assets/1.jpg',  // Using your custom assets
    'assets/2.png',  // Using your custom assets
  ];

  BottleSelectionScreen({required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Bottle')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: bottleImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    players: players,
                    bottleImage: bottleImages[index],
                  ),
                ),
              );
            },
            child: Image.asset(bottleImages[index]), // Display the custom bottle images
          );
        },
      ),
    );
  }
}

// 3. Game Screen with Bottle Spin
class GameScreen extends StatefulWidget {
  final List<String> players;
  final String bottleImage;

  GameScreen({required this.players, required this.bottleImage});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _spinning = false;
  String? _selectedPlayer;
  final List<String> _challenges = [
    'Dance for 30 seconds',
    'Sing a song',
    'Tell a joke',
    'Do 10 push-ups',
    'Imitate an animal',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 6 * pi).animate(_controller);
  }

  void _spinBottle() {
    setState(() {
      _spinning = true;
    });

    _controller.forward(from: 0).then((_) {
      final randomIndex = Random().nextInt(widget.players.length);
      setState(() {
        _selectedPlayer = widget.players[randomIndex];
        _spinning = false;
      });

      _showChallengeDialog();
    });
  }

  void _showChallengeDialog() {
    final randomChallenge = _challenges[Random().nextInt(_challenges.length)];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Challenge for $_selectedPlayer'),
        content: Text(randomChallenge),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spin the Bottle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _animation,
              child: Image.asset(widget.bottleImage, height: 200), // Use your selected bottle image
            ),
            SizedBox(height: 20),
            if (_selectedPlayer != null)
              Text(
                'Selected Player: $_selectedPlayer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: !_spinning ? _spinBottle : null,
              child: Text(_spinning ? 'Spinning...' : 'Spin the Bottle'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
