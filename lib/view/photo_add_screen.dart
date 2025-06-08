import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food/view_models/single/add_post_viewmodel.dart';

class PhotoAddScreen extends ConsumerWidget {
  const PhotoAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addPostViewModelProvider);
    final notifier = ref.read(addPostViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('投稿')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (v) => notifier.updateDraft(username: v),
              decoration: InputDecoration(labelText: 'ユーザー名'),
            ),
            TextField(
              onChanged: (v) => notifier.updateDraft(title: v),
              decoration: InputDecoration(labelText: 'タイトル'),
            ),
            SizedBox(height: 16),
            if (state.file != null)
              Image.file(state.file!, height: 200)
            else
              Text('画像が選択されていません'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final picked =
                    await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  print("画像を選択しました: ${picked.path}");
                  notifier.addFile(File(picked.path));
                } else {
                  print("画像の選択をキャンセルしました");
                }
              },
              child: Text('画像を選択'),
            ),
            SizedBox(height: 16),
            if (state.errorMessage != null)
              Text(state.errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  state.isSubmitting ? null : () => notifier.submitPost(),
              child: state.isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('投稿'),
            ),
          ],
        ),
      ),
    );
  }
}
