import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:youtube_testing/modal/ChannelInfo.dart';
import 'package:youtube_testing/modal/video_list.dart';

class Services {

  static const CHANNEL_ID = 'UCshJkIDg8JxgFLzlXGZAgFg';
  static const _baseUrl = 'www.googleapis.com';
  static const key = 'AIzaSyDK0GLBwrb00uC3uu0060O2QPoaYi6ySNk';
  // get Videos Data

  static Future<List<dynamic>> getVideosList() async {
    List<dynamic> videoList = [];
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': 'UUshJkIDg8JxgFLzlXGZAgFg',
      'maxResults': '8',
      'pageToken': 'EAAaBlBUOkNBVQ',
      'key': key,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    http.Response response = await http.get(uri, headers: headers);
    print('Status code comming from getVideo Services ${response.statusCode}');
    Map<String, dynamic> mapBody = jsonDecode(response.body.toString());
      videoList.add(mapBody);
    return videoList;
  }

  static Future<ChannelInfo> getChannelInfo() async {
    Map<String, String> parameters = {
      'part': 'snippet,contentDetails,statistics',
      'id': CHANNEL_ID,
      'key': key,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    http.Response response = await http.get(uri, headers: headers);
    print(
        'StatusCode prinintg from chanel info future function ${response.statusCode}');
    Map<String, dynamic> mapBody = jsonDecode(response.body);
    ChannelInfo channelInfo = ChannelInfo.fromJson(mapBody);
    return channelInfo;
  }
  /////'UUshJkIDg8JxgFLzlXGZAgFg'
  ////'EAAaBlBUOkNBVQ'

  static Future<VideosList> getVideosListModal({ required String playListId, required String pageToken}) async {
    print('Net Page token From Modal $pageToken');
    print('PlayList Id From Modal $playListId');
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playListId,
      'maxResults': '20',
      'pageToken':pageToken ,
      'key': key,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    http.Response response = await http.get(uri, headers: headers);
    // print(response.body);
    print(
        'StatusCode prinintg from Modal ${response.statusCode}');
    VideosList videosList = videosListFromJson(response.body);
    print('Data Commming From New modal $videosList');
    return videosList;
  }
}
