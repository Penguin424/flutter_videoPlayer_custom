import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/pages/pagesHome/Chat_home.dart';
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
    final size = MediaQuery.of(context).size;

    final _selector = useState<int>(1);
    final _pages = useState<List<Widget>>(
      [
        ContactoHome(),
        PageHome(),
        HomePerfil(),
        ChatHome(),
      ],
    );

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.shopping_cart, title: "Compras"),
            TabData(iconData: Icons.class__sharp, title: "Cursos"),
            TabData(iconData: Icons.person, title: "Perfil"),
            TabData(iconData: Icons.chat, title: "Chat"),
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
        body: Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: controller,
              children: _pages.value,
              onPageChanged: (page) {
                _selector.value = page;
              },
            ),
            Positioned(
              top: size.height * 0.5,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/livestreams');
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.live_tv_outlined,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
