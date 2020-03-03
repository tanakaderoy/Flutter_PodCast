import 'package:flutter/material.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/screens/CarouselWithTitle.dart';
import 'package:pod_cast_app/widgets/SearchBar.dart';

import 'PodListScreen.dart';


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
            child: PodListView(podData: widget.podData),
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

