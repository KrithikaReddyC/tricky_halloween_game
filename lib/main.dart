// Team members
//  Harshith Dande
// Krithika

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

void main() {
  runApp(HalloweenGameApp());
}

class HalloweenGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Game',
      home: HalloweenGameScreen(),
    );
  }
}

class HalloweenGameScreen extends StatefulWidget {
  @override
  _HalloweenGameScreenState createState() => _HalloweenGameScreenState();
}

class _HalloweenGameScreenState extends State<HalloweenGameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();

  double _ghostX = 0.0;
  double _ghostY = 0.0;
  double _batX = 200.0;
  double _batY = 100.0;
  double _pumpkinX = 150.0;
  double _pumpkinY = 400.0;
  double _candyX = 100.0;
  double _candyY = 300.0;
  double _treeX = 50.0;
  double _treeY = 200.0;

  bool _isCorrectItemFound = false;
  int _attempts = 5; // Number of attempts allowed

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
    _animateObjects();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.play('assets/spooky_music.mp3', isLocal: true);
    _audioPlayer.onPlayerCompletion.listen((event) {
      _audioPlayer.play('assets/spooky_music.mp3', isLocal: true);
    });
  }

  void _playSoundEffect(String path) async {
    final player = AudioPlayer();
    await player.play(path, isLocal: true);
  }

  void _animateObjects() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _ghostX = _random.nextDouble() * 300;
        _ghostY = _random.nextDouble() * 500;
        _batX = _random.nextDouble() * 300;
        _batY = _random.nextDouble() * 500;
        _pumpkinX = _random.nextDouble() * 300;
        _pumpkinY = _random.nextDouble() * 500;
        _candyX = _random.nextDouble() * 300;
        _candyY = _random.nextDouble() * 500;
        _treeX = _random.nextDouble() * 300;
        _treeY = _random.nextDouble() * 500;
      });
      _animateObjects();
    });
  }

  void _handleTrapTap() {
    if (_attempts > 0 && !_isCorrectItemFound) {
      setState(() {
        _attempts -= 1;
      });
      _playSoundEffect('assets/jump_scare.mp3');

      if (_attempts == 0) {
        _showGameOverDialog();
      }
    }
  }

  void _handleCorrectTap() {
    if (!_isCorrectItemFound && _attempts > 0) {
      setState(() {
        _isCorrectItemFound = true;
      });
      _playSoundEffect('assets/success_sound.mp3');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("You Found It!"),
          content: Text("Congratulations! You found the correct item."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  void _handleCandyTap() {
    if (_attempts > 0 && !_isCorrectItemFound) {
      setState(() {
        _attempts += 1; // Add an extra attempt as a reward
      });
      _playSoundEffect('assets/success_sound.mp3');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Yum! You found candy and gained an extra attempt!")),
      );
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Game Over"),
        content: Text("You've run out of attempts. Better luck next time!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Halloween Game'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Display remaining attempts
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              'Attempts left: $_attempts',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          // Animated Ghost (Trap)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            left: _ghostX,
            top: _ghostY,
            child: GestureDetector(
              onTap:
                  _attempts > 0 && !_isCorrectItemFound ? _handleTrapTap : null,
              child: Image.asset('assets/ghost.jpeg', width: 80),
            ),
          ),
          // Animated Bat (Trap)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            left: _batX,
            top: _batY,
            child: GestureDetector(
              onTap:
                  _attempts > 0 && !_isCorrectItemFound ? _handleTrapTap : null,
              child: Image.asset('assets/bat.png', width: 80),
            ),
          ),
          // Moving Pumpkin (Correct Item)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            left: _pumpkinX,
            top: _pumpkinY,
            child: GestureDetector(
              onTap: _attempts > 0 && !_isCorrectItemFound
                  ? _handleCorrectTap
                  : null,
              child: Image.asset('assets/pumpkin.png', width: 100),
            ),
          ),
          // Moving Candy (Bonus Item)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            left: _candyX,
            top: _candyY,
            child: GestureDetector(
              onTap: _attempts > 0 && !_isCorrectItemFound
                  ? _handleCandyTap
                  : null,
              child: Image.asset('assets/candy.jpg', width: 60),
            ),
          ),
          // Moving Tree (Additional Trap)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            left: _treeX,
            top: _treeY,
            child: GestureDetector(
              onTap:
                  _attempts > 0 && !_isCorrectItemFound ? _handleTrapTap : null,
              child: Image.asset('assets/tree.png', width: 80),
            ),
          ),
        ],
      ),
    );
  }
}
