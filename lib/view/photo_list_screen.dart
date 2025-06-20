import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:food/view_models/multi/photo_list_view_model.dart';

class PhotoListScreen extends ConsumerWidget {
  PhotoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginatedPostsAsyncValue = ref.watch(postListViewModelProvider); // 型が変わる
    final viewModel = ref.read(postListViewModelProvider.notifier); // リフレッシュ用

    return Scaffold(
      body: Stack(
        children: [
          // 背景画像
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // オーバーレイでUI要素を配置
          SafeArea(
            child: Column(
              children: [
                // ヘッダー部分 (戻るボタン、カテゴリ選択、追加ボタン)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.brown),
                        onPressed: () {
                          context.go('/');
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print('');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.brown[700],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'メニュー',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: Colors.brown, size: 30),
                        onPressed: () {
                          context.go('/add');
                        },
                      ),
                    ],
                  ),
                ),
                // コンテンツ部分 (リスト表示)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: AssetImage('images/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: paginatedPostsAsyncValue.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('エラー: $err',
                                style: const TextStyle(color: Colors.red)),
                            ElevatedButton(
                              onPressed: () => viewModel.refreshPosts(),
                              child: const Text('再試行'),
                            ),
                          ],
                        ),
                      ),
                      data: (paginatedPosts) {
                        final posts = paginatedPosts.posts;
                        if (posts.isEmpty) {
                          return const Center(
                              child: Text('投稿がありません',
                                  style: TextStyle(color: Colors.white)));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final bool isEven = index % 2 == 0;

                            final formattedDate = DateFormat('yyyy.MM.dd').format(post.created_at);

                            final imageUrl =
                                'http://127.0.0.1:8000${post.imageUrl}';

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isEven)
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          height: 130,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print(
                                                'Image load error: $error for URL: $imageUrl');
                                            return Container(
                                              height: 130,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  if (isEven) const SizedBox(width: 16),
                                  if (isEven)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.username,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                          ),
                                          Text(
                                            post.title,
                                            style: const TextStyle(fontSize: 16, color: Colors.brown),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(fontSize: 14, color: Colors.brown),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (!isEven)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            post.username,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                          ),
                                          Text(
                                            post.title,
                                            style: const TextStyle(fontSize: 16, color: Colors.brown),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(fontSize: 14, color: Colors.brown),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (!isEven) const SizedBox(width: 16),
                                  if (!isEven)
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          height: 130,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print(
                                                'Image load error: $error for URL: $imageUrl');
                                            return Container(
                                              height: 130,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                // フッター部分 (ページネーション)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: paginatedPostsAsyncValue.when(
                    loading: () => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                      ],
                    ),
                    error: (err, stack) => const SizedBox.shrink(),
                    data: (paginatedPosts) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
                            onPressed: paginatedPosts.hasPreviousPage
                                ? () => viewModel.goToPreviousPage()
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.brown[700],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '${paginatedPosts.currentPage} / ${paginatedPosts.totalPages} ページ',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: Colors.brown, size: 20),
                            onPressed: paginatedPosts.hasNextPage
                                ? () {
                                    viewModel.goToNextPage();
                                  }
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
