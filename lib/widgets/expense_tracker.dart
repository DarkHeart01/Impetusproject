import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csv/csv.dart';

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  List<ExpenseData> chartData = [];
  bool loading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    try {
      final String csvData = await rootBundle.loadString('assets/data.csv');
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
      List<ExpenseData> data = [];

      for (var row in csvTable) {
        if (row.length >= 2) {
          String month = row[0].toString();
          double expense = double.tryParse(row[1].toString()) ?? 0.0;

          if (expense != null) {
            data.add(ExpenseData(month, expense));
          } else {
            print('Invalid expense value for month: $month');
          }
        } else {
          print('Invalid row format: $row');
        }
      }

      setState(() {
        chartData = data;
        loading = false;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = 'Error loading data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Expenses Over Time',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        loading
            ? CircularProgressIndicator()
            : errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  )
                : Expanded(
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: 'Month'),
                      ),
                      primaryYAxis: NumericAxis(
                        labelFormat: '{value} \$',
                        title: AxisTitle(text: 'Expense'),
                      ),
                      series: <CartesianSeries<ExpenseData, String>>[
                        LineSeries<ExpenseData, String>(
                          dataSource: chartData,
                          xValueMapper: (ExpenseData expenses, _) =>
                              expenses.month,
                          yValueMapper: (ExpenseData expenses, _) =>
                              expenses.expense,
                        )
                      ],
                    ),
                  ),
      ],
    );
  }
}

class ExpenseData {
  final String month;
  final double expense;

  ExpenseData(this.month, this.expense);
}
