import 'package:flutter/material.dart';
import 'widgets/expense_tracker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: ExpenseTracker(),
        ),
      ),
    );
  }
}
