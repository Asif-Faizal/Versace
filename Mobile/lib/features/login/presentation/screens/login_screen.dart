import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/core/routing/routing_extension.dart';
import 'package:versace/features/login/cubit/password_visibility/password_visibility_login_cubit.dart';

import '../../../../core/routing/routing_constants.dart';
import '../../../../core/util/validate_email.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';
import '../../cubit/password_visibility/password_visibility_login_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          debugPrint('Login State: $state');
          state.maybeWhen(
            error: (error) {
              showErrorSnackBar(context, error.toString());
            },
            success: (success) {
              context.navigateToAndRemoveUntil(RouteConstants.home);
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
                Text('Welcome Back!', style: textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(
                  'Please enter your credentials to continue.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address*',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: validateEmail,
                  autovalidateMode: AutovalidateMode.disabled,
                ),
                const SizedBox(height: 20),
                BlocBuilder<
                  PasswordVisibilityLoginCubit,
                  PasswordVisibilityLoginState
                >(
                  builder: (context, state) {
                    return TextFormField(
                      controller: passwordController,
                      obscureText: !state.isPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
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
                                .read<PasswordVisibilityLoginCubit>()
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
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(
                          LoginRequested(
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        );
                      }
                    },
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          loading: () => const CircularProgressIndicator(),
                          orElse: () => const Text('Login'),
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
    );
  }
}
