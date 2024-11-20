import 'package:flutter/material.dart';
import 'package:browser_mirror_wall_app/shr/shr_helper.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeProvider extends ChangeNotifier {
  List<String> searchHistory = [];
  final ShrHelper shrHelper = ShrHelper();

  bool canBack = false;
  bool canForward = false;
  String googleURL = 'https://www.google.co.in/';
  String webURL = '';

  late InAppWebViewController webViewController;

  String groupValue = 'Google';

  List<String> bookmarkList = [];

  void saveSearchHistory(String value) async {
    searchHistory.add(value);
    await shrHelper.setSearchHistory(searchHistory);
    notifyListeners();
  }

  void getSearchHistory() async {
    searchHistory = await shrHelper.getSearchHistory();
    notifyListeners();
  }

  void clearSearchHistory() async {
    await shrHelper.clearSearchHistory();
    searchHistory.clear();
    notifyListeners();
  }

  Future<void> loadBookmarks() async {
    bookmarkList = await ShrHelper.getBookmarks();
    notifyListeners();
  }

  Future<void> addBookmark(String url) async {
    await ShrHelper.addBookmark(url);
    loadBookmarks();
  }

  Future<void> removeBookmark(String url) async {
    await ShrHelper.removeBookmark(url);
    loadBookmarks();
  }

  void chromeWeb({required String val}) {
    googleURL = val;
    webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(googleURL))));
    notifyListeners();
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  Future<void> checkNavigations() async {
    canBack = await webViewController.canGoBack();
    canForward = await webViewController.canGoForward();
    notifyListeners();
  }

  void onLoadStop(controller, uri) {
    webViewController = controller;
    checkNavigations();
  }

  void back() {
    if (canBack) {
      webViewController.goBack();
      notifyListeners();
    }
  }

  void forward() {
    if (canForward) {
      webViewController.goForward();
      notifyListeners();
    }
  }

  Future<void> reload() async {
    await webViewController.reload();
    checkNavigations();
  }

  void searchEngine(String val) {
    groupValue = val;
    notifyListeners();
  }

  void textOnSubmitted(String val) {
    if (groupValue == 'Google') {
      googleURL = 'https://www.google.com/search?q=$val';
    } else if (groupValue == 'Yahoo') {
      googleURL = 'https://search.yahoo.com/search?p=$val';
    } else if (groupValue == 'Bing') {
      googleURL = 'https://www.bing.com/search?q=$val';
    } else {
      googleURL = 'https://duckduckgo.com/?q=$val';
    }
    webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(googleURL))));
  }
}
