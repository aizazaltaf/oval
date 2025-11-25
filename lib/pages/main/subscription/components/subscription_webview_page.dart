import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionWebViewPage extends StatefulWidget {
  const SubscriptionWebViewPage({
    super.key,
    required this.url,
    required this.pageKey,
    this.needNavigation = false,
  });
  final String url;
  final String pageKey;
  final bool needNavigation;

  static const routeName = "CurrentSubscriptionPage";

  static Future<void> push(
    BuildContext context, {
    required String url,
    required String pageKey,
    needNavigation = false,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => SubscriptionWebViewPage(
        url: url,
        pageKey: pageKey,
        needNavigation: needNavigation,
      ),
    );
  }

  @override
  State<SubscriptionWebViewPage> createState() =>
      _SubscriptionWebViewPageState();
}

class _SubscriptionWebViewPageState extends State<SubscriptionWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  Future<void> restartApp() async {
    final navigationContext = singletonBloc.navigatorKey?.currentState?.context;
    if (navigationContext != null && navigationContext.mounted) {
      final startupBloc = StartupBloc.of(navigationContext);
      await startupBloc.callUserDetails();
      if (navigationContext.mounted && widget.needNavigation) {
        startupBloc.clearPageIndexes();
        unawaited(MainDashboard.pushRemove(navigationContext));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'AppChannel', // channel name
        onMessageReceived: (message) {
          if (message.message == "force_restart") {
            if (widget.pageKey == "change_plan") {
              Navigator.pop(context);
              restartApp();
            } else if (widget.pageKey == "add_payment_method") {
              SubscriptionBloc.of(context).callPaymentMethods();
              Navigator.pop(context);
            } else if (widget.pageKey == "upgrade_downgrade") {
              StartupBloc.of(context).callUserDetails();
              Navigator.pop(context);
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true); // Show loader
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false); // Hide loader
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: CommonFunctions.getThemeBasedWidgetColor(context),
            size: 30,
          ),
        ),
      ),
      body: _isLoading
          ? ColoredBox(
              color: Theme.of(context).colorScheme.onPrimary,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : WebViewWidget(controller: _controller),
    );
  }
}
