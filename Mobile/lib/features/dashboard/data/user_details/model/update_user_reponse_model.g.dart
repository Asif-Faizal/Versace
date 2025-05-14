// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_reponse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateUserDetailsModelImpl _$$UpdateUserDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateUserDetailsModelImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: json['role'] as String,
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$$UpdateUserDetailsModelImplToJson(
  _$UpdateUserDetailsModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': instance.role,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
