// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_verification_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EmailVerificationEvent {
  String get email => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) sendOtpRequested,
    required TResult Function(String email, String otp) verifyOtpRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? sendOtpRequested,
    TResult? Function(String email, String otp)? verifyOtpRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? sendOtpRequested,
    TResult Function(String email, String otp)? verifyOtpRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendOtpRequested value) sendOtpRequested,
    required TResult Function(VerifyOtpRequested value) verifyOtpRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SendOtpRequested value)? sendOtpRequested,
    TResult? Function(VerifyOtpRequested value)? verifyOtpRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendOtpRequested value)? sendOtpRequested,
    TResult Function(VerifyOtpRequested value)? verifyOtpRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of EmailVerificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmailVerificationEventCopyWith<EmailVerificationEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailVerificationEventCopyWith<$Res> {
  factory $EmailVerificationEventCopyWith(
    EmailVerificationEvent value,
    $Res Function(EmailVerificationEvent) then,
  ) = _$EmailVerificationEventCopyWithImpl<$Res, EmailVerificationEvent>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$EmailVerificationEventCopyWithImpl<
  $Res,
  $Val extends EmailVerificationEvent
>
    implements $EmailVerificationEventCopyWith<$Res> {
  _$EmailVerificationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmailVerificationEvent
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
abstract class _$$SendOtpRequestedImplCopyWith<$Res>
    implements $EmailVerificationEventCopyWith<$Res> {
  factory _$$SendOtpRequestedImplCopyWith(
    _$SendOtpRequestedImpl value,
    $Res Function(_$SendOtpRequestedImpl) then,
  ) = __$$SendOtpRequestedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$SendOtpRequestedImplCopyWithImpl<$Res>
    extends _$EmailVerificationEventCopyWithImpl<$Res, _$SendOtpRequestedImpl>
    implements _$$SendOtpRequestedImplCopyWith<$Res> {
  __$$SendOtpRequestedImplCopyWithImpl(
    _$SendOtpRequestedImpl _value,
    $Res Function(_$SendOtpRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailVerificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _$SendOtpRequestedImpl(
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

class _$SendOtpRequestedImpl implements SendOtpRequested {
  const _$SendOtpRequestedImpl({required this.email});

  @override
  final String email;

  @override
  String toString() {
    return 'EmailVerificationEvent.sendOtpRequested(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendOtpRequestedImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of EmailVerificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendOtpRequestedImplCopyWith<_$SendOtpRequestedImpl> get copyWith =>
      __$$SendOtpRequestedImplCopyWithImpl<_$SendOtpRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) sendOtpRequested,
    required TResult Function(String email, String otp) verifyOtpRequested,
  }) {
    return sendOtpRequested(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? sendOtpRequested,
    TResult? Function(String email, String otp)? verifyOtpRequested,
  }) {
    return sendOtpRequested?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? sendOtpRequested,
    TResult Function(String email, String otp)? verifyOtpRequested,
    required TResult orElse(),
  }) {
    if (sendOtpRequested != null) {
      return sendOtpRequested(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendOtpRequested value) sendOtpRequested,
    required TResult Function(VerifyOtpRequested value) verifyOtpRequested,
  }) {
    return sendOtpRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SendOtpRequested value)? sendOtpRequested,
    TResult? Function(VerifyOtpRequested value)? verifyOtpRequested,
  }) {
    return sendOtpRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendOtpRequested value)? sendOtpRequested,
    TResult Function(VerifyOtpRequested value)? verifyOtpRequested,
    required TResult orElse(),
  }) {
    if (sendOtpRequested != null) {
      return sendOtpRequested(this);
    }
    return orElse();
  }
}

abstract class SendOtpRequested implements EmailVerificationEvent {
  const factory SendOtpRequested({required final String email}) =
      _$SendOtpRequestedImpl;

  @override
  String get email;

  /// Create a copy of EmailVerificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendOtpRequestedImplCopyWith<_$SendOtpRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VerifyOtpRequestedImplCopyWith<$Res>
    implements $EmailVerificationEventCopyWith<$Res> {
  factory _$$VerifyOtpRequestedImplCopyWith(
    _$VerifyOtpRequestedImpl value,
    $Res Function(_$VerifyOtpRequestedImpl) then,
  ) = __$$VerifyOtpRequestedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String otp});
}

/// @nodoc
class __$$VerifyOtpRequestedImplCopyWithImpl<$Res>
    extends _$EmailVerificationEventCopyWithImpl<$Res, _$VerifyOtpRequestedImpl>
    implements _$$VerifyOtpRequestedImplCopyWith<$Res> {
  __$$VerifyOtpRequestedImplCopyWithImpl(
    _$VerifyOtpRequestedImpl _value,
    $Res Function(_$VerifyOtpRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailVerificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? otp = null}) {
    return _then(
      _$VerifyOtpRequestedImpl(
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

class _$VerifyOtpRequestedImpl implements VerifyOtpRequested {
  const _$VerifyOtpRequestedImpl({required this.email, required this.otp});

  @override
  final String email;
  @override
  final String otp;

  @override
  String toString() {
    return 'EmailVerificationEvent.verifyOtpRequested(email: $email, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyOtpRequestedImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, otp);

  /// Create a copy of EmailVerificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyOtpRequestedImplCopyWith<_$VerifyOtpRequestedImpl> get copyWith =>
      __$$VerifyOtpRequestedImplCopyWithImpl<_$VerifyOtpRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) sendOtpRequested,
    required TResult Function(String email, String otp) verifyOtpRequested,
  }) {
    return verifyOtpRequested(email, otp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? sendOtpRequested,
    TResult? Function(String email, String otp)? verifyOtpRequested,
  }) {
    return verifyOtpRequested?.call(email, otp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? sendOtpRequested,
    TResult Function(String email, String otp)? verifyOtpRequested,
    required TResult orElse(),
  }) {
    if (verifyOtpRequested != null) {
      return verifyOtpRequested(email, otp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendOtpRequested value) sendOtpRequested,
    required TResult Function(VerifyOtpRequested value) verifyOtpRequested,
  }) {
    return verifyOtpRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SendOtpRequested value)? sendOtpRequested,
    TResult? Function(VerifyOtpRequested value)? verifyOtpRequested,
  }) {
    return verifyOtpRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendOtpRequested value)? sendOtpRequested,
    TResult Function(VerifyOtpRequested value)? verifyOtpRequested,
    required TResult orElse(),
  }) {
    if (verifyOtpRequested != null) {
      return verifyOtpRequested(this);
    }
    return orElse();
  }
}

abstract class VerifyOtpRequested implements EmailVerificationEvent {
  const factory VerifyOtpRequested({
    required final String email,
    required final String otp,
  }) = _$VerifyOtpRequestedImpl;

  @override
  String get email;
  String get otp;

  /// Create a copy of EmailVerificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyOtpRequestedImplCopyWith<_$VerifyOtpRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
