# TFARAJ Flutter V1

تحويل تطبيق TFARAJ PWA إلى Flutter مع الحفاظ على بنية المحتوى الأصلية.

## ما تم تحويله
- الرئيسية، الأنمي، الأفلام، المسلسلات، المفضلة.
- البحث الفوري.
- صفحة مشاهدة داخل WebView باستخدام رابط المشغل الموجود في المشروع الأصلي.
- المفضلة، المشاهدات المحلية، الوضع الداكن/الفاتح، اللغات، العملات ومانع الإعلانات.
- Firebase Auth للبريد وكلمة المرور.
- Firestore للمستخدمين والعملات والمشاهدات والإشعارات.
- شعار TFARAJ.

## تشغيل المشروع
1. ثبّت Flutter 3.x.
2. افتح المشروع.
3. نفّذ `flutter pub get`.
4. لأندرويد: أضف تطبيق Android داخل مشروع Firebase `tfaraj-app` ثم شغّل `flutterfire configure`، أو عدّل `lib/firebase_options.dart` وضع قيم Android الصحيحة.
5. فعّل Email/Password في Firebase Authentication.
6. أنشئ Collections في Firestore: `users`, `views`, `notifications`.
7. نفّذ `flutter run` ثم `flutter build apk --release`.

### ملاحظة البيانات
ملف `series.js` لم يكن ضمن الملفات المرفوعة، لذلك `seriesData` في هذه النسخة فارغة مؤقتاً. عند توفيره يمكن تحويله مباشرة إلى Dart.

### ملاحظة المشغل
النسخة الأصلية تفتح المشغل عبر `https://streamimdb.ru/embed/tv/{id}/`. تم الحفاظ على هذا السلوك في Flutter. تأكد من حقوق المحتوى ومصدر البث قبل النشر.
