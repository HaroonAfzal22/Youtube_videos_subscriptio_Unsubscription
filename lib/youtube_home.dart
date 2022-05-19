import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_testing/Utils/services.dart';
import 'package:youtube_testing/modal/ChannelInfo.dart';
import 'package:youtube_testing/modal/video_list.dart';
import 'package:youtube_testing/modal_video_player.dart';
import 'package:youtube_testing/player_page.dart';


class VideosHomeScreen extends StatefulWidget {
  const VideosHomeScreen({Key? key}) : super(key: key);

  @override
  State<VideosHomeScreen> createState() => _VideosHomeScreenState();
}

class _VideosHomeScreenState extends State<VideosHomeScreen> {
  ChannelInfo? channelInfo;
  Item? item;
  bool? _loading;
  List<dynamic> ListData = [];
  late String _playListId;
  late VideosList _videosList;
 late String _nextPageToken;
  late ScrollController _scrollController;

  @override
  void initState() {
    _loading = true;
    _getChannelInfo();
    _videosList = VideosList();
    _videosList.videos = [];
    // Services.getVideosListModal();
    _nextPageToken = '';
    _scrollController = ScrollController();
    // TODO: implement initState
    super.initState();
  }

  _getChannelInfo() async {
    channelInfo = await Services.getChannelInfo();
    item = channelInfo!.items[0];
    _playListId = item!.contentDetails.relatedPlaylists.uploads;
    // await _loadVideosFunction();
    await  _loadVideosFromModal();
    setState(() {
      _loading = false;
    });
  }

// Get data from List
   _loadVideosFunction() async {
    ListData = await Services.getVideosList();
    setState(() {
      _loading = false;
    });
  }
// Get Video Modal Data
  _loadVideosFromModal() async {
    VideosList tempVideosList = await Services.getVideosListModal(
      playListId: _playListId,
      pageToken: _nextPageToken,
    );
   if(tempVideosList.videos != null){
     _nextPageToken = tempVideosList.nextPageToken!;
     _videosList.videos!.addAll(tempVideosList.videos!);
   }
    print('videos: ${_videosList.videos!.length}');
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Center(child: Text(_loading ==true ? 'Loading...' : 'YouTube')),
      ),
      body: Container(
        color: Colors.white,
        child: _loading == true
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildInfoView(),
                  // _VideoListScrolable()
                  _buildVideoBody()

                ],
              ),
      ),
    );
  }
/////////////
  _buildInfoView() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  item!.snippet.thumbnails.medium.url),
            ),
            Text(
              item!.snippet.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Text(item!.statistics.videoCount)
          ],
        ),
      ),
    );
  }
  ///////////////
  _VideoListScrolable(){
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i <= ListData[0].length; i++) ...[
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                          imageUrl: ListData[0]['items'][i]
                          ['snippet']
                          ['thumbnails']
                          ['default']['url']
                              .toString()),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: Text(ListData[0]['items']
                          [i]['snippet']['title']
                              .toString())),
                    ],
                  ),
                ),
                onTap: () {
                  final videoId = ListData[0]['items'][i]
                  ['snippet']['resourceId']['videoId'];
                  final videoTitle = ListData[0]['items'][i]
                  ['snippet']['title'];
                  print('Video Id printing $videoId');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayerScren(
                            VideoId: videoId,
                            VideoTitle: videoTitle)),
                  );
                },
              )
            ]
          ],
        ),
      ),
    )
      ;
  }
  /////////
  _buildVideoBody(){
    return  Expanded(
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollNotification notification) {
          if (_videosList.videos!.length >=
              int.parse(item!.statistics.videoCount)) {
            return true;
          }
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            _loadVideosFromModal();
          }
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _videosList.videos!.length,
          itemBuilder: (context, index) {
            VideoItem videoItem = _videosList.videos![index];
            return InkWell(
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return VideoPlayerScreen(
                        videoItem: videoItem,
                      );
                    }));
              },
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: videoItem
                          .video.thumbnails.thumbnailsDefault.url,
                    ),
                    SizedBox(width: 20),
                    Flexible(child: Text(videoItem.video.title)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

