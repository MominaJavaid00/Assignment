import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  // Create an AudioPlayer instance
  final AudioPlayer player = AudioPlayer();

  // Function to play sound based on index
  void playSound(int soundNumber) async {
    await player.play(AssetSource('note$soundNumber.wav')); // Use AssetSource
  }

  // Build each key as an Expanded widget
  Expanded buildKey({required Color color, required int soundNumber}) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color, // Set background color for each key
        ),
        onPressed: () {
          playSound(soundNumber); // Play sound on button press
        },
        child: Container(), // Empty container just to take up space
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Xylophone'),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildKey(color: Colors.red, soundNumber: 1),
            buildKey(color: Colors.orange, soundNumber: 2),
            buildKey(color: Colors.yellow, soundNumber: 3),
            buildKey(color: Colors.green, soundNumber: 4),
            buildKey(color: Colors.blue, soundNumber: 5),
            buildKey(color: Colors.purple, soundNumber: 6),
          ],
        ),
      ),
    );
  }
}
