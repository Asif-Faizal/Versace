import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/email_verification/entity/email_verification_entity.dart';

abstract class EmailVerificationDataSource {
  Future<Either<Failure, EmailVerificationEntity>> sendOtp(String email);
  Future<Either<Failure, EmailVerificationEntity>> verifyOtp(String email, String otp);
}

class EmailVerificationDataSourceImpl extends EmailVerificationDataSource {
  final http.Client client;
  final String baseUrl;

  EmailVerificationDataSourceImpl({required this.client}) : baseUrl = Platform.isIOS ? 'http://127.0.0.1:5000' : 'http://10.0.2.2:5000';

  @override
  Future<Either<Failure, EmailVerificationEntity>> sendOtp(String email) async {
    return await ExceptionHandler.handleApiCall(() async {
      debugPrint('Sending OTP to $email');
      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        return EmailVerificationEntity(message: 'Email sent successfully');
      } else {
        throw ServerException(
          message: jsonDecode(response.body)['error']['message'],
          statusCode: response.statusCode,
        );
      }
    });
  }

  @override
  Future<Either<Failure, EmailVerificationEntity>> verifyOtp(String email, String otp) async {
    return await ExceptionHandler.handleApiCall(() async {
      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return EmailVerificationEntity(message: 'Email verified successfully');
      } else {
        throw ServerException(
          message: 'Failed to verify OTP',
          statusCode: response.statusCode,
        );
      }
    });
  }
}