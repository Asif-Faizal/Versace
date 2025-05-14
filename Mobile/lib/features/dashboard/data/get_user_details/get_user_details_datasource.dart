import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:versace/core/error/failures.dart';
import 'package:versace/core/injection/injection_container.dart';
import 'package:versace/core/storage/storage_helper.dart';
import 'package:versace/features/dashboard/domain/get_user_details/entity/get_user_details_entity.dart';

import '../../../../core/api/api_config.dart';
import '../../../../core/error/exception_handler.dart';
import '../../../../core/error/exceptions.dart';
import 'model/get_user_details_model.dart';

abstract class GetUserDetailsDatasource {
  Future<Either<Failure, GetUserDetailsEntity>> getUserDetails();
}

class GetUserDetailsDatasourceImpl implements GetUserDetailsDatasource {
  final http.Client client;

  GetUserDetailsDatasourceImpl({required this.client});
  @override
  Future<Either<Failure, GetUserDetailsEntity>> getUserDetails() async {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final deviceId = await storageHelper.deviceId ?? '';
    final deviceModel = await storageHelper.deviceModel ?? '';
    final deviceOs = await storageHelper.deviceOs ?? '';
    final deviceOsVersion = await storageHelper.deviceOsVersion ?? '';
    return await ExceptionHandler.handleApiCall(() async {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json', 'deviceid': deviceId, 'devicemodel': deviceModel, 'deviceos': deviceOs+deviceOsVersion,},
      );
      debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        return GetUserDetailsModel.fromApiJson(jsonDecode(response.body)).toEntity();
      } else {
        throw ServerException(
          message: jsonDecode(response.body)['error']['message'],
          statusCode: response.statusCode,
        );
      }
    });
  }
}
