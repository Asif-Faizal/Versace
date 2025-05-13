import 'package:bloc/bloc.dart';

import '../../domain/email_verification/usecases/sent_email_otp.dart';
import '../../domain/email_verification/usecases/verify_email_otp.dart';

import 'email_verification_event.dart';
import 'email_verification_state.dart';

class EmailVerificationBloc extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final SentEmailOtpUsecase sentEmailOtpUsecase;
  final VerifyEmailOtpUsecase verifyEmailOtpUsecase;

  EmailVerificationBloc({
    required this.sentEmailOtpUsecase,
    required this.verifyEmailOtpUsecase,
  }) : super(const EmailVerificationState.initial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(const EmailVerificationState.loading());
    
    final result = await sentEmailOtpUsecase.execute(event.email);
    
    result.fold(
      (failure) => emit(EmailVerificationState.error(failure.toString())),
      (entity) => emit(EmailVerificationState.otpSent(entity.message)),
    );
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(const EmailVerificationState.loading());
    
    final result = await verifyEmailOtpUsecase.execute({
      'email': event.email,
      'otp': event.otp,
    });
    
    result.fold(
      (failure) => emit(EmailVerificationState.error(failure.toString())),
      (entity) => emit(EmailVerificationState.verified(entity.message)),
    );
  }
}
