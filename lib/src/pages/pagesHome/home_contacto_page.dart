import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactoHome extends StatelessWidget {
  // const ContactoHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medidas = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: medidas.width / 2,
              image: AssetImage('images/logo.png'),
            ),
            Text(
              '¿Necesitas producto para tus practicas o te interesa el adquirir alguna maquina para tu cabina?',
              style: TextStyle(
                fontSize: medidas.width / 12,
              ),
              textAlign: TextAlign.center,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 450),
              child: GestureDetector(
                child: Text(
                  '!Contactanos 3319747514¡',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  FlutterPhoneDirectCaller.callNumber('3319747514');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
