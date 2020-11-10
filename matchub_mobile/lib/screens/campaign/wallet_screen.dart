import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Profile myProfile;
  bool _isLoading = false;
  bool _isLoadingPage = false;
  String stripeExpressDashboard;
  Future loadDashboard;

  @override
  void initState() {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    if (myProfile.stripeAccountUid != null) {
      loadDashboard = getStripeExpressDashboard();
    }
    _isLoadingPage = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;

    return Scaffold(
      appBar: AppBar(title: Text("Stripe Wallet")),
      body: LoadingOverlay(
        isLoading: _isLoading,
        color: kSecondaryColor.withOpacity(0.2),
        child: Container(
          child: Column(
            children: [
              if (myProfile.stripeAccountUid == null) ...[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      "It seems like you have yet to set up Stripe. \n\nMatcHub partners with Stripe to handle the payments on the platform to enable payments and ensure a seamless experience.",
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w400)),
                ),
                SizedBox(height: 10),
                RaisedButton(
                    child: Text("Setup Stripe Account",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                        )),
                    onPressed: () => createStripeAccount())
              ],
              if (myProfile.stripeAccountUid != null) ...[
                Expanded(
                  child: Container(
                    child: FutureBuilder(
                      future: loadDashboard,
                      builder: (_, snapshot) {
                        return (snapshot.connectionState ==
                                ConnectionState.done)
                            ? Stack(
                                children: [
                                  WebView(
                                    initialUrl: stripeExpressDashboard,
                                    javascriptMode: JavascriptMode.unrestricted,

                                    navigationDelegate:
                                        (NavigationRequest request) {
                                      if (request.url.startsWith(
                                          "http://localhost:3000/returnFromStripe")) {
                                        print(
                                            'blocking navigation to $request}');
                                        Navigator.pop(context);
                                        return NavigationDecision.prevent;
                                      }
                                      print('allowing navigation to $request');
                                      return NavigationDecision.navigate;
                                    },
                                    onWebViewCreated: (WebViewController
                                        webViewController) async {
                                      setState(() => _isLoading = false);
                                    },
                                    onPageFinished: (finish) {
                                      setState(() {
                                        _isLoadingPage = false;
                                      });
                                    },
                                  ),
                                  _isLoadingPage
                                      ? Container(
                                          alignment: FractionalOffset.center,
                                          child: CircularProgressIndicator(),
                                        )
                                      : Container(
                                          color: Colors.transparent,
                                        ),
                                ],
                              ) : Container();
                      },
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  createStripeAccount() async {
    setState(() => _isLoading = true);
    final stripeSetupUrl = await ApiBaseHelper.instance.postProtected(
        "authenticated/createStripeAccount?email=${myProfile.email}");
    setState(() => _isLoading = false);
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => StripeWebpage(url: stripeSetupUrl['url'])))
        .then((value) => refreshState()).then((value) => 
        Navigator.pop(context));
  }

  getStripeExpressDashboard() async {
    final stripeSetupUrl = await ApiBaseHelper.instance.getProtected(
        "authenticated/getStripeExpressDashboard?stripeAccountUid=${myProfile.stripeAccountUid}");
    stripeExpressDashboard = stripeSetupUrl['url'];
    print(stripeExpressDashboard);
  }

  refreshState() async {
    setState(() => _isLoading = true);
    await Provider.of<Auth>(context, listen: false).retrieveUser();
    setState(() => _isLoading = false);
  }
}

class StripeWebpage extends StatefulWidget {
  String url;
  StripeWebpage({@required this.url});
  @override
  _StripeWebpageState createState() => _StripeWebpageState();
}

class _StripeWebpageState extends State<StripeWebpage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  final Set<String> _favorites = Set<String>();
  bool _isLoading = true;
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Stripe Account'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        color: kSecondaryColor.withOpacity(0.2),
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                .startsWith("http://localhost:3000/returnFromStripe")) {
              print('blocking navigation to $request}');
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onWebViewCreated: (WebViewController webViewController) async {
            _controller.complete(webViewController);
            setState(() => _isLoading = false);
          },
        ),
      ),
    );
  }
}
