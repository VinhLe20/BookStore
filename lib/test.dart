import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class Payment extends StatefulWidget {
  Payment({
    Key? key,
    required this.products,
    required this.total,
    required this.quantity,
  }) : super(key: key);

  final dynamic products;
  final String total;
  final String quantity;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String selectedPaymentMethod = 'Thanh toán khi nhận hàng';

  @override
  Widget build(BuildContext context) {
    int totalCost = int.parse(widget.total);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (selectedPaymentMethod == 'Ví điện tử Momo') {
              payWithStripe();
            } else {
              // Handle other payment methods
            }
          },
          child: Text('Thanh toán'),
        ),
      ),
    );
  }

  Future<void> payWithStripe() async {
    try {
      // Replace with your own server endpoint for creating a PaymentIntent
      final response = await http.post(
        Uri.parse('https://buy.stripe.com/test_14keWU8Hw9Vc5LW146'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': widget.total,
          'currency': 'usd',
        }),
      );

      final paymentIntentData = jsonDecode(response.body);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          merchantDisplayName: 'BookStore', // Replace with your app's name
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thanh toán thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thanh toán thất bại: $e')),
      );
    }
  }
}