import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Helper class for repositories to handle common API call errors
class ExceptionHandler {
  /// Checks if the device has an active internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      // Double check with a real connection test
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Executes API calls and handles common errors
  /// 
  /// Takes a function [apiCall] that returns a Future of type T
  /// Returns Either a Failure or the result of type T
  static Future<Either<Failure, T>> handleApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      // Check internet connection first
      if (!await hasInternetConnection()) {
        return Left(NetworkFailure());
      }

      final result = await apiCall();
      return Right(result);
    } on SocketException catch (e) {
      debugPrint("__________SOCKET EXCEPTION____________");
      debugPrint(e.toString());
      return Left(NetworkFailure());
    } on http.ClientException catch (e) {
      debugPrint("__________CLIENT EXCEPTION____________");
      debugPrint(e.toString());
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('Connection timed out')) {
        return Left(NetworkFailure());
      }
      return Left(ServerFailure());
    } on ServerException catch (e) {
      debugPrint("__________SERVER EXCEPTION____________");
      debugPrint(e.toString());
      return Left(ServerFailure());
    } catch (e) {
      debugPrint("__________GENERAL EXCEPTION____________");
      debugPrint(e.toString());
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('ClientException') ||
          e.toString().contains('Connection timed out')) {
        return Left(NetworkFailure());
      }
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}