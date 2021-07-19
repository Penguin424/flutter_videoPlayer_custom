import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/pages/pagesHome/home_pageCursos.dart';
import 'package:reproductor/src/pages/pagesHome/home_perfil_page.dart';

import 'home_contacto_page.dart';

class HomeApp extends HookWidget {
  // const HomeApp({Key? key}) : super(key: key);

  final controller = PageController(
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    final _selector = useState<int>(1);
    final _pages = useState<List<Widget>>([
      ContactoHome(),
      PageHome(),
      HomePerfil(),
    ]);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.shopping_cart, title: "Compras"),
            TabData(iconData: Icons.class__sharp, title: "Cursos"),
            TabData(iconData: Icons.person, title: "Perfil"),
          ],
          onTabChangedListener: (position) {
            print(position);
            _selector.value = position;
            controller.animateToPage(
              position,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          },
          circleColor: Color(0xFF4CAAB1),
          inactiveIconColor: Color(0xFF4CAAB1),
          initialSelection: _selector.value,
        ),
        body: PageView(
          // allowImplicitScrolling: false,
          // pageSnapping: false,
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: _pages.value,
          onPageChanged: (page) {
            _selector.value = page;
          },
        ),
      ),
    );
  }
}
