// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_scroll_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AutoScrollState {
  bool get isScrolling => throw _privateConstructorUsedError;
  double get scrollPosition => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;

  /// Create a copy of AutoScrollState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutoScrollStateCopyWith<AutoScrollState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoScrollStateCopyWith<$Res> {
  factory $AutoScrollStateCopyWith(
    AutoScrollState value,
    $Res Function(AutoScrollState) then,
  ) = _$AutoScrollStateCopyWithImpl<$Res, AutoScrollState>;
  @useResult
  $Res call({bool isScrolling, double scrollPosition, int totalItems});
}

/// @nodoc
class _$AutoScrollStateCopyWithImpl<$Res, $Val extends AutoScrollState>
    implements $AutoScrollStateCopyWith<$Res> {
  _$AutoScrollStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutoScrollState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isScrolling = null,
    Object? scrollPosition = null,
    Object? totalItems = null,
  }) {
    return _then(
      _value.copyWith(
            isScrolling:
                null == isScrolling
                    ? _value.isScrolling
                    : isScrolling // ignore: cast_nullable_to_non_nullable
                        as bool,
            scrollPosition:
                null == scrollPosition
                    ? _value.scrollPosition
                    : scrollPosition // ignore: cast_nullable_to_non_nullable
                        as double,
            totalItems:
                null == totalItems
                    ? _value.totalItems
                    : totalItems // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AutoScrollStateImplCopyWith<$Res>
    implements $AutoScrollStateCopyWith<$Res> {
  factory _$$AutoScrollStateImplCopyWith(
    _$AutoScrollStateImpl value,
    $Res Function(_$AutoScrollStateImpl) then,
  ) = __$$AutoScrollStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isScrolling, double scrollPosition, int totalItems});
}

/// @nodoc
class __$$AutoScrollStateImplCopyWithImpl<$Res>
    extends _$AutoScrollStateCopyWithImpl<$Res, _$AutoScrollStateImpl>
    implements _$$AutoScrollStateImplCopyWith<$Res> {
  __$$AutoScrollStateImplCopyWithImpl(
    _$AutoScrollStateImpl _value,
    $Res Function(_$AutoScrollStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AutoScrollState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isScrolling = null,
    Object? scrollPosition = null,
    Object? totalItems = null,
  }) {
    return _then(
      _$AutoScrollStateImpl(
        isScrolling:
            null == isScrolling
                ? _value.isScrolling
                : isScrolling // ignore: cast_nullable_to_non_nullable
                    as bool,
        scrollPosition:
            null == scrollPosition
                ? _value.scrollPosition
                : scrollPosition // ignore: cast_nullable_to_non_nullable
                    as double,
        totalItems:
            null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc

class _$AutoScrollStateImpl implements _AutoScrollState {
  const _$AutoScrollStateImpl({
    this.isScrolling = true,
    this.scrollPosition = 0.0,
    this.totalItems = 50,
  });

  @override
  @JsonKey()
  final bool isScrolling;
  @override
  @JsonKey()
  final double scrollPosition;
  @override
  @JsonKey()
  final int totalItems;

  @override
  String toString() {
    return 'AutoScrollState(isScrolling: $isScrolling, scrollPosition: $scrollPosition, totalItems: $totalItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoScrollStateImpl &&
            (identical(other.isScrolling, isScrolling) ||
                other.isScrolling == isScrolling) &&
            (identical(other.scrollPosition, scrollPosition) ||
                other.scrollPosition == scrollPosition) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isScrolling, scrollPosition, totalItems);

  /// Create a copy of AutoScrollState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutoScrollStateImplCopyWith<_$AutoScrollStateImpl> get copyWith =>
      __$$AutoScrollStateImplCopyWithImpl<_$AutoScrollStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AutoScrollState implements AutoScrollState {
  const factory _AutoScrollState({
    final bool isScrolling,
    final double scrollPosition,
    final int totalItems,
  }) = _$AutoScrollStateImpl;

  @override
  bool get isScrolling;
  @override
  double get scrollPosition;
  @override
  int get totalItems;

  /// Create a copy of AutoScrollState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoScrollStateImplCopyWith<_$AutoScrollStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
