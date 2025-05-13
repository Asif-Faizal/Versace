import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class OtpBottomSheet extends StatefulWidget {
  final int numberOfFields;
  final Function(String) onVerifyTap;
  final bool useAlternateTheme;
  final String title;
  final String subTitle;
  final String buttonText;
  final String mobile;
  final bool showResendButton;
  final bool obscureText;
  const OtpBottomSheet({
    super.key,
    this.numberOfFields = 6,
    required this.onVerifyTap,
    this.useAlternateTheme = false,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.mobile,
    this.showResendButton = true,
    this.obscureText = false,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  late final List<FocusNode> focusNodes;
  late final List<TextEditingController> controllers;
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    // Initialize focus nodes and controllers
    focusNodes = List.generate(widget.numberOfFields, (_) => FocusNode());
    controllers =
        List.generate(widget.numberOfFields, (_) => TextEditingController());
    // Start the timer
    startTimer();
    // Add this to focus on first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  void startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    // Clean up focus nodes and controllers
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    _timer?.cancel(); // Cancel timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: textTheme.displaySmall,
          ),
          // const SizedBox(height: 10),
          Text(
            widget.subTitle,
            style: textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              widget.numberOfFields,
              (index) => SizedBox(
                width: 50,
                child: TextFormField(
                  obscureText: widget.obscureText,
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: textTheme.titleMedium,
                  decoration: InputDecoration(
                    counterText: '',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      // Move to next field
                      if (index < widget.numberOfFields - 1) {
                        focusNodes[index + 1].requestFocus();
                      }
                    } else {
                      // If value is empty and we're not at the first field, move to previous field
                      if (index > 0) {
                        focusNodes[index - 1].requestFocus();
                        controllers[index - 1].selection = TextSelection.fromPosition(
                          TextPosition(offset: controllers[index - 1].text.length),
                        );
                      }
                    }
                  },
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isEmpty && oldValue.text.isEmpty && index > 0) {
                        // Move to previous field on backspace when current field is empty
                        focusNodes[index - 1].requestFocus();
                      }
                      return newValue;
                    }),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (widget.showResendButton)
          TextButton(
            onPressed: _canResend
                ? () {
                  }
                : null,
            child: Text(
              _canResend
                  ? "Resend OTP"
                  : "Resend OTP in $_secondsRemaining seconds",
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(onPressed: (){}, child: Text(widget.buttonText))
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}