import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'features/expense_manager/data/datasources/expense_local_datasource.dart';
import 'features/expense_manager/data/repositories/expense_repository_impl.dart';
import 'features/expense_manager/domain/usecases/add_expense.dart';
import 'features/expense_manager/domain/usecases/delete_expense.dart';
import 'features/expense_manager/domain/usecases/get_expenses.dart';
import 'features/expense_manager/domain/usecases/update_expense.dart';
import 'features/expense_manager/presentation/pages/category_management_screen.dart';
import 'features/expense_manager/presentation/pages/home_screen.dart';
import 'features/expense_manager/presentation/pages/tag_management_screen.dart';
import 'features/expense_manager/presentation/provider/expense_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalStorage();
  final storage = localStorage;

  final localDataSource = ExpenseLocalDataSourceImpl(storage: storage);
  final repo = ExpenseRepositoryImpl(localDataSource: localDataSource);

  final getExpensesUC = GetExpenses(repo);
  final addExpenseUC = AddExpense(repo);
  final updateExpenseUC = UpdateExpense(repo);
  final deleteExpenseUC = DeleteExpense(repo);

  runApp(
    MyApp(
      getExpensesUC: getExpensesUC,
      addExpenseUC: addExpenseUC,
      updateExpenseUC: updateExpenseUC,
      deleteExpenseUC: deleteExpenseUC,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetExpenses getExpensesUC;
  final AddExpense addExpenseUC;
  final UpdateExpense updateExpenseUC;
  final DeleteExpense deleteExpenseUC;

  const MyApp({
    super.key,
    required this.getExpensesUC,
    required this.addExpenseUC,
    required this.updateExpenseUC,
    required this.deleteExpenseUC,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => ExpenseProvider(
                getExpensesUC: getExpensesUC,
                addExpenseUC: addExpenseUC,
                updateExpenseUC: updateExpenseUC,
                deleteExpenseUC: deleteExpenseUC,
              ),
        ),
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
