import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:versace/features/login/data/login/models/login_request_model.dart';
import 'package:versace/features/login/data/login/models/login_reponse_model.dart';
import 'package:versace/features/login/domain/login/entities/login_entity.dart';

import '../../../../core/api/api.config.dart';
import '../../../../core/error/exception_handler.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../core/storage/storage_helper.dart';

abstract class LoginRemoteDataSource {
  Future<Either<Failure, LoginEntity>> login(LoginRequestModel request);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;

  LoginRemoteDataSourceImpl({required this.client});

  @override
  Future<Either<Failure, LoginEntity>> login(LoginRequestModel request) async {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final deviceId = await storageHelper.deviceId ?? '';
    final deviceModel = await storageHelper.deviceModel ?? '';
    final deviceOs = await storageHelper.deviceOs ?? '';
    final deviceOsVersion = await storageHelper.deviceOsVersion ?? '';
    return await ExceptionHandler.handleApiCall(() async {
      debugPrint('Request: ${request.toJson()}');
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json', 'deviceid': deviceId, 'devicemodel': deviceModel, 'deviceos': deviceOs+deviceOsVersion,},
        body: jsonEncode(request.toJson()),
      );
      debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        return LoginResponseModel.fromApiJson(jsonDecode(response.body)).toEntity();
      } else {
        throw ServerException(
          message: jsonDecode(response.body)['error']['message'],
          statusCode: response.statusCode,
        );
      }
    });
  }
}