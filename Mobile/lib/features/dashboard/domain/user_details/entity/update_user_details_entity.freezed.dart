// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_details_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UpdateUserDetailsEntity {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;

  /// Create a copy of UpdateUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateUserDetailsEntityCopyWith<UpdateUserDetailsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserDetailsEntityCopyWith<$Res> {
  factory $UpdateUserDetailsEntityCopyWith(
    UpdateUserDetailsEntity value,
    $Res Function(UpdateUserDetailsEntity) then,
  ) = _$UpdateUserDetailsEntityCopyWithImpl<$Res, UpdateUserDetailsEntity>;
  @useResult
  $Res call({
    String id,
    String email,
    String firstName,
    String lastName,
    String role,
    String accessToken,
    String refreshToken,
  });
}

/// @nodoc
class _$UpdateUserDetailsEntityCopyWithImpl<
  $Res,
  $Val extends UpdateUserDetailsEntity
>
    implements $UpdateUserDetailsEntityCopyWith<$Res> {
  _$UpdateUserDetailsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? role = null,
    Object? accessToken = null,
    Object? refreshToken = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            firstName:
                null == firstName
                    ? _value.firstName
                    : firstName // ignore: cast_nullable_to_non_nullable
                        as String,
            lastName:
                null == lastName
                    ? _value.lastName
                    : lastName // ignore: cast_nullable_to_non_nullable
                        as String,
            role:
                null == role
                    ? _value.role
                    : role // ignore: cast_nullable_to_non_nullable
                        as String,
            accessToken:
                null == accessToken
                    ? _value.accessToken
                    : accessToken // ignore: cast_nullable_to_non_nullable
                        as String,
            refreshToken:
                null == refreshToken
                    ? _value.refreshToken
                    : refreshToken // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateUserDetailsEntityImplCopyWith<$Res>
    implements $UpdateUserDetailsEntityCopyWith<$Res> {
  factory _$$UpdateUserDetailsEntityImplCopyWith(
    _$UpdateUserDetailsEntityImpl value,
    $Res Function(_$UpdateUserDetailsEntityImpl) then,
  ) = __$$UpdateUserDetailsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String firstName,
    String lastName,
    String role,
    String accessToken,
    String refreshToken,
  });
}

/// @nodoc
class __$$UpdateUserDetailsEntityImplCopyWithImpl<$Res>
    extends
        _$UpdateUserDetailsEntityCopyWithImpl<
          $Res,
          _$UpdateUserDetailsEntityImpl
        >
    implements _$$UpdateUserDetailsEntityImplCopyWith<$Res> {
  __$$UpdateUserDetailsEntityImplCopyWithImpl(
    _$UpdateUserDetailsEntityImpl _value,
    $Res Function(_$UpdateUserDetailsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? role = null,
    Object? accessToken = null,
    Object? refreshToken = null,
  }) {
    return _then(
      _$UpdateUserDetailsEntityImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        firstName:
            null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                    as String,
        lastName:
            null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                    as String,
        role:
            null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                    as String,
        accessToken:
            null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                    as String,
        refreshToken:
            null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateUserDetailsEntityImpl implements _UpdateUserDetailsEntity {
  const _$UpdateUserDetailsEntityImpl({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  final String id;
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String role;
  @override
  final String accessToken;
  @override
  final String refreshToken;

  @override
  String toString() {
    return 'UpdateUserDetailsEntity(id: $id, email: $email, firstName: $firstName, lastName: $lastName, role: $role, accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserDetailsEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    firstName,
    lastName,
    role,
    accessToken,
    refreshToken,
  );

  /// Create a copy of UpdateUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserDetailsEntityImplCopyWith<_$UpdateUserDetailsEntityImpl>
  get copyWith => __$$UpdateUserDetailsEntityImplCopyWithImpl<
    _$UpdateUserDetailsEntityImpl
  >(this, _$identity);
}

abstract class _UpdateUserDetailsEntity implements UpdateUserDetailsEntity {
  const factory _UpdateUserDetailsEntity({
    required final String id,
    required final String email,
    required final String firstName,
    required final String lastName,
    required final String role,
    required final String accessToken,
    required final String refreshToken,
  }) = _$UpdateUserDetailsEntityImpl;

  @override
  String get id;
  @override
  String get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get role;
  @override
  String get accessToken;
  @override
  String get refreshToken;

  /// Create a copy of UpdateUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserDetailsEntityImplCopyWith<_$UpdateUserDetailsEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
