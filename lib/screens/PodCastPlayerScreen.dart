import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:pod_cast_app/Util/Constants.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/service/AudioServiceHelper.dart';
import 'package:pod_cast_app/widgets/MarqueeWidget.dart';
import 'package:webfeed/domain/rss_item.dart';

class PodcastPlayer extends StatefulWidget {
  final RssItem episode;
  final String imageUrl;
  final String time;
  final int mil;
  final iTunesSearchResults pod;

  PodcastPlayer({@required this.episode, @required this.imageUrl, this.time, this.mil, this.pod});

  @override
  _PodcastPlayerState createState() => _PodcastPlayerState();
}

class _PodcastPlayerState extends State<PodcastPlayer>
    with SingleTickerProviderStateMixin {
  String time;
  Duration _duration = Duration();
  Duration _position = Duration();
  AudioPlayer audioPlayer;
  AnimationController playPauseController;

  //Vertical drag details
  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;

  RssItem episode;
  String imageUrl;
  bool isPlaying = false;
  Duration seekToDuration;


  playPod() {
    if (isPlaying) {
      playPauseController.reverse();
      DartNotificationCenter.post(channel: kNotPlaying, options: {"episode":episode, "image":imageUrl});
      audioPlayer.pause();
    } else {
      DartNotificationCenter.post(channel: kPlaying, options: {"episode":episode, "image":imageUrl,"pod":widget.pod});
      playPauseController.forward();
      audioPlayer.resume();
    }
    isPlaying = !isPlaying;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    audioPlayer.release();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageUrl = widget.imageUrl;
    if (widget.time != null) {
      time = widget.time;
      var timeList = time.split(":");
      if (timeList.length == 3) {
        seekToDuration = Duration(
            hours: int.parse(timeList[0]),
            minutes: int.parse(timeList[1]),
            seconds: int.parse(timeList[2]));
      } else if (timeList.length == 2) {
        seekToDuration = Duration(
            minutes: int.parse(timeList[0]), seconds: int.parse(timeList[1]));
      }
      if(widget.mil != null){
        seekToDuration = Duration(milliseconds: widget.mil);
      }
    }
    initPlayer();
    if (seekToDuration != null) {
      _position = seekToDuration;
      _duration = seekToDuration;
      audioPlayer.seek(seekToDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('EpisodeScreen'),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.pop(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: MarqueeWidget(direction: Axis.horizontal, child: Text(episode.title)),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 50,
              )),
        ),
        body: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, str, obj) => CircularProgressIndicator(),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
            child: StreamBuilder<Duration>(
                stream: audioPlayer.onDurationChanged,
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return buildEmptyPlayer();
                  }
                  _duration = snapshot.data;
                  return StreamBuilder<Duration>(
                      stream: audioPlayer.onAudioPositionChanged,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData){
                          return Container(
                            color: Colors.black.withOpacity(0.75),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Container(
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,

                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                Icons.replay_10,
                                                size: 40,
                                              ),
                                              onPressed: () => audioPlayer
                                                  .seek(_position - Duration(seconds: 10)),
                                            ),
                                            GestureDetector(
                                                onTap: () => playPod(),
                                                child: AnimatedIcon(
                                                  icon: AnimatedIcons.play_pause,
                                                  progress: playPauseController,
                                                  size: 40,
                                                )),
                                            IconButton(
                                              icon: Icon(
                                                Icons.forward_10,
                                                size: 40,
                                              ),
                                              onPressed: () => audioPlayer
                                                  .seek(_position + Duration(seconds: 10)),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text(_printDuration(_position)),
                                            Expanded(child: slider()),
                                            Text(_printDuration(_duration)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        _position = snapshot.data;
                        return Container(
                          color: Colors.black.withOpacity(0.75),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Container(
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,

                                      )),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.replay_10,
                                              size: 40,
                                            ),
                                            onPressed: () => audioPlayer
                                                .seek(_position - Duration(seconds: 10)),
                                          ),
                                          GestureDetector(
                                              onTap: () => playPod(),
                                              child: AnimatedIcon(
                                                icon: AnimatedIcons.play_pause,
                                                progress: playPauseController,
                                                size: 40,
                                              )),
                                          IconButton(
                                            icon: Icon(
                                              Icons.forward_10,
                                              size: 40,
                                            ),
                                            onPressed: () => audioPlayer
                                                .seek(_position + Duration(seconds: 10)),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(_printDuration(_position)),
                                          Expanded(child: slider()),
                                          Text(_printDuration(_duration)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  );
                }
            ),
          ),
        ),
      ),
    );
  }

  Container buildEmptyPlayer() {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,

                  )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.replay_10,
                          size: 40,
                        ),
                        onPressed: () => audioPlayer
                            .seek(_position - Duration(seconds: 10)),
                      ),
                      GestureDetector(
                          onTap: () => playPod(),
                          child: AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            progress: playPauseController,
                            size: 40,
                          )),
                      IconButton(
                        icon: Icon(
                          Icons.forward_10,
                          size: 40,
                        ),
                        onPressed: () => audioPlayer
                            .seek(_position + Duration(seconds: 10)),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(_printDuration(_position)),
                      Expanded(child: slider()),
                      Text(_printDuration(_duration)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initPlayer() {
    episode = widget.episode;
    audioPlayer = AudioServiceHelper.shared;

//    audioPlayer.onDurationChanged.listen((duration){
//      setState(() {
//        _duration = duration;
//      });
//    });

//    audioPlayer.durationHandler = (d) => setState(() {
//          _duration = d;
//        });

//    audioPlayer.positionHandler = (p) => setState(() {
//          _position = p;
//        });
    audioPlayer.setUrl(episode.enclosure.url);
//    audioPlayer.setNotification(title: episode.title,albumTitle: episode.pubDate,imageUrl: imageUrl);
    audioPlayer.setReleaseMode(
        ReleaseMode.STOP); // set release mode so that it never releases

    playPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    playPod();
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.grey,
        inactiveColor: Colors.lightBlueAccent,
        max: _duration.inSeconds.toDouble(),
        min: 0,
        value: _position.inSeconds.toDouble(),
        onChanged: (v) {
          setState(() {
            seekToSecond(v.toInt());
          });
        });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }
}