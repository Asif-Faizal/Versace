// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserDetailsModelImpl _$$GetUserDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$GetUserDetailsModelImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: json['role'] as String,
  isActive: json['isActive'] as bool? ?? false,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
);

Map<String, dynamic> _$$GetUserDetailsModelImplToJson(
  _$GetUserDetailsModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': instance.role,
  'isActive': instance.isActive,
  'isEmailVerified': instance.isEmailVerified,
};
