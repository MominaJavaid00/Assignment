import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CoinFlipGame());
}

class CoinFlipGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin Flip Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoinFlipScreen(),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  String coinFace = 'Heads'; // Initial face of the coin
  bool isFlipping = false; // To manage flip state
  String resultMessage = ""; // Message to display after flipping

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Duration of the coin flip animation
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCoin() {
    setState(() {
      isFlipping = true;
    });

    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        // Randomly decide between heads and tails
        bool isHeads = Random().nextBool();
        coinFace = isHeads ? 'Heads' : 'Tails';

        // Show result message after the coin has flipped
        resultMessage = coinFace == 'Heads' ? "It's Heads!" : "It's Tails!";

        isFlipping = false; // Reset the flipping state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Flip Game'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                transform: Matrix4.rotationY(_animation.value), // Y-axis rotation for flip effect
                alignment: Alignment.center,
                child: Image.asset(
                  coinFace == 'Heads' ? 'assets/images.jpeg' : 'assets/images (1).jpeg',
                  height: 150,
                  width: 150,
                ),
              ),
              SizedBox(height: 30),
              Text(
                isFlipping ? 'Flipping...' : resultMessage, // Display the result
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: isFlipping
                    ? null // Disable button while flipping
                    : () {
                  flipCoin();
                },
                child: Text('Flip the Coin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
