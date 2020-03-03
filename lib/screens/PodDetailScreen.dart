import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pod_cast_app/Util/Extensions.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/widgets/MarqueeWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'PodCastPlayerScreen.dart';


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
      body: buildPodDetailHeader(),
    );
  }

  Column buildPodDetailHeader() {
    return Column(
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
        buildPodDetailEpisodeList()
      ],
    );
  }

  Expanded buildPodDetailEpisodeList() {
    return Expanded(
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
                                    0.73,
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
                                              height: MediaQuery.of(context).size.height * 0.30,
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
                                            Center(child: Container(child: Text(pod.collectionName, style: TextStyle(
                                                inherit: true,
                                                fontSize: 48.0,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow( // bottomLeft
                                                      offset: Offset(-1.5, -1.5),
                                                      color: Colors.black45
                                                  ),
                                                  Shadow( // bottomRight
                                                      offset: Offset(1.5, -1.5),
                                                      color: Colors.black45
                                                  ),
                                                  Shadow( // topRight
                                                      offset: Offset(1.5, 1.5),
                                                      color: Colors.black45
                                                  ),
                                                  Shadow( // topLeft
                                                      offset: Offset(-1.5, 1.5),
                                                      color: Colors.black45
                                                  ),
                                                ]
                                            ),textAlign: TextAlign.center,),)),
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
                            Text(formatDate(episode.pubDate)),
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
    );
  }

  String formatDate(String date) {
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