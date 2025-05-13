// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_otp_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VerifyOtpRequestModel _$VerifyOtpRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _VerifyOtpRequestModel.fromJson(json);
}

/// @nodoc
mixin _$VerifyOtpRequestModel {
  String get email => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;

  /// Serializes this VerifyOtpRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyOtpRequestModelCopyWith<VerifyOtpRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyOtpRequestModelCopyWith<$Res> {
  factory $VerifyOtpRequestModelCopyWith(
    VerifyOtpRequestModel value,
    $Res Function(VerifyOtpRequestModel) then,
  ) = _$VerifyOtpRequestModelCopyWithImpl<$Res, VerifyOtpRequestModel>;
  @useResult
  $Res call({String email, String otp});
}

/// @nodoc
class _$VerifyOtpRequestModelCopyWithImpl<
  $Res,
  $Val extends VerifyOtpRequestModel
>
    implements $VerifyOtpRequestModelCopyWith<$Res> {
  _$VerifyOtpRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? otp = null}) {
    return _then(
      _value.copyWith(
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            otp:
                null == otp
                    ? _value.otp
                    : otp // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VerifyOtpRequestModelImplCopyWith<$Res>
    implements $VerifyOtpRequestModelCopyWith<$Res> {
  factory _$$VerifyOtpRequestModelImplCopyWith(
    _$VerifyOtpRequestModelImpl value,
    $Res Function(_$VerifyOtpRequestModelImpl) then,
  ) = __$$VerifyOtpRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String otp});
}

/// @nodoc
class __$$VerifyOtpRequestModelImplCopyWithImpl<$Res>
    extends
        _$VerifyOtpRequestModelCopyWithImpl<$Res, _$VerifyOtpRequestModelImpl>
    implements _$$VerifyOtpRequestModelImplCopyWith<$Res> {
  __$$VerifyOtpRequestModelImplCopyWithImpl(
    _$VerifyOtpRequestModelImpl _value,
    $Res Function(_$VerifyOtpRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerifyOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? otp = null}) {
    return _then(
      _$VerifyOtpRequestModelImpl(
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        otp:
            null == otp
                ? _value.otp
                : otp // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyOtpRequestModelImpl implements _VerifyOtpRequestModel {
  const _$VerifyOtpRequestModelImpl({required this.email, required this.otp});

  factory _$VerifyOtpRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyOtpRequestModelImplFromJson(json);

  @override
  final String email;
  @override
  final String otp;

  @override
  String toString() {
    return 'VerifyOtpRequestModel(email: $email, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyOtpRequestModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, otp);

  /// Create a copy of VerifyOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyOtpRequestModelImplCopyWith<_$VerifyOtpRequestModelImpl>
  get copyWith =>
      __$$VerifyOtpRequestModelImplCopyWithImpl<_$VerifyOtpRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyOtpRequestModelImplToJson(this);
  }
}

abstract class _VerifyOtpRequestModel implements VerifyOtpRequestModel {
  const factory _VerifyOtpRequestModel({
    required final String email,
    required final String otp,
  }) = _$VerifyOtpRequestModelImpl;

  factory _VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) =
      _$VerifyOtpRequestModelImpl.fromJson;

  @override
  String get email;
  @override
  String get otp;

  /// Create a copy of VerifyOtpRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyOtpRequestModelImplCopyWith<_$VerifyOtpRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
