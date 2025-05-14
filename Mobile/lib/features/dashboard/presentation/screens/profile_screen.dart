import 'package:flutter/material.dart';
import 'package:versace/core/routing/routing_constants.dart';
import 'package:versace/core/routing/routing_extension.dart';

import '../../../../core/injection/injection_container.dart';
import '../../../../core/storage/storage_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final isLoggedIn = storageHelper.isLoggedIn;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child:
            isLoggedIn
                ? Text(isLoggedIn.toString())
                : ElevatedButton(
                  onPressed: () {
                    context.navigateToAndRemoveUntil(RouteConstants.initial);
                  },
                  child: Text('Login'),
                ),
      ),
    );
  }
}
