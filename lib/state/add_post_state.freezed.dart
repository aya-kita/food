// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_post_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddPostState {
  Post get draft;
  File? get file;
  bool get isSubmitting;
  String? get errorMessage;

  /// Create a copy of AddPostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddPostStateCopyWith<AddPostState> get copyWith =>
      _$AddPostStateCopyWithImpl<AddPostState>(
          this as AddPostState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddPostState &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, draft, file, isSubmitting, errorMessage);

  @override
  String toString() {
    return 'AddPostState(draft: $draft, file: $file, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $AddPostStateCopyWith<$Res> {
  factory $AddPostStateCopyWith(
          AddPostState value, $Res Function(AddPostState) _then) =
      _$AddPostStateCopyWithImpl;
  @useResult
  $Res call({Post draft, File? file, bool isSubmitting, String? errorMessage});

  $PostCopyWith<$Res> get draft;
}

/// @nodoc
class _$AddPostStateCopyWithImpl<$Res> implements $AddPostStateCopyWith<$Res> {
  _$AddPostStateCopyWithImpl(this._self, this._then);

  final AddPostState _self;
  final $Res Function(AddPostState) _then;

  /// Create a copy of AddPostState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draft = null,
    Object? file = freezed,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      draft: null == draft
          ? _self.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as Post,
      file: freezed == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of AddPostState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostCopyWith<$Res> get draft {
    return $PostCopyWith<$Res>(_self.draft, (value) {
      return _then(_self.copyWith(draft: value));
    });
  }
}

/// @nodoc

class _AddPostState implements AddPostState {
  const _AddPostState(
      {required this.draft,
      this.file,
      this.isSubmitting = false,
      this.errorMessage});

  @override
  final Post draft;
  @override
  final File? file;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? errorMessage;

  /// Create a copy of AddPostState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddPostStateCopyWith<_AddPostState> get copyWith =>
      __$AddPostStateCopyWithImpl<_AddPostState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddPostState &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, draft, file, isSubmitting, errorMessage);

  @override
  String toString() {
    return 'AddPostState(draft: $draft, file: $file, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$AddPostStateCopyWith<$Res>
    implements $AddPostStateCopyWith<$Res> {
  factory _$AddPostStateCopyWith(
          _AddPostState value, $Res Function(_AddPostState) _then) =
      __$AddPostStateCopyWithImpl;
  @override
  @useResult
  $Res call({Post draft, File? file, bool isSubmitting, String? errorMessage});

  @override
  $PostCopyWith<$Res> get draft;
}

/// @nodoc
class __$AddPostStateCopyWithImpl<$Res>
    implements _$AddPostStateCopyWith<$Res> {
  __$AddPostStateCopyWithImpl(this._self, this._then);

  final _AddPostState _self;
  final $Res Function(_AddPostState) _then;

  /// Create a copy of AddPostState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? draft = null,
    Object? file = freezed,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_AddPostState(
      draft: null == draft
          ? _self.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as Post,
      file: freezed == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of AddPostState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostCopyWith<$Res> get draft {
    return $PostCopyWith<$Res>(_self.draft, (value) {
      return _then(_self.copyWith(draft: value));
    });
  }
}

// dart format on
