import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Venta_model.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:universal_html/js.dart';

class VentaSendVendedor extends HookWidget {
  // const VentaSendVendedor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _g = Get.find<GlobalController>();
    final moment = new Moment.now().locale(new LocaleDe());
    final _isLoading = useState<bool>(false);

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

    final _venta = Venta(
      nombreCliente:
          '${_g.alumno.alumnoNombres} ${_g.alumno.alumnoApellidoPaterno} ${_g.alumno.alumnoApellidoMaterno}',
      vendedor: _g.alumno.alumnoVendedor,
      total: _g.total,
      subTotal: _g.total,
      aparatado: 0,
      estatus: 'CALIDAD',
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
    );

    return GetBuilder<GlobalController>(
      builder: (_) => LoadingOverlay(
        isLoading: _isLoading.value,
        color: Color(0xFF4CAAB1),
        opacity: 0.2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: Colors.black,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _topTexto(_),
                SizedBox(height: 40),
                _vistaProductos(_),
                SizedBox(height: 10),
                _bottomTexto(
                  _,
                  _venta,
                  context,
                  _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, GlobalController _) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'PEDIDO REALIZADO CORRECETAMENTE',
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Image.asset('assets/logo.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Gracias por su compra, el asesor se comunicara con usted',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pushNamed(context, '/home');

                _.onClearShoppingCart();
              },
            ),
          ],
        );
      },
    );
  }

  Column _bottomTexto(
    GlobalController _,
    Venta _venta,
    BuildContext context,
    ValueNotifier<bool> _isLoading,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'PARA UNA MEJOR ATENCION AL CLIENTE COMUNICATE CON NOSOTROS AL 3335607808',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w200,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'TOTAL A PAGAR ${_.total.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            _isLoading.value = true;
            final url = Uri(
              host: 'cosbiome.online',
              path: '/cosbiomepedidos',
              scheme: "https",
            );
            final response = await post(
              url,
              body: jsonEncode(_venta.toJson()),
              headers: {HttpHeaders.contentTypeHeader: "application/json"},
            );

            if (response.statusCode == 200) {
              _isLoading.value = false;

              await _showDialog(context, _);
            }
          },
          child: Text('CREAR PEDIDO'),
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(76, 170, 177, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        )
      ],
    );
  }

  Column _topTexto(GlobalController _) {
    return Column(
      children: [
        Text(
          'TU PEDIDO SERA ATENDIDO POR NUESTRO ASESOR ${_.alumno.alumnoVendedor!.toUpperCase()}',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'PARA UN PROCESO MAS AGIL DE ENVIO Y VENTA DE PRODUCTO \nDEPOSITA EL TOTAL DE TU PEDIDO A NUESTRA CUENTA 0110 5147 99\nO NUESTRA CUENTA CLABE 0123 2000 1105 1479 91\nA NOMBRE DE NATURABIOME, S.A DE C.V\nBBVA bancomer.',
          textAlign: TextAlign.center,
          maxLines: 5,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Expanded _vistaProductos(GlobalController _) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: _.productos.length,
        itemBuilder: (context, index) {
          final producto = _.productos[index];

          return ListTile(
            title: Text(
              producto.name,
            ),
            subtitle: Text(
              '${producto.total.toStringAsFixed(2)} - ${producto.canitdad}',
            ),
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: Image.network(
                producto.image,
                fit: BoxFit.cover,
                scale: 1.3,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.remove,
                color: Color.fromRGBO(76, 170, 177, 1.0),
              ),
              onPressed: () {
                if (_.productos.length == 1) {
                  _.onRemoveShoppingCart(producto.id);
                  Navigator.pop(context);
                } else {
                  _.onRemoveShoppingCart(producto.id);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
