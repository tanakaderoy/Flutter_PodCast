import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pod_cast_app/Util/LayoutType.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/service/ApiService.dart';
import 'package:pod_cast_app/service/FirebaseHelper.dart';
import 'package:shimmer/shimmer.dart';

import 'HomeScreen.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key key, this.layoutGroup}) : super(key: key);
  final LayoutGroup layoutGroup;

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with AutomaticKeepAliveClientMixin{
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
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          favePods = snapshot.data.documents
              .map((p) => iTunesSearchResults.fromJson(p.data))
              .toList();
          return _scrollView(
              context,
              'https://i.pinimg.com/originals/a4/12/f5/a412f526ac3abbd30aa4d7ad1743e165.jpg',
              favePods);

//          return ListView.builder(itemCount: favePods.length,itemBuilder: (context,index){
//            var pod = favePods[index];
//            return ListTile(
//              leading: Text(pod.collectionName),
//            );
//          });
        });
  }

  Widget _scrollView(
      BuildContext context, String imgUrl, List<iTunesSearchResults> favePods) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: HeroHeader(
                layoutGroup: widget.layoutGroup,
                minExtent: 150,
                maxExtent: 250,
                imgUrl: imgUrl),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              var pod = favePods[index];
              return Container(
                  alignment: Alignment.center,
                  padding: _edgeInsetsForIndex(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: CachedNetworkImage(
                    imageUrl: pod.artworkUrl100,
                    fit: BoxFit.cover,
                    placeholder: (_,__)=>SizedBox(width: 100, height: 100, child: Shimmer.fromColors(child: Container(width: 50,height: 50, color: Colors.grey,), baseColor: Colors.blue, highlightColor: Colors.white),),
                  ),
//                        Image.network(
//                          pod.artworkUrl600,
//                          scale: 0.5,
//                        ),
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
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pod.collectionName,
                            style: TextStyle(color: Colors.grey),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ))
                    ],
                  ));
            }, childCount: favePods.length),
          )
        ],
      ),
    );
  }

  EdgeInsets _edgeInsetsForIndex(int index) {
    if (index % 2 == 0) {
      return EdgeInsets.only(top: 4.0, left: 8.0, right: 4.0, bottom: 4.0);
    } else {
      return EdgeInsets.only(top: 4.0, left: 4.0, right: 8.0, bottom: 4.0);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class HeroHeader implements SliverPersistentHeaderDelegate {
  HeroHeader({this.layoutGroup, this.minExtent, this.maxExtent, this.imgUrl});

  final LayoutGroup layoutGroup;
  double maxExtent;
  double minExtent;
  String imgUrl;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imgUrl,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          child: Text(
            'My Library',
            style: TextStyle(fontSize: 32.0, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}
