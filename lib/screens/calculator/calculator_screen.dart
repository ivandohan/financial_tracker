import 'package:fin_trackr/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String userInput = '';
  String result = '0';

  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.ftScaffoldColor,
        iconTheme: const IconThemeData(
          color: AppColor.ftTextSecondaryColor,
        ),
        title: const Text(
          'Kalkulator',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColor.ftTextSecondaryColor,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              FlutterClipboard.copy(result);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.copy,
                    size: 15,
                    color: AppColor.ftTextQuinaryColor,
                  ),
                  SizedBox(width: 5,),
                  Text(
                      "Salin Hasil",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColor.ftTextQuinaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColor.ftScaffoldColor,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 340,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userInput,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColor.ftTextSecondaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      result,
                      style: const TextStyle(
                          fontSize: 30,
                          color: AppColor.ftTextSecondaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
              width: 330,
              child: Divider(
                thickness: 1,
                color: AppColor.ftLoadingSpinKitColor,
              ),
            ),
            Expanded(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: buttonList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CustomButtom(buttonList[index]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CustomButtom(String text) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: AppColor.ftScaffoldColor,
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.ftTextSecondaryColor.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  getColor(String text) {
    if (text == '/' ||
        text == '*' ||
        text == '+' ||
        text == '-' ||
        text == 'C' ||
        text == '(' ||
        text == ')') {
      return AppColor.ftTextPrimaryColor;
    }
    return AppColor.ftTextSecondaryColor;
  }

  getBgColor(String text) {
    if (text == 'AC') {
      return AppColor.ftTextPrimaryColor;
    }
    if (text == '=') {
      return Colors.grey[700];
    }
    return AppColor.ftAppBarColor;
  }

  handleButtons(String text) {
    if (text == 'AC') {
      userInput = '';
      result = '0';
      return;
    }
    if (text == 'C') {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    }

    if (text == '=') {
      result = calculate();
      userInput = result;

      if (userInput.endsWith('.0')) {
        userInput = userInput.replaceAll('.0', '');
      }

      if (result.endsWith('.0')) {
        result = result.replaceAll('.0', '');
        return;
      }
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "Error";
    }
  }
}
