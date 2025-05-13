import 'package:flutter/material.dart';
import 'package:versace/core/widgets/otp_bottom_sheet.dart';
import '../../../../core/util/validate_email.dart';

class EnterEmailScreen extends StatelessWidget {
  const EnterEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.08),
              Text(
                'Welcome!',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'Please enter your email address to continue.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: validateEmail,
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: (value) {
                  // Handle email changes if needed
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                        ),
                        context: context,
                        builder: (context) => OtpBottomSheet(onVerifyTap: (otp){}, title: 'Verify Email', subTitle: 'Enter the 6-digit code sent to your email address', buttonText: 'Verify', mobile: emailController.text),
                      );
                    }
                  },
                  child: const Text(
                    'Verify Email',
                  ),
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