// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_visibility_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PasswordVisibilityState {
  bool get isPasswordVisible => throw _privateConstructorUsedError;
  bool get isConfirmPasswordVisible => throw _privateConstructorUsedError;

  /// Create a copy of PasswordVisibilityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordVisibilityStateCopyWith<PasswordVisibilityState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordVisibilityStateCopyWith<$Res> {
  factory $PasswordVisibilityStateCopyWith(
    PasswordVisibilityState value,
    $Res Function(PasswordVisibilityState) then,
  ) = _$PasswordVisibilityStateCopyWithImpl<$Res, PasswordVisibilityState>;
  @useResult
  $Res call({bool isPasswordVisible, bool isConfirmPasswordVisible});
}

/// @nodoc
class _$PasswordVisibilityStateCopyWithImpl<
  $Res,
  $Val extends PasswordVisibilityState
>
    implements $PasswordVisibilityStateCopyWith<$Res> {
  _$PasswordVisibilityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordVisibilityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPasswordVisible = null,
    Object? isConfirmPasswordVisible = null,
  }) {
    return _then(
      _value.copyWith(
            isPasswordVisible:
                null == isPasswordVisible
                    ? _value.isPasswordVisible
                    : isPasswordVisible // ignore: cast_nullable_to_non_nullable
                        as bool,
            isConfirmPasswordVisible:
                null == isConfirmPasswordVisible
                    ? _value.isConfirmPasswordVisible
                    : isConfirmPasswordVisible // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PasswordVisibilityStateImplCopyWith<$Res>
    implements $PasswordVisibilityStateCopyWith<$Res> {
  factory _$$PasswordVisibilityStateImplCopyWith(
    _$PasswordVisibilityStateImpl value,
    $Res Function(_$PasswordVisibilityStateImpl) then,
  ) = __$$PasswordVisibilityStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isPasswordVisible, bool isConfirmPasswordVisible});
}

/// @nodoc
class __$$PasswordVisibilityStateImplCopyWithImpl<$Res>
    extends
        _$PasswordVisibilityStateCopyWithImpl<
          $Res,
          _$PasswordVisibilityStateImpl
        >
    implements _$$PasswordVisibilityStateImplCopyWith<$Res> {
  __$$PasswordVisibilityStateImplCopyWithImpl(
    _$PasswordVisibilityStateImpl _value,
    $Res Function(_$PasswordVisibilityStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PasswordVisibilityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPasswordVisible = null,
    Object? isConfirmPasswordVisible = null,
  }) {
    return _then(
      _$PasswordVisibilityStateImpl(
        isPasswordVisible:
            null == isPasswordVisible
                ? _value.isPasswordVisible
                : isPasswordVisible // ignore: cast_nullable_to_non_nullable
                    as bool,
        isConfirmPasswordVisible:
            null == isConfirmPasswordVisible
                ? _value.isConfirmPasswordVisible
                : isConfirmPasswordVisible // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$PasswordVisibilityStateImpl implements _PasswordVisibilityState {
  const _$PasswordVisibilityStateImpl({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  @override
  @JsonKey()
  final bool isPasswordVisible;
  @override
  @JsonKey()
  final bool isConfirmPasswordVisible;

  @override
  String toString() {
    return 'PasswordVisibilityState(isPasswordVisible: $isPasswordVisible, isConfirmPasswordVisible: $isConfirmPasswordVisible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordVisibilityStateImpl &&
            (identical(other.isPasswordVisible, isPasswordVisible) ||
                other.isPasswordVisible == isPasswordVisible) &&
            (identical(
                  other.isConfirmPasswordVisible,
                  isConfirmPasswordVisible,
                ) ||
                other.isConfirmPasswordVisible == isConfirmPasswordVisible));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isPasswordVisible, isConfirmPasswordVisible);

  /// Create a copy of PasswordVisibilityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordVisibilityStateImplCopyWith<_$PasswordVisibilityStateImpl>
  get copyWith => __$$PasswordVisibilityStateImplCopyWithImpl<
    _$PasswordVisibilityStateImpl
  >(this, _$identity);
}

abstract class _PasswordVisibilityState implements PasswordVisibilityState {
  const factory _PasswordVisibilityState({
    final bool isPasswordVisible,
    final bool isConfirmPasswordVisible,
  }) = _$PasswordVisibilityStateImpl;

  @override
  bool get isPasswordVisible;
  @override
  bool get isConfirmPasswordVisible;

  /// Create a copy of PasswordVisibilityState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordVisibilityStateImplCopyWith<_$PasswordVisibilityStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
