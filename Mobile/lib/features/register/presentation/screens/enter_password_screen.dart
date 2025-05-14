import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/core/routing/routing_extension.dart';
import 'package:versace/features/register/bloc/email_verification/email_verification_bloc.dart';
import '../../../../core/routing/routing_arguments.dart';
import '../../../../core/routing/routing_constants.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../bloc/email_verification/email_verification_event.dart';
import '../../bloc/email_verification/email_verification_state.dart';
import '../../bloc/register/register_bloc.dart';
import '../../bloc/register/register_event.dart';
import '../../bloc/register/register_state.dart';
import '../cubits/password_visibility_cubit.dart';
import '../cubits/password_visibility_state.dart';

class EnterPasswordScreen extends StatelessWidget {
  EnterPasswordScreen({super.key, required this.arguments});
  final EnterPasswordArguments arguments;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => PasswordVisibilityCubit(),
      child: Scaffold(
        appBar: AppBar(),
        body: MultiBlocListener(
          listeners: [
            BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  error: (error) {
                    showErrorSnackBar(context, error.toString());
                  },
                  success: (success) {
                    context.read<EmailVerificationBloc>().add(
                      EmailVerificationEvent.sendOtpRequested(
                        email: arguments.email,
                      ),
                    );
                  },
                );
              },
            ),
            BlocListener<EmailVerificationBloc, EmailVerificationState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  error: (error) {
                    showErrorSnackBar(context, error.toString());
                  },
                  otpSent: (otp) {
                    context.navigateTo(
                      RouteConstants.verifyOtp,
                      arguments: VerifyOtpArguments(email: arguments.email),
                    );
                  },
                );
              },
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Password', style: textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(
                    'Please enter your password to continue.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
                    builder: (context, state) {
                      return TextFormField(
                        controller: passwordController,
                        obscureText: !state.isPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password is required';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password*',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                            ),
                          ),
                            onPressed: () {
                              context
                                  .read<PasswordVisibilityCubit>()
                                  .togglePasswordVisibility();
                            },
                            icon: Icon(
                              state.isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.disabled,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
                    builder: (context, state) {
                      return TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !state.isConfirmPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password is required';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password*',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                            ),
                          ),
                            onPressed: () {
                              context
                                  .read<PasswordVisibilityCubit>()
                                  .toggleConfirmPasswordVisibility();
                            },
                            icon: Icon(
                              state.isConfirmPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.disabled,
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
                          context.read<RegisterBloc>().add(
                            RegisterEvent.registerRequested(
                              email: arguments.email,
                              password: passwordController.text,
                              firstName: arguments.firstName,
                              lastName: arguments.lastName,
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
                        builder: (context, emailState) {
                          return emailState.maybeWhen(
                            loading: () => const CircularProgressIndicator(),
                            orElse: () => BlocBuilder<RegisterBloc, RegisterState>(
                              builder: (context, registerState) {
                                return registerState.maybeWhen(
                                  orElse: () => const Text('Create Account'),
                                  loading: () => const CircularProgressIndicator(
                                  ),
                                );
                              },
                            ),
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
    );
  }
}
