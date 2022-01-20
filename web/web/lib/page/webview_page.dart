// ignore_for_file: unused_field

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum MenuOptions {
  clearCahe,
  clearCookies,
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webController;
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webController.canGoBack()) {
          _webController.goBack();
        } else {
          log('Нет записи в истории');
        }
        // Stay App
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WebView'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await _webController.canGoBack()) {
                  _webController.goBack();
                } else {
                  log('Нет записи в истории');
                }
                return;
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (await _webController.canGoForward()) {
                  _webController.goForward();
                } else {
                  log('Нет записи в истории');
                }
                return;
              },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () => _webController.reload(),
            ),
            PopupMenuButton<MenuOptions>(
              onSelected: (value) {
                switch (value) {
                  case MenuOptions.clearCahe:
                    _onClearCache(_webController, context);
                    break;
                  case MenuOptions.clearCookies:
                    _OnClearCookies(context);
                    break;
                }
              },
              itemBuilder: (context) => <PopupMenuItem<MenuOptions>>[
                const PopupMenuItem(
                  value: MenuOptions.clearCahe,
                  child: Text('Удалить кеш'),
                ),
                const PopupMenuItem(
                  value: MenuOptions.clearCookies,
                  child: Text('Удалить куки'),
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              color: Colors.red,
              backgroundColor: Colors.black,
            ),
            Expanded(
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: 'https://vk.com',
                onWebViewCreated: (controller) {
                  _webController = controller;
                },
                onProgress: (progress) {
                  this.progress = progress / 100;
                  setState(() {});
                },
                onPageStarted: (url) {
                  log('Новый сайт: $url');
                  // if (url.contains('https://flutter.dev')) {
                  //   Future.delayed(const Duration(milliseconds: 30));
                  //   _webController.evaluateJavascript(
                  //    "document.getElementsByTagName('footer')[0].style.display='none'",
                  //   );
                  // }
                },
                onPageFinished: (url) {
                  log('Страница полностью загружена');
                },
                navigationDelegate: (request) {
                  if (request.url.startsWith('https://m.youtube.com')) {
                    log('Навигация заблокирована к $request');
                    return NavigationDecision.prevent;
                  }
                  log('Навигация разрещена к $request');
                  return NavigationDecision.navigate;
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.next_plan, size: 32),
          onPressed: () async {
            final currentUrl = await _webController.currentUrl();
            log('Предыдущий сайт: $currentUrl');
            //_webController.loadUrl('https://www.youtube.com');
            // _webController.evaluateJavascript(
            //   "document.getElementsByTagName('footer')[0].style.display='none'",
            // );
          },
        ),
      ),
    );
  }

  void _OnClearCookies(BuildContext) async {
    final bool hadCookies = await CookieManager().clearCookies();
    String message = 'Coocies delete';
    if (!hadCookies) {
      message = 'Cookies was clean';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await _webController.clearCache();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cache cleaned")),
    );
  }
}
