import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/utils/loader_component.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/utils/no_network_component.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewComponent extends StatefulWidget {
  static const routeName = '/webviewComponent';
  final String surveyUrl;

  WebViewComponent({this.surveyUrl});

  @override
  _WebViewComponentState createState() => _WebViewComponentState();
}

class _WebViewComponentState extends State<WebViewComponent> {
  bool isLoading;
  bool isNetworkAvailable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        (isNetworkAvailable == null || isNetworkAvailable == true)
            ? widget.surveyUrl.isNotEmpty
            ? WebView(
          initialUrl: widget.surveyUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (status) {
            Fimber.d("Status  :  $status");
            setState(() {
              this.isLoading = false;
            });
          },
        )
            : Container(
          child: Center(child: Text("Url not available")),
        )
            : NoNetworkConnection(connectionCheck: validateInternetAvailablity),
        isLoading ? Center(child: LoaderComponent()) : Container(),
      ],
    );
  }

  /// InitState of widget, this methods called only once in widget lifecycle
  @override
  void initState() {
    super.initState();
    //toast("URL : ${widget.surveyUrl}");
    Fimber.d("Webview link : ${widget.surveyUrl}");
    setState(() {
      this.isLoading = true;
    });

    var internet = getConnectivityStatus();
    Fimber.d("internet : $internet");
    validateInternetAvailablity();
    Fimber.d("init completed");
  }

  /// This method user to check connectivity status
  Future<bool> getConnectivityStatus() async {
    return await NetworkUtils.isNetwork();
  }

  /// Used to manage webivew loading process based on internet availability
  void validateInternetAvailablity() {
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");
        setState(() {
          isNetworkAvailable = true;
          isLoading = true;
        });
      } else {
        Fimber.d("isNetwork Not Available");
        setState(() {
          isNetworkAvailable = false;
          isLoading = false;
        });
      }
    });
  }
}
