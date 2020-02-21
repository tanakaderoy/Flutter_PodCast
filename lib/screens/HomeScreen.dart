import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pod_cast_app/Util/Constants.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/models/PodDataModel.dart';
import 'package:pod_cast_app/screens/BottomAppBar.dart';
import 'package:pod_cast_app/screens/LibraryScreen.dart';
import 'package:pod_cast_app/service/ApiService.dart';
import 'package:pod_cast_app/service/AudioServiceHelper.dart';
import 'package:pod_cast_app/service/FirebaseHelper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:pod_cast_app/Util/Extensions.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dart_notification_center/dart_notification_center.dart';


class HomePage extends StatefulWidget {
  final List<iTunesSearchResults> podData;

  const HomePage({
    Key key,
    @required this.podData,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    int _current = 0;
    return Stack(children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: CarouselWithTitle(
              podData: widget.podData,
              onTapCallback: null,
            ),
          ),
          Expanded(
            flex: 2,
            child: HomePodList(podData: widget.podData),
          ),
        ],
      ),
      Positioned(
        top: 0,
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: Container(
                color: Colors.transparent,
                child: SearchBar(),
              ),
            ),
          ),
        ),
      )
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CarouselWithTitle extends StatefulWidget {
  const CarouselWithTitle(
      {Key key, @required this.podData, @required this.onTapCallback})
      : super(key: key);

  final List<iTunesSearchResults> podData;
  final Function onTapCallback;

  @override
  _CarouselWithTitleState createState() => _CarouselWithTitleState();
}

class _CarouselWithTitleState extends State<CarouselWithTitle> {
  iTunesSearchResults pod = iTunesSearchResults();
  List<iTunesSearchResults> podData = [];
  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    podData.addAll(widget.podData);
    podData.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          pod = podData[_current];
        });
        await goToPoddetailScreen(context);
      },
      child: Container(
        color: Colors.black45,
        child: CarouselSlider(
          items: podData.map((i) {
            String img = i.artworkUrl600;
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Stack(children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: img,
                      fit: BoxFit.cover,
                      width: 1000,

                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          i.collectionName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ));
          }).toList(),
          autoPlay: true,
          aspectRatio: 2.0,
          onPageChanged: (index) {
            _current = index;
          },
        ),
      ),
    );
  }

  Future goToPoddetailScreen(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.pink,
            ),
          );
        });
    var podFeed = await ApiService.instance.getPodData(pod.feedUrl);
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return PodDetailScreen(
            pod: pod,
            podcastFeed: podFeed,
          );
        },
        fullscreenDialog: true));
  }
}

class HomePodList extends StatefulWidget {
  const HomePodList({Key key, @required this.podData}) : super(key: key);
  final List<iTunesSearchResults> podData;

  @override
  _HomePodListState createState() => _HomePodListState();
}

class _HomePodListState extends State<HomePodList> {
  List<iTunesSearchResults> podData;
  List<iTunesSearchResults> favePods;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    podData = widget.podData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseHelper.instance.getFavePodcasts(),
      builder: (context, snapshot) {
        List<iTunesSearchResults> favePods;
        if (!snapshot.hasData) {
          favePods = [];
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        } else if (snapshot.hasData) {
          favePods = snapshot.data.documents
              .map((p) => iTunesSearchResults.fromJson(p.data))
              .toList();
          podData.forEach((pod) {
            if (favePods.contains(pod)) {
              pod.isFavorited = true;
            }
          });
          return Container(
            child: ListView.builder(
                itemCount: podData.length,
                itemBuilder: (context, index) {
                  iTunesSearchResults pod = podData[index];
//              configurePod(pod);

                  return ListTile(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.yellow,
                                ),
                              );
                            });
                        var podFeed =
                            await ApiService.instance.getPodData(pod.feedUrl);
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return PodDetailScreen(
                                pod: pod,
                                podcastFeed: podFeed,
                              );
                            },
                            fullscreenDialog: true));
                      },
                      title: Text(pod.collectionName),
                      subtitle: Text(pod.artistName),
                      trailing: pod.isFavorited
                          ? IconButton(
                              icon: Icon(Icons.favorite),
                              onPressed: () {
                                pod.isFavorited = false;
                                FirebaseHelper.instance.deleteFavePodCast(pod);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.favorite_border),
                              onPressed: () {
                                pod.isFavorited = true;
                                FirebaseHelper.instance.saveFavePodCast(pod);
                              },
                            ),
                      leading: CachedNetworkImage(
                        imageUrl: pod.artworkUrl100,
                        fit: BoxFit.cover,

                      )

//                    Image.network(
//                      pod.artworkUrl100,
//                      fit: BoxFit.cover,
//                    ),
                      );
                }),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class PodDetailScreen extends StatefulWidget {
  const PodDetailScreen(
      {Key key, @required this.pod, @required this.podcastFeed})
      : super(key: key);

  final iTunesSearchResults pod;
  final RssFeed podcastFeed;

  @override
  _PodDetailScreenState createState() => _PodDetailScreenState();
}

class _PodDetailScreenState extends State<PodDetailScreen> {
  RssFeed podcastFeed;
  iTunesSearchResults pod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pod = widget.pod;
    podcastFeed = widget.podcastFeed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pod.collectionName),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left,
            size: 50,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: CachedNetworkImage(
              imageUrl: pod.artworkUrl100,
              fit: BoxFit.cover,

              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          child: CachedNetworkImage(
                            imageUrl: pod.artworkUrl600,
                            fit: BoxFit.cover,

                          ),
                          elevation: 10,
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: Color.fromRGBO(6, 6, 6, 0.2),
                          elevation: 20,
                          child: Container(
                            height: 370,
                            child: RichText(
                              text: TextSpan(
                                  children: podcastFeed.description
                                      .replaceHtmlTags()
                                      .split(" ")
                                      .map((w) {
                                return TextSpan(
                                    text: w + " ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        backgroundColor: Colors.black45));
                              }).toList()),
                            ),
//                            Text(
//                              podcastFeed.description.replaceHtmlTags(),
//                              style: TextStyle(
//                                fontWeight: FontWeight.bold,
//                                backgroundColor: Colors.black45,
//                              ),
//                              textAlign: TextAlign.center,
//                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                child: ListView.builder(
                    itemCount: podcastFeed.items.length,
                    itemBuilder: (context, index) {
                      var episode = podcastFeed.items[index];
                      return Container(
                        child: Card(
                          elevation: 30,
                          child: ListTile(
                              onTap: () {
                                print(episode.title.replaceHtmlTags());
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SingleChildScrollView(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.75,
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Container(
                                        color: Color.fromRGBO(117, 117, 117, 1),
                                        child: Container(
//                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Stack(
                                                fit: StackFit.loose,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: pod.artworkUrl600,
                                                    fit: BoxFit.cover,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 200,
                                                  ),
                                                  BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 5, sigmaY: 5),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .transparent,
                                                                Colors.black54,
                                                              ],
                                                              stops: [0.5, 1.0],
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              tileMode: TileMode
                                                                  .repeated,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          left: 16.0,
                                                          right: 16.0,
                                                          bottom: 16.0,
                                                          child: Text(
                                                            'My Library',
                                                            style: TextStyle(
                                                                fontSize: 32.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.black54,
                                                        ],
                                                        stops: [0.5, 1.0],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        tileMode:
                                                            TileMode.repeated,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(child: Container(color:Colors.black45,child: Text(pod.collectionName, style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),)),
                                                  Positioned(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    bottom: 16.0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: MarqueeWidget(
                                                            child: Text(
                                                              episode.title,
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                backgroundColor: Colors.black45,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .play_circle_filled,
                                                            color: Colors.blue,
                                                            size: 50,
                                                          ),
                                                          onPressed: () => Navigator
                                                                  .of(context)
                                                              .pushReplacement(PageRouteBuilder(
                                                                  opaque: false,
                                                                  pageBuilder: (context,
                                                                          _,
                                                                          __) =>
                                                                      PodcastPlayer(
                                                                          episode:
                                                                              episode,
                                                                          pod: pod,
                                                                          imageUrl:
                                                                              pod.artworkUrl600))),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                flex: 2,
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    child: RichText(
                                                      text: TextSpan(
                                                          children: episode
                                                              .description
                                                              .replaceHtmlTags()
                                                              .split(" ")
                                                              .map((w) {
                                                        if (w
                                                            .contains("http")) {
                                                          var linkRecognizer =
                                                              TapGestureRecognizer();
                                                          return TextSpan(
                                                              text: w + " ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                              recognizer:
                                                                  linkRecognizer
                                                                    ..onTap =
                                                                        () {
                                                                      launch(w);
                                                                    });
                                                        }
                                                        RegExp reg = RegExp(
                                                            r"\d+:\d+|:\d+");
                                                        if (reg.hasMatch(w)) {
                                                          var timeStampRecognizer =
                                                              TapGestureRecognizer();
                                                          return TextSpan(
                                                              text: "\n " +
                                                                  w +
                                                                  " ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                              recognizer:
                                                                  timeStampRecognizer
                                                                    ..onTap =
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pushReplacement(
                                                                        PageRouteBuilder(
                                                                          opaque:
                                                                              false,
                                                                          pageBuilder: (context, _, __) =>
                                                                              PodcastPlayer(
                                                                            episode:
                                                                                episode,
                                                                            imageUrl:
                                                                                pod.artworkUrl600,
                                                                            time:
                                                                                w,
                                                                                pod: pod,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                        }
                                                        return TextSpan(
                                                            text: w + " ");
                                                      }).toList()),
                                                    ),
                                                  ),
                                                ),
//                                                        Text(episode
//                                                            .description
//                                                            .replaceHtmlTags()))),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
//                                Navigator.of(context).push(PageRouteBuilder(
//                                    opaque: false,
//                                    pageBuilder: (context, _, __) =>
//                                        PodcastPlayer(
//                                            episode: episode,
//                                            imageUrl: pod.artworkUrl600)));

//                            Navigator.of(context).push(MaterialPageRoute(
//                                builder: (context) {
//                                  return PodcastPlayer(
//                                    episode: episode,
//                                    imageUrl: pod.artworkUrl600,
//                                  );
//                                },
//                                fullscreenDialog: true));
                              },
                              title: Text(episode.title),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(formattDate(episode.pubDate)),
                                ],
                              ),
                              leading: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: pod.artworkUrl100,
                                    fit: BoxFit.cover,

                                  ),
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(50)),
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Text(
                                            '${podcastFeed.items.length - index}',
                                          )))
                                ],
                              )),
                        ),
                      );
                    })),
          )
        ],
      ),
    );
  }

  String formattDate(String date) {
    var formatter = DateFormat('E, d MMM y H:m:s Z');
    var newDate = formatter.parse(date);
    var newFormatter = DateFormat('MMM d y');
//    DateTime dateTime = DateTime.parse(date);
//    print(formatDate(dateTime, [M,' ',d,' ', yyyy]));
    print(newDate);
    return newFormatter.format(newDate);
//        D, d M Y H:i:s T
  }
}

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
          title: Text(episode.title),
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
                  return Container();
                }
                _duration = snapshot.data;
                return StreamBuilder<Duration>(
                  stream: audioPlayer.onAudioPositionChanged,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Container();
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

  void initPlayer() {
    episode = widget.episode;
    audioPlayer = AudioServiceHelperr.shared;

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

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<iTunesSearchResults> podData;
  final TextEditingController _searchController = new TextEditingController();
  String searchText;

  void _searchPressed(BuildContext context) async {
    if (searchText != null) {
      print(searchText);
      podData = await ApiService.instance.searchWithTerm(term: searchText);
      print(podData.length);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              body: HomePodList(podData: podData),
              appBar: AppBar(
                title: Text('Search Results: $searchText'),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            );
          },
          fullscreenDialog: true));
    }
//    _searchController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isEditing
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  isEditing = false;
                });
                _searchController.clear();
              },
            )
          : null,
      backgroundColor: !isEditing ? Colors.black.withOpacity(0.3) : Colors.grey,
      title: TextField(
        onTap: () {
          setState(() {
            isEditing = true;
          });
        },
        onChanged: (val) {
          setState(() {
            searchText = val;
          });
        },
        onEditingComplete: () {
          setState(() {
            isEditing = false;
          });
          _searchPressed(context);
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        controller: _searchController,
        decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _searchPressed(context),
            )),
      ),
    );
  }
}

//  onVerticalDragStart: (dragDetails) {
//          startVerticalDragDetails = dragDetails;
//        },
//        onVerticalDragUpdate: (dragDetails) {
//          updateVerticalDragDetails = dragDetails;
//        },
//        onVerticalDragEnd: (endDetails) {
//          double dx = updateVerticalDragDetails.globalPosition.dx -
//              startVerticalDragDetails.globalPosition.dx;
//          double dy = updateVerticalDragDetails.globalPosition.dy -
//              startVerticalDragDetails.globalPosition.dy;
//          double velocity = endDetails.primaryVelocity;
//
//          //Convert values to be positive
//          if (dx < 0) dx = -dx;
//          if (dy < 0) dy = -dy;
//
//          if (velocity < 0) {
////            widget.onSwipeUp();
//          } else {
//            Navigator.pop(context);
//          }

//class HomePodList extends StatelessWidget {
//  const HomePodList({Key key, @required this.podData}) : super(key: key);
//  final List<iTunesSearchResults> podData;
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: ListView.builder(
//          itemCount: podData.length,
//          itemBuilder: (context, index) {
//            iTunesSearchResults pod = podData[index];
//            pod.isFavorited = false;
//            configurePod(pod);
//            return ListTile(
//              onTap: () async {
//                showDialog(
//                    context: context,
//                    builder: (BuildContext context) {
//                      return Center(
//                        child: CircularProgressIndicator(),
//                      );
//                    });
//                var podFeed = await ApiService.instance.getPodData(pod.feedUrl);
//                Navigator.pop(context);
//                Navigator.of(context).push(MaterialPageRoute(
//                    builder: (context) {
//                      return PodDetailScreen(
//                        pod: pod,
//                        podcastFeed: podFeed,
//                      );
//                    },
//                    fullscreenDialog: true));
//              },
//              title: Text(pod.collectionName),
//              subtitle: Text(pod.artistName),
//              trailing: pod.isFavorited
//                  ? IconButton(
//                      icon: Icon(Icons.favorite),
//                      onPressed: () {
//                        pod.isFavorited = false;
//                        FirebaseHelper.instance.deleteFavePodCast(pod);
//                      },
//                    )
//                  : IconButton(
//                      icon: Icon(Icons.favorite_border),
//                      onPressed: () {
//                        pod.isFavorited = true;
//                        FirebaseHelper.instance.saveFavePodCast(pod);
//                      },
//                    ),
//              leading: Image.network(
//                pod.artworkUrl60,
//                fit: BoxFit.cover,
//              ),
//            );
//          }),
//    );
//  }
//
//  void configurePod(iTunesSearchResults pod) async {
//    QuerySnapshot favePodcasts =
//        await FirebaseHelper.instance.getFavePodcasts();
//    favePodcasts.documents.map((p) {
//      iTunesSearchResults newPod = iTunesSearchResults.fromJson(p.data);
//      print(newPod.collectionName);
//      pod.isFavorited = newPod.isFavorited;
//    });
//  }
//}

