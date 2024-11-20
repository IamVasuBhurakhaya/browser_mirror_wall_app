import 'package:shared_preferences/shared_preferences.dart';

class ShrHelper {
  Future<void> setBookmark(List<String> bookmaark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("bookmark", bookmaark);
  }

  Future<List<String>> getBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("bookmark") ?? [];
  }

  Future<void> setSearchHistory(List<String> searchHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("searchHistory", searchHistory);
  }

  Future<void> setThemeMode(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", isDark);
  }

  Future<bool> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDark") ?? false;
  }

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("searchHistory") ?? [];
  }

  Future<void> clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("searchHistory");
  }
}
