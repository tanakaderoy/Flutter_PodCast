import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/screens/PodDetailScreen.dart';
import 'package:pod_cast_app/service/ApiService.dart';
import 'package:pod_cast_app/service/FirebaseHelper.dart';

class PodListWidget extends StatelessWidget {
  const PodListWidget({
    Key key,
    @required this.podData,
  }) : super(key: key);

  final List<iTunesSearchResults> podData;

  @override
  Widget build(BuildContext context) {
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
}

