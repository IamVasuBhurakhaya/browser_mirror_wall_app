import 'package:browser_mirror_wall_app/screens/view/provider/home_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final nonProvider = Provider.of<HomeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Browser',
          style: TextStyle(
            color: Colors.black45,
          ),
        ),
        actions: [
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
                                  itemCount: provider.searchHistory.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(provider.searchHistory.isEmpty
                                          ? 'No History'
                                          : provider.searchHistory[index]),
                                    );
                                  },
                                ),
                              ),
                              if (provider.searchHistory.isNotEmpty)
                                ElevatedButton(
                                  onPressed: () {
                                    nonProvider.clearSearchHistory();
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
                        return ListView.builder(
                          itemCount: provider.bookmarkList.length,
                          itemBuilder: (context, index) {
                            final bookmark = provider.bookmarkList[index];
                            return ListTile(
                              title: Text(bookmark),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    provider.removeBookmark(bookmark),
                              ),
                            );
                          },
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
                          groupValue: provider.groupValue,
                          onChanged: (val) {
                            nonProvider.searchEngine(val!);
                            nonProvider.chromeWeb(
                                val: 'https://www.google.co.in/');
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Yahoo'),
                          value: 'Yahoo',
                          groupValue: provider.groupValue,
                          onChanged: (val) {
                            nonProvider.searchEngine(val!);
                            nonProvider.chromeWeb(
                                val: 'https://www.yahoo.com/');
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Bing'),
                          value: 'Bing',
                          groupValue: provider.groupValue,
                          onChanged: (val) {
                            nonProvider.searchEngine(val!);
                            nonProvider.chromeWeb(val: 'https://www.bing.com/');
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Duck Duck Go'),
                          value: 'Duck Duck Go',
                          groupValue: provider.groupValue,
                          onChanged: (val) {
                            nonProvider.searchEngine(val!);
                            nonProvider.chromeWeb(
                                val: 'https://duckduckgo.com/');
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
          Expanded(
            flex: 8,
            child: InAppWebView(
              onWebViewCreated: provider.onWebViewCreated,
              initialUrlRequest:
                  URLRequest(url: WebUri.uri(Uri.parse(provider.googleURL))),
              onLoadStop: (controller, uri) {
                provider.onLoadStop(controller, uri);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: provider.canBack ? provider.back : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: provider.canForward ? provider.forward : null,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: provider.reload,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (val) {
                nonProvider.textOnSubmitted(val);
                nonProvider.saveSearchHistory(val);
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                nonProvider.addBookmark(provider.googleURL);
              },
              child: const Text('Bookmark This Page'),
            ),
          ),
        ],
      ),
    );
  }
}
