import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:money_management/presentation/splash/screen_splash.dart';
import 'package:money_management/application/theme/theme_change.dart';
import 'package:money_management/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/add_transaction/screen_add_note_provider.dart';
import 'application/all_transaction/pie/view_transaction_all.dart';
import 'application/splash/splash_provider.dart';

final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool('is_dark') ?? false;
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDark),
        ),
        ChangeNotifierProvider(
          create: (context) => SplashProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ViewTransactionAllProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScreenAddNoteProvider(),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Money Management',
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          home: const ScreenSplash(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
