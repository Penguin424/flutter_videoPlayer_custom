import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/state_manager.dart';
import 'package:reproductor/src/models/clase_live_model.dart';
import 'package:reproductor/src/utils/Http.dart';
import 'package:video_player/video_player.dart';

class LivesStreamsController extends GetxController {
  RxBool isLoading = true.obs;
  late Timer _timer;

  RxBool isOpenMenu = false.obs;

  late Rx<VideoPlayerController> videoPlayerController;

  Rx<ClaseLiveModel> claseLive = ClaseLiveModel(
    ClaseActiva: false,
  ).obs;

  RxInt fullScreen = 4.obs;
  RxInt views = 0.obs;

  @override
  void onInit() async {
    try {
      final claseReponse = await HttpMod.getLive('clases/68', {});

      claseLive.value = ClaseLiveModel.fromJson(
        jsonDecode(
          claseReponse.body,
        ),
      );

      if (claseLive.value.ClaseActiva!) {
        videoPlayerController = VideoPlayerController.network(
          claseLive.value.ClaseVideo!,
        ).obs;

        handleGetViews();

        await videoPlayerController.value.initialize();
        videoPlayerController.value.play();
      }

      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }

    super.onInit();
  }

  @override
  void onClose() {
    videoPlayerController.value.dispose();
    _timer.cancel();

    super.onClose();
  }

  handleGetViews() async {
    final dio = Dio();

    _timer = Timer.periodic(
      Duration(seconds: 5),
      (timer) async {
        try {
          final response = await dio.get(
            'https://stream.cosbiome.online/api/streams/live/cosbiomelive',
          );

          final viewers = response.data['viewers'] as int;

          views.value = viewers;

          update();
        } catch (e) {
          final error = e as DioError;
          print('streams: ${error.response}');
        }
      },
    );
  }

  handleShowMenu() {
    isOpenMenu.value = !isOpenMenu.value;
    update();
  }

  handleFullScreen() {
    fullScreen.value = fullScreen.value == 3 ? 4 : 3;
    update();
  }
}
