import 'dart:async';

import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  // Start timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  // Pause timer
  void _pauseTimer() {
    _timer?.cancel();
  }

  // Handle lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pauseTimer(); // Pause when app is minimized
    } else if (state == AppLifecycleState.resumed) {
      _startTimer(); // Resume when app is back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer Example')),
      body: Center(
        child: Text('Seconds: $_seconds', style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
