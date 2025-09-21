import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const HomeAppBar({super.key, required this.tabController});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Expense Tracker"),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      bottom: TabBar(
        controller: tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [Tab(text: "By Date"), Tab(text: "By Category")],
      ),
    );
  }
}
