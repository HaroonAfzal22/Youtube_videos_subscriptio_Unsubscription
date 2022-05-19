import 'dart:core';
import 'dart:async';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_testing/youtube_home.dart';


final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
'https://www.googleapis.com/auth/youtubepartner',
  'https://www.googleapis.com/auth/youtube',
  'https://www.googleapis.com/auth/youtube.force-ssl'
  ],
);


/// The main widget of this demo.
class SignInDemoWidget extends StatefulWidget {
  /// Creates the main widget of this demo.
  const SignInDemoWidget({Key? key}) : super(key: key);

  @override
  State createState() => SignInDemoWidgetState();
}

/// The state of the main widget.
class SignInDemoWidgetState extends State<SignInDemoWidget> {
  late var client;
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
    client = await _googleSignIn.authenticatedClient();

    assert(client != null, 'Authenticated client missing!');
  }
  //
  // String? _pickFirstNamedContact(List<Person>? connections) {
  //   return connections
  //       ?.firstWhere(
  //         (Person person) => person.names != null,
  //   )
  //       .names
  //       ?.firstWhere(
  //         (Name name) => name.displayName != null,
  //   )
  //       .displayName;
  // }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          Text(_contactText),
          ElevatedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: _handleGetContact,
          ),
          ElevatedButton(onPressed: () {
            addSubscription();
          }, child: Text('Subscription Button'),),
          ElevatedButton(onPressed: () {
            deleteSubscription();
          }, child: Text('Cancel Subscription'),)
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              _buildBody(),
              ElevatedButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => const VideosHomeScreen()));
              }, child: Text('Go to next Page'))
            ],
          ),
        ));
  }

  var response;
  addSubscription() async {
    try {

List<String> part = ['snippet'];
ResourceId resourceId = ResourceId(kind:'youtube#channel',channelId:'UCshJkIDg8JxgFLzlXGZAgFg' );
SubscriptionSnippet snippet = SubscriptionSnippet(resourceId:resourceId );
Subscription subscription = Subscription(snippet:snippet);
print('Subscription class instance $subscription');

var  youApi= YouTubeApi(client);

  response  =   await youApi.subscriptions.insert(subscription, part);
      print('Client response ${response.id}');
      print('Client Data $youApi');

    } on Exception catch (e) {
    print('Exception prinituing $e');
    // TODO
    }

  }
  deleteSubscription()async{
    print('Client response ${response.id}');
    var  youApi= YouTubeApi(client);
    await youApi.subscriptions.delete(response.id);
  }
}