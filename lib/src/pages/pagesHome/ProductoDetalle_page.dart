import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Producto_model.dart';

class ProductoDetalle extends HookWidget {
  const ProductoDetalle({Key? key, this.producto}) : super(key: key);

  final Producto? producto;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final _ontrollerText = useTextEditingController(text: '1');
    final _cantidad = useState<int>(1);

    return GetBuilder<GlobalController>(
      id: 'shopping_car',
      builder: (_) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: _.productos.length > 0
                    ? Color.fromRGBO(76, 170, 177, 1.0)
                    : Colors.grey,
              ),
              onPressed: _.productos.length > 0
                  ? () {
                      Navigator.pushNamed(context, '/shoppingCar');
                    }
                  : null,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                child: Hero(
                  tag: "text_${producto!.name}",
                  child: Material(
                    child: Text(
                      producto!.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: size.height * 0.2,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: producto!.name,
                        child: Image.network(
                          producto!.image,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (
                            BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color.fromRGBO(76, 170, 177, 1.0),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: size.width * 0.05,
                      bottom: 0,
                      child: TweenAnimationBuilder(
                        tween: Tween(
                          begin: 1.0,
                          end: 0.0,
                        ),
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(-100 * value, 240 * value),
                            child: child,
                          );
                        },
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          '\$${producto!.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 10,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (String value) {
                          _cantidad.value = int.parse(value);
                        },
                        keyboardType: TextInputType.number,
                        controller: _ontrollerText,
                        decoration: InputDecoration(
                          labelText: 'CANTIDAD',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(76, 170, 177, 1.0),
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(76, 170, 177, 1.0),
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(76, 170, 177, 1.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Color.fromRGBO(76, 170, 177, 1.0),
                        ),
                        cursorColor: Color.fromRGBO(76, 170, 177, 1.0),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _.onAddShoppingCart(
                            ProductoShoppingCart(
                              id: _.productos.length + 1,
                              name: producto!.name,
                              image: producto!.image,
                              price: producto!.price,
                              canitdad: _cantidad.value,
                              total: producto!.price * _cantidad.value,
                              canitdadAlamacen: producto!.cantidad,
                            ),
                            context,
                          );
                        },
                        child: Text('AGREGAR'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(76, 170, 177, 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '¿Qué es Lorem Ipsum? Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas "Letraset", las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejemplo Aldus PageMaker, el cual incluye versiones de Lorem Ipsum.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
