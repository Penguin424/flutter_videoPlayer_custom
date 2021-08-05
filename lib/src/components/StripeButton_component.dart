import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Venta_model.dart';
import 'package:simple_moment/simple_moment.dart';

class StripePayButton extends HookWidget {
  const StripePayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentIntentData = useState<Map<String, dynamic>>({});
    final _stripeKey = useState<String>(
      'pk_test_51JKmmuHfPPJjPocOu06RcDMNGCY42PENFLJSd5wo3DRG52aUqIidshY72iHbN0fFgAB6qII9I1hrpzIwAu70AvjC00IlJnWbTk',
    );

    final _g = Get.find<GlobalController>();
    final moment = new Moment.now().locale(new LocaleDe());

    final _direccion = Direccion(
      ciudad: _g.alumno.alumnoMunicipio,
      codigoPostal: _g.alumno.alumnoCodiPostal,
      colonia: _g.alumno.alumnoDomicilio,
      cruces: "S/N",
      domicilio: _g.alumno.alumnoDomicilio,
      estado: _g.alumno.alumnoEstado,
      tipo: "casa",
    );

    final _producto = _g.productos
        .map(
          (e) => ProductosCompra(
            cantidad: e.canitdad,
            precio: e.price,
            producto: e.name,
          ),
        )
        .toList();

    final _venta = useState<Venta>(
      Venta(
        nombreCliente:
            '${_g.alumno.alumnoNombres} ${_g.alumno.alumnoApellidoPaterno} ${_g.alumno.alumnoApellidoMaterno}',
        vendedor: _g.alumno.alumnoVendedor,
        total: _g.total,
        subTotal: _g.total,
        aparatado: 0,
        estatus: 'PAGADO',
        direccion: _direccion,
        cargo: 1,
        de: '',
        a: '',
        numTel: _g.alumno.alumnoCelular,
        metodoDePago: 'Deposito Bancario',
        fechaDeEntrega: '',
        idCliente: '',
        idFirebase: '',
        iva: 0.0,
        idPedido: '',
        nota: '',
        referencia: '',
        vue: false,
        abono: false,
        autorizado: '',
        fechaVenta: moment.format("MM/dd/yyyy"),
        horaVenta: moment.format("HH:mm:ss"),
        medio: 'escuela',
        productosCompra: _producto,
      ),
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

            _diaplayPaymentSheet(paymentIntentData, context, _, _venta);
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
    ValueNotifier<Venta> _venta,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentData.value['paymentIntent'],
          confirmPayment: true,
        ),
      );

      _venta.value.referencia = paymentIntentData.value['id'];

      print('id => ${paymentIntentData.value['id']}');
      print('id => ref ${_venta.value.referencia}');

      final url = Uri(
        host: 'cosbiome.online',
        path: '/cosbiomepedidos',
        scheme: "https",
      );
      await post(
        url,
        body: jsonEncode(_venta.value.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
      );

      Navigator.pushNamed(context, '/home');

      _.onClearShoppingCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pago Relizado'),
        ),
      );

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
