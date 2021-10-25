import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:http/http.dart' as http;

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
    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

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
      onWillPop: () async {
        if (showPdf == true) {
          setState(() {
            showPdf = false;
          });

          return false;
        }
        var hhhh= await _onBack();
        print(hhhh);
       
       return hhhh;
       
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              print("Reloading it");
              //   _controller.reload();

              try {
                var ssdf = await _controller.currentUrl();
                print(ssdf);
                var response = await Dio().get(ssdf!);
                print(response);
                response.headers.forEach((name, values) {
                  if (name == "content-type") {
                    if (values
                            .where((element) => element == "application/pdf")
                            .length !=
                        0) {
                      //it is pdf
                      setState(() {
                        showPdf = true;
                      });

                      print("it is pdf page");
                    }
                  }
                  print(name);
                  print(values.toString());
                });
              } catch (e) {
                print(e);
              }

              // try {
              //   var response = await Dio()
              //       .get(ssdf.toString())
              //       .then((value) => print(value.headers));
              //   //print(response);

              //   // Uri ss= Uri("dsdsd");

              // } catch (e) {
              //   print(e);
              // }
            },
            child: Icon(Icons.refresh),
          ),
          body: Stack(
            children: [
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: "https://sachinshrestha.w3spaces.com/",
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
                onPageStarted: (String rrr) async {
                  print(rrr);
                  try {
                    var ssdf = rrr;
                    print(ssdf);
                    var response = await Dio().get(ssdf);
                    // print(response);
                    response.headers.forEach((name, values) {
                      if (name == "content-type") {
                        if (values
                                .where(
                                    (element) => element == "application/pdf")
                                .length !=
                            0) {
                          //it is pdf
                          setState(() {
                            showPdf = true;
                          });

                          print("it is pdf page");
                        }
                      }
                      //                  print(name);
                      //                print(values.toString());
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                onProgress: (int f) async {
                  var fff = await _controller.getTitle();
                  print("ssss678 : ${fff} ");
                  try {
                    var ssdf = await _controller.currentUrl();
                    print(ssdf);
                    var response = await Dio().get(ssdf!);
                    // print(response);
                    response.headers.forEach((name, values) {
                      if (name == "content-type") {
                        if (values
                                .where(
                                    (element) => element == "application/pdf")
                                .length !=
                            0) {
                          //it is pdf
                          setState(() {
                            showPdf = true;
                          });

                          print("it is pdf page");
                        }
                      }
                      //                  print(name);
                      //                print(values.toString());
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                onPageFinished: (String? f) async {
                  // var fff = await   _controller.getTitle();
                  // print("12345678 :  ${fff}");
                },
              ),
              Visibility(
                visible: showPdf,
                child: SfPdfViewer.network(
                  'http://smartboardadminen.replsolutions.com/Invoice/Print/22',
                  key: _pdfViewerKey,
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
