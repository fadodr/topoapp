import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/homescreen.dart';
import 'package:todoapp/provider/todosprovider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Todosprovider())
      ],
      child: MaterialApp(
        home: Homescreen(),
      ),
    );
  }
}