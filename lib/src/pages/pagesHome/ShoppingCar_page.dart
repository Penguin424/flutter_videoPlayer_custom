import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/utils/Http.dart';

class ShoppingCar extends HookWidget {
  ShoppingCar({Key? key}) : super(key: key);
  final controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      return () {
        final valid = controller.productos[0].name
            .toLowerCase()
            .startsWith('colegiatura');

        if (valid) {
          controller.onClearShoppingCart();
        }
      };
    }, []);

    return GetBuilder<GlobalController>(
      id: 'shopping_car',
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
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
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'TOTAL: ${_.total.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  ElevatedButton(
                    child: Text(
                      'MANDAR PEDIDO',
                    ),
                    onPressed: () async {
                      final userMe = await HttpMod.get('users/me', {});

                      if (userMe.statusCode == 200) {
                        print('userMe: ${userMe.body}');
                        controller.onAddAlumnoShop(userMe.body);
                        Navigator.pushNamed(context, '/detalleVentaMandar');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(76, 170, 177, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
