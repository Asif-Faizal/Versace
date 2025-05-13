import 'package:flutter/material.dart';
import 'package:versace/core/routing/routing_extension.dart';
import '../../../../core/routing/routing_arguments.dart';
import '../../../../core/routing/routing_constants.dart';
import '../../../../core/util/validate_email.dart';

class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome!', style: textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(
                'Please enter your email address to continue.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                    controller: firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      }else if(value.length < 3){
                        return 'First name must be at least 3 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'First Name*',
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                ],
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
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.navigateTo( RouteConstants.enterPassword, arguments: EnterPasswordArguments(email: emailController.text, firstName: firstNameController.text, lastName: lastNameController.text));
                    }
                  },
                  child: const Text('Continue'),
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
