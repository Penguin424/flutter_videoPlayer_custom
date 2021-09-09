import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/Global_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerFull extends StatefulWidget {
  VideoPlayerFull({
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  _VideoPlayerFullState createState() => _VideoPlayerFullState();
}

class _VideoPlayerFullState extends State<VideoPlayerFull> {
  late VideoPlayerController _playerController;
  int _fullScreen = kIsWeb ? 1 : 3;
  bool _isPlaying = false;
  double _buffer = 0.0;
  double _position = 0.0;
  bool _isOPenMenu = false;
  final _globalstate = Get.find<GlobalController>();

  void _handleInitialize() {
    setState(() {
      _playerController = VideoPlayerController.network(widget.url)
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );

      _playerController.play();
      _playerController.setLooping(true);

      print(
          'test => ${_playerController.value.duration.inMilliseconds.toDouble()}');
      _isPlaying = true;
    });
    _playerController.addListener(() {
      setState(() {
        _buffer =
            _playerController.value.buffered.last.end.inMilliseconds.toDouble();
        _position = _playerController.value.position.inMilliseconds.toDouble();
      });
    });
  }

  @override
  void initState() {
    _handleInitialize();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      height: media.height / _fullScreen,
      color: Colors.black,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: <Widget>[
            VideoPlayer(_playerController),
            _isOPenMenu
                ? _menuButtons(media, context, orientation)
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _isOPenMenu = true;
                      });
                    },
                  )
          ],
        ),
      ),
    );
  }

  GestureDetector _menuButtons(
      Size media, BuildContext context, Orientation orientation) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOPenMenu = false;
        });
      },
      child: Container(
        color: Color(0xFF4CAAB1).withOpacity(0.3),
        child: Stack(
          children: [
            _topButtons(media, context),
            _middleButtons(media),
            _timeBarVideo(media),
            _bottomButtons(media, orientation),
          ],
        ),
      ),
    );
  }

  Positioned _topButtons(Size media, BuildContext context) {
    return Positioned(
      top: 0,
      width: media.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.chevron_left_sharp,
                size: 42,
                color: Color(0xFF4CAAB1),
              ),
              onPressed: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                Navigator.pop(context);
              },
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  Positioned _bottomButtons(Size media, Orientation orientation) {
    return Positioned(
      bottom: _fullScreen == 1 ? 0 : 0,
      width: media.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              if (orientation == Orientation.landscape) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                _globalstate.setFullScreen(false);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                ]);
                _globalstate.setFullScreen(true);
              }
              setState(() {
                _fullScreen = _fullScreen == 1 ? 3 : 1;
              });
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
    );
  }

  Positioned _timeBarVideo(Size media) {
    return Positioned(
      bottom: _fullScreen == 1 ? 30 : 30,
      child: Container(
        width: media.width,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ProgressBar(
          progress: Duration(milliseconds: _position.toInt()),
          buffered: Duration(milliseconds: _buffer.toInt()),
          timeLabelLocation: TimeLabelLocation.sides,
          total: Duration(
            milliseconds: _playerController.value.duration.inMilliseconds
                .toDouble()
                .toInt(),
          ),
          onSeek: (Duration value) {
            _playerController.seekTo(value);
          },
          progressBarColor: Color(0xFF4CAAB1),
          baseBarColor: Color(0xFF4CAAB1).withOpacity(0.24),
          bufferedBarColor: Color(0xFFBFE3ED).withOpacity(0.24),
          thumbColor: Colors.white,
          barHeight: 10.0,
          thumbRadius: 5.0,
          timeLabelTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Positioned _middleButtons(Size media) {
    return Positioned(
      top: 0,
      bottom: 0,
      child: Container(
        width: media.width,
        child: Row(
          children: [
            GestureDetector(
              child: Container(
                width: media.width / 3,
                height: 170,
                color: Color(0xFF4CAAB1).withOpacity(0.02),
              ),
              onDoubleTap: () {
                _playerController.seekTo(
                  Duration(
                    milliseconds: (_position - 5000).toInt(),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                if (_playerController.value.isPlaying) {
                  _playerController.pause();
                  setState(() {
                    _isPlaying = false;
                  });
                } else {
                  _playerController.play();
                  setState(() {
                    _isPlaying = true;
                  });
                }
              },
              child: Container(
                width: media.width / 3,
                child: Icon(
                  !_isPlaying ? Icons.play_arrow : Icons.pause,
                  size: 64,
                  color: Color(0xFF4CAAB1),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                width: media.width / 3,
                height: 170,
                color: Color(0xFF4CAAB1).withOpacity(0.02),
              ),
              onDoubleTap: () {
                _playerController.seekTo(
                  Duration(
                    milliseconds: (_position + 5000).toInt(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
