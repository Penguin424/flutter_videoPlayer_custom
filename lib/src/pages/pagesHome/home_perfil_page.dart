import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:reproductor/src/models/Curso.dart';
import 'package:reproductor/src/models/Producto_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:reproductor/src/utils/PrefsSIngle.dart';
import 'package:http/http.dart' as http;

class HomePerfil extends HookWidget {
  const HomePerfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cursosAlumnos = useState<List<Curso>>([]);
    final _fotoPerfil = useState<String>(
      PreferenceUtils.getString('imagenPerfil').toString(),
    );
    final isLoading = useState<bool>(false);

    void initGetDate() async {
      try {
        final id = PreferenceUtils.getString('idUser');

        await PreferenceUtils.init();

        final res = await HttpMod.get(
          '/cursos',
          {
            '_where[0][CursoAlumnos.id]': id.toString(),
          },
        );

        if (res.statusCode == 200) {
          List<Curso> data = jsonDecode(res.body).map<Curso>((a) {
            return Curso.fromJson(a);
          }).toList();

          _cursosAlumnos.value = data;

          print(_fotoPerfil.value);
        } else {}
      } catch (e) {
        print(e);
      }
    }

    useEffect(() {
      initGetDate();
    }, []);

    return GetBuilder<GlobalController>(
      builder: (_) {
        return LoadingOverlay(
          isLoading: isLoading.value,
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.95,
              ),
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        if (_fotoPerfil.value != 'no' &&
                            _fotoPerfil.value != '')
                          GestureDetector(
                            onLongPress: () => _createMenuLoadNewImagePerfil(
                              context,
                              isLoading,
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                Uri.parse(_fotoPerfil.value).toString(),
                              ),
                              backgroundColor: Color(0xFF4CAAB1),
                              maxRadius: 120,
                            ),
                          )
                        else
                          GestureDetector(
                            onLongPress: () => _createMenuLoadNewImagePerfil(
                              context,
                              isLoading,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF4CAAB1),
                              child: Text(
                                PreferenceUtils.getString('userName')
                                    .substring(0, 2)
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              maxRadius: 120,
                            ),
                          ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          PreferenceUtils.getString('userName').toString(),
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'CURSOS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      children: _cursosAlumnos.value.map(
                        (c) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/clases',
                                arguments: {
                                  'curso': c.id.toString(),
                                  'cursoTitulo': c.cursoTitulo,
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  c.cursoTitulo,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Utlima clase tomada: ${c.cursoClases.last.claseTitulo}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(76, 170, 177, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      onPressed: () async {
                        await PreferenceUtils.init();

                        PreferenceUtils.putString('token', '');
                        PreferenceUtils.putString('idUser', '');
                        PreferenceUtils.putString('userName', '');
                        PreferenceUtils.putString('role', '');
                        PreferenceUtils.putString('imagenPerfil', '');
                        PreferenceUtils.putBool('isLogged', false);
                        PreferenceUtils.putString('email', '');
                        PreferenceUtils.putString('password', '');
                        PreferenceUtils.putBool('isTest', false);
                        PreferenceUtils.putString(
                          'limitTest',
                          '',
                        );

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          ModalRoute.withName('/'),
                        );
                      },
                      child: Text('Cerrar Sesión'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(76, 170, 177, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      onPressed: _.ultimoPago.month == DateTime.now().month
                          ? null
                          : () {
                              _.onClearShoppingCart();
                              _.onAddShoppingCart(
                                ProductoShoppingCart(
                                  price: _.alumno.alumnoMensualidad!,
                                  canitdad: 1,
                                  id: _.productos.length + 1,
                                  image: Uri.parse(
                                          'https://i.pinimg.com/originals/dc/30/85/dc3085dbbc9897fc374f804d4649b502.png')
                                      .toString(),
                                  name: 'COLEGIATURA',
                                  total: _.alumno.alumnoMensualidad! * 1,
                                  canitdadAlamacen: 2,
                                  descripcion: 'Mensualidad',
                                ),
                                context,
                              );

                              Navigator.pushNamed(context, '/shoppingCar');
                            },
                      child: Text('PAGAR COLEGIATURA'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _createMenuLoadNewImagePerfil(
    BuildContext context,
    ValueNotifier<bool> isLoading,
  ) async {
    final size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            height: size.height * 0.4,
            width: size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'CAMBIAR IMAGEN DE PERFIL',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final permiso = await Permission.camera.request();

                    print(permiso);
                    if (await Permission.camera.request().isGranted) {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null) {
                        Navigator.pop(context);
                        isLoading.value = true;
                        loadNewPerfilImage(
                          image,
                          context,
                        );
                      }
                    } else {
                      _createWindowPermissionHnadler(
                        context,
                        'PERMISO DE CAMARA',
                        'El acceso a la camara es para que puedas tomar fotos de tus tareas  si es que quieres enviarlas por medio de una foto a tus maestros, enviar una foto por mensaje o poner una foto de perfil',
                      );
                    }
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Tomar foto'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final permiso = await Permission.camera.request();

                    print(permiso);
                    if (await Permission.camera.request().isGranted) {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        Navigator.pop(context);
                        isLoading.value = true;
                        loadNewPerfilImage(
                          image,
                          context,
                        );
                      }
                    } else {
                      _createWindowPermissionHnadler(
                        context,
                        'PERMISO DE GALERIA',
                        'El acceso a la galeria es por si quieres adjuntar una imagen o archivo desde tu galeria o gestor de archivos para poder usarla al entregar tu tarea al maestro, enviarle un mensaje con imagen o poner una foto de perfil',
                      );
                    }
                  },
                  icon: Icon(Icons.image),
                  label: Text('Seleccionar foto'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  loadNewPerfilImage(XFile? image, BuildContext context) async {
    final file = http.MultipartFile.fromBytes(
      'file',
      await image!.readAsBytes(),
      filename: image.name,
    );

    final urlNewImagePerfil = await HttpMod.loadFileAlumno(
      file,
    );

    await HttpMod.update(
      'users/${PreferenceUtils.getString('idUser')}',
      jsonEncode({
        'UsuarioFoto': urlNewImagePerfil,
      }),
    );

    PreferenceUtils.putString(
      'imagenPerfil',
      urlNewImagePerfil,
    );

    Navigator.pushReplacementNamed(context, '/home');
  }

  _createWindowPermissionHnadler(
    BuildContext context,
    String title,
    String content,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Denegar'),
          ),
          ElevatedButton(
            onPressed: () => openAppSettings(),
            child: Text('Permitir desde configutacion'),
          ),
        ],
      ),
    );
  }
}
