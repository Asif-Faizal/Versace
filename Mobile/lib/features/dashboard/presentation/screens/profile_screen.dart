import 'package:flutter/material.dart';
import 'package:versace/core/routing/routing_constants.dart';
import 'package:versace/core/routing/routing_extension.dart';

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
          context.navigateToAndRemoveUntil(RouteConstants.initial);
        }, child: Text('Login')),
      ),
    );
  }
}
