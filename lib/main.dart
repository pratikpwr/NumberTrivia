import 'package:flutter/material.dart';
import 'package:numtrivia/features/number_trivia/presentation/screens/number_trivia_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  /* ENSURE ASYNC WILL NOT GENERATE RUNTIME ERROR */
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  NumberTriviaScreen(),
    );
  }
}
