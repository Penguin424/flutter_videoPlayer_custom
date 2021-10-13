import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Producto_model.dart';
import 'package:reproductor/src/pages/pagesHome/ProductoDetalle_page.dart';

const _duration = Duration(milliseconds: 250);

class ContactoHome extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final _productos = useState<List<Producto>>([]);
    final _currentPage = useState<double>(0.0);
    final _textPage = useState<double>(0.0);
    final _pageCoffeControles = useState<PageController>(new PageController(
      viewportFraction: 0.35,
    ));

    final _pageCoffeTextControles =
        useState<PageController>(new PageController());
    final _autoCompleteController = useTextEditingController();

    void _coffeScrollListener() {
      _currentPage.value = _pageCoffeControles.value.page!;
    }

    void _coffeScrollTextListener() {
      _textPage.value = _pageCoffeTextControles.value.page!;
    }

    Future<void> _getProductos() async {
      // final numersStreams =
      _pageCoffeControles.value.addListener(_coffeScrollListener);
      _pageCoffeControles.value.addListener(_coffeScrollListener);
      _pageCoffeTextControles.value.addListener(_coffeScrollTextListener);
    }

    useEffect(() {
      _getProductos();
    }, []);

    return GetBuilder<GlobalController>(
      id: 'shopping_car',
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('productos')
              // .limit(5)
              .where('imagen', isNotEqualTo: '')
              .snapshots(),
          builder: (
            context,
            snapshot,
          ) {
            // print(snapshot.data!.docs.length);
            if (snapshot.hasData) {
              final productos = snapshot.data!.docs
                  .map(
                    (element) => Producto(
                      name: element.data()['nombreProducto'],
                      image:
                          'https://cosbiomeescuela.s3.us-east-2.amazonaws.com/productos/${element.data()['imagen']}',
                      price: double.parse(
                          element.data()['precioVenta'].toString()),
                      cantidad: int.parse(element.data()['general'].toString()),
                    ),
                  )
                  .toList();
              return _body(
                size,
                _pageCoffeControles,
                productos,
                _pageCoffeTextControles,
                _currentPage,
                _textPage,
                _autoCompleteController,
                context,
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(76, 170, 177, 1.0),
              ),
            );
          },
        ),
      ),
    );
  }

  Stack _body(
      Size size,
      ValueNotifier<PageController> _pageCoffeControles,
      List<Producto> _productos,
      ValueNotifier<PageController> _pageCoffeTextControles,
      ValueNotifier<double> _currentPage,
      ValueNotifier<double> _textPage,
      TextEditingController _autoCompleteController,
      BuildContext context) {
    return Stack(
      children: [
        _shadowBottom(size),
        _imagesProductos(
          _pageCoffeControles,
          _productos,
          _pageCoffeTextControles,
          _currentPage,
          size,
        ),
        _textProductos(
          _productos,
          _pageCoffeTextControles,
          _textPage,
          size,
          _autoCompleteController,
          _pageCoffeControles,
          context,
        ),
      ],
    );
  }

  Positioned _textProductos(
      List<Producto> _productos,
      ValueNotifier<PageController> _pageCoffeTextControles,
      ValueNotifier<double> _textPage,
      Size size,
      TextEditingController _autoCompleteController,
      ValueNotifier<PageController> _pageCoffeControles,
      BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      height: 180,
      child: TweenAnimationBuilder(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ),
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(0.0, -100 * value),
            child: child,
          );
        },
        duration: _duration,
        child: Column(
          children: [
            Expanded(
              child: new PageView.builder(
                itemCount: _productos.length,
                key: Key('sad'),
                controller: _pageCoffeTextControles.value,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final opacity =
                      (1 - (index - _textPage.value).abs()).clamp(0.0, 1.0);

                  return Opacity(
                    opacity: opacity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.2,
                      ),
                      child: Hero(
                        tag: "text_${_productos[index].name}",
                        child: Material(
                          child: Text(
                            _productos[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 2,
            ),
            AnimatedSwitcher(
              duration: _duration,
              child: Text(
                'DISPONIBLE: ${_productos[_textPage.value.toInt()].cantidad}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
                key: Key(
                  _productos[_textPage.value.toInt()].name,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            AnimatedSwitcher(
              duration: _duration,
              child: Text(
                '\$${_productos[_textPage.value.toInt()].price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                ),
                key: Key(
                  _productos[_textPage.value.toInt()].name,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    controller: _autoCompleteController,
                    decoration: InputDecoration(
                      labelText: 'BUSQUEDA',
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
                  itemBuilder: (context, Producto suggestion) {
                    return ListTile(
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 64,
                          maxHeight: 64,
                        ),
                        child: Image.network(
                          suggestion.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(suggestion.name),
                      subtitle: Text(
                        '\$${suggestion.price.toStringAsFixed(2)}',
                      ),
                    );
                  },
                  suggestionsCallback: (textEditingValue) {
                    if (textEditingValue == '') {
                      return Iterable<Producto>.empty();
                    }
                    return _productos.where(
                      (Producto option) {
                        return option.name.toLowerCase().trim().contains(
                              textEditingValue.toLowerCase().trim(),
                            );
                      },
                    );
                  },
                  onSuggestionSelected: (Producto selection) {
                    final producto = _productos.indexWhere(
                      (element) => element.name == selection.name,
                    );

                    _pageCoffeControles.value.jumpToPage(producto);

                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 650),
                        pageBuilder: (context, animation, _) {
                          return FadeTransition(
                            opacity: animation,
                            child: ProductoDetalle(producto: selection),
                          );
                        },
                      ),
                    );

                    _autoCompleteController.text = '';
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Transform _imagesProductos(
      ValueNotifier<PageController> _pageCoffeControles,
      List<Producto> _productos,
      ValueNotifier<PageController> _pageCoffeTextControles,
      ValueNotifier<double> _currentPage,
      Size size) {
    return Transform.scale(
      scale: 1.3,
      alignment: Alignment.bottomCenter,
      child: new PageView.builder(
        controller: _pageCoffeControles.value,
        onPageChanged: (page) {
          if (page < _productos.length) {
            print('asd $page');
            _pageCoffeTextControles.value.animateToPage(
              page,
              duration: _duration,
              curve: Curves.easeInOut,
            );
          }
        },
        scrollDirection: Axis.vertical,
        itemCount: _productos.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox.shrink();
          }

          final producto = _productos[index - 1];
          final result = _currentPage.value - index + 1;
          final value = -0.4 * result + 1;
          final opcity = value.clamp(0.0, 1.0);

          return GestureDetector(
            onTap: () {
              if (result == 0.0) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 650),
                    pageBuilder: (context, animation, _) {
                      return FadeTransition(
                        opacity: animation,
                        child: ProductoDetalle(producto: producto),
                      );
                    },
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(
                    3,
                    2,
                    0.1,
                  )
                  ..translate(
                    0.0,
                    size.height / 2.6 * (1 - value).abs(),
                  )
                  ..scale(value),
                child: Opacity(
                  opacity: opcity,
                  child: Hero(
                    tag: producto.name,
                    child: Image.network(
                      producto.image,
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
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Positioned _shadowBottom(Size size) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: -size.height * 0.22,
      height: size.height * 0.3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(76, 170, 177, 1.0),
              blurRadius: 90,
              offset: Offset.zero,
              spreadRadius: 45,
            )
          ],
        ),
      ),
    );
  }
}
