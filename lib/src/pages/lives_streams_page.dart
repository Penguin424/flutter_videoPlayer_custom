import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reproductor/src/controllers/lives_streams_controller.dart';
import 'package:video_player/video_player.dart';

class LivesStreamsPage extends StatefulWidget {
  LivesStreamsPage({Key? key}) : super(key: key);

  @override
  State<LivesStreamsPage> createState() => _LivesStreamsPageState();
}

class _LivesStreamsPageState extends State<LivesStreamsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LivesStreamsController>(
        init: LivesStreamsController(),
        initState: (_) {},
        builder: (_) {
          return SafeArea(
            child: _.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _.claseLive.value.ClaseActiva ?? false
                    ? Container(
                        color: _.fullScreen == 3 ? Colors.black : Colors.white,
                        child: Stack(
                          children: [
                            _.videoPlayerController.value.value.isInitialized
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: _.fullScreen == 3
                                        ? MainAxisAlignment.center
                                        : MainAxisAlignment.start,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: _.fullScreen.value,
                                        child: _videoPlayer(_, context),
                                      ),
                                      Offstage(
                                        offstage: _.fullScreen.value == 3,
                                        child: Column(
                                          children: [],
                                        ),
                                      )
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/logo.png'),
                                  SizedBox(height: 20),
                                  Text(
                                    'No hay lives activos',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }

  AspectRatio _videoPlayer(LivesStreamsController _, BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        onTap: _.handleShowMenu,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            VideoPlayer(
              _.videoPlayerController.value,
            ),
            if (_.isOpenMenu.value)
              Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _.onClose();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              _.claseLive.value.ClaseTitulo!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                _.views.value.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Container(),
                          IconButton(
                            onPressed: _.handleFullScreen,
                            icon: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
