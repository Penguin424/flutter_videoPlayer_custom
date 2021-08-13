import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reproductor/src/utils/convertsTime.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends HookWidget {
  VideoPlay({
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    final _playerController = useState<VideoPlayerController>(
      VideoPlayerController.network('$url')..initialize(),
    );
    final _menurview = useState<bool>(false);
    final _position = useState<double>(0);
    final _duration = useState<double>(0);
    final _fullScreen = useState<int>(kIsWeb ? 1 : 3);

    handleInit() async {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      _playerController.value.addListener(() {
        _position.value =
            _playerController.value.value.position.inMilliseconds.toDouble();

        _duration.value =
            _playerController.value.value.duration.inMilliseconds.toDouble();
      });
      _playerController.value.play();
      _playerController.value.setLooping(true);
    }

    useEffect(() {
      final seconsAdd =
          Duration(milliseconds: _position.value.toInt()).inSeconds;
      if (seconsAdd == 0) {
        _duration.value =
            _duration.value + Duration(seconds: 24).inMilliseconds.toDouble();

        print(
            'activado0 => ${Duration(milliseconds: _position.value.toInt()).inSeconds}');
      }
    }, [_position.value]);

    useEffect(() {
      handleInit();

      return () {
        _playerController.value.dispose();
      };
    }, [_playerController.value]);

    return Container(
      height: MediaQuery.of(context).size.height / _fullScreen.value,
      color: Colors.black,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _menurview.value = !_menurview.value;
        },
        child: Stack(
          children: [
            VideoPlayer(_playerController.value),
            if (_menurview.value)
              videoPlayerMenu(
                _playerController,
                context,
                _duration,
                _position,
                _fullScreen,
                _menurview,
              )
            else
              GestureDetector(onTap: () {
                _menurview.value = !_menurview.value;
              }),
          ],
        ),
      ),
    );
  }

  Widget videoPlayerMenu(
    ValueNotifier<VideoPlayerController> _playerController,
    BuildContext context,
    ValueNotifier<double> _duration,
    ValueNotifier<double> _position,
    ValueNotifier<int> _fullScreen,
    ValueNotifier<bool> _menurview,
  ) {
    return Container(
      color: Color.fromRGBO(13, 27, 42, 0.6),
      child: Stack(
        children: [
          nextAndBackPanel(_playerController, context, _duration),
          upMenuVideoPlayer(context, _playerController, _fullScreen),
          sliderProgVideo(context, _duration, _position, _playerController),
          downMenuVideoPlayer(
              context, _fullScreen, _playerController, _duration),
          buttonsMiddle(_playerController.value, _menurview),
        ],
      ),
    );
  }

  Positioned downMenuVideoPlayer(
    BuildContext context,
    ValueNotifier<int> _fullScreen,
    ValueNotifier<VideoPlayerController> _playerController,
    ValueNotifier<double> _duration,
  ) {
    Duration position = _playerController.value.value.position;
    Duration duration = _playerController.value.value.duration;

    return Positioned(
      bottom: 0,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${printDuration(position)}/${printDuration(duration)}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                print('volu => ${_playerController.value.value.volume}');
                Orientation orientation = MediaQuery.of(context).orientation;
                if (orientation == Orientation.landscape) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  _fullScreen.value = 3;
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                  ]);
                  _fullScreen.value = 1;
                }
              },
              child: !kIsWeb
                  ? Icon(
                      Icons.fullscreen,
                      size: 32,
                      color: Color(0xFF4CAAB1),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Positioned sliderProgVideo(
      BuildContext context,
      ValueNotifier<double> _duration,
      ValueNotifier<double> _position,
      ValueNotifier<VideoPlayerController> _playerController) {
    return Positioned(
      bottom: 20,
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        width: MediaQuery.of(context).size.width,
        child: Slider(
          min: 0,
          label: printDuration(Duration(milliseconds: _position.value.toInt())),
          divisions: _position.value > 0 ? _position.value.toInt() : 1,
          max: _duration.value,
          value: _position.value,
          onChanged: (double data) {
            _playerController.value.seekTo(
              Duration(
                milliseconds: data.toInt(),
              ),
            );
          },
          onChangeEnd: (value) {},
          inactiveColor: Color(0xFFBFE3ED),
          activeColor: Color(0xFF4CAAB1),
        ),
      ),
    );
  }

  Positioned upMenuVideoPlayer(
    BuildContext context,
    ValueNotifier<VideoPlayerController> _playerController,
    ValueNotifier<int> _fullScreen,
  ) {
    return Positioned(
      top: 0,
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.chevron_left_sharp,
                  size: 48,
                  color: Color(0xFF4CAAB1),
                ),
              ),
              Text(
                this.title.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _fullScreen.value == 3 ? 7 : 12,
                ),
                // maxLines: 1,
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }

  Row nextAndBackPanel(
    ValueNotifier<VideoPlayerController> _playerController,
    BuildContext context,
    ValueNotifier<double> _duration,
  ) {
    return Row(
      children: [
        GestureDetector(
          onDoubleTap: () {
            _playerController.value.seekTo(
              Duration(
                seconds: _playerController.value.value.position.inSeconds - 5,
              ),
            );
          },
          child: Container(
            color: Color.fromRGBO(255, 0, 0, 0.0001),
            height: double.infinity,
            width: MediaQuery.of(context).size.width / 2,
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            print('duration $_duration');
            _playerController.value.seekTo(
              Duration(
                seconds: _playerController.value.value.position.inSeconds + 5,
              ),
            );
          },
          child: Container(
            color: Color.fromRGBO(0, 255, 0, 0.0001),
            height: double.infinity,
            width: MediaQuery.of(context).size.width / 2,
          ),
        ),
      ],
    );
  }

  Center buttonsMiddle(VideoPlayerController vp, ValueNotifier<bool> showMenu) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          GestureDetector(
            onTap: () {
              showMenu.value = false;
              if (vp.value.isPlaying) {
                vp.pause();
                showMenu.value = true;
              } else {
                vp.play();
              }
            },
            child: Icon(
              !vp.value.isPlaying ? Icons.play_arrow : Icons.pause_sharp,
              size: 64,
              color: Color(0xFF4CAAB1),
            ),
          ),
          // Container(
          //   height: 150,
          //   child: RotatedBox(
          //     quarterTurns: -1,
          //     child: Slider(
          //       min: 0,
          //       max: 1,
          //       divisions: 10,
          //       label: 'VOL: ${vp.value.volume * 10}',
          //       value: vp.value.volume,
          //       onChanged: (data) {
          //         vp.setVolume(data);
          //       },
          //       activeColor: Color(0xFF4CAAB1),
          //     ),
          //   ),
          // ),
          Container()
        ],
      ),
    );
  }
}
