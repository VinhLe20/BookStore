import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:bookstore/Views/Admin.dart';  // Make sure this import is correct based on your project structure

class Statistical extends StatefulWidget {
  const Statistical({super.key});

  @override
  State<Statistical> createState() => _StatisticalState();
}

class _StatisticalState extends State<Statistical> {
  DateTime? _selectedDate;
  List<_SalesData> _chartData = [];

  @override
  void initState() {
    super.initState();
    _chartData = getChartData();
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.blue,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _chartData =
            getChartData(); // Update the chart data based on the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistical Revenue'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Admin()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _selectMonthYear(context),
              child: Text(
                _selectedDate == null
                    ? 'Select Month and Year'
                    : DateFormat.yMMM().format(_selectedDate!),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(
                    text:
                        'Revenue for ${_selectedDate != null ? DateFormat.yMMM().format(_selectedDate!) : 'Selected Month'}'),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<_SalesData, String>>[
                  ColumnSeries<_SalesData, String>(
                    dataSource: _chartData,
                    xValueMapper: (_SalesData sales, _) => sales.day.toString(),
                    yValueMapper: (_SalesData sales, _) => sales.revenue,
                    name: 'Revenue',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_SalesData> getChartData() {
    // Generate dummy data based on the selected date
    // In a real-world scenario, you would fetch data from your backend or database
    final DateTime now = DateTime.now();
    final DateTime date = _selectedDate ?? now;
    final int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final List<_SalesData> chartData = List.generate(
      daysInMonth,
      (index) => _SalesData(index + 1, (index + 1) * 100.0),
    );
    return chartData;
  }
}

class _SalesData {
  _SalesData(this.day, this.revenue);

  final int day;
  final double revenue;
}
