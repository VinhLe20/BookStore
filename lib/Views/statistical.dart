import 'dart:convert';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Views/Admin.dart';
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

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu doanh thu cho năm hiện tại khi trang được tải lần đầu
    _loadOrderDataByYear(DateTime.now().year);
  }

  Future<void> _loadOrderDataByYear(int year) async {
    try {
      var response = await http.get(Uri.parse('${Host.host}/getdataOder.php'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        Map<String, double> monthlyRevenueMap = {};

        // Calculate total revenue per month for the given year
        jsonData.forEach((order) {
          if (DateTime.parse(order['create']).year == year &&
              order['pay'] == 'đã thanh toán') {
            double totalPrice = double.parse(order['total_price']);
            DateTime createDateTime = DateTime.parse(order['create']);
            String month = DateFormat.MMMM().format(createDateTime);

            // Check if monthlyRevenueMap already has an entry for the month
            if (monthlyRevenueMap.containsKey(month)) {
              monthlyRevenueMap[month] = monthlyRevenueMap[month]! +
                  totalPrice; // Perform the addition if not null
            } else {
              monthlyRevenueMap[month] =
                  totalPrice; // Set initial value if null
            }
          }
        });

        // Convert map to _SalesData list for charting
        List<_SalesData> chartDataList = monthlyRevenueMap.entries
            .map((entry) => _SalesData(entry.key, entry.value))
            .toList();

        setState(() {
          _chartData = chartDataList;
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
        title: Text(
          'Thống kê doanh thu',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade500,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(
                  text: 'Thống kê theo năm ${DateTime.now().year}',
                ),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  ColumnSeries<_SalesData, String>(
                    dataSource: _chartData,
                    xValueMapper: (_SalesData sales, _) => sales.month,
                    yValueMapper: (_SalesData sales, _) => sales.revenue,
                    name: 'Doanh thu',
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
