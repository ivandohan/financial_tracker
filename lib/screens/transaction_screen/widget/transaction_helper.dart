import 'dart:io';

import 'package:fin_trackr/constants/constant.dart';
import 'package:fin_trackr/db/functions/currency_function.dart';
import 'package:fin_trackr/db/functions/transaction_function.dart';
import 'package:fin_trackr/models/category/category_model_db.dart';
import 'package:fin_trackr/models/transactions/transaction_model_db.dart';
import 'package:fin_trackr/screens/accounts_screen/balance_calculation.dart';
import 'package:fin_trackr/screens/transaction_screen/add_transactions/add_transactions_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDate {
  selectePreviousMonth() {
    DateTimeRange selectedDate = DateTimeRange(
      start: DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
      end: DateTime(DateTime.now().year, DateTime.now().month, 0),
    );
    return selectedDate;
  }

  selectNextMonth() {
    DateTimeRange selectedDate = DateTimeRange(
      start: DateTime(DateTime.now().year, DateTime.now().month, 1),
      end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    );
    return selectedDate;
  }

  currentDateForCalenderSelection() {
    var dateRange = DateTimeRange(
      start: DateTime(DateTime.now().year, DateTime.now().month),
      end: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );

    return dateRange;
  }

  Map<String, List<TransactionModel>> sortByDate(
      List<TransactionModel> models) {
    Map<String, List<TransactionModel>> mapList = {};
    for (TransactionModel model in models) {
      if (!mapList.containsKey(model.date)) {
        mapList[model.date] = [];
      }
      mapList[model.date]!.add(model);
    }
    return mapList;
  }
}

class FilterFunction {
  void showPopupMenu1(BuildContext context) async {
    await showMenu(
      color: AppColor.ftAppBarColor,
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 10, 10),
      items: [
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filter('Semua');
              TransactionDB.instance.refresh();
            },
            child: const Text(
              'Semua',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondaryColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filter('Pemasukan');
            },
            child: const Text(
              'Pemasukan',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondaryColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filter('Pengeluaran');
            },
            child: const Text(
              'Pengeluaran',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondaryColor),
            )),
      ],
      elevation: 8.0,
    );
  }

  void showPopupMenu2(BuildContext context) async {
    await showMenu(
      color: AppColor.ftAppBarColor,
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 10, 10),
      items: [
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filterDataByDate('semua');
            },
            child: const Text(
              'Semua',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondaryColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filterDataByDate('hari-ini');
            },
            child: const Text(
              'Hari ini',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondaryColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filterDataByDate('kemarin');
            },
            child: const Text(
              'Kemarin',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondaryColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filterDataByDate('minggu-ini');
            },
            child: const Text(
              'Minggu ini',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondaryColor),
            )),
        PopupMenuItem(
          onTap: () async {
            var daterange = DateTimeRange(
              start: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day - 7),
              end: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day),
            );
            DateTimeRange? picked = await showDateRangePicker(
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                            onPrimary: AppColor.ftAppBarColor,
                            onSurface: AppColor.ftTextSecondaryColor,
                            primary: AppColor.ftTextTertiaryColor),
                        dialogBackgroundColor: AppColor.ftAppBarColor),
                    child: child!,
                  );
                },
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime.now(),
                initialDateRange: daterange);
            if (picked != null) {
              TransactionDB.instance.filterByDate(picked.start, picked.end);
            }
          },
          child: const Text(
            'Atur Waktu',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.ftTextSecondaryColor),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}

class TransactionsCategory extends StatefulWidget {
  const TransactionsCategory({
    required this.newList,
    super.key,
  });

  final List<TransactionModel> newList;

  @override
  State<TransactionsCategory> createState() => _TransactionsCategoryState();
}

class _TransactionsCategoryState extends State<TransactionsCategory> {
  final NumberFormat formatter = NumberFormat('#,##0.00');

  bool screenExpand = false;
  @override
  Widget build(BuildContext context) {
    balanceAmount();
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.newList.length,
      itemBuilder: (context, index) {
        final data = widget.newList[index];
        return GestureDetector(
          onTap: () {
            if (screenExpand == false) {
              setState(() {
                screenExpand = true;
              });
            } else if (screenExpand == true) {
              setState(() {
                screenExpand = false;
              });
            }
          },
          onLongPress: () {
            int tabIndex = 2;
            if (data.categoryType == CategoryType.income) {
              tabIndex = 0;
            } else if (data.categoryType == CategoryType.expense) {
              tabIndex = 1;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TransactionScreenSelector(tabIndex: tabIndex, model: data),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          data.category.name,
                          style: const TextStyle(
                            color: AppColor.ftTextTertiaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                          data.account.name == "cash" ?
                              "Uang Cash" : "Rekening",
                        style: const TextStyle(
                          color: AppColor.ftTextTertiaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        data.categoryType == CategoryType.income
                            ? '+ ${currencySymbolUpdate.value} ${formatter.format(data.amount)}'
                            : '- ${currencySymbolUpdate.value} ${formatter.format(data.amount)}',
                        style: const TextStyle(
                          color: AppColor.ftTextTertiaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                screenExpand == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Catatan : ${data.note}',
                                style: const TextStyle(
                                  color: AppColor.ftTextTertiaryColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                              ),
                              margin: const EdgeInsets.only(top: 5),
                              child: data.image != null
                                  ? Image.file(
                                      File(data.image.toString()),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width:
                                          MediaQuery.of(context).size.width * 2,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const Divider(
                              color: AppColor.ftSecondaryDividerColor,
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
