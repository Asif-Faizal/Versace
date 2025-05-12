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
  int get currentIndex => throw _privateConstructorUsedError;
  bool get isScrolling => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  double get textWidth => throw _privateConstructorUsedError;

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
  $Res call({
    int currentIndex,
    bool isScrolling,
    int totalItems,
    double textWidth,
  });
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
    Object? currentIndex = null,
    Object? isScrolling = null,
    Object? totalItems = null,
    Object? textWidth = null,
  }) {
    return _then(
      _value.copyWith(
            currentIndex:
                null == currentIndex
                    ? _value.currentIndex
                    : currentIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            isScrolling:
                null == isScrolling
                    ? _value.isScrolling
                    : isScrolling // ignore: cast_nullable_to_non_nullable
                        as bool,
            totalItems:
                null == totalItems
                    ? _value.totalItems
                    : totalItems // ignore: cast_nullable_to_non_nullable
                        as int,
            textWidth:
                null == textWidth
                    ? _value.textWidth
                    : textWidth // ignore: cast_nullable_to_non_nullable
                        as double,
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
  $Res call({
    int currentIndex,
    bool isScrolling,
    int totalItems,
    double textWidth,
  });
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
    Object? currentIndex = null,
    Object? isScrolling = null,
    Object? totalItems = null,
    Object? textWidth = null,
  }) {
    return _then(
      _$AutoScrollStateImpl(
        currentIndex:
            null == currentIndex
                ? _value.currentIndex
                : currentIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        isScrolling:
            null == isScrolling
                ? _value.isScrolling
                : isScrolling // ignore: cast_nullable_to_non_nullable
                    as bool,
        totalItems:
            null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                    as int,
        textWidth:
            null == textWidth
                ? _value.textWidth
                : textWidth // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc

class _$AutoScrollStateImpl implements _AutoScrollState {
  const _$AutoScrollStateImpl({
    this.currentIndex = 0,
    this.isScrolling = false,
    this.totalItems = 0,
    this.textWidth = 0.0,
  });

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final bool isScrolling;
  @override
  @JsonKey()
  final int totalItems;
  @override
  @JsonKey()
  final double textWidth;

  @override
  String toString() {
    return 'AutoScrollState(currentIndex: $currentIndex, isScrolling: $isScrolling, totalItems: $totalItems, textWidth: $textWidth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoScrollStateImpl &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.isScrolling, isScrolling) ||
                other.isScrolling == isScrolling) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.textWidth, textWidth) ||
                other.textWidth == textWidth));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentIndex,
    isScrolling,
    totalItems,
    textWidth,
  );

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
    final int currentIndex,
    final bool isScrolling,
    final int totalItems,
    final double textWidth,
  }) = _$AutoScrollStateImpl;

  @override
  int get currentIndex;
  @override
  bool get isScrolling;
  @override
  int get totalItems;
  @override
  double get textWidth;

  /// Create a copy of AutoScrollState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoScrollStateImplCopyWith<_$AutoScrollStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
