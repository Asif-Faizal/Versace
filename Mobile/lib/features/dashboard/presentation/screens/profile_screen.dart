import 'package:flutter/material.dart';
import 'package:versace/core/routing/routing_constants.dart';
import 'package:versace/core/routing/routing_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/features/register/bloc/email_verification/email_verification_bloc.dart';

import '../../../../core/injection/injection_container.dart';
import '../../../../core/routing/routing_arguments.dart';
import '../../../../core/storage/storage_helper.dart';
import 'package:versace/features/dashboard/bloc/user_details/user_details_bloc.dart';
import 'package:versace/features/dashboard/bloc/user_details/user_details_event.dart';
import 'package:versace/features/dashboard/bloc/user_details/user_details_state.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../../core/widgets/loading_snackbar.dart';
import '../../../../core/widgets/success_snackbar.dart';
import '../../../register/bloc/email_verification/email_verification_event.dart';
import '../../../register/bloc/email_verification/email_verification_state.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../../cubit/bottom_nav_state.dart';
import 'package:versace/features/dashboard/presentation/screens/dashboard_screen.dart';

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
          context.read<UserDetailsBloc>().add(
            const UserDetailsEvent.userDetailsRequested(),
          );
          _dispatched = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserDetailsBloc, UserDetailsState>(
            listener: (context, state) {
              state.maybeWhen(
                logoutSuccess: () {
                  StorageHelper storageHelper = getIt<StorageHelper>();
                  storageHelper.clearAuthData();
                  showSuccessSnackBar(context, 'Logged out successfully');
                  context.navigateToAndRemoveUntil(RouteConstants.initial);
                },
                logoutFailure: (message) {
                  showErrorSnackBar(context, message);
                },
                orElse: () {},
              );
            },
          ),
          BlocListener<EmailVerificationBloc, EmailVerificationState>(
            listener: (context, state) {
              state.maybeWhen(
                loading: () {
                  showLoadingSnackBar(context, 'Sending OTP...');
                },
                otpSent: (message) {
                  final userState = context.read<UserDetailsBloc>().state;
                  String? email;
                  userState.maybeWhen(
                    success: (user) => email = user.email,
                    orElse: () {},
                  );
                  if (email != null) {
                    context.navigateTo(RouteConstants.verifyOtp, arguments: VerifyOtpArguments(email: email!));
                  }
                },
                error: (message) {
                  showErrorSnackBar(context, message);
                },
                orElse: () {},
              );
            },
          ),
        ],
        child: Center(
          child:
              isLoggedIn
                  ? BlocBuilder<UserDetailsBloc, UserDetailsState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        initial: () => const Text('Welcome!'),
                        loading: () => const CircularProgressIndicator(),
                        success:
                            (user) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 60,
                                            child: Text(
                                              user.firstName[0].toUpperCase() +
                                                  user.lastName[0]
                                                      .toUpperCase(),
                                              style: textTheme.displayMedium
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 7,
                                            bottom: 7,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.add_a_photo,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.firstName +
                                                ' ' +
                                                user.lastName,
                                            style: textTheme.titleLarge,
                                          ),
                                          Text(
                                            user.email,
                                            style: textTheme.bodyMedium,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              context
                                                  .read<EmailVerificationBloc>()
                                                  .add(
                                                    EmailVerificationEvent.sendOtpRequested(
                                                      email: user.email,
                                                    ),
                                                  );
                                            },
                                            child: Chip(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              label: Text(
                                                user.isEmailVerified
                                                    ? 'Verified'
                                                    : 'Not Verified',
                                                style: textTheme.labelSmall,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            final editProfileArgs =
                                                EditProfileArguments(
                                                  firstName: user.firstName,
                                                  lastName: user.lastName,
                                                );

                                            // Pass the arguments via the dashboard screen
                                            final dashboardWidget =
                                                context
                                                    .findAncestorWidgetOfExactType<
                                                      DashboardScreen
                                                    >();
                                            if (dashboardWidget != null) {
                                              // Store the arguments
                                              if (getIt
                                                  .isRegistered<
                                                    EditProfileArguments
                                                  >()) {
                                                getIt
                                                    .unregister<
                                                      EditProfileArguments
                                                    >();
                                              }
                                              getIt.registerSingleton<
                                                EditProfileArguments
                                              >(editProfileArgs);
                                            }

                                            // Navigate to edit profile
                                            context.read<BottomNavCubit>().select(
                                              const BottomNavState.editProfile(),
                                            );
                                          },
                                          title: Text('Edit Profile'),
                                          trailing: Icon(Icons.person),
                                        ),
                                        ListTile(
                                          title: Text('Change Password'),
                                          trailing: Icon(Icons.lock),
                                        ),
                                        ListTile(
                                          title: Text('Order History'),
                                          trailing: Icon(Icons.history),
                                        ),
                                        ListTile(
                                          title: Text('Address Book'),
                                          trailing: Icon(Icons.book),
                                        ),
                                        ListTile(
                                          title: Text('Notifications'),
                                          trailing: Icon(Icons.notifications),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            context.read<UserDetailsBloc>().add(
                                              const UserDetailsEvent.logoutRequested(),
                                            );
                                          },
                                          title: Text('Logout'),
                                          trailing: Icon(Icons.logout),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            final deleteAccountArgs =
                                                DeleteAccountArguments(
                                                  email: user.email,
                                                );

                                            // Pass the arguments via the dashboard screen
                                            final dashboardWidget =
                                                context
                                                    .findAncestorWidgetOfExactType<
                                                      DashboardScreen
                                                    >();
                                            if (dashboardWidget != null) {
                                              // Store the arguments
                                              if (getIt
                                                  .isRegistered<
                                                    DeleteAccountArguments
                                                  >()) {
                                                getIt
                                                    .unregister<
                                                      DeleteAccountArguments
                                                    >();
                                              }
                                              getIt.registerSingleton<
                                                DeleteAccountArguments
                                              >(deleteAccountArgs);
                                            }

                                            // Navigate to edit profile
                                            context.read<BottomNavCubit>().select(
                                              const BottomNavState.deleteAccount(),
                                            );
                                          },
                                          title: Text('Delete Account'),
                                          trailing: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        error:
                            (msg) => ElevatedButton(
                              onPressed: () {
                                context.navigateToAndRemoveUntil(
                                  RouteConstants.initial,
                                );
                              },
                              child: Text('Login'),
                            ),
                        orElse: () => const SizedBox.shrink(),
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
      ),
    );
  }
}
