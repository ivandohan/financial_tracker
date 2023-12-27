import 'package:fin_trackr/constants/constant.dart';
import 'package:fin_trackr/screens/transaction_screen/add_transactions/add_transactions_selector.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFloatingActionButton extends StatelessWidget {
  CustomFloatingActionButton({super.key, required this.index});

  int index;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onPressed: () {
        if (index == 0) {
          // print('transaction');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TransactionScreenSelector()));
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      backgroundColor: AppColor.ftFloatingButton,
      child: const Icon(
        Icons.add,
        color: AppColor.ftTextSecondaryColor,
      ),
    );
  }
}
