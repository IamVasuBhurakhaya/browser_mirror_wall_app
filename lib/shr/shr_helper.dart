import 'package:shared_preferences/shared_preferences.dart';

class ShrHelper {
  static const String bookmark = 'bookmarks';

  static Future<void> addBookmark(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkList = prefs.getStringList(bookmark) ?? [];
    if (!bookmarkList.contains(url)) {
      bookmarkList.add(url);
      await prefs.setStringList(bookmark, bookmarkList);
    }
  }

  static Future<List<String>> getBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(bookmark) ?? [];
  }

  static Future<void> removeBookmark(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkList = prefs.getStringList(bookmark) ?? [];
    bookmarkList.remove(url);
    await prefs.setStringList(bookmark, bookmarkList);
  }

  Future<void> setSearchHistory(List<String> searchHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("searchHistory", searchHistory);
  }

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("searchHistory") ?? [];
  }

  Future<void> clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("searchHistory");
  }

  Future<void> setThemeMode(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", isDark);
  }

  Future<bool> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDark") ?? false;
  }
}
