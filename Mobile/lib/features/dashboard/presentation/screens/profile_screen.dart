import 'package:flutter/material.dart';
import 'package:versace/core/routing/routing_constants.dart';
import 'package:versace/core/routing/routing_extension.dart';

import '../../../../core/routing/routing_arguments.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          context.navigateToAndRemoveUntil(RouteConstants.verifyOtp, arguments: VerifyOtpArguments(email: 'test@test.com'));
        }, child: Text('Login')),
      ),
    );
  }
}
