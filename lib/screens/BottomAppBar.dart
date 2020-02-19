import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pod_cast_app/Util/Constants.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/screens/AccountScreen.dart';
import 'package:pod_cast_app/screens/HomeScreen.dart';
import 'package:pod_cast_app/screens/LibraryScreen.dart';
import 'package:pod_cast_app/service/ApiService.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUp();
    pageController = PageController(
        keepPage: true,
      initialPage: _currentIndex,
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PodCast'),
      ),
      bottomNavigationBar: _pages.isNotEmpty ? _bottomNavigationBar(_currentIndex): null,
      body: _pages.isNotEmpty ? PageStorage(
        child:  PageView(
          controller: pageController,
          onPageChanged: onPageSwiped,
          children: _pages.map((p)=>p.widget).toList(),
        ),
        bucket: bucket,
      ):Container(),

//_pages[_currentIndex].widget
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
    setState(() {
      _currentIndex = index;
    });
//    pageController
    pageController.animateToPage(index, curve: Curves.bounceIn,duration: Duration(milliseconds: 200));
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
