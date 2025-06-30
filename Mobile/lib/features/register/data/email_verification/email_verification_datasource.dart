import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/api/api.config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/email_verification/entity/email_verification_entity.dart';
import 'models/email_verification_model.dart';

abstract class EmailVerificationDataSource {
  Future<Either<Failure, EmailVerificationEntity>> sendOtp(String email);
  Future<Either<Failure, EmailVerificationEntity>> verifyOtp(String email, String otp);
}

class EmailVerificationDataSourceImpl extends EmailVerificationDataSource {
  final http.Client client;

  EmailVerificationDataSourceImpl({required this.client});

  @override
  Future<Either<Failure, EmailVerificationEntity>> sendOtp(String email) async {
    return await ExceptionHandler.handleApiCall(() async {
      debugPrint('Sending OTP to $email');
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        return EmailVerificationModel.fromJson(jsonDecode(response.body)).toEntity();
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
        Uri.parse('${ApiConfig.baseUrl}/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return EmailVerificationModel.fromJson(jsonDecode(response.body)).toEntity();
      } else {
        throw ServerException(
          message: 'Failed to verify OTP',
          statusCode: response.statusCode,
        );
      }
    });
  }
}