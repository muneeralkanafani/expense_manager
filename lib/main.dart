import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/dependency_injection/service_locator.dart';
import 'features/expense_manager/presentation/pages/category_management_screen.dart';
import 'features/expense_manager/presentation/pages/home_screen.dart';
import 'features/expense_manager/presentation/pages/tag_management_screen.dart';
import 'features/expense_manager/presentation/providers/category_provider.dart';
import 'features/expense_manager/presentation/providers/expense_provider.dart';
import 'features/expense_manager/presentation/providers/tag_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<ExpenseProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CategoryProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<TagProvider>()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/manage_categories': (context) => CategoryManagementScreen(),
          '/manage_tags': (context) => TagManagementScreen(),
        },
      ),
    );
  }
}
