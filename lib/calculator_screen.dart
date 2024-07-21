import 'package:calculator_v07212024/button_values.dart';
import 'package:calculator_v07212024/theme_colors.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
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
                    '0',
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
          onTap: () {},
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

  /// Get button color
  Color getButtonColor(value) {
    return [
      Btn.negOrPos,
      Btn.per,
      Btn.divide,
      Btn.multiply,
      Btn.subtract,
      Btn.add
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
      Btn.negOrPos,
      Btn.per,
      Btn.divide,
      Btn.multiply,
      Btn.subtract,
      Btn.add
    ].contains(value)
        ? kOprtrBtnTxtClr
        : [Btn.ac].contains(value)
            ? kAcBtnTxtClr
            : [Btn.equal].contains(value)
                ? kEqualBtnTxtClr
                : kNmbrBtnTxtClr;
  }
}
