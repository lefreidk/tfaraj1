import 'package:flutter/material.dart';

import '../data/content_data.dart';
import '../models/content_item.dart';
import '../services/local_store.dart';
import '../services/translations.dart';
import '../widgets/content_card.dart';
import '../services/firebase_service.dart';

import 'player_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  final String language;
  final ThemeMode mode;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String> onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.language,
    required this.mode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final store = LocalStore();

  int nav = 0;
  String query = '';
  int coins = 0;
  bool adBlock = false;

  List<ContentItem> favorites = [];
  Map<String, int> views = {};

  String tr(String key) => T.get(widget.language, key);

  List<ContentItem> get all => [
        ...moviesData,
        ...seriesData,
        ...animeData,
      ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.language != widget.language) {
      setState(() {});
    }
  }

  Future<void> _load() async {
    coins = await store.getCoins();
    adBlock = await store.getAdBlock();
    favorites = await store.getFavorites();
    views = await store.getViews();

    if (mounted) {
      setState(() {});
    }
  }

  List<ContentItem> filter(List<ContentItem> source) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      return source;
    }

    return source
        .where(
          (item) => item.title.toLowerCase().contains(q),
        )
        .toList();
  }

  void open(ContentItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(item: item),
      ),
    ).then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _gridPage(
        tr('anime'),
        filter(animeData),
      ),
      _gridPage(
        tr('movies'),
        filter(moviesData),
      ),
      _gridPage(
        tr('series'),
        filter(seriesData),
      ),
      _favorites(),
      _notifications(),
      _settings(),
    ];

    return Directionality(
      textDirection: widget.language == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: nav == 6 ? null : _appBar(),
        body: pages[nav],
        bottomNavigationBar: _bottomNav(),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    final smallColor =
        Theme.of(context).textTheme.bodySmall?.color;

    return AppBar(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TFARAJ',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          Text(
            tr('subtitle'),
            style: TextStyle(
              fontSize: 11,
              color: smallColor?.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            setState(() {
              nav = 5;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            setState(() {
              nav = 6;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: TfarajSearchDelegate(
                all,
                open,
                widget.language,
              ),
            );
          },
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _home() {
    final top = [...all]
      ..sort(
        (a, b) => (views[b.id] ?? 0).compareTo(
          views[a.id] ?? 0,
        ),
      );

    final latest = [...all]
      ..sort(
        (a, b) => b.year.compareTo(a.year),
      );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        30,
      ),
      children: [
        _section(
          tr('mostViewed'),
          filter(top.take(10).toList()),
        ),
        const SizedBox(height: 25),
        _section(
          tr('latest'),
          filter(latest.take(10).toList()),
        ),
      ],
    );
  }

  Widget _section(
    String title,
    List<ContentItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 265,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.55,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ContentCard(
                  item: items[i],
                  onTap: () => open(items[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _gridPage(
    String title,
    List<ContentItem> items,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(
              child: Text(
                tr('noResults'),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 170,
              mainAxisExtent: 270,
              crossAxisSpacing: 12,
              mainAxisSpacing: 18,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              return ContentCard(
                item: items[i],
                onTap: () => open(items[i]),
              );
            },
          ),
      ],
    );
  }

  Widget _favorites() {
    return _gridPage(
      tr('favorites'),
      filter(favorites),
    );
  }

  Widget _notifications() {
    return FutureBuilder<List<AppNotification>>(
      future: FirebaseService.initialized
          ? FirebaseService.notifications()
          : Future.value(
              const <AppNotification>[],
            ),
      builder: (context, snap) {
        if (snap.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final list =
            snap.data ?? const <AppNotification>[];

        if (list.isEmpty) {
          return Center(
            child: Text(
              tr('noNotifications'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final n = list[i];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(n.body),
                    if (n.date != null) ...[
                      const SizedBox(height: 7),
                      Text(
                        n.date!.toLocal().toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _settings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '⚙️ الإعدادات',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 20),

        SwitchListTile(
          title: Text(tr('dark')),
          value: widget.mode == ThemeMode.dark,
          onChanged: widget.onThemeChanged,
        ),

        SwitchListTile(
          title: Text(tr('adBlock')),
          subtitle: const Text('50 🪙'),
          value: adBlock,
          onChanged: (value) async {
            if (value && coins < 50) {
              _snack('الرصيد غير كافٍ');
              return;
            }

            if (value) {
              coins -= 50;
              await store.setCoins(coins);
            }

            adBlock = value;

            await store.setAdBlock(value);

            if (mounted) {
              setState(() {});
            }
          },
        ),

        ListTile(
          title: Text(tr('language')),
          trailing: DropdownButton<String>(
            value: widget.language,
            items: const [
              DropdownMenuItem(
                value: 'ar',
                child: Text('🇸🇦 العربية'),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Text('🇬🇧 English'),
              ),
              DropdownMenuItem(
                value: 'fr',
                child: Text('🇫🇷 Français'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                widget.onLanguageChanged(value);
              }
            },
          ),
        ),

        ListTile(
          title: Text(
            '🪙 ${tr('balance')}',
          ),
          trailing: Text('$coins'),
        ),

        ListTile(
          leading: const Icon(
            Icons.account_circle_outlined,
          ),
          title: Text(tr('account')),
          subtitle: Text(
            FirebaseService.initialized
                ? (FirebaseService
                        .auth
                        .currentUser
                        ?.email ??
                    'زائر')
                : 'Firebase غير مهيأ',
          ),
          onTap: () async {
            if (!FirebaseService.initialized ||
                FirebaseService.auth.currentUser ==
                    null) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AuthScreen(),
                ),
              );

              if (mounted) {
                setState(() {});
              }
            } else {
              await FirebaseService.signOut();

              if (mounted) {
                setState(() {});
              }
            }
          },
        ),

        ListTile(
          title: Text(tr('privacy')),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('سياسة الخصوصية'),
                content: SingleChildScrollView(
                  child: Text(
                    'TFARAJ يخزن المفضلة والإعدادات محلياً. '
                    'إعداد Firebase اختياري في هذه النسخة '
                    'إلى حين تشغيل flutterfire configure.',
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 25),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'TFARAJ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr('aboutDesc'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '${tr('credit')}: Lefreid Khalil',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomNav() {
    return NavigationBar(
      selectedIndex: nav > 4 ? 4 : nav,
      onDestinationSelected: (index) {
        setState(() {
          nav = index;
        });
      },
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        NavigationDestination(
          icon: const Icon(Icons.animation_outlined),
          label: tr('anime'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.movie_outlined),
          label: tr('movies'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.tv_outlined),
          label: tr('series'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.favorite_outline),
          selectedIcon: const Icon(Icons.favorite),
          label: tr('favorites'),
        ),
      ],
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

class TfarajSearchDelegate
    extends SearchDelegate<ContentItem?> {
  final List<ContentItem> source;
  final void Function(ContentItem) onOpen;
  final String language;

  TfarajSearchDelegate(
    this.source,
    this.onOpen,
    this.language,
  );

  @override
  List<Widget>? buildActions(
    BuildContext context,
  ) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(
    BuildContext context,
  ) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    return _results(context);
  }

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return _results(context);
  }

  Widget _results(BuildContext context) {
    final list = source
        .where(
          (item) => item.title
              .toLowerCase()
              .contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    if (list.isEmpty) {
      return const Center(
        child: Text('لا توجد نتائج'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate:
          const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 170,
        mainAxisExtent: 270,
        crossAxisSpacing: 12,
        mainAxisSpacing: 18,
      ),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];

        return ContentCard(
          item: item,
          onTap: () {
            close(context, item);
            onOpen(item);
          },
        );
      },
    );
  }
}
