import 'dart:convert';

import 'package:pod_cast_app/Util/Constants.dart';
import 'package:pod_cast_app/models/ItunesSearchResultModel.dart';
import 'package:http/http.dart' as http;
import 'package:pod_cast_app/models/PodDataModel.dart';
import 'package:webfeed/domain/rss_feed.dart';

class ApiService {
  static final instance = ApiService();

  Future<List<iTunesSearchResults>> getTopPodcasts() async {
    return await _searchItunesApi(term: "podcast");
  }
  Future<List<iTunesSearchResults>> searchWithTerm({String term}) async{
    return await _searchItunesApi(term: term);
  }


  Future<List<iTunesSearchResults>> _searchItunesApi({String term}) async {
     Map<String, String> queryParams = {"entity": "podcast", "term": term};
    Uri url = Uri(
        scheme: 'https',
        host: kBASE_HOST,
        path: '$kSEARCH_PATH',
        queryParameters: queryParams);
    http.Response response = await http.get(url);
    String data = response.body;
    Map<String, dynamic> resultMap = jsonDecode(data);
    List<iTunesSearchResults> itunesSearchResults =
        ItunesSearchResultModel.fromJson(resultMap).results;
    return itunesSearchResults;
  }

  Future<RssFeed> getPodData(String url) async {
    http.Response response = await http.get(url);

    var pod = RssFeed.parse(response.body);




    return pod;
  }

}
