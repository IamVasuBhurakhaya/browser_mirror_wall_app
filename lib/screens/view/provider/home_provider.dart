import 'package:flutter/material.dart';
import 'package:browser_mirror_wall_app/shr/shr_helper.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeProvider with ChangeNotifier {
  HomeProvider() {
    getThemeMode();
    getBookmark();
  }

  List<String> searchHistory = [];
  final ShrHelper shrHelper = ShrHelper();
  bool canBack = false;
  bool canForward = false;
  String googleURL = 'https://www.google.co.in/';
  String webURL = '';
  bool isDark = false;
  ThemeMode themeMode = ThemeMode.light;
  late InAppWebViewController webViewController;
  String groupValue = 'Google';
  List<String> bookmark = [];

  void setBookmark(String value) async {
    bookmark.add(value);
    shrHelper.setBookmark(bookmark);
    notifyListeners();
  }

  void getBookmark() async {
    bookmark = await shrHelper.getBookmark();
    notifyListeners();
  }

  void setThemeMode(bool value) async {
    isDark = value;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    shrHelper.setThemeMode(isDark);
    notifyListeners();
  }

  void getThemeMode() async {
    isDark = await shrHelper.getThemeMode();
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSearchHistory(String value) async {
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
