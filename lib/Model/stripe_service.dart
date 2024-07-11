import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  static String secrectKey =
      "sk_test_51PbE052Kp0Ros8xQ8sywuANHEYQDBCLcWWYRlYXXTIYRen2Gelw2xBaIWqgwEy1eFBYS9xKMJOSXmzjKY8runCnt00seF6162q";
  static String publicshableKey =
      "pk_test_51PbE052Kp0Ros8xQ2BSShPPjbDMn79CR39LqhHD0QdmlDrgd9UcxZOpNLNBJqlonRHjXRPYZoUIIzu4zMsstRCcq00bSTrJCCX";
  static Future<dynamic> createCheckoutSesion(
      List<dynamic> product, var totalAmount) async {
    final url = Uri.parse("http://api.stripe.com/v1/checkout/sessions");
    String lineItem = '';
    int index = 0;
    product.forEach((val) {
      var productPrice = (val["productPrice"] * 100).toString();
      lineItem +=
          "&line_items[$index][price_data][product_data][name]= ${val['productName']}";
      lineItem +=
          "&line_items[$index][price_data][unit_amount]= ${val['productPrice']}";
      lineItem += "&line_items[$index][price_data][currency]= EUR";
      lineItem +=
          "&line_items[$index][qunatity]= ${val['quantity'].toString()}";
      index++;
    });
    final reponse = await http.post(url,
        body:
            'success_url=http://checkout.stripe.dev/success&mode=payment$lineItem',
        headers: {'Authorization': 'Bearer $secrectKey'});
    return json.decode(reponse.body)["id"];
  }

  static Future<dynamic> stripePaymentCheckout(
      productItems, subTotal, context, mounted,
      {onSuccess, onCancel, onError}) async {
    final sessionId = await createCheckoutSesion(productItems, subTotal);
    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey: publicshableKey,
      successUrl: "http://checkout.stripe.dev/success",
      canceledUrl: "http://checkout.stripe.dev/cancel",
    );
    if (mounted) {
      final text = result.when(
        redirected: () => 'Redirected Successfuly',
        success: () => onSuccess(),
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );
      return text;
    }
  }
}
