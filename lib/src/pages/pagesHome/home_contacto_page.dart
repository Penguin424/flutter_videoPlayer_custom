import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Producto_model.dart';
import 'dart:math';
import 'package:reproductor/src/pages/pagesHome/ProductoDetalle_page.dart';

const _duration = Duration(milliseconds: 250);

class ContactoHome extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _productos = useState<List<Producto>>([]);
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

    double _doubleInRange(Random min, num max, num value) {
      return min.nextDouble() * (value - max) + max;
    }

    useEffect(() {
      _pageCoffeControles.value.addListener(_coffeScrollListener);
      _pageCoffeTextControles.value.addListener(_coffeScrollTextListener);

      const numers = [
        'Crema piel madura chica.png',
        'CREMA RELAX ZEN CHICA.png',
        'Cremygel hipoalergenico.png',
        'Desmaquillante hipoalergenico.png',
        'ESPUMA DERMOLIMPIADORA EQUILIBRANT-SKIN.png',
        'Espuma dermolimpiadora hipoalergenica.png',
        'EYE LISS.png',
        'GEL ANTI EDAD CHICO.png',
        'Gel colageno y elastima chico.png',
        'Gel colageno con hilos.png',
        'Gel con hilos chico.png',
        'Gel control acne grande.png',
        'GEL CONTROL ACNE.png',
        'GEL HIDRATANTE PIEL GRASA CHICO.png',
        'Gel matificante 24 horas chico.png',
        'Juvicell.png',
        'Kit anti edad.png',
        'Kit hipoalergenico.png',
        'Kit piel grasa.png',
        'Kit piel madura.png',
        'kit relax zen.png',
        'LOCION ACTI WHITE.png',
        'LOCION CONTROL ACNE CHICA.png',
        'LOCION CONTROL ACNE.png',
        'LOCION EQUILIBRANTA SKIN GRANDE.png',
        'LOCION HIPOALERGENICA.png',
        'Locion piel madura.png',
        'Locion posdepilacion.png',
        'LOCION RELAX ZEN CHICA.png',
        'LOCION VENO RELAX GRANDE.png',
        'Locion anti edad chica.png',
        'Locion hipoalergenica chica.png',
        'MARCARILLA CONTROL ACNE.png',
        'Mascarilla cremos acti white.png',
        'Mascarilla cremosa anti edad.png',
        'Mezcla ahas 10.png',
        'Mezcla glicolico-hialuronico.png',
        'Microdermoabrasion crema.png',
        'Nano cel.png',
        'Nasso fill.png',
        'Neck lifth.png',
        'Pantalla solar 45 spray 130.png',
        'Pantalla solar crema.png',
        'Pantalla solar spray chica.png',
        'Papayna.png',
        'Plastic mask control acne.png',
        'Plastic mask intolerante.png',
        'Plastic mask manzana verde.png',
        'REVITAL EYES.png',
        'Scrub bamboo grande.png',
        'Serum acti white.png',
        'Serum iso 50 chico.png',
        'Serum ISO 50.png',
        'Serum relax zen grande.png',
        'Serum relax zen.png',
        'SHAMPOO DERMO DETOX CHICO.png',
        'SHAMPOO DERMOLIMPIADOR AHAS CHICO.png',
        'SHAMPOO DERMOLIMPIADOR AHAS.png',
        'Shampoo dermolimpiador hipoalergenico chico.png',
        'Shampoo dermolimpiador neutro chico.png',
        'Shampoo dermolimpiador relax zen.png',
      ];

      final imagenes = numers.map(
        (e) {
          return Producto(
            image: 'assets/$e',
            name: e.split('.')[0],
            price: _doubleInRange(Random(), 200, 500),
          );
        },
      ).toList();

      _productos.value = imagenes;
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
        body: Stack(
          children: [
            Positioned(
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
            ),
            Transform.scale(
              scale: 1.3,
              alignment: Alignment.bottomCenter,
              child: new PageView.builder(
                controller: _pageCoffeControles.value,
                onPageChanged: (page) {
                  if (page < _productos.value.length) {
                    print('asd $page');
                    _pageCoffeTextControles.value.animateToPage(
                      page,
                      duration: _duration,
                      curve: Curves.easeInOut,
                    );
                  }
                },
                scrollDirection: Axis.vertical,
                itemCount: _productos.value.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return SizedBox.shrink();
                  }

                  final producto = _productos.value[index - 1];
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
                            child: Image(
                              image: AssetImage(producto.image),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: 160,
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
                        itemCount: _productos.value.length,
                        key: Key('sad'),
                        controller: _pageCoffeTextControles.value,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final opacity = (1 - (index - _textPage.value).abs())
                              .clamp(0.0, 1.0);

                          return Opacity(
                            opacity: opacity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.2,
                              ),
                              child: Hero(
                                tag: "text_${_productos.value[index].name}",
                                child: Material(
                                  child: Text(
                                    _productos.value[index].name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 25,
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
                      height: 12,
                    ),
                    AnimatedSwitcher(
                      duration: _duration,
                      child: Text(
                        '\$${_productos.value[_textPage.value.toInt()].price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        key: Key(
                          _productos.value[_textPage.value.toInt()].name,
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
                                child: Image.asset(
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
                            return _productos.value.where(
                              (Producto option) {
                                return option.name
                                    .toLowerCase()
                                    .trim()
                                    .contains(
                                      textEditingValue.toLowerCase().trim(),
                                    );
                              },
                            );
                          },
                          onSuggestionSelected: (Producto selection) {
                            final producto = _productos.value.indexWhere(
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
            ),
          ],
        ),
      ),
    );
  }
}
