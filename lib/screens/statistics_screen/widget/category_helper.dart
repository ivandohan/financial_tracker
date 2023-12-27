import 'package:fin_trackr/constants/constant.dart';
import 'package:fin_trackr/db/functions/transaction_function.dart';
import 'package:fin_trackr/models/transactions/transaction_model_db.dart';
import 'package:flutter/material.dart';

class CategoryFilter {
  void showPopupMenu1(BuildContext context) async {
    await showMenu(
      color: AppColor.ftAppBarColor,
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 10, 10),
      items: [
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filter('Pemasukan');
              TransactionDB.instance.filterByDate(
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day - 30),
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day));
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
              TransactionDB.instance.filterByDate(
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day - 30),
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day));
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
              TransactionDB.instance.filterByDate(
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day - 30),
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day));
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
              'Minggu Ini',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondaryColor),
            )),
        PopupMenuItem(
          onTap: () async {
            var daterange = DateTimeRange(
              start: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day - 30),
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
