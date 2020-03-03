import 'package:flutter/material.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:pod_cast_app/screens/PodListScreen.dart';
import 'package:pod_cast_app/service/ApiService.dart';

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
              body: PodListView(podData: podData),
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