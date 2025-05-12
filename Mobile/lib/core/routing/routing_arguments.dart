import 'package:equatable/equatable.dart';

/// Base class for all route arguments
abstract class RouteArguments extends Equatable {
  const RouteArguments();
  
  @override
  bool get stringify => true;
}