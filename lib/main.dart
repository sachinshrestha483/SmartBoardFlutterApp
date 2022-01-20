import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
  // String pdfLink = "https://www.americanexpress.com/content/dam/amex/us/staticassets/pdf/GCO/Test_PDF.pdf";
  String pdfLink = Utility.GetDefaultPdfPage();
  
  bool showPdf = false;
  late WebViewController _controller;
  void TogglePdfView() {
    setState(() {
      showPdf = !showPdf;
    });
  }
  void SetPdfUrl(String link){
      setState(() {
        pdfLink=link;
      });
  }

  NavigationDecision _interceptNavigation(NavigationRequest request) {
    print("Page Contains $request ");
    print("Page Contains Navigation Url: ${request.url}");

    if (request.url.contains("Print")) {
      //  launch(request.url);
      SetPdfUrl(request.url);
      TogglePdfView();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBack() async {
      var value = await _controller.canGoBack();
      // check webview can go back
      if (showPdf == true) {
        TogglePdfView();
        return false;
      }
      if (value) {
        _controller.goBack(); // perform webview back operation
        return false;
      } else {
        return true;
      }
    }
    return WillPopScope(
      onWillPop: () async {
        var canGoBack = await _onBack();
        print(canGoBack);
        return canGoBack;
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
               // initialUrl: 'http://smartboard.replsolutions.com/',
               initialUrl: Utility.GetParentConsoleUrl(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                navigationDelegate: this._interceptNavigation,
                onWebResourceError: (Wedf) {
                  print("Page Load Error");
                },
                // onPageStarted: (url) {
                //   print("Page Contains ");
                //   if (url.contains("Print")) {
                //     print("Page Contains Pdf");
                //     TogglePdfView();
                //     _controller.goBack();
                //   }
                // },
              ),
              Visibility(
                visible: showPdf,
                child: SfPdfViewer.network(
                  pdfLink,
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
