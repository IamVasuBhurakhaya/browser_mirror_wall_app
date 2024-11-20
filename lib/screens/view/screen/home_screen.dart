import 'package:browser_mirror_wall_app/screens/view/provider/home_provider.dart';
import 'package:browser_mirror_wall_app/shr/shr_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    HomeProvider providerR = context.read<HomeProvider>();
    HomeProvider providerW = context.watch<HomeProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Browser',
        ),
        actions: [
          Switch(
            value: providerW.isDark,
            onChanged: (value) {
              webViewController?.setSettings(settings: InAppWebViewSettings());
              providerR.changeThemeMode(value);
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Search History',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: providerW.searchHistory.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                          providerW.searchHistory.isEmpty
                                              ? 'No History'
                                              : providerW.searchHistory[index]),
                                    );
                                  },
                                ),
                              ),
                              if (providerW.searchHistory.isNotEmpty)
                                ElevatedButton(
                                  onPressed: () {
                                    providerR.clearSearchHistory();
                                    Navigator.pop(context); // Close the modal
                                  },
                                  child: const Text('Clear History'),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.timer_sharp, color: Colors.grey),
                    Text('Search History'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Bookmarks',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: providerW.bookmarkList.length,
                                  itemBuilder: (context, index) {
                                    final bookmark =
                                        providerW.bookmarkList[index];
                                    return ListTile(
                                      title: Text(bookmark),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            providerR.removeBookmark(bookmark),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(CupertinoIcons.bookmark_fill, color: Colors.grey),
                    Text('All Bookmarks'),
                  ],
                ),
              ),
              // Search Engine Item
              PopupMenuItem(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Search Engine'),
                      actions: [
                        RadioListTile(
                          title: const Text('Google'),
                          value: 'Google',
                          groupValue: providerW.groupValue,
                          onChanged: (val) {
                            providerR.searchEngine(val!);
                            providerR.chromeWeb(
                                val: 'https://www.google.co.in/');
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Yahoo'),
                          value: 'Yahoo',
                          groupValue: providerW.groupValue,
                          onChanged: (val) {
                            providerR.searchEngine(val!);
                            providerR.chromeWeb(val: 'https://www.yahoo.com/');
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Bing'),
                          value: 'Bing',
                          groupValue: providerW.groupValue,
                          onChanged: (val) {
                            providerR.searchEngine(val!);
                            providerR.chromeWeb(val: 'https://www.bing.com/');
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Duck Duck Go'),
                          value: 'Duck Duck Go',
                          groupValue: providerW.groupValue,
                          onChanged: (val) {
                            providerR.searchEngine(val!);
                            providerR.chromeWeb(val: 'https://duckduckgo.com/');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.screen_search_desktop_outlined,
                        color: Colors.grey),
                    Text('Search Engine'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // WebView displaying the webpage
          Expanded(
            flex: 8,
            child: InAppWebView(
              pullToRefreshController:
                  providerW.pullToRefreshController, // Attach it here
              onWebViewCreated: providerR.onWebViewCreated,
              initialUrlRequest:
                  URLRequest(url: WebUri.uri(Uri.parse(providerW.googleURL))),
              onLoadStop: (controller, uri) {
                providerR.onLoadStop(controller, uri);
                providerW.pullToRefreshController.endRefreshing();
              },
              // onLoadStart: (controller, uri) {
              //   providerW.pullToRefreshController?.beginRefreshing();
              // },
            ),
          ),
          // Navigation Controls (Back, Forward, Reload)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: providerW.canBack ? providerR.back : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: providerW.canForward ? providerR.forward : null,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: providerR.reload,
                ),
                IconButton(
                  onPressed: () {
                    providerR.addBookmark(providerW.googleURL);
                  },
                  icon: const Icon(Icons.bookmark),
                ),
              ],
            ),
          ),
          // URL input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (val) {
                providerR.textOnSubmitted(val);
                providerR.saveSearchHistory(val);
              },
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                labelText: 'Search or Type Web Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
