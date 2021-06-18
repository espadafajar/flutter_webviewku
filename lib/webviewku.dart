import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewKu extends StatefulWidget {
  const WebviewKu({Key? key}) : super(key: key);

  @override
  _WebviewKuState createState() => _WebviewKuState();
}

class _WebviewKuState extends State<WebviewKu> {
  bool _isLoading = true;
  String _myUrl = "https://marasmart.id/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: _myUrl,
            onPageStarted: (_) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (_) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebViewCreated: (_) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          Visibility(
            visible: _isLoading,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.blue,
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
