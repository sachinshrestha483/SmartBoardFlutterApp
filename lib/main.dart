import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parent Console App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  void _onVerticalSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.up) {
      print('Swiped up!');
    } else {
      print('Swiped down!');
    }
  }

  @override
  Widget build(BuildContext context) {
    late WebViewController _controller;

    Future<bool> _onBack() async {
      bool goBack;

      var value = await _controller.canGoBack(); // check webview can go back

      if (value) {
        _controller.goBack(); // perform webview back operation
        return false;
      } else {
        return true;
      }
    }

    return WillPopScope(
      onWillPop: ()async {
        await _onBack();
        if(await _controller.canGoBack()==true){
        return false;
        }
        else{
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
        
          floatingActionButton:FloatingActionButton(
onPressed: (){
  print("Reloading it");
  _controller.reload();
},
child: Icon(Icons.refresh),
          ),
          body: WebView(
            
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: "http://smartboard.replsolutions.com/",
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
          ),
        ),
      ),
    );
  }
}
