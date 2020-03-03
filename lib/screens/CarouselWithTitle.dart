import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/service/ApiService.dart';
import 'PodDetailScreen.dart';

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