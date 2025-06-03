import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food/models/post.dart';
part 'add_post_state.freezed.dart';

@freezed
abstract class AddPostState with _$AddPostState {
  const factory AddPostState({
    required Post draft,
    File? file,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _AddPostState;
}
