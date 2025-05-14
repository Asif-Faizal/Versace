import 'package:flutter/material.dart';
import '../../../../core/routing/routing_arguments.dart';
class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key, required this.arguments});
  final VerifyOtpArguments arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
    );
  }
}
