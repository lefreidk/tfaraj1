import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_item.dart';

class LocalStore {
  static const _favoritesKey = 'tfaraj_favs';
  static const _viewsKey = 'tfaraj_movie_views';
  static const _themeKey = 'tfaraj_theme';
  static const _langKey = 'tfaraj_language';
  static const _coinsKey = 'tfaraj_coins';
  static const _adBlockKey = 'tfaraj_adblock';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<List<ContentItem>> getFavorites() async {
    final p = await _prefs;
    final raw = p.getStringList(_favoritesKey) ?? <String>[];
    return raw.map((e) => ContentItem.fromMap(jsonDecode(e))).toList();
  }

  Future<void> toggleFavorite(ContentItem item) async {
    final p = await _prefs;
    final list = await getFavorites();
    final index = list.indexWhere((x) => x.id == item.id);
    if (index >= 0) {
      list.removeAt(index);
    } else {
      list.add(item);
    }
    await p.setStringList(_favoritesKey, list.map((x) => jsonEncode(x.toMap())).toList());
  }

  Future<bool> isFavorite(String id) async => (await getFavorites()).any((x) => x.id == id);

  Future<Map<String, int>> getViews() async {
    final p = await _prefs;
    final raw = p.getString(_viewsKey);
    if (raw == null) return {};
    return Map<String, int>.from(jsonDecode(raw).map((k, v) => MapEntry(k, (v as num).toInt())));
  }

  Future<void> incrementView(String id) async {
    final p = await _prefs;
    final views = await getViews();
    views[id] = (views[id] ?? 0) + 1;
    await p.setString(_viewsKey, jsonEncode(views));
  }

  Future<String> getTheme() async => (await _prefs).getString(_themeKey) ?? 'dark';
  Future<void> setTheme(String value) async => (await _prefs).setString(_themeKey, value);
  Future<String> getLanguage() async => (await _prefs).getString(_langKey) ?? 'ar';
  Future<void> setLanguage(String value) async => (await _prefs).setString(_langKey, value);
  Future<int> getCoins() async => (await _prefs).getInt(_coinsKey) ?? 0;
  Future<void> setCoins(int value) async => (await _prefs).setInt(_coinsKey, value);
  Future<bool> getAdBlock() async => (await _prefs).getBool(_adBlockKey) ?? false;
  Future<void> setAdBlock(bool value) async => (await _prefs).setBool(_adBlockKey, value);
}
