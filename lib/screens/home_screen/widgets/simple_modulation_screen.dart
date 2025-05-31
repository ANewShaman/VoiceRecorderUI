import 'package:flutter/material.dart';
import 'dart:math';

class SimpleModulationScreen extends StatefulWidget {
  const SimpleModulationScreen({Key? key}) : super(key: key);

  @override
  _SimpleModulationScreenState createState() => _SimpleModulationScreenState();
}

class _SimpleModulationScreenState extends State<SimpleModulationScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  List<double> _bars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..repeat();
    
    _bars = List.generate(20, (_) => _random.nextDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _bars = _bars.map((val) {
            final change = (_random.nextDouble() - 0.5) * 0.2;
            return (val + change).clamp(0.1, 1.0);
          }).toList();
          
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _bars.map((height) {
                return Container(
                  width: 10,
                  height: height * 100,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_controller.isAnimating ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          if (_controller.isAnimating) {
            _controller.stop();
          } else {
            _controller.repeat();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}