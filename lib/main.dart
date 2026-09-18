import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'services/firebase_service.dart';
import 'services/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const TfarajApp());
}

class TfarajApp extends StatefulWidget {
  const TfarajApp({super.key});
  @override State<TfarajApp> createState() => _TfarajAppState();
}

class _TfarajAppState extends State<TfarajApp> {
  final store = LocalStore();
  ThemeMode mode = ThemeMode.dark;
  String language = 'ar';

  @override
  void initState() { super.initState(); _loadSettings(); }

  Future<void> _loadSettings() async {
    final theme = await store.getTheme();
    final lang = await store.getLanguage();
    if (!mounted) return;
    setState(() { mode = theme == 'light' ? ThemeMode.light : ThemeMode.dark; language = lang; });
  }

  @override
  Widget build(BuildContext context) {
    final dark = ThemeData.dark(useMaterial3: true);
    final light = ThemeData.light(useMaterial3: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFARAJ',
      locale: Locale(language),
      themeMode: mode,
      theme: light.copyWith(
        scaffoldBackgroundColor: const Color(0xfff4f4f7),
        textTheme: GoogleFonts.tajawalTextTheme(light.textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe31b23)),
      ),
      darkTheme: dark.copyWith(
        scaffoldBackgroundColor: const Color(0xff0b0b0f),
        textTheme: GoogleFonts.tajawalTextTheme(dark.textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe31b23), brightness: Brightness.dark),
      ),
      home: HomeScreen(
        language: language,
        mode: mode,
        onThemeChanged: (isDark) async { await store.setTheme(isDark ? 'dark' : 'light'); setState(() => mode = isDark ? ThemeMode.dark : ThemeMode.light); },
        onLanguageChanged: (lang) async { await store.setLanguage(lang); setState(() => language = lang); },
      ),
    );
  }
}
