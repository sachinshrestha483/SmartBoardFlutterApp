import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parent Console App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String WebsiteTitle = "";
  String pdfLink = "";
  bool showPdf = false;
  late WebViewController _controller;
  String pdfUrl = "http://smartboardadminen.replsolutions.com/";

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBack() async {
      var value = await _controller.canGoBack(); // check webview can go back
      if (value) {
        _controller.goBack(); // perform webview back operation
        return false;
      } else {
        return true;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (showPdf == true) {
          setState(() {
            showPdf = false;
          });

          return false;
        }
        var hhhh = await _onBack();
        print(hhhh);

        return hhhh;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              _controller.reload();
            },
            child: Icon(Icons.refresh),
          ),
          body: Stack(
            children: [
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: "http://smartboardadminen.replsolutions.com/",
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
                onPageStarted: (String rrr) async {
                  print(rrr);
                  if (rrr.contains("Print")) {
                    setState(() {
                      showPdf = true;
                      pdfUrl = rrr;
                    });
                  }
                },
              ),
              Visibility(
                  visible: showPdf,
                  child: Column(
                    children: [
                      Text("This is he Seconday Web view",style: TextStyle(   color: Colors.white, backgroundColor: Colors.blue[500]),),
                      Expanded(
                        child: WebView(
                          javascriptMode: JavascriptMode.unrestricted,
                          initialUrl:
                              "https://docs.google.com/gview?url=${pdfUrl}",
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
