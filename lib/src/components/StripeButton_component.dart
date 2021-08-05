import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';

class StripePayButton extends HookWidget {
  const StripePayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentIntentData = useState<Map<String, dynamic>>({});
    final _stripeKey = useState<String>(
      'pk_test_51JKmmuHfPPJjPocOu06RcDMNGCY42PENFLJSd5wo3DRG52aUqIidshY72iHbN0fFgAB6qII9I1hrpzIwAu70AvjC00IlJnWbTk',
    );

    useEffect(() {
      Stripe.publishableKey = _stripeKey.value;
    }, []);

    return GetBuilder<GlobalController>(
      builder: (_) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(76, 170, 177, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
          onPressed: () async {
            final url = Uri.parse(
              'http://138.197.209.230:2999/pago?amount=${((_.total + (_.total * 0.046) + 3) * 100).toInt()}&currency=MXN',
            );

            final response = await post(
              url,
              headers: {
                'Content-Type': 'application/json',
              },
            );

            if (response.statusCode == 200) {
              paymentIntentData.value = jsonDecode(response.body);

              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData.value['paymentIntent'],
                  applePay: true,
                  googlePay: true,
                  style: ThemeMode.light,
                  merchantCountryCode: 'MXN',
                  merchantDisplayName: 'PRODUCTO COSBIOME',
                ),
              );
            }

            _diaplayPaymentSheet(paymentIntentData, context, _);
          },
          child: Text(
            'PAGO CON TARJETA',
          ),
        );
      },
    );
  }

  void _diaplayPaymentSheet(
    ValueNotifier<Map<String, dynamic>> paymentIntentData,
    BuildContext context,
    GlobalController _,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentData.value['paymentIntent'],
          confirmPayment: true,
        ),
      );

      Navigator.pushNamed(context, '/home');

      _.onClearShoppingCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pago Relizado'),
        ),
      );

      print('id => ${paymentIntentData.value['id']}');

      paymentIntentData.value = {};
    } catch (e) {
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentData.value['paymentIntent'],
          confirmPayment: false,
        ),
      );
      print(e);
    }
  }
}
