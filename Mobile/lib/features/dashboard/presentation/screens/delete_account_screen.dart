import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/core/routing/routing_extension.dart';
import 'package:versace/core/storage/storage_helper.dart';

import '../../../../core/injection/injection_container.dart';
import '../../../../core/routing/routing_arguments.dart';
import '../../../../core/routing/routing_constants.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../bloc/user_details/user_details_bloc.dart';
import '../../bloc/user_details/user_details_event.dart';
import '../../bloc/user_details/user_details_state.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../../cubit/bottom_nav_state.dart';
import '../../../dashboard/cubit/password_visibility_delete_account_cubit.dart';
import '../../../dashboard/cubit/password_visibility_delete_account_state.dart';

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key, required this.arguments});
  final DeleteAccountArguments arguments;
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.read<BottomNavCubit>().select(const BottomNavState.profile());
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocProvider(
          create: (_) => PasswordVisibilityDeleteAccountCubit(),
          child: BlocListener<UserDetailsBloc, UserDetailsState>(
            listener: (context, state) {
              state.maybeWhen(
                deleteAccountSuccess: () {
                  StorageHelper storageHelper = getIt<StorageHelper>();
                  storageHelper.clearAuthData();
                  context.navigateToAndRemoveUntil(RouteConstants.initial);
                },
                deleteAccountFailure: (error) {
                  showErrorSnackBar(context, error);
                },
                orElse: () {},
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delete Account', style: textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Text(
                      'Please enter the password to delete your account',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<PasswordVisibilityDeleteAccountCubit, PasswordVisibilityDeleteAccountState>(
                      builder: (context, state) {
                        return TextFormField(
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !state.isPasswordVisible,
                          decoration: InputDecoration(
                            counterText: '',
                            suffixIcon: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide.none
                                  ),
                                ),
                              onPressed: () {
                                context.read<PasswordVisibilityDeleteAccountCubit>().togglePasswordVisibility();
                              },
                              icon: Icon(
                                state.isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return '';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<UserDetailsBloc>().add(
                              UserDetailsEvent.deleteAccountRequested(
                                passwordController.text,
                              ),
                            );
                          } else {
                            showErrorSnackBar(
                              context,
                              'Please enter the complete 6-digit OTP',
                            );
                          }
                        },
                        child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              deleteAccountLoading:
                                  () => const CircularProgressIndicator(),
                              orElse: () => const Text('Delete Account'),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
