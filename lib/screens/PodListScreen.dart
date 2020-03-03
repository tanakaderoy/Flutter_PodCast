import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/service/FirebaseHelper.dart';
import 'package:pod_cast_app/widgets/PodListWidget.dart';

class PodListView extends StatefulWidget {
  const PodListView({Key key, @required this.podData}) : super(key: key);
  final List<iTunesSearchResults> podData;

  @override
  _PodListViewState createState() => _PodListViewState();
}

class _PodListViewState extends State<PodListView> {
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
          return PodListWidget(podData: podData);
        }
        return CircularProgressIndicator();
      },
    );
  }
}