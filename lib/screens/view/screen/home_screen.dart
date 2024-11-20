import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:browser_mirror_wall_app/screens/view/provider/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (webViewController != null) {
          await webViewController!.reload();
        }
      },
    );
  }

  @override
  void dispose() {
    pullToRefreshController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider providerR = context.read<HomeProvider>();
    HomeProvider providerW = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: providerW.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: providerW.isDark ? Colors.black : Colors.white,
        centerTitle: true,
        title: const Text(
          'Browser',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            fontSize: 30,
          ),
        ),
        actions: [
          Switch(
            value: providerW.isDark,
            onChanged: (value) {
              providerR.changeThemeMode(value);
            },
            activeColor: Colors.amber,
            inactiveThumbColor: Colors.lightGreen,
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
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                  ),
                                  child: const Text('Clear History'),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.timer_sharp, color: Colors.grey[600]),
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
                                  itemCount: providerW.bookmark.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(providerW.bookmark[index]),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          providerR.bookmark.removeAt(index);
                                          providerR.shrHelper
                                              .setBookmark(providerW.bookmark);
                                        },
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(CupertinoIcons.bookmark_fill, color: Colors.grey[600]),
                    Text('All Bookmarks'),
                  ],
                ),
              ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.screen_search_desktop_outlined,
                        color: Colors.grey[600]),
                    Text('Search Engine'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: InAppWebView(
                pullToRefreshController: pullToRefreshController!,
                onWebViewCreated: providerR.onWebViewCreated,
                initialUrlRequest:
                    URLRequest(url: WebUri.uri(Uri.parse(providerW.googleURL))),
                onLoadStart: (controller, uri) {
                  pullToRefreshController?.beginRefreshing();
                },
                onLoadStop: (controller, uri) {
                  providerR.onLoadStop(controller, uri);
                  pullToRefreshController!.endRefreshing();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: providerW.canBack ? providerR.back : null,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 30,
                    ),
                    onPressed: providerW.canForward ? providerR.forward : null,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh_outlined,
                      size: 30,
                    ),
                    onPressed: providerR.reload,
                  ),
                  IconButton(
                    onPressed: () async {
                      String? currentUrl =
                          await webViewController?.getUrl().toString();
                      if (currentUrl != null) {
                        providerR.saveBookmark(currentUrl);
                      }
                    },
                    icon: const Icon(
                      Icons.bookmark,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextField(
                onSubmitted: (val) {
                  providerR.textOnSubmitted(val);
                  providerR.saveSearchHistory(val);
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  labelText: 'Search or Type Web Address',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: providerW.isDark ? Colors.white : Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color:
                          providerW.isDark ? Colors.white : Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
