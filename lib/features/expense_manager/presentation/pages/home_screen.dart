import 'package:flutter/material.dart';

import '../widgets/add_expense_button.dart';
import '../widgets/expense_list_by_category.dart';
import '../widgets/expense_list_by_date.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(tabController: _tabController),
      drawer: const HomeDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [ExpenseListByDate(), ExpenseListByCategory()],
      ),
      floatingActionButton: const AddExpenseButton(),
    );
  }
}
