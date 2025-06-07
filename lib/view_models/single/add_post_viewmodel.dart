import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  // 投稿を送信するメソッド
  Future<void> submitPost(File imageFile) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);// 投稿の送信状態を更新
    try {
      final uploadedImageUrl = await uploadImage(imageFile);// 画像をアップロードしてURLを取得
      state = state.copyWith(
        draft: state.draft.copyWith(imageUrl: uploadedImageUrl),// 投稿の下書き状態を更新
      );

      // 実際の投稿処理を行う（例: API呼び出し）
      await _postToServer(state.draft);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());//失敗したとき
    } finally {
      state = state.copyWith(isSubmitting: false);//成功しても失敗しても、isSubmitting(投稿中)をfalseに戻す
    }
  }

  Future<String> uploadImage(File file) async {
  final uri = Uri.parse('http://127.0.0.1:8000:8000/posts/');
  final request = http.MultipartRequest('POST', uri);


  request.files.add(await http.MultipartFile.fromPath(
    'file', // FastAPIで指定したフィールド名と一致させる
    file.path,
    contentType: MediaType('image', 'jpeg'),
  ));

  final response = await request.send();

  if (response.statusCode == 200) {
    final responseBody = await response.stream.bytesToString();
    final imageUrl = RegExp(r'"imageUrl"\s*:\s*"([^"]+)"')
        .firstMatch(responseBody)
        ?.group(1);
    if (imageUrl != null) {
      return imageUrl;
    } else {
      throw Exception("画像URLがレスポンスから取得できませんでした");
    }
  } else {
    throw Exception("画像のアップロードに失敗しました: ${response.statusCode}");
  }
}

  Future<void> _postToServer(Post post) async {
    final uri = Uri.parse('http://localhost:8000/posts/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: post.toJson(), // toJson()がMapならjsonEncode(post.toJson())に
    );
    if (response.statusCode != 200) {
      throw Exception('投稿に失敗しました');
    }
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

