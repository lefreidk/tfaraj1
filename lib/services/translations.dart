class T {
  static const Map<String, Map<String, String>> data = {
    'ar': {
      'subtitle': 'عالمك السينمائي', 'search': 'ابحث عن فيلم أو مسلسل...',
      'mostViewed': '🔥 الأكثر مشاهدة', 'latest': '🆕 أحدث الإضافات', 'anime': '🎎 الأنمي',
      'movies': '🎬 الأفلام السينمائية', 'series': '📺 المسلسلات التلفزيونية', 'favorites': '❤️ قائمتي المفضلة',
      'notifications': '🔔 الإشعارات', 'settings': '⚙️ الإعدادات', 'dark': 'الوضع الداكن',
      'adBlock': 'مانع الإعلانات والنوافذ المنبثقة', 'language': 'لغة التطبيق', 'about': 'حول التطبيق',
      'aboutDesc': 'تطبيق عصري لمشاهدة المحتوى السينمائي بدقة عالية وسرعة فائقة.', 'credit': 'برمجة وتصميم',
      'balance': 'رصيدك الحالي', 'useCoins': '🛒 استخدام العملات', 'noResults': 'لا توجد نتائج مطابقة لبحثك.',
      'noFavorites': 'لم تقم بإضافة أي محتوى لمفضلتك بعد.', 'noViews': 'لم يتم مشاهدة أي محتوى بعد.',
      'addFav': 'إضافة إلى المفضلة', 'inFav': 'في مفضلتي', 'privacy': 'سياسة الخصوصية',
      'login': 'تسجيل الدخول', 'logout': 'تسجيل الخروج', 'account': 'إعدادات الحساب',
    },
    'en': {
      'subtitle': 'Your Cinematic World', 'search': 'Search movies or series...', 'mostViewed': '🔥 Most Viewed',
      'latest': '🆕 Latest Additions', 'anime': '🎎 Anime', 'movies': '🎬 Movies', 'series': '📺 TV Series',
      'favorites': '❤️ My Favorites', 'notifications': '🔔 Notifications', 'settings': '⚙️ Settings',
      'dark': 'Dark Mode', 'adBlock': 'Ad Blocker & Popups', 'language': 'App Language', 'about': 'About',
      'aboutDesc': 'A modern app for watching cinematic content in high quality and fast speed.',
      'credit': 'Developed & Designed by', 'balance': 'Your Balance', 'useCoins': '🛒 Use Coins',
      'noResults': 'No results found.', 'noFavorites': 'You haven\'t added any favorites yet.',
      'noViews': 'No content watched yet.', 'addFav': 'Add to Favorites', 'inFav': 'In Favorites',
      'privacy': 'Privacy Policy', 'login': 'Sign in', 'logout': 'Sign out', 'account': 'Account settings',
    },
    'fr': {
      'subtitle': 'Votre monde cinématographique', 'search': 'Rechercher un film ou une série...',
      'mostViewed': '🔥 Les plus vus', 'latest': '🆕 Ajouts récents', 'anime': '🎎 Anime', 'movies': '🎬 Films',
      'series': '📺 Séries TV', 'favorites': '❤️ Mes favoris', 'notifications': '🔔 Notifications', 'settings': '⚙️ Paramètres',
      'dark': 'Mode sombre', 'adBlock': 'Bloqueur de publicités', 'language': 'Langue', 'about': 'À propos',
      'aboutDesc': 'Une application moderne pour regarder du contenu cinématographique.', 'credit': 'Développé et conçu par',
      'balance': 'Votre solde', 'useCoins': '🛒 Utiliser les pièces', 'noResults': 'Aucun résultat.',
      'noFavorites': 'Aucun favori.', 'noViews': 'Aucun contenu regardé.', 'addFav': 'Ajouter aux favoris',
      'inFav': 'Dans mes favoris', 'privacy': 'Politique de confidentialité', 'login': 'Connexion', 'logout': 'Déconnexion',
      'account': 'Paramètres du compte',
    },
  };

  static String get(String lang, String key) => data[lang]?[key] ?? data['ar']![key] ?? key;
}
