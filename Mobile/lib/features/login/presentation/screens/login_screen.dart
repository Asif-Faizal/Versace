import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/features/login/cubit/password_visibility/password_visibility_login_cubit.dart';

import '../../../../core/util/validate_email.dart';
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
      body: Padding(
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
              BlocBuilder<PasswordVisibilityLoginCubit, PasswordVisibilityLoginState>(
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
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
