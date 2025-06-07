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
      draft: Post(id:0,username: '', title: '', imageUrl: '',created_at: DateTime.now()),

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
    print('submitPost: Method started.'); // 追加
    if (state.file == null) {
      state = state.copyWith(errorMessage: "画像ファイルが選択されていません");
      print('submitPost: No file selected, returning.'); // 追加
      return;
    }
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    print('submitPost: isSubmitting set to true.'); // 追加

    try {
      print('submitPost: Attempting to upload image...'); // 追加
      final uploadedImageUrl = await _uploadImage(state.file!);
      print('submitPost: Image uploaded. URL: $uploadedImageUrl'); // 追加

      var updatedDraft = state.draft.copyWith(imageUrl: uploadedImageUrl);
      print('submitPost: Draft updated with imageUrl: ${updatedDraft.imageUrl}'); // 追加

      print('submitPost: Attempting to post to server...'); // 追加
      await _postToServer(updatedDraft);
      print('submitPost: Post to server successful.'); // 追加

      resetDraft();
      print('submitPost: Draft reset.'); // 追加

    } catch (e) {
      print('submitPost: Error caught: $e'); // ここにエラーが出たら原因が分かる
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      print('submitPost: Finally block executed. isSubmitting set to false.'); // 追加
      state = state.copyWith(isSubmitting: false);
    }
  }

  // _postToServer メソッドの中にも念のためログを追加
  Future<void> _postToServer(Post post) async {
    final uri = Uri.parse('http://127.0.0.1:8000/posts/');
    print('_postToServer: Sending POST request to: $uri'); // 追加
    print('_postToServer: Request body: ${jsonEncode(post.toJson())}'); // 追加
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
    print('_postToServer: Response status code: ${response.statusCode}'); // 追加
    print('_postToServer: Response body: ${response.body}'); // 追加
    if (response.statusCode != 200) {
      print('_postToServer: Post failed with status: ${response.statusCode}'); // 追加
      throw Exception('投稿に失敗しました: ${response.statusCode}');
    }
    print('_postToServer: Post successful.'); // 追加
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
      // ↓↓↓ ここを修正します ↓↓↓
      if (json.containsKey('url')) return json['url'] as String; // 'imageUrl' を 'url' に変更
      // ↑↑↑ ここを修正します ↑↑↑
      throw Exception("画像URLがレスポンスから取得できませんでした");
    } else {
      throw Exception("画像のアップロードに失敗しました: ${response.statusCode}");
    }
  }
  void resetDraft() {
    state = state.copyWith(
      draft: Post(id:0,username: '', title: '', imageUrl: '', created_at: DateTime.now()),
      file: null,
    );
  }
}
