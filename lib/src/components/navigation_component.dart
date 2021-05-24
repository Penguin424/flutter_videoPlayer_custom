import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyBottomNavigation(
      tabs: [
        TabData(iconData: Icons.shopping_cart, title: "Compras"),
        TabData(iconData: Icons.class__sharp, title: "Clases"),
        TabData(iconData: Icons.person, title: "Perfil"),
      ],
      onTabChangedListener: (position) {
        print(position);
      },
      circleColor: Color(0xFF4CAAB1),
      inactiveIconColor: Color(0xFF4CAAB1),
      initialSelection: 1,
    );
  }
}
