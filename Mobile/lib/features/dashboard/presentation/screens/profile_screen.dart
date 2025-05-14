import 'package:flutter/material.dart';
import 'package:versace/core/routing/routing_constants.dart';
import 'package:versace/core/routing/routing_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection_container.dart';
import '../../../../core/storage/storage_helper.dart';
import 'package:versace/features/dashboard/bloc/user_details/user_details_bloc.dart';
import 'package:versace/features/dashboard/bloc/user_details/user_details_event.dart';
import 'package:versace/features/dashboard/bloc/user_details/user_details_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final StorageHelper storageHelper;
  late final bool isLoggedIn;
  bool _dispatched = false;

  @override
  void initState() {
    super.initState();
    storageHelper = getIt<StorageHelper>();
    isLoggedIn = storageHelper.isLoggedIn;
    if (isLoggedIn) {
      // Avoid multiple dispatches
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_dispatched) {
          context.read<UserDetailsBloc>().add(const UserDetailsEvent.userDetailsRequested());
          _dispatched = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: isLoggedIn
            ? BlocBuilder<UserDetailsBloc, UserDetailsState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Text('Welcome!'),
                    loading: () => const CircularProgressIndicator(),
                    success: (user) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: 	${user.id}'),
                        Text('Email: 	${user.email}'),
                        Text('First Name: ${user.firstName}'),
                        Text('Last Name: ${user.lastName}'),
                        Text('Role: 	${user.role}'),
                        Text('Active: 	${user.isActive}'),
                        Text('Email Verified: ${user.isEmailVerified}'),
                      ],
                    ),
                    error: (msg) => ElevatedButton(
                onPressed: () {
                  context.navigateToAndRemoveUntil(RouteConstants.initial);
                },
                child: Text('Login'),
              ),
                  );
                },
              )
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
