// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_verification_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EmailVerificationEntity {
  String get message => throw _privateConstructorUsedError;

  /// Create a copy of EmailVerificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmailVerificationEntityCopyWith<EmailVerificationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailVerificationEntityCopyWith<$Res> {
  factory $EmailVerificationEntityCopyWith(
    EmailVerificationEntity value,
    $Res Function(EmailVerificationEntity) then,
  ) = _$EmailVerificationEntityCopyWithImpl<$Res, EmailVerificationEntity>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$EmailVerificationEntityCopyWithImpl<
  $Res,
  $Val extends EmailVerificationEntity
>
    implements $EmailVerificationEntityCopyWith<$Res> {
  _$EmailVerificationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmailVerificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmailVerificationEntityImplCopyWith<$Res>
    implements $EmailVerificationEntityCopyWith<$Res> {
  factory _$$EmailVerificationEntityImplCopyWith(
    _$EmailVerificationEntityImpl value,
    $Res Function(_$EmailVerificationEntityImpl) then,
  ) = __$$EmailVerificationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$EmailVerificationEntityImplCopyWithImpl<$Res>
    extends
        _$EmailVerificationEntityCopyWithImpl<
          $Res,
          _$EmailVerificationEntityImpl
        >
    implements _$$EmailVerificationEntityImplCopyWith<$Res> {
  __$$EmailVerificationEntityImplCopyWithImpl(
    _$EmailVerificationEntityImpl _value,
    $Res Function(_$EmailVerificationEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailVerificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$EmailVerificationEntityImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$EmailVerificationEntityImpl implements _EmailVerificationEntity {
  const _$EmailVerificationEntityImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'EmailVerificationEntity(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailVerificationEntityImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of EmailVerificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailVerificationEntityImplCopyWith<_$EmailVerificationEntityImpl>
  get copyWith => __$$EmailVerificationEntityImplCopyWithImpl<
    _$EmailVerificationEntityImpl
  >(this, _$identity);
}

abstract class _EmailVerificationEntity implements EmailVerificationEntity {
  const factory _EmailVerificationEntity({required final String message}) =
      _$EmailVerificationEntityImpl;

  @override
  String get message;

  /// Create a copy of EmailVerificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailVerificationEntityImplCopyWith<_$EmailVerificationEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
