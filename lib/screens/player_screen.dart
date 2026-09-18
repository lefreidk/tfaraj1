import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/content_item.dart';
import '../services/local_store.dart';

class PlayerScreen extends StatefulWidget {
  final ContentItem item;
  const PlayerScreen({super.key, required this.item});
  @override State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final WebViewController controller;
  final store = LocalStore();
  bool favorite = false;

  String get poster => widget.item.poster.isNotEmpty ? widget.item.poster : 'https://img.omdbapi.com/?i=${widget.item.id}&apikey=trilogy';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse('https://streamimdb.ru/embed/tv/${widget.item.id}/'));
    _init();
  }

  Future<void> _init() async {
    favorite = await store.isFavorite(widget.item.id);
    await store.incrementView(widget.item.id);
    if (mounted) setState(() {});
  }

  Future<void> _toggleFavorite() async { await store.toggleFavorite(widget.item); setState(() => favorite = !favorite); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff08080b),
    body: SafeArea(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Stack(children: [
        AspectRatio(aspectRatio: 16 / 9, child: WebViewWidget(controller: controller)),
        Positioned(top: 10, right: 10, child: CircleAvatar(backgroundColor: Colors.black.withOpacity(.7), child: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () => Navigator.pop(context)))),
      ])),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(18, 22, 18, 30), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.item.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(spacing: 14, runSpacing: 8, children: [Text(widget.item.year), Text(widget.item.category), Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, color: Color(0xffffc107), size: 18), const SizedBox(width: 4), Text(widget.item.rating)])]),
        const SizedBox(height: 15),
        Text(widget.item.description, style: const TextStyle(color: Colors.white70, height: 1.7)),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: _toggleFavorite, icon: Icon(favorite ? Icons.bookmark : Icons.bookmark_border), label: Text(favorite ? 'في مفضلتي' : 'إضافة إلى المفضلة')),
      ]))),
    ])),
  );
}
