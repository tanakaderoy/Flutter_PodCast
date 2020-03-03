import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:pod_cast_app/Util/Constants.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/screens/AccountScreen.dart';
import 'package:pod_cast_app/screens/HomeScreen.dart';
import 'package:pod_cast_app/screens/LibraryScreen.dart';
import 'package:pod_cast_app/service/ApiService.dart';
import 'package:pod_cast_app/service/AudioServiceHelper.dart';
import 'package:pod_cast_app/widgets/MarqueeWidget.dart';
import 'package:webfeed/domain/rss_item.dart';

import 'PodCastPlayerScreen.dart';

class BottomNavBarController extends StatefulWidget {
  final List<iTunesSearchResults> list;

  BottomNavBarController({@required this.list});

  @override
  _BottomNavBarControllerState createState() => _BottomNavBarControllerState();
}

class _BottomNavBarControllerState extends State<BottomNavBarController> {

//  final List<Widget> _children = [, ,];
  List<String> imageUrls = [];
  List<WidgetModel> _pages = [];
  int _currentIndex = 0;
  List<iTunesSearchResults> list;


@override
  void dispose() {
    // TODO: implement dispose
//  DartNotificationCenter.post(channel: kDispose);
  DartNotificationCenter.unsubscribe(observer: this);
  AudioServiceHelper.shared.release();
  print('dispose');
    super.dispose();
  }

  void setUp() async {
     list = widget.list;
    imageUrls = list.map((res) {
      return res.artworkUrl600;
    }).toList();
    setState(() {
      _pages = [
        WidgetModel(
            title: 'Home',
            widget: HomePage(key: PageStorageKey(kHOME_KEY), podData: list),
            icon: Icons.home),
        WidgetModel(
            title: 'Library',
            widget: LibraryPage(key: PageStorageKey(kLIBRARY_KEY)),
            icon: Icons.headset),
        WidgetModel(
            title: 'Account',
            widget: AccountPage(key: PageStorageKey(kACCOUNT_KEY),),
            icon: Icons.account_box)
      ];
    });

  }

  final PageStorageBucket bucket = PageStorageBucket();
   PageController pageController;
   AudioPlayer audioPlayer;
  String imageUrl;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUp();
    pageController = PageController(
        keepPage: true,
      initialPage: _currentIndex,
    );
    DartNotificationCenter.subscribe(channel: kNotPlaying, observer: this, onNotification: (options){
      isPaused = true;
    });

    DartNotificationCenter.subscribe(channel: kPlaying, observer: this, onNotification: (options){
      print('Tanaka $options');
      Map<String,dynamic> map = options;
      RssItem Gottenepisode = map['episode'];
      imageUrl = map['image'];
      episode = Gottenepisode;
      isPlaying = true;
      isPaused = false;
      pod = map['pod'];
      print('Playing: ${episode.title}');
    });

  }
  bool isPlaying = false;
  bool isPaused = false;
  RssItem episode;
  iTunesSearchResults pod;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        await  AudioServiceHelper.shared.release();
        return true;
      },
      child: Scaffold(
//      appBar: AppBar(
//        title: Text('PodCast'),
//      ),
        bottomNavigationBar: _pages.isNotEmpty ? _bottomNavigationBar(_currentIndex): null,
        body: _pages.isNotEmpty ? SafeArea(
          child: PageStorage(
            child:  Stack(
              children: <Widget>[
                PageView(
                  controller: pageController,
                  onPageChanged: onPageSwiped,
                  children: _pages.map((p)=>p.widget).toList(),
                ),
                isPlaying ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async{
                        var mil = await AudioServiceHelper.shared.getCurrentPosition();

                        Navigator.of(
                            context)
                            .push(
                          PageRouteBuilder(
                            opaque:
                            false,
                            pageBuilder: (context, _, __) =>
                                PodcastPlayer(
                                    episode:
                                    episode,
                                    imageUrl:
                                    imageUrl,
                                    mil:
                                    mil,
                                  pod: pod,
                                ),
                          ),
                        );},
                      child: Dismissible(
                        direction: DismissDirection.down,
                        key: Key('miniPlayer'),
                        onDismissed:(d){
                      setState(() {
                        isPlaying = false;
                      });
                      AudioServiceHelper.shared.release();},
                        child: Container(
                        color: Colors.black45,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        CachedNetworkImage(imageUrl: imageUrl,fit: BoxFit.cover,),
                        SizedBox(width: 20,),
                        Expanded(child: MarqueeWidget(direction: Axis.horizontal,animationDuration: Duration(seconds: 4),pauseDuration: Duration(seconds: 4),backDuration: Duration(seconds: 4),child: Text('${episode.title} - ${pod.collectionName}'))),
                          isPaused ?  IconButton(icon: Icon(Icons.play_arrow),onPressed: (){
                            setState(() {
                              isPaused = false;
                            });
                            AudioServiceHelper.shared.resume();},):IconButton(icon: Icon(Icons.pause),onPressed:(){
                            setState(() {
                              isPaused = true;
                            });
                            AudioServiceHelper.shared.pause(); },) ,

                        ],
                      ),
                      ),
                      ),
                    ),
                  ),
                )
 : Container()
              ],
            ),
            bucket: bucket,
          ),
        ):Container(),

//_pages[_currentIndex].widget
      ),
    );
  }

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    selectedItemColor: Colors.lightBlueAccent,
    onTap: onTabTapped,
    currentIndex: selectedIndex,
    items: _pages.map((page){
      return BottomNavigationBarItem(
        icon: Icon(page.icon),title: Text(page.title)
      );
    }).toList(),
  );

  void onTabTapped(int index) {
    DartNotificationCenter.post(channel: kStartUpAudio, options: audioPlayer);

    setState(() {
      _currentIndex = index;
    });
//    pageController
    pageController.animateToPage(index, curve: Curves.easeIn,duration: Duration(milliseconds: 150));
  }

  void onPageSwiped(int index){

      setState(() {
        _currentIndex = index;
      });

  }

}


class WidgetModel {
  String title;
  Widget widget;
  IconData icon;

  WidgetModel(
      {@required this.title, @required this.widget, @required this.icon});
}




