// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_details_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserDetailsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userDetailsRequested,
    required TResult Function(UpdateUserRequestModel updateUserRequestModel)
    updateUserDetailsRequested,
    required TResult Function() logoutRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userDetailsRequested,
    TResult? Function(UpdateUserRequestModel updateUserRequestModel)?
    updateUserDetailsRequested,
    TResult? Function()? logoutRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userDetailsRequested,
    TResult Function(UpdateUserRequestModel updateUserRequestModel)?
    updateUserDetailsRequested,
    TResult Function()? logoutRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserDetailsRequested value) userDetailsRequested,
    required TResult Function(UpdateUserDetailsRequested value)
    updateUserDetailsRequested,
    required TResult Function(LogoutRequested value) logoutRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserDetailsRequested value)? userDetailsRequested,
    TResult? Function(UpdateUserDetailsRequested value)?
    updateUserDetailsRequested,
    TResult? Function(LogoutRequested value)? logoutRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserDetailsRequested value)? userDetailsRequested,
    TResult Function(UpdateUserDetailsRequested value)?
    updateUserDetailsRequested,
    TResult Function(LogoutRequested value)? logoutRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDetailsEventCopyWith<$Res> {
  factory $UserDetailsEventCopyWith(
    UserDetailsEvent value,
    $Res Function(UserDetailsEvent) then,
  ) = _$UserDetailsEventCopyWithImpl<$Res, UserDetailsEvent>;
}

/// @nodoc
class _$UserDetailsEventCopyWithImpl<$Res, $Val extends UserDetailsEvent>
    implements $UserDetailsEventCopyWith<$Res> {
  _$UserDetailsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UserDetailsRequestedImplCopyWith<$Res> {
  factory _$$UserDetailsRequestedImplCopyWith(
    _$UserDetailsRequestedImpl value,
    $Res Function(_$UserDetailsRequestedImpl) then,
  ) = __$$UserDetailsRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserDetailsRequestedImplCopyWithImpl<$Res>
    extends _$UserDetailsEventCopyWithImpl<$Res, _$UserDetailsRequestedImpl>
    implements _$$UserDetailsRequestedImplCopyWith<$Res> {
  __$$UserDetailsRequestedImplCopyWithImpl(
    _$UserDetailsRequestedImpl _value,
    $Res Function(_$UserDetailsRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserDetailsRequestedImpl implements UserDetailsRequested {
  const _$UserDetailsRequestedImpl();

  @override
  String toString() {
    return 'UserDetailsEvent.userDetailsRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDetailsRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userDetailsRequested,
    required TResult Function(UpdateUserRequestModel updateUserRequestModel)
    updateUserDetailsRequested,
    required TResult Function() logoutRequested,
  }) {
    return userDetailsRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userDetailsRequested,
    TResult? Function(UpdateUserRequestModel updateUserRequestModel)?
    updateUserDetailsRequested,
    TResult? Function()? logoutRequested,
  }) {
    return userDetailsRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userDetailsRequested,
    TResult Function(UpdateUserRequestModel updateUserRequestModel)?
    updateUserDetailsRequested,
    TResult Function()? logoutRequested,
    required TResult orElse(),
  }) {
    if (userDetailsRequested != null) {
      return userDetailsRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserDetailsRequested value) userDetailsRequested,
    required TResult Function(UpdateUserDetailsRequested value)
    updateUserDetailsRequested,
    required TResult Function(LogoutRequested value) logoutRequested,
  }) {
    return userDetailsRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserDetailsRequested value)? userDetailsRequested,
    TResult? Function(UpdateUserDetailsRequested value)?
    updateUserDetailsRequested,
    TResult? Function(LogoutRequested value)? logoutRequested,
  }) {
    return userDetailsRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserDetailsRequested value)? userDetailsRequested,
    TResult Function(UpdateUserDetailsRequested value)?
    updateUserDetailsRequested,
    TResult Function(LogoutRequested value)? logoutRequested,
    required TResult orElse(),
  }) {
    if (userDetailsRequested != null) {
      return userDetailsRequested(this);
    }
    return orElse();
  }
}

abstract class UserDetailsRequested implements UserDetailsEvent {
  const factory UserDetailsRequested() = _$UserDetailsRequestedImpl;
}

/// @nodoc
abstract class _$$UpdateUserDetailsRequestedImplCopyWith<$Res> {
  factory _$$UpdateUserDetailsRequestedImplCopyWith(
    _$UpdateUserDetailsRequestedImpl value,
    $Res Function(_$UpdateUserDetailsRequestedImpl) then,
  ) = __$$UpdateUserDetailsRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UpdateUserRequestModel updateUserRequestModel});

  $UpdateUserRequestModelCopyWith<$Res> get updateUserRequestModel;
}

/// @nodoc
class __$$UpdateUserDetailsRequestedImplCopyWithImpl<$Res>
    extends
        _$UserDetailsEventCopyWithImpl<$Res, _$UpdateUserDetailsRequestedImpl>
    implements _$$UpdateUserDetailsRequestedImplCopyWith<$Res> {
  __$$UpdateUserDetailsRequestedImplCopyWithImpl(
    _$UpdateUserDetailsRequestedImpl _value,
    $Res Function(_$UpdateUserDetailsRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? updateUserRequestModel = null}) {
    return _then(
      _$UpdateUserDetailsRequestedImpl(
        null == updateUserRequestModel
            ? _value.updateUserRequestModel
            : updateUserRequestModel // ignore: cast_nullable_to_non_nullable
                as UpdateUserRequestModel,
      ),
    );
  }

  /// Create a copy of UserDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateUserRequestModelCopyWith<$Res> get updateUserRequestModel {
    return $UpdateUserRequestModelCopyWith<$Res>(
      _value.updateUserRequestModel,
      (value) {
        return _then(_value.copyWith(updateUserRequestModel: value));
      },
    );
  }
}

/// @nodoc

class _$UpdateUserDetailsRequestedImpl implements UpdateUserDetailsRequested {
  const _$UpdateUserDetailsRequestedImpl(this.updateUserRequestModel);

  @override
  final UpdateUserRequestModel updateUserRequestModel;

  @override
  String toString() {
    return 'UserDetailsEvent.updateUserDetailsRequested(updateUserRequestModel: $updateUserRequestModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserDetailsRequestedImpl &&
            (identical(other.updateUserRequestModel, updateUserRequestModel) ||
                other.updateUserRequestModel == updateUserRequestModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, updateUserRequestModel);

  /// Create a copy of UserDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserDetailsRequestedImplCopyWith<_$UpdateUserDetailsRequestedImpl>
  get copyWith => __$$UpdateUserDetailsRequestedImplCopyWithImpl<
    _$UpdateUserDetailsRequestedImpl
  >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userDetailsRequested,
    required TResult Function(UpdateUserRequestModel updateUserRequestModel)
    updateUserDetailsRequested,
    required TResult Function() logoutRequested,
  }) {
    return updateUserDetailsRequested(updateUserRequestModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userDetailsRequested,
    TResult? Function(UpdateUserRequestModel updateUserRequestModel)?
    updateUserDetailsRequested,
    TResult? Function()? logoutRequested,
  }) {
    return updateUserDetailsRequested?.call(updateUserRequestModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userDetailsRequested,
    TResult Function(UpdateUserRequestModel updateUserRequestModel)?
    updateUserDetailsRequested,
    TResult Function()? logoutRequested,
    required TResult orElse(),
  }) {
    if (updateUserDetailsRequested != null) {
      return updateUserDetailsRequested(updateUserRequestModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserDetailsRequested value) userDetailsRequested,
    required TResult Function(UpdateUserDetailsRequested value)
    updateUserDetailsRequested,
    required TResult Function(LogoutRequested value) logoutRequested,
  }) {
    return updateUserDetailsRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserDetailsRequested value)? userDetailsRequested,
    TResult? Function(UpdateUserDetailsRequested value)?
    updateUserDetailsRequested,
    TResult? Function(LogoutRequested value)? logoutRequested,
  }) {
    return updateUserDetailsRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserDetailsRequested value)? userDetailsRequested,
    TResult Function(UpdateUserDetailsRequested value)?
    updateUserDetailsRequested,
    TResult Function(LogoutRequested value)? logoutRequested,
    required TResult orElse(),
  }) {
    if (updateUserDetailsRequested != null) {
      return updateUserDetailsRequested(this);
    }
    return orElse();
  }
}

abstract class UpdateUserDetailsRequested implements UserDetailsEvent {
  const factory UpdateUserDetailsRequested(
    final UpdateUserRequestModel updateUserRequestModel,
  ) = _$UpdateUserDetailsRequestedImpl;

  UpdateUserRequestModel get updateUserRequestModel;

  /// Create a copy of UserDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserDetailsRequestedImplCopyWith<_$UpdateUserDetailsRequestedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LogoutRequestedImplCopyWith<$Res> {
  factory _$$LogoutRequestedImplCopyWith(
    _$LogoutRequestedImpl value,
    $Res Function(_$LogoutRequestedImpl) then,
  ) = __$$LogoutRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LogoutRequestedImplCopyWithImpl<$Res>
    extends _$UserDetailsEventCopyWithImpl<$Res, _$LogoutRequestedImpl>
    implements _$$LogoutRequestedImplCopyWith<$Res> {
  __$$LogoutRequestedImplCopyWithImpl(
    _$LogoutRequestedImpl _value,
    $Res Function(_$LogoutRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LogoutRequestedImpl implements LogoutRequested {
  const _$LogoutRequestedImpl();

  @override
  String toString() {
    return 'UserDetailsEvent.logoutRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LogoutRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userDetailsRequested,
    required TResult Function(UpdateUserRequestModel updateUserRequestModel)
    updateUserDetailsRequested,
    required TResult Function() logoutRequested,
  }) {
    return logoutRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userDetailsRequested,
    TResult? Function(UpdateUserRequestModel updateUserRequestModel)?
    updateUserDetailsRequested,
    TResult? Function()? logoutRequested,
  }) {
    return logoutRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userDetailsRequested,
    TResult Function(UpdateUserRequestModel updateUserRequestModel)?
    updateUserDetailsRequested,
    TResult Function()? logoutRequested,
    required TResult orElse(),
  }) {
    if (logoutRequested != null) {
      return logoutRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserDetailsRequested value) userDetailsRequested,
    required TResult Function(UpdateUserDetailsRequested value)
    updateUserDetailsRequested,
    required TResult Function(LogoutRequested value) logoutRequested,
  }) {
    return logoutRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserDetailsRequested value)? userDetailsRequested,
    TResult? Function(UpdateUserDetailsRequested value)?
    updateUserDetailsRequested,
    TResult? Function(LogoutRequested value)? logoutRequested,
  }) {
    return logoutRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserDetailsRequested value)? userDetailsRequested,
    TResult Function(UpdateUserDetailsRequested value)?
    updateUserDetailsRequested,
    TResult Function(LogoutRequested value)? logoutRequested,
    required TResult orElse(),
  }) {
    if (logoutRequested != null) {
      return logoutRequested(this);
    }
    return orElse();
  }
}

abstract class LogoutRequested implements UserDetailsEvent {
  const factory LogoutRequested() = _$LogoutRequestedImpl;
}
