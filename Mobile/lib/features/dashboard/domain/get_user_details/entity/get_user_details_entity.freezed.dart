// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_details_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GetUserDetailsEntity {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;

  /// Create a copy of GetUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetUserDetailsEntityCopyWith<GetUserDetailsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserDetailsEntityCopyWith<$Res> {
  factory $GetUserDetailsEntityCopyWith(
    GetUserDetailsEntity value,
    $Res Function(GetUserDetailsEntity) then,
  ) = _$GetUserDetailsEntityCopyWithImpl<$Res, GetUserDetailsEntity>;
  @useResult
  $Res call({
    String id,
    String email,
    String firstName,
    String lastName,
    String role,
    bool isActive,
    bool isEmailVerified,
  });
}

/// @nodoc
class _$GetUserDetailsEntityCopyWithImpl<
  $Res,
  $Val extends GetUserDetailsEntity
>
    implements $GetUserDetailsEntityCopyWith<$Res> {
  _$GetUserDetailsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? role = null,
    Object? isActive = null,
    Object? isEmailVerified = null,
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
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isEmailVerified:
                null == isEmailVerified
                    ? _value.isEmailVerified
                    : isEmailVerified // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetUserDetailsEntityImplCopyWith<$Res>
    implements $GetUserDetailsEntityCopyWith<$Res> {
  factory _$$GetUserDetailsEntityImplCopyWith(
    _$GetUserDetailsEntityImpl value,
    $Res Function(_$GetUserDetailsEntityImpl) then,
  ) = __$$GetUserDetailsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String firstName,
    String lastName,
    String role,
    bool isActive,
    bool isEmailVerified,
  });
}

/// @nodoc
class __$$GetUserDetailsEntityImplCopyWithImpl<$Res>
    extends _$GetUserDetailsEntityCopyWithImpl<$Res, _$GetUserDetailsEntityImpl>
    implements _$$GetUserDetailsEntityImplCopyWith<$Res> {
  __$$GetUserDetailsEntityImplCopyWithImpl(
    _$GetUserDetailsEntityImpl _value,
    $Res Function(_$GetUserDetailsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? role = null,
    Object? isActive = null,
    Object? isEmailVerified = null,
  }) {
    return _then(
      _$GetUserDetailsEntityImpl(
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
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isEmailVerified:
            null == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$GetUserDetailsEntityImpl implements _GetUserDetailsEntity {
  const _$GetUserDetailsEntityImpl({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.isActive = false,
    this.isEmailVerified = false,
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
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isEmailVerified;

  @override
  String toString() {
    return 'GetUserDetailsEntity(id: $id, email: $email, firstName: $firstName, lastName: $lastName, role: $role, isActive: $isActive, isEmailVerified: $isEmailVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserDetailsEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    firstName,
    lastName,
    role,
    isActive,
    isEmailVerified,
  );

  /// Create a copy of GetUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserDetailsEntityImplCopyWith<_$GetUserDetailsEntityImpl>
  get copyWith =>
      __$$GetUserDetailsEntityImplCopyWithImpl<_$GetUserDetailsEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _GetUserDetailsEntity implements GetUserDetailsEntity {
  const factory _GetUserDetailsEntity({
    required final String id,
    required final String email,
    required final String firstName,
    required final String lastName,
    required final String role,
    final bool isActive,
    final bool isEmailVerified,
  }) = _$GetUserDetailsEntityImpl;

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
  bool get isActive;
  @override
  bool get isEmailVerified;

  /// Create a copy of GetUserDetailsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserDetailsEntityImplCopyWith<_$GetUserDetailsEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
