// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_visibility_login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PasswordVisibilityLoginState {
  bool get isPasswordVisible => throw _privateConstructorUsedError;

  /// Create a copy of PasswordVisibilityLoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordVisibilityLoginStateCopyWith<PasswordVisibilityLoginState>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordVisibilityLoginStateCopyWith<$Res> {
  factory $PasswordVisibilityLoginStateCopyWith(
    PasswordVisibilityLoginState value,
    $Res Function(PasswordVisibilityLoginState) then,
  ) =
      _$PasswordVisibilityLoginStateCopyWithImpl<
        $Res,
        PasswordVisibilityLoginState
      >;
  @useResult
  $Res call({bool isPasswordVisible});
}

/// @nodoc
class _$PasswordVisibilityLoginStateCopyWithImpl<
  $Res,
  $Val extends PasswordVisibilityLoginState
>
    implements $PasswordVisibilityLoginStateCopyWith<$Res> {
  _$PasswordVisibilityLoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordVisibilityLoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isPasswordVisible = null}) {
    return _then(
      _value.copyWith(
            isPasswordVisible:
                null == isPasswordVisible
                    ? _value.isPasswordVisible
                    : isPasswordVisible // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PasswordVisibilityLoginStateImplCopyWith<$Res>
    implements $PasswordVisibilityLoginStateCopyWith<$Res> {
  factory _$$PasswordVisibilityLoginStateImplCopyWith(
    _$PasswordVisibilityLoginStateImpl value,
    $Res Function(_$PasswordVisibilityLoginStateImpl) then,
  ) = __$$PasswordVisibilityLoginStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isPasswordVisible});
}

/// @nodoc
class __$$PasswordVisibilityLoginStateImplCopyWithImpl<$Res>
    extends
        _$PasswordVisibilityLoginStateCopyWithImpl<
          $Res,
          _$PasswordVisibilityLoginStateImpl
        >
    implements _$$PasswordVisibilityLoginStateImplCopyWith<$Res> {
  __$$PasswordVisibilityLoginStateImplCopyWithImpl(
    _$PasswordVisibilityLoginStateImpl _value,
    $Res Function(_$PasswordVisibilityLoginStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PasswordVisibilityLoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isPasswordVisible = null}) {
    return _then(
      _$PasswordVisibilityLoginStateImpl(
        isPasswordVisible:
            null == isPasswordVisible
                ? _value.isPasswordVisible
                : isPasswordVisible // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$PasswordVisibilityLoginStateImpl
    implements _PasswordVisibilityLoginState {
  const _$PasswordVisibilityLoginStateImpl({this.isPasswordVisible = false});

  @override
  @JsonKey()
  final bool isPasswordVisible;

  @override
  String toString() {
    return 'PasswordVisibilityLoginState(isPasswordVisible: $isPasswordVisible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordVisibilityLoginStateImpl &&
            (identical(other.isPasswordVisible, isPasswordVisible) ||
                other.isPasswordVisible == isPasswordVisible));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isPasswordVisible);

  /// Create a copy of PasswordVisibilityLoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordVisibilityLoginStateImplCopyWith<
    _$PasswordVisibilityLoginStateImpl
  >
  get copyWith => __$$PasswordVisibilityLoginStateImplCopyWithImpl<
    _$PasswordVisibilityLoginStateImpl
  >(this, _$identity);
}

abstract class _PasswordVisibilityLoginState
    implements PasswordVisibilityLoginState {
  const factory _PasswordVisibilityLoginState({final bool isPasswordVisible}) =
      _$PasswordVisibilityLoginStateImpl;

  @override
  bool get isPasswordVisible;

  /// Create a copy of PasswordVisibilityLoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordVisibilityLoginStateImplCopyWith<
    _$PasswordVisibilityLoginStateImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
