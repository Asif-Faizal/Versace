// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RegisterEvent {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String email,
      String password,
      String firstName,
      String lastName,
    )
    registerRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String email,
      String password,
      String firstName,
      String lastName,
    )?
    registerRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String email,
      String password,
      String firstName,
      String lastName,
    )?
    registerRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterRequested value) registerRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterRequested value)? registerRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterRequested value)? registerRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of RegisterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterEventCopyWith<RegisterEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterEventCopyWith<$Res> {
  factory $RegisterEventCopyWith(
    RegisterEvent value,
    $Res Function(RegisterEvent) then,
  ) = _$RegisterEventCopyWithImpl<$Res, RegisterEvent>;
  @useResult
  $Res call({String email, String password, String firstName, String lastName});
}

/// @nodoc
class _$RegisterEventCopyWithImpl<$Res, $Val extends RegisterEvent>
    implements $RegisterEventCopyWith<$Res> {
  _$RegisterEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? firstName = null,
    Object? lastName = null,
  }) {
    return _then(
      _value.copyWith(
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            password:
                null == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterRequestedImplCopyWith<$Res>
    implements $RegisterEventCopyWith<$Res> {
  factory _$$RegisterRequestedImplCopyWith(
    _$RegisterRequestedImpl value,
    $Res Function(_$RegisterRequestedImpl) then,
  ) = __$$RegisterRequestedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password, String firstName, String lastName});
}

/// @nodoc
class __$$RegisterRequestedImplCopyWithImpl<$Res>
    extends _$RegisterEventCopyWithImpl<$Res, _$RegisterRequestedImpl>
    implements _$$RegisterRequestedImplCopyWith<$Res> {
  __$$RegisterRequestedImplCopyWithImpl(
    _$RegisterRequestedImpl _value,
    $Res Function(_$RegisterRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? firstName = null,
    Object? lastName = null,
  }) {
    return _then(
      _$RegisterRequestedImpl(
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        password:
            null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc

class _$RegisterRequestedImpl implements RegisterRequested {
  const _$RegisterRequestedImpl({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  final String email;
  @override
  final String password;
  @override
  final String firstName;
  @override
  final String lastName;

  @override
  String toString() {
    return 'RegisterEvent.registerRequested(email: $email, password: $password, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestedImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, firstName, lastName);

  /// Create a copy of RegisterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestedImplCopyWith<_$RegisterRequestedImpl> get copyWith =>
      __$$RegisterRequestedImplCopyWithImpl<_$RegisterRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String email,
      String password,
      String firstName,
      String lastName,
    )
    registerRequested,
  }) {
    return registerRequested(email, password, firstName, lastName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String email,
      String password,
      String firstName,
      String lastName,
    )?
    registerRequested,
  }) {
    return registerRequested?.call(email, password, firstName, lastName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String email,
      String password,
      String firstName,
      String lastName,
    )?
    registerRequested,
    required TResult orElse(),
  }) {
    if (registerRequested != null) {
      return registerRequested(email, password, firstName, lastName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterRequested value) registerRequested,
  }) {
    return registerRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterRequested value)? registerRequested,
  }) {
    return registerRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterRequested value)? registerRequested,
    required TResult orElse(),
  }) {
    if (registerRequested != null) {
      return registerRequested(this);
    }
    return orElse();
  }
}

abstract class RegisterRequested implements RegisterEvent {
  const factory RegisterRequested({
    required final String email,
    required final String password,
    required final String firstName,
    required final String lastName,
  }) = _$RegisterRequestedImpl;

  @override
  String get email;
  @override
  String get password;
  @override
  String get firstName;
  @override
  String get lastName;

  /// Create a copy of RegisterEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterRequestedImplCopyWith<_$RegisterRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
