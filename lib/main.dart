import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _controller.goBack();
              },
              child: const Text('<-'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.goForward();
              },
              child: const Text('->'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.loadUrl('https://google.com');
              },
              child: const Text('google'),
            ),
          ],
        ),
        Expanded(
          child: WebView(
            initialUrl: 'https://ssac-flutter.github.io/webview/',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
          ),
        ),
      ],
    );
  }
}
