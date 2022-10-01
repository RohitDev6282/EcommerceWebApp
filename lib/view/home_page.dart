import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController? _controller;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  Future<bool> _goBack(BuildContext context) async {
    if (await _controller!.canGoBack()) {
      _controller!.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Do you want to exit'),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text('Yes'),
                  ),
                ],
              ));
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    // Enable virtual display.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: WebView(
              onPageFinished: ((url) {
                _controller!.evaluateJavascript(
                    "document.querySelectorAll('.footer-part').forEach(a=>a.style.display = 'none');");
                _controller!.evaluateJavascript(
                    "document.querySelectorAll('.testimonial-part').forEach(a=>a.style.display = 'none');");
              }),
              initialUrl: 'https://ecommdemoone.renutech.in/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controllerCompleter.future
                    .then((value) => _controller = value);
                _controllerCompleter.complete(webViewController);
              },
            ),
          ),
        ),
      ),
    );
  }
}
