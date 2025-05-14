import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:versace/core/error/failures.dart';
import 'package:versace/core/injection/injection_container.dart';
import 'package:versace/core/storage/storage_helper.dart';
import 'package:versace/features/dashboard/domain/user_details/entity/user_details_entity.dart';

import '../../../../core/api/api_config.dart';
import '../../../../core/error/exception_handler.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/user_details/entity/update_user_details_entity.dart';
import 'model/update_user_reponse_model.dart';
import 'model/update_user_request_model.dart';
import 'model/user_details_model.dart';

abstract class UserDetailsDatasource {
  Future<Either<Failure, UserDetailsEntity>> getUserDetails();
  Future<Either<Failure, UpdateUserDetailsEntity>> updateUserDetails(
    UpdateUserRequestModel updateUserRequestModel,
  );
  Future<Either<Failure, void>> logout();
}

class UserDetailsDatasourceImpl implements UserDetailsDatasource {
  final http.Client client;

  UserDetailsDatasourceImpl({required this.client});
  @override
  Future<Either<Failure, UserDetailsEntity>> getUserDetails() async {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final deviceId = await storageHelper.deviceId ?? '';
    final deviceModel = await storageHelper.deviceModel ?? '';
    final deviceOs = await storageHelper.deviceOs ?? '';
    final deviceOsVersion = await storageHelper.deviceOsVersion ?? '';
    final token = await storageHelper.accessToken ?? '';
    return await ExceptionHandler.handleApiCall(() async {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'deviceid': deviceId,
          'devicemodel': deviceModel,
          'deviceos': deviceOs + deviceOsVersion,
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        return UserDetailsModel.fromApiJson(
          jsonDecode(response.body),
        ).toEntity();
      } else {
        throw ServerException(
          message: jsonDecode(response.body)['error']['message'],
          statusCode: response.statusCode,
        );
      }
    });
  }

  @override
  Future<Either<Failure, UpdateUserDetailsEntity>> updateUserDetails(
    UpdateUserRequestModel updateUserRequestModel,
  ) async {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final deviceId = await storageHelper.deviceId ?? '';
    final deviceModel = await storageHelper.deviceModel ?? '';
    final deviceOs = await storageHelper.deviceOs ?? '';
    final deviceOsVersion = await storageHelper.deviceOsVersion ?? '';
    final token = await storageHelper.accessToken ?? '';
    return await ExceptionHandler.handleApiCall(() async {
      final response = await client.put(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'deviceid': deviceId,
          'devicemodel': deviceModel,
          'deviceos': deviceOs + deviceOsVersion,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateUserRequestModel.toJson()),
      );
      debugPrint('Edit Profile Response: ${response.body}');
      if (response.statusCode == 200) {
        return UpdateUserDetailsModel.fromApiJson(
          jsonDecode(response.body),
        ).toEntity();
      } else {
        throw ServerException(
          message: jsonDecode(response.body)['error']['message'],
          statusCode: response.statusCode,
        );
      }
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final StorageHelper storageHelper = getIt<StorageHelper>();
    final deviceId = await storageHelper.deviceId ?? '';
    final deviceModel = await storageHelper.deviceModel ?? '';
    final deviceOs = await storageHelper.deviceOs ?? '';
    final deviceOsVersion = await storageHelper.deviceOsVersion ?? '';
    final token = await storageHelper.accessToken ?? '';
    return await ExceptionHandler.handleApiCall(() async {
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'deviceid': deviceId,
          'devicemodel': deviceModel,
          'deviceos': deviceOs + deviceOsVersion,
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Logout Response: ${response.statusCode}');
      if (response.statusCode == 204) {
        return;
      } else {
        throw ServerException(
          message: jsonDecode(response.body)['error']['message'],
          statusCode: response.statusCode,
        );
      }
    });
  }
}
