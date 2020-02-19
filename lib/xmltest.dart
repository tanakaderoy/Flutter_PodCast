import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pod_cast_app/models/PodDataModel.dart';
import 'package:webfeed/domain/rss_feed.dart';

void main(){
  getData();

}

getData() {
  String url  = "30:23";
  for(var word in url.split(":")){
    print(word);
  }
//  http.Response response = await http.get(url);
// var  pod = RssFeed.parse(response.body);
// print(pod.items.first.title);
////
//  var file = File('data.txt');
//  var contents;
//
//
//    // Write file
//    var fileCopy = await File('planetPod.json').writeAsString(jsonData);
//    print(await fileCopy.exists());
//    print(await fileCopy.length());


}

