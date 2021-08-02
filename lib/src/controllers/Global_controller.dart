import 'package:get/get.dart';
import 'package:reproductor/src/models/Producto_model.dart';

class GlobalController extends GetxController {
  List<ProductoShoppingCart> _productos = [];
  double _total = 0.0;
  List<ProductoShoppingCart> get productos => _productos;
  double get total => _total;

  @override
  void onInit() {
    super.onInit();

    print('Hola, Mundo');
  }

  onAddShoppingCart(ProductoShoppingCart producto) {
    final productoEcontrado = this
        ._productos
        .where((element) => element.name == producto.name)
        .toList();

    print(productoEcontrado);
    if (productoEcontrado.isEmpty) {
      _productos.add(producto);
    } else {
      this._productos = this._productos.map((elem) {
        if (elem.id == productoEcontrado[0].id) {
          elem.canitdad += producto.canitdad;
          elem.total = elem.canitdad * elem.price;

          return elem;
        }

        return elem;
      }).toList();
    }

    _total = _productos.map((e) => e.total).toList().reduce(
          (value, element) => value + element,
        );

    update(['shopping_car']);
  }

  onRemoveShoppingCart(int id) {
    this._productos = _productos.where((element) => element.id != id).toList();

    if (this._productos.isEmpty) {
      this._total = 0.0;
    } else {
      _total = _productos.map((e) => e.total).toList().reduce(
            (value, element) => value + element,
          );
    }

    update(['shopping_car']);
  }
}
