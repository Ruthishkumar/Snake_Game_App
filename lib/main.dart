import 'package:arcade_game/view/number_guessing_game/number_screen_provider/number_screen_provider.dart';
import 'package:arcade_game/view/word_game/provider/word_game_provider.dart';
import 'package:arcade_game/view/word_game/screens/word_game_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NumberScreenProvider()),
    ChangeNotifierProvider(create: (_) => WordGameProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 805),
      builder: (context, child) {
        return MaterialApp(
          title: 'Offline Arcade Game',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const GameScreen(),
        );
      },
    );
  }
}
