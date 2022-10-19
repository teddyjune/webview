import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: const WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
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
              ElevatedButton(
                onPressed: () {
                  _loadHtmlFromAssets();
                },
                child: const Text('assets'),
              ),
            ],
          ),
          Expanded(
            child: WebView(
              initialUrl: 'https://google.com',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              javascriptChannels: {
                JavascriptChannel(
                  name: 'myChannel',
                  onMessageReceived: (JavascriptMessage message) {
                    log(message.message);
                    Map<String, dynamic> json = jsonDecode(message.message);

                    final snackBar = SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(json['title']),
                          Text(json['body']),
                          Text('${json['id']}'),
                        ],
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                )
              },
            ),
          ),
        ],
      ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/test.html');
    _controller.loadUrl(
      Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }
}
