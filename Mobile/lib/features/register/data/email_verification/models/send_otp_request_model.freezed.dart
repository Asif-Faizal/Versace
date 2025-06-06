// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_otp_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SendOtpRequestModel _$SendOtpRequestModelFromJson(Map<String, dynamic> json) {
  return _SendOtpRequestModel.fromJson(json);
}

/// @nodoc
mixin _$SendOtpRequestModel {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this SendOtpRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendOtpRequestModelCopyWith<SendOtpRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendOtpRequestModelCopyWith<$Res> {
  factory $SendOtpRequestModelCopyWith(
    SendOtpRequestModel value,
    $Res Function(SendOtpRequestModel) then,
  ) = _$SendOtpRequestModelCopyWithImpl<$Res, SendOtpRequestModel>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$SendOtpRequestModelCopyWithImpl<$Res, $Val extends SendOtpRequestModel>
    implements $SendOtpRequestModelCopyWith<$Res> {
  _$SendOtpRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _value.copyWith(
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SendOtpRequestModelImplCopyWith<$Res>
    implements $SendOtpRequestModelCopyWith<$Res> {
  factory _$$SendOtpRequestModelImplCopyWith(
    _$SendOtpRequestModelImpl value,
    $Res Function(_$SendOtpRequestModelImpl) then,
  ) = __$$SendOtpRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$SendOtpRequestModelImplCopyWithImpl<$Res>
    extends _$SendOtpRequestModelCopyWithImpl<$Res, _$SendOtpRequestModelImpl>
    implements _$$SendOtpRequestModelImplCopyWith<$Res> {
  __$$SendOtpRequestModelImplCopyWithImpl(
    _$SendOtpRequestModelImpl _value,
    $Res Function(_$SendOtpRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _$SendOtpRequestModelImpl(
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SendOtpRequestModelImpl implements _SendOtpRequestModel {
  const _$SendOtpRequestModelImpl({required this.email});

  factory _$SendOtpRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendOtpRequestModelImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'SendOtpRequestModel(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendOtpRequestModelImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of SendOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendOtpRequestModelImplCopyWith<_$SendOtpRequestModelImpl> get copyWith =>
      __$$SendOtpRequestModelImplCopyWithImpl<_$SendOtpRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SendOtpRequestModelImplToJson(this);
  }
}

abstract class _SendOtpRequestModel implements SendOtpRequestModel {
  const factory _SendOtpRequestModel({required final String email}) =
      _$SendOtpRequestModelImpl;

  factory _SendOtpRequestModel.fromJson(Map<String, dynamic> json) =
      _$SendOtpRequestModelImpl.fromJson;

  @override
  String get email;

  /// Create a copy of SendOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendOtpRequestModelImplCopyWith<_$SendOtpRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
