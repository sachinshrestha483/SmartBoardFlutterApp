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
  late WebViewController _controller;
  String pdfUrl = "http://smartboardadminen.replsolutions.com/";
  String logMessage = "";
  void SetMessage(String message) {
    setState(() {
      logMessage = message;
    });
  }

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
        SetMessage("Back Button Clicked");

        var hhhh = await _onBack();
        print(hhhh);
        SetMessage("Can Go back:${hhhh}");

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
          body: Column(
            children: [
              Expanded(flex: 1, child: Container(child: Text("${logMessage}"))),
              Expanded(
                flex: 10,
                child: Container(
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: "http://smartboardadminen.replsolutions.com/",
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                    },
                    onPageStarted: (String rrr) async {
                      SetMessage("Entering On Page Started Method");

                      print(rrr);
                      SetMessage(
                          "Inside OnPage Started Method: Checking If Link  Contains Pdf Content");

                      if (rrr.contains("Print")) {
                        SetMessage(
                            " Inside OnPage Started Method: Pdf Cotent Present There");

                        setState(() {
                          //                      _controller.goBack();
                          pdfUrl = rrr;
                          SetMessage(
                              " Inside OnPage Started Method: Setting Link As Pdf Url For Download ${pdfUrl} ");
                          SetMessage("  Opening  Modal Box:  ");

                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // const Text('Download Pdf'),
                                        ElevatedButton(
                                          child: const Text('Download'),
                                          onPressed: () async {
                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked:  ");
                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked: Getting extStorage Object   ");

                                            var extstorage =
                                                await getExternalStorageDirectory();
                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked: extStorage -> ${extstorage}   ");

                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked: Geerating Path To Save The Object    ");

                                            var finalPath =
                                                "${extstorage!.path}/${new Random().nextInt(5014).toString()}.pdf";
                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked: Generated Path -> ${finalPath}    ");

                                            DownloaderUtils options =
                                                DownloaderUtils(
                                              progressCallback:
                                                  (current, total) {
                                                final progress =
                                                    (current / total) * 100;
                                                SetMessage(
                                                    "  DownLoad Pdf Button Clicked:   Download : ${progress} ");
                                                print('Downloading: $progress');
                                              },
                                              file: File(finalPath),
                                              progress:
                                                  ProgressImplementation(),
                                              onDone: () {
                                                print('COMPLETE');
                                                SetMessage(
                                                    "  DownLoad Pdf Button Clicked:   Download  Completed ");
                                              },
                                              deleteOnCancel: true,
                                            );
                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked:    Starting Downloading Process   ");

                                            await Flowder.download(
                                                'http://smartboardadminen.replsolutions.com/Invoice/Print/21',
                                                options);
                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked:  Download Process Finished   ");
                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked: Opening The File With Final Path $finalPath  ");

                                            await OpenFile.open(finalPath);
                                            SetMessage(
                                                "  DownLoad Pdf Button Clicked:  File Opened  ");
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
