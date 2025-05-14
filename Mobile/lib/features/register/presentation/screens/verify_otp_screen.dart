import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versace/core/routing/routing_extension.dart';
import 'package:versace/core/widgets/error_snackbar.dart';
import 'package:versace/features/register/bloc/email_verification/email_verification_bloc.dart';
import '../../../../core/routing/routing_arguments.dart';
import '../../../../core/routing/routing_constants.dart';
import '../../bloc/email_verification/email_verification_event.dart';
import '../../bloc/email_verification/email_verification_state.dart';
import '../cubits/otp_focus_cubit.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key, required this.arguments});
  final VerifyOtpArguments arguments;

  Widget _buildOtpField(BuildContext context, int index, OtpFocusCubit cubit) {
    return Expanded(
      child: TextFormField(
        controller: cubit.controllers[index],
        focusNode: cubit.focusNodes[index],
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.next,
        maxLength: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(counterText: ''),
        onChanged: (value) {
          if (value.isNotEmpty) {
            cubit.moveToNext(index);
          } else if (value.isEmpty && index > 0) {
            cubit.moveToPrevious(index);
          }
        },
        onFieldSubmitted: (_) {
          cubit.moveToNext(index);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          }
          return null;
        },
        onEditingComplete: () {},
        onTap: () {
          cubit.controllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: cubit.controllers[index].text.length,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (_) => OtpFocusCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<OtpFocusCubit>();
          final formKey = GlobalKey<FormState>();
          return Scaffold(
            appBar: AppBar(),
            body: BlocListener<EmailVerificationBloc, EmailVerificationState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  verified: (email) {
                    context.navigateToAndRemoveUntil(RouteConstants.home);
                  },
                  error: (error) {
                    showErrorSnackBar(context, error.toString());
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verify your email', style: textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(
                        'Please enter the code sent to your email address ${arguments.email}',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: List.generate(
                          6,
                          (i) => _buildOtpField(context, i, cubit),
                        ),
                      ),
                      KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.backspace) {
                            for (int i = 1; i < 6; i++) {
                              if (cubit.controllers[i].text.isEmpty &&
                                  cubit.focusNodes[i].hasFocus) {
                                cubit.moveToPrevious(i);
                                cubit.clearField(i - 1);
                                break;
                              }
                            }
                          }
                        },
                        child: const SizedBox.shrink(),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final otp =
                                  cubit.controllers.map((e) => e.text).join();
                              context.read<EmailVerificationBloc>().add(
                                EmailVerificationEvent.verifyOtpRequested(
                                  email: arguments.email,
                                  otp: otp,
                                ),
                              );
                            } else {
                              showErrorSnackBar(
                                context,
                                'Please enter the complete 6-digit OTP',
                              );
                            }
                          },
                          child: BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () => const Text('Verify'),
                                loading: () => const CircularProgressIndicator(),
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
        },
      ),
    );
  }
}
