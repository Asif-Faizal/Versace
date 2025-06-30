import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:versace/features/register/domain/register/entity/register_entity.dart';

import '../../../../core/api/api.config.dart';
import '../../../../core/error/exception_handler.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../core/storage/storage_helper.dart';
import 'model/register_request_model.dart';
import 'model/register_response_model.dart';

abstract class RegisterDatasource {
  Future<Either<Failure, RegisterEntity>> register(RegisterRequestModel request);
}

class RegisterDatasourceImpl implements RegisterDatasource {
  final http.Client client;
  RegisterDatasourceImpl({required this.client});

  @override
  Future<Either<Failure, RegisterEntity>> register(RegisterRequestModel request) async {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final deviceId = await storageHelper.deviceId ?? '';
    final deviceModel = await storageHelper.deviceModel ?? '';
    final deviceOs = await storageHelper.deviceOs ?? '';
    final deviceOsVersion = await storageHelper.deviceOsVersion ?? '';
    return await ExceptionHandler.handleApiCall(() async {
      debugPrint('Request: ${request.toJson()}');
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),
        headers: { 'deviceid': deviceId, 'devicemodel': deviceModel, 'deviceos': deviceOs+deviceOsVersion,},
        body: request.toJson(),
      );
      debugPrint('Response: ${response.body}');
      if (response.statusCode == 201) {
        return RegisterResponseModel.fromApiJson(jsonDecode(response.body)).toEntity();
      } else {
        throw ServerException(
          message: jsonDecode(response.body)['error']['message'],
          statusCode: response.statusCode,
        );
      }
    });
  }
}