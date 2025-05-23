// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SplashState {
  SplashStateType get type => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get deviceModel => throw _privateConstructorUsedError;
  String? get deviceManufacturer => throw _privateConstructorUsedError;
  String? get deviceOs => throw _privateConstructorUsedError;
  String? get deviceOsVersion => throw _privateConstructorUsedError;

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplashStateCopyWith<SplashState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashStateCopyWith<$Res> {
  factory $SplashStateCopyWith(
    SplashState value,
    $Res Function(SplashState) then,
  ) = _$SplashStateCopyWithImpl<$Res, SplashState>;
  @useResult
  $Res call({
    SplashStateType type,
    String? deviceId,
    String? deviceModel,
    String? deviceManufacturer,
    String? deviceOs,
    String? deviceOsVersion,
  });
}

/// @nodoc
class _$SplashStateCopyWithImpl<$Res, $Val extends SplashState>
    implements $SplashStateCopyWith<$Res> {
  _$SplashStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? deviceId = freezed,
    Object? deviceModel = freezed,
    Object? deviceManufacturer = freezed,
    Object? deviceOs = freezed,
    Object? deviceOsVersion = freezed,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as SplashStateType,
            deviceId:
                freezed == deviceId
                    ? _value.deviceId
                    : deviceId // ignore: cast_nullable_to_non_nullable
                        as String?,
            deviceModel:
                freezed == deviceModel
                    ? _value.deviceModel
                    : deviceModel // ignore: cast_nullable_to_non_nullable
                        as String?,
            deviceManufacturer:
                freezed == deviceManufacturer
                    ? _value.deviceManufacturer
                    : deviceManufacturer // ignore: cast_nullable_to_non_nullable
                        as String?,
            deviceOs:
                freezed == deviceOs
                    ? _value.deviceOs
                    : deviceOs // ignore: cast_nullable_to_non_nullable
                        as String?,
            deviceOsVersion:
                freezed == deviceOsVersion
                    ? _value.deviceOsVersion
                    : deviceOsVersion // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SplashStateImplCopyWith<$Res>
    implements $SplashStateCopyWith<$Res> {
  factory _$$SplashStateImplCopyWith(
    _$SplashStateImpl value,
    $Res Function(_$SplashStateImpl) then,
  ) = __$$SplashStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SplashStateType type,
    String? deviceId,
    String? deviceModel,
    String? deviceManufacturer,
    String? deviceOs,
    String? deviceOsVersion,
  });
}

/// @nodoc
class __$$SplashStateImplCopyWithImpl<$Res>
    extends _$SplashStateCopyWithImpl<$Res, _$SplashStateImpl>
    implements _$$SplashStateImplCopyWith<$Res> {
  __$$SplashStateImplCopyWithImpl(
    _$SplashStateImpl _value,
    $Res Function(_$SplashStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? deviceId = freezed,
    Object? deviceModel = freezed,
    Object? deviceManufacturer = freezed,
    Object? deviceOs = freezed,
    Object? deviceOsVersion = freezed,
  }) {
    return _then(
      _$SplashStateImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as SplashStateType,
        deviceId:
            freezed == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                    as String?,
        deviceModel:
            freezed == deviceModel
                ? _value.deviceModel
                : deviceModel // ignore: cast_nullable_to_non_nullable
                    as String?,
        deviceManufacturer:
            freezed == deviceManufacturer
                ? _value.deviceManufacturer
                : deviceManufacturer // ignore: cast_nullable_to_non_nullable
                    as String?,
        deviceOs:
            freezed == deviceOs
                ? _value.deviceOs
                : deviceOs // ignore: cast_nullable_to_non_nullable
                    as String?,
        deviceOsVersion:
            freezed == deviceOsVersion
                ? _value.deviceOsVersion
                : deviceOsVersion // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$SplashStateImpl implements _SplashState {
  const _$SplashStateImpl({
    this.type = SplashStateType.initial,
    this.deviceId,
    this.deviceModel,
    this.deviceManufacturer,
    this.deviceOs,
    this.deviceOsVersion,
  });

  @override
  @JsonKey()
  final SplashStateType type;
  @override
  final String? deviceId;
  @override
  final String? deviceModel;
  @override
  final String? deviceManufacturer;
  @override
  final String? deviceOs;
  @override
  final String? deviceOsVersion;

  @override
  String toString() {
    return 'SplashState(type: $type, deviceId: $deviceId, deviceModel: $deviceModel, deviceManufacturer: $deviceManufacturer, deviceOs: $deviceOs, deviceOsVersion: $deviceOsVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplashStateImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.deviceManufacturer, deviceManufacturer) ||
                other.deviceManufacturer == deviceManufacturer) &&
            (identical(other.deviceOs, deviceOs) ||
                other.deviceOs == deviceOs) &&
            (identical(other.deviceOsVersion, deviceOsVersion) ||
                other.deviceOsVersion == deviceOsVersion));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    deviceId,
    deviceModel,
    deviceManufacturer,
    deviceOs,
    deviceOsVersion,
  );

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplashStateImplCopyWith<_$SplashStateImpl> get copyWith =>
      __$$SplashStateImplCopyWithImpl<_$SplashStateImpl>(this, _$identity);
}

abstract class _SplashState implements SplashState {
  const factory _SplashState({
    final SplashStateType type,
    final String? deviceId,
    final String? deviceModel,
    final String? deviceManufacturer,
    final String? deviceOs,
    final String? deviceOsVersion,
  }) = _$SplashStateImpl;

  @override
  SplashStateType get type;
  @override
  String? get deviceId;
  @override
  String? get deviceModel;
  @override
  String? get deviceManufacturer;
  @override
  String? get deviceOs;
  @override
  String? get deviceOsVersion;

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplashStateImplCopyWith<_$SplashStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
