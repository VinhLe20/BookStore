import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';



class Statistical extends StatefulWidget {
  const Statistical({Key? key}) : super(key: key);

  @override
  State<Statistical> createState() => _StatisticalState();
}

class _StatisticalState extends State<Statistical> {
  late List<_SalesData> _chartData = [];
  TextEditingController _yearController = TextEditingController();

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAllOrderData();
  }

  Future<void> _loadAllOrderData() async {
    try {
      var response =
          await http.get(Uri.parse('http://192.168.1.13:8012/getdataOder.php'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _chartData = jsonData.map((order) {
            double totalPrice = double.parse(order['total_price']);
            DateTime createDateTime = DateTime.parse(order['create']);
            String month = DateFormat.MMMM().format(createDateTime);
            return _SalesData(month, totalPrice);
          }).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadOrderDataByYear(int year) async {
    try {
      var response =
          await http.get(Uri.parse('http://192.168.1.13:8012/getdataOder.php'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _chartData = jsonData
              .where((order) =>
                  DateTime.parse(order['create']).year == year &&
                  order['pay'] == 'đã thanh toán')
              .map((order) {
            double totalPrice = double.parse(order['total_price']);
            DateTime createDateTime = DateTime.parse(order['create']);
            String month = DateFormat.MMMM().format(createDateTime);
            return _SalesData(month, totalPrice);
          }).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
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
            TextField(
              controller: _yearController,
              decoration: InputDecoration(
                labelText: 'Enter Year',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_yearController.text.isNotEmpty) {
                  int year = int.parse(_yearController.text);
                  _loadOrderDataByYear(year);
                }
              },
              child: const Text('Load Data'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(
                  text: 'Revenue by Month',
                ),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<dynamic, dynamic>>[
                  ColumnSeries<_SalesData, String>(
                    dataSource: _chartData,
                    xValueMapper: (_SalesData sales, _) => sales.month,
                    yValueMapper: (_SalesData sales, _) => sales.revenue,
                    name: 'Revenue',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.month, this.revenue);

  final String month;
  final double revenue;
}
