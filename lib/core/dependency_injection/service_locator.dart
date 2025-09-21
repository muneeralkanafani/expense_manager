import 'package:get_it/get_it.dart';
import 'package:localstorage/localstorage.dart';

import '../../features/expense_manager/data/datasources/category_local_data_source.dart';
import '../../features/expense_manager/data/datasources/expense_local_data_source.dart';
import '../../features/expense_manager/data/datasources/tag_local_data_source.dart';
import '../../features/expense_manager/data/repositories/expense_repository_impl.dart';
import '../../features/expense_manager/domain/usecases/add_category.dart';
import '../../features/expense_manager/domain/usecases/add_expense.dart';
import '../../features/expense_manager/domain/usecases/add_tag.dart';
import '../../features/expense_manager/domain/usecases/delete_category.dart';
import '../../features/expense_manager/domain/usecases/delete_expense.dart';
import '../../features/expense_manager/domain/usecases/delete_tag.dart';
import '../../features/expense_manager/domain/usecases/get_categories.dart';
import '../../features/expense_manager/domain/usecases/get_expenses.dart';
import '../../features/expense_manager/domain/usecases/get_tags.dart';
import '../../features/expense_manager/domain/usecases/update_expense.dart';
import '../../features/expense_manager/presentation/providers/category_provider.dart';
import '../../features/expense_manager/presentation/providers/expense_provider.dart';
import '../../features/expense_manager/presentation/providers/tag_provider.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  await initLocalStorage();
  final storage = localStorage;

  //! Data sources
  getIt.registerLazySingleton<ExpenseLocalDataSource>(
      () => ExpenseLocalDataSourceImpl(storage: storage));
  getIt.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl(storage: storage));
  getIt.registerLazySingleton<TagLocalDataSource>(
      () => TagLocalDataSourceImpl(storage: storage));

  //! Repository
  getIt.registerLazySingleton<ExpenseRepositoryImpl>(
      () => ExpenseRepositoryImpl(
            expenseLocalDataSource: getIt<ExpenseLocalDataSource>(),
            categoryLocalDataSource: getIt<CategoryLocalDataSource>(),
            tagLocalDataSource: getIt<TagLocalDataSource>(),
          ));

  //! Use cases
  getIt.registerLazySingleton(() => GetExpenses(getIt<ExpenseRepositoryImpl>()));
  getIt.registerLazySingleton(() => AddExpense(getIt<ExpenseRepositoryImpl>()));
  getIt.registerLazySingleton(() => UpdateExpense(getIt<ExpenseRepositoryImpl>()));
  getIt.registerLazySingleton(() => DeleteExpense(getIt<ExpenseRepositoryImpl>()));

  getIt.registerLazySingleton(() => GetCategories(getIt<ExpenseRepositoryImpl>()));
  getIt.registerLazySingleton(() => AddCategory(getIt<ExpenseRepositoryImpl>()));
  getIt.registerLazySingleton(() => DeleteCategory(getIt<ExpenseRepositoryImpl>()));

  getIt.registerLazySingleton(() => GetTags(getIt<ExpenseRepositoryImpl>()));
  getIt.registerLazySingleton(() => AddTag(getIt<ExpenseRepositoryImpl>()));
  getIt.registerLazySingleton(() => DeleteTag(getIt<ExpenseRepositoryImpl>()));

  //! Providers
  getIt.registerFactory(
    () => ExpenseProvider(
      getExpensesUC: getIt<GetExpenses>(),
      addExpenseUC: getIt<AddExpense>(),
      updateExpenseUC: getIt<UpdateExpense>(),
      deleteExpenseUC: getIt<DeleteExpense>(),
    ),
  );

  getIt.registerFactory(
    () => CategoryProvider(
      getCategoriesUC: getIt<GetCategories>(),
      addCategoryUC: getIt<AddCategory>(),
      deleteCategoryUC: getIt<DeleteCategory>(),
    ),
  );

  getIt.registerFactory(
    () => TagProvider(
      getTagsUC: getIt<GetTags>(),
      addTagUC: getIt<AddTag>(),
      deleteTagUC: getIt<DeleteTag>(),
    ),
  );
}

