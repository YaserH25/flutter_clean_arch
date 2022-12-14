import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/core/app_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      title: 'aa',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App'),
        ),
        body: Center(
          child: Container(
            child: Text('HelloWorld'),
          ),
        ),
      ),
    );
  }
}
