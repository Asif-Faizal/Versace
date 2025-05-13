// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_verification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmailVerificationModel _$EmailVerificationModelFromJson(
  Map<String, dynamic> json,
) {
  return _EmailVerificationModel.fromJson(json);
}

/// @nodoc
mixin _$EmailVerificationModel {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this EmailVerificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmailVerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmailVerificationModelCopyWith<EmailVerificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailVerificationModelCopyWith<$Res> {
  factory $EmailVerificationModelCopyWith(
    EmailVerificationModel value,
    $Res Function(EmailVerificationModel) then,
  ) = _$EmailVerificationModelCopyWithImpl<$Res, EmailVerificationModel>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$EmailVerificationModelCopyWithImpl<
  $Res,
  $Val extends EmailVerificationModel
>
    implements $EmailVerificationModelCopyWith<$Res> {
  _$EmailVerificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmailVerificationModel
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
abstract class _$$EmailVerificationModelImplCopyWith<$Res>
    implements $EmailVerificationModelCopyWith<$Res> {
  factory _$$EmailVerificationModelImplCopyWith(
    _$EmailVerificationModelImpl value,
    $Res Function(_$EmailVerificationModelImpl) then,
  ) = __$$EmailVerificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$EmailVerificationModelImplCopyWithImpl<$Res>
    extends
        _$EmailVerificationModelCopyWithImpl<$Res, _$EmailVerificationModelImpl>
    implements _$$EmailVerificationModelImplCopyWith<$Res> {
  __$$EmailVerificationModelImplCopyWithImpl(
    _$EmailVerificationModelImpl _value,
    $Res Function(_$EmailVerificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailVerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$EmailVerificationModelImpl(
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
@JsonSerializable()
class _$EmailVerificationModelImpl implements _EmailVerificationModel {
  const _$EmailVerificationModelImpl({required this.message});

  factory _$EmailVerificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmailVerificationModelImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'EmailVerificationModel(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailVerificationModelImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of EmailVerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailVerificationModelImplCopyWith<_$EmailVerificationModelImpl>
  get copyWith =>
      __$$EmailVerificationModelImplCopyWithImpl<_$EmailVerificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailVerificationModelImplToJson(this);
  }
}

abstract class _EmailVerificationModel implements EmailVerificationModel {
  const factory _EmailVerificationModel({required final String message}) =
      _$EmailVerificationModelImpl;

  factory _EmailVerificationModel.fromJson(Map<String, dynamic> json) =
      _$EmailVerificationModelImpl.fromJson;

  @override
  String get message;

  /// Create a copy of EmailVerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailVerificationModelImplCopyWith<_$EmailVerificationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
