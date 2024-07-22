import 'package:calculator_v07212024/button_values.dart';
import 'package:calculator_v07212024/theme_colors.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ''; // ., 0-9
  String operator = ''; // +, -, x, /
  String number2 = ''; // ., 0-9

  @override
  Widget build(BuildContext context) {
    /// Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Set result display text size as a fraction of the screen height
    double rsltDsplyTxtSize = screenHeight * 0.06;

    // Set button text size as a fraction of the screen height
    double btnTxtSize = screenHeight * 0.03;

    return Scaffold(
      backgroundColor: kBckgrndClr,
      body: SafeArea(
        child: Column(
          children: [
            /// Result display
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '$number1$operator$number2'.isEmpty
                        ? '0'
                        : '$number1$operator$number2',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: kRsltTxtClr,
                      fontSize: rsltDsplyTxtSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            /// Divider
            const Divider(
              indent: 12.0,
              endIndent: 12.0,
              color: kDividerClr,
            ),

            /// Button pad
            Container(
              height: screenHeight * 0.6,
              padding:
                  const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
              child: Wrap(
                children: Btn.buttonValues
                    .map(
                      (value) => SizedBox(
                        width: (screenWidth - 16) / 4,
                        height: ((screenHeight * 0.6) - 8) / 5,
                        child: buildButton(value, btnTxtSize),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Button
  Widget buildButton(String value, double btnTxtSize) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide.none,
        ),
        child: InkWell(
          onTap: () => onButtonTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: getButtonTextColor(value),
                fontSize: btnTxtSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// On button tap method
  void onButtonTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.ac) {
      clearAll();
      return;
    }

    if (value == Btn.adna) {
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.equal) {
      calculate();
      return;
    }

    appendValue(value);
  }

  /// Calculates the result
  void calculate() {
    if (number1.isEmpty) return;
    if (operator.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operator) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = result.toString();

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operator = "";
      number2 = "";
    });
  }

  /// Converts output to %
  void convertToPercentage() {
    // ex: 434+324
    if (number1.isNotEmpty && operator.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operator.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operator = "";
      number2 = "";
    });
  }

  /// Clears all output
  void clearAll() {
    setState(() {
      number1 = "";
      operator = "";
      number2 = "";
    });
  }

  /// Delete one from the end
  void delete() {
    if (number2.isNotEmpty) {
      // 12323 => 1232
      number2 = number2.substring(0, number2.length - 1);
    } else if (operator.isNotEmpty) {
      operator = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  /// Appends value to the end
  void appendValue(String value) {
    // number1 operator number2
    // 234       +      5343

    // if is operator and not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      // operator pressed
      if (operator.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operator = value;
    }
    // assign value to number1 variable
    else if (number1.isEmpty || operator.isEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        // ex: number1 = "" | "0"
        value = "0.";
      }
      number1 += value;
    }
    // assign value to number2 variable
    else if (number2.isEmpty || operator.isNotEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        // number1 = "" | "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  /// Get button color
  Color getButtonColor(value) {
    return [
      Btn.adna,
      Btn.per,
      Btn.divide,
      Btn.multiply,
      Btn.subtract,
      Btn.add,
    ].contains(value)
        ? kOprtrBtnClr
        : [Btn.ac].contains(value)
            ? kAcBtnClr
            : [Btn.equal].contains(value)
                ? kEqualBtnClr
                : kNmbrBtnClr;
  }

  /// Get button text color
  Color getButtonTextColor(value) {
    return [
      Btn.adna,
      Btn.per,
      Btn.divide,
      Btn.multiply,
      Btn.subtract,
      Btn.add,
    ].contains(value)
        ? kOprtrBtnTxtClr
        : [Btn.ac].contains(value)
            ? kAcBtnTxtClr
            : [Btn.equal].contains(value)
                ? kEqualBtnTxtClr
                : kNmbrBtnTxtClr;
  }
}
