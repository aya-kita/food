import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food/view_models/single/add_post_viewmodel.dart';


class PhotoAddScreen extends ConsumerStatefulWidget {
  const PhotoAddScreen({super.key});

  @override
  ConsumerState<PhotoAddScreen> createState() => _PhotoAddScreenState();
}

class _PhotoAddScreenState extends ConsumerState<PhotoAddScreen> {
  final _usernameController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      ref.read(addPostViewModelProvider.notifier).addFile(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addPostViewModelProvider);
    final notifier = ref.read(addPostViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿画面'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    onChanged: (v) => notifier.updateDraft(username: v),
                    decoration: const InputDecoration(
                      labelText: 'ユーザー名',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    onChanged: (v) => notifier.updateDraft(title: v),
                    decoration: const InputDecoration(
                      labelText: 'タイトル',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red[700],
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            //color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: state.file == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    color: Colors.orange[300], size: 80),
                                Icon(Icons.add_circle_outline,
                                    color: Colors.orange[300], size: 30),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(state.file!, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.errorMessage != null)
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: state.isSubmitting || state.file == null
                        ? null
                        : () async {
                            await notifier.submitPost(state.file!);
                            context.go('/list'); // 投稿後リストページへ遷移
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: state.isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('投稿する', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      notifier.resetDraft();
                      context.go('/list');
                    },
                    child: const Text('キャンセルして戻る'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
