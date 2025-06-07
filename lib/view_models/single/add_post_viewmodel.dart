// add_post_viewmodel.dart
import 'dart:io';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:food/models/post.dart';
import 'package:food/state/add_post_state.dart';

part 'add_post_viewmodel.g.dart';

@riverpod
class AddPostViewModel extends _$AddPostViewModel {
  @override
  AddPostState build() {
    return AddPostState(
      draft: Post(username: '', title: '', imageUrl: ''),
    );
  }

  void updateDraft({String? username, String? title, String? imageUrl}) {
    var updated = state.draft;
    if (username != null) updated = updated.copyWith(username: username);
    if (title != null) updated = updated.copyWith(title: title);
    if (imageUrl != null) updated = updated.copyWith(imageUrl: imageUrl);

    state = state.copyWith(draft: updated);
  }

  void addFile(File file) {
  print('addFile called with path: ${file.path}');
  state = state.copyWith(file: file);
  print('state.file after update: ${state.file?.path}');
}

  Future<void> submitPost() async {
    print('submitPost called. state.file: ${state.file?.path}');
    if (state.file == null) {
      state = state.copyWith(errorMessage: "画像ファイルが選択されていません");
      return;
    }
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final uploadedImageUrl = await _uploadImage(state.file!);
      updateDraft(imageUrl: uploadedImageUrl);
      await _postToServer(state.draft);
      resetDraft();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  Future<String> _uploadImage(File file) async {
    final uri = Uri.parse("http://127.0.0.1:8000/upload-image/");
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType('image', 'jpg'),
    ));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> json = jsonDecode(responseBody);
      if (json.containsKey('imageUrl')) return json['imageUrl'] as String;
      throw Exception("画像URLがレスポンスから取得できませんでした");
    } else {
      throw Exception("画像のアップロードに失敗しました: ${response.statusCode}");
    }
  }

  Future<void> _postToServer(Post post) async {
    final uri = Uri.parse('http://127.0.0.1:8000/posts/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('投稿に失敗しました: ${response.statusCode}');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void resetDraft() {
    state = state.copyWith(
      draft: Post(username: '', title: '', imageUrl: ''),
      file: null,
    );
  }
}
