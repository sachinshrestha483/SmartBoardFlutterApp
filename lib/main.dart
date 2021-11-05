import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flowder/flowder.dart';
import 'package:open_file/open_file.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

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

//                      _controller.goBack();
                      pdfUrl = rrr;

                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    // const Text('Download Pdf'),
                                    ElevatedButton(
                                      child: const Text('Download'),
                                      onPressed: () async {
                                        var extstorage =
                                            await getExternalStorageDirectory();
                                          var finalPath="${extstorage!.path}/${new Random().nextInt(5014).toString()}.pdf";
                                        DownloaderUtils options =
                                            DownloaderUtils(
                                          progressCallback: (current, total) {
                                            final progress =
                                                (current / total) * 100;
                                            print('Downloading: $progress');
                                          },
                                          file: File(
                                              finalPath),
                                          progress: ProgressImplementation(),
                                          onDone: () => print('COMPLETE'),
                                          deleteOnCancel: true,
                                        );

                                        await Flowder.download(
                                            'http://smartboardadminen.replsolutions.com/Invoice/Print/21',
                                            options);
                                         await OpenFile.open(finalPath);
                                      },
                                    ),
                                    // ElevatedButton(
                                    //   child: const Text('Close BottomSheet'),
                                    //   onPressed: () => Navigator.pop(context),
                                    // )
                                  ],
                                ),
                              ),
                            );
                          });

                      return null;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
