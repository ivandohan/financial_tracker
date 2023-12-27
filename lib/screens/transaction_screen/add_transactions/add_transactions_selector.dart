import 'package:fin_trackr/constants/constant.dart';
import 'package:fin_trackr/db/functions/category_functions.dart';
import 'package:fin_trackr/models/transactions/transaction_model_db.dart';
import 'package:fin_trackr/screens/app_settings_screen/expense_category_settings/expense_category_list_view.dart';
import 'package:fin_trackr/screens/app_settings_screen/income_category_settings/income_category_list_view.dart';
import 'package:fin_trackr/screens/calculator/calculator_screen.dart';
import 'package:fin_trackr/screens/transaction_screen/add_transactions/add_expense_screen.dart';
import 'package:fin_trackr/screens/transaction_screen/add_transactions/add_income_screen.dart';
import 'package:fin_trackr/screens/transaction_screen/add_transactions/add_transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class TransactionScreenSelector extends StatefulWidget {
  const TransactionScreenSelector({super.key, this.tabIndex, this.model});

  @override
  State<TransactionScreenSelector> createState() =>
      _TransactionScreenSelector();
  final int? tabIndex;

  final TransactionModel? model;
}

const colors = [
  AppColor.ftIncomeColor,
  AppColor.ftExpenseColor,
  AppColor.ftTextIncomeColor2,
];

const List<String> tabBarText = ['Pemasukan', 'Pengeluaran', 'Transfer'];

class _TransactionScreenSelector extends State<TransactionScreenSelector>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    if (widget.tabIndex != null) {
      setState(() {
        _tabIndex = widget.tabIndex!;
        _tabController.index = widget.tabIndex!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.getAllCategory();
    final double screenWidth = MediaQuery.of(context).size.width;

    double fontSize = 9;

    if (screenWidth > 350) {
      fontSize = 16;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.ftScaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColor.ftScaffoldColor,
        iconTheme: const IconThemeData(
            color: AppColor.ftTextSecondaryColor,
        ),
        title: Title(
          color: AppColor.ftTextSecondaryColor,
          child: Text(
            tabBarText[_tabIndex],
            style: const TextStyle(fontSize: 18, color: AppColor.ftTextSecondaryColor),
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_tabIndex == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IncomeCategoryList(),
                      ),
                    );
                  } else if (_tabIndex == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpenseCategoryList(),
                      ),
                    );
                  } else if (_tabIndex == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IncomeCategoryList(),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.add_to_photos_outlined,
                  size: 18,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalculatorScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Ionicons.calculator,
                  size: 18,
                ),
              ),
            ],
          )
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: AppColor.ftScaffoldColor,
            height: 50,
            child: TabBar(
              indicatorColor: Colors.transparent,
              padding:
                  const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 10),
              controller: _tabController,
              labelStyle: TextStyle(fontSize: fontSize),
              indicatorSize: TabBarIndicatorSize.label,
              splashFactory: NoSplash.splashFactory,
              onTap: (value) {
                if (widget.model != null) {
                  _tabController.index = widget.tabIndex!;
                  return;
                }
                _tabIndex = value;
                setState(() {});
              },
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: colors[_tabIndex],
              ),
              tabs: [
                Tab(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColor.ftIncomeColor,
                        width: 1,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        tabBarText[0],
                        style: const TextStyle(
                          color: AppColor.ftTextSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColor.ftExpenseColor,
                        width: 1,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        tabBarText[1],
                        style: const TextStyle(
                          color: AppColor.ftTextSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColor.ftTextIncomeColor2,
                        width: 1,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        tabBarText[2],
                        style: const TextStyle(
                          color: AppColor.ftTextSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Navigator(
        key: _navKey,
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              AddIncomeScreen(modelFromTransaction: widget.model),
              AddExpenseScreen(modelFromTransaction: widget.model),
              const AddTransferScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
