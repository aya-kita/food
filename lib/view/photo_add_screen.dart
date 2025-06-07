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
    final viewModel = ref.read(addPostViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('投稿画面')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ユーザー名入力
            TextField(
              decoration: const InputDecoration(labelText: 'ユーザー名'),
              onChanged: (value) => viewModel.updateDraft(username: value),
            ),
            const SizedBox(height: 16),

            // タイトル入力
            TextField(
              decoration: const InputDecoration(labelText: 'タイトル'),
              onChanged: (value) => viewModel.updateDraft(title: value),
            ),
            const SizedBox(height: 16),

            // 画像プレビュー
            if (state.file != null)
              Image.file(state.file!, height: 150)
            else
              const Text('画像が選択されていません'),
            const SizedBox(height: 16),

            // 画像選択ボタン
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final XFile? picked =
                    await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  viewModel.addFile(File(picked.path));
                }
              },
              child: const Text('画像を選択'),
            ),
            const SizedBox(height: 16),

            // 投稿ボタン
            ElevatedButton(
              onPressed: state.isSubmitting || state.file == null
                  ? null
                  : () async {
                      await viewModel.submitPost(state.file!);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('投稿が完了しました')),
                        );
                        viewModel.resetDraft(); // 投稿後にリセット
                      }
                    },
              child: state.isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('投稿する'),
            ),

            // エラーメッセージ
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
