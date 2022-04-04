// @JS()
// library stripe;

// import 'package:flutter/material.dart';
// import 'package:js/js.dart';

// void redirectToCheckout(BuildContext _, String pago) async {
//   final stripe = Stripe(
//       'pk_test_51JKmmuHfPPJjPocOu06RcDMNGCY42PENFLJSd5wo3DRG52aUqIidshY72iHbN0fFgAB6qII9I1hrpzIwAu70AvjC00IlJnWbTk');
//   stripe.redirectToCheckout(
//     CheckoutOptions(
//       lineItems: [
//         LineItem(price: pago, quantity: 1),
//       ],
//       mode: 'payment',
//       successUrl: 'http://localhost:8080/#/success',
//       cancelUrl: 'http://localhost:8080/#/cancel',
//     ),
//   );
// }

// @JS()
// class Stripe {
//   external Stripe(String key);

//   external redirectToCheckout(CheckoutOptions options);
// }

// @JS()
// @anonymous
// class CheckoutOptions {
//   external List<LineItem> get lineItems;

//   external String get mode;

//   external String get successUrl;

//   external String get cancelUrl;

//   external factory CheckoutOptions({
//     List<LineItem> lineItems,
//     String mode,
//     String successUrl,
//     String cancelUrl,
//     String sessionId,
//   });
// }

// @JS()
// @anonymous
// class LineItem {
//   external String get price;

//   external int get quantity;

//   external factory LineItem({String price, int quantity});
// }
