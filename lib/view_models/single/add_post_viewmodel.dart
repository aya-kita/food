import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:food/models/post.dart';
import 'package:food/state/add_post_state.dart';

part 'add_post_viewmodel.g.dart';


@Riverpod(keepAlive: true)
class AddPostViewModel extends _$AddPostViewModel {
  @override
  
  //初期の条件を定義
  AddPostState build() {
    return const AddPostState(
      draft: Post(username: '', title: '', imageUrl: ''),
    );
  }
  
  // ユーザー名、タイトル、画像URLを更新するメソッド
  void updateDraft({String? username, String? title, String? imageUrl}) {
      var updated = state.draft;

      if (username != null) {
        updated = updated.copyWith(username: username);
      }
      if (title != null) {
        updated = updated.copyWith(title: title);
      }
      if (imageUrl != null) {
        updated = updated.copyWith(imageUrl: imageUrl);
      }

      state = state.copyWith(draft: updated);
    }

  
  // 画像ファイルを追加するメソッド
  void addFile(File file) {
    state = state.copyWith(file: file);
  }

  Future<void> submitPost(File imageFile) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final uploadedImageUrl = await uploadImage(imageFile);
      state = state.copyWith(
        draft: state.draft.copyWith(imageUrl: uploadedImageUrl),
      );

      // 実際の投稿処理を行う（例: API呼び出し）
      await _postToServer(state.draft);
    } catch (e, stack) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  Future<String> uploadImage(File file) async {
    // TODO: 実際のアップロード処理に差し替える
    await Future.delayed(Duration(seconds: 1));
    return 'https://example.com/uploaded_image.jpg';
  }

  Future<void> _postToServer(Post post) async {
    // TODO: 実際の投稿処理（API呼び出しなど）
    await Future.delayed(Duration(seconds: 1));
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
  //投稿の下書き状態（draft）を初期値（空の状態）に戻す
  void resetDraft() {
    state = state.copyWith(
      draft: const Post(username: '', title: '', imageUrl: ''),
    );
  }
} 

