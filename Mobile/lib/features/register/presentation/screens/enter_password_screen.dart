import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/routing_arguments.dart';
import '../cubits/password_visibility_cubit.dart';
import '../cubits/password_visibility_state.dart';

class EnterPasswordScreen extends StatelessWidget {
  EnterPasswordScreen({super.key, required this.arguments});
  final EnterPasswordArguments arguments;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => PasswordVisibilityCubit(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
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
                          onPressed: () {
                            context.read<PasswordVisibilityCubit>().togglePasswordVisibility();
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
                          onPressed: () {
                            context.read<PasswordVisibilityCubit>().toggleConfirmPasswordVisibility();
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
                      }
                    },
                    child: const Text('Create Account'),
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
