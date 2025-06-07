import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 表示するアイテムのダミーデータモデル
class FoodItem {
  final String shopName;
  final String menuName;
  final String date;
  final String imageUrl; // ローカルアセットまたはネットワークURL

  FoodItem({
    required this.shopName,
    required this.menuName,
    required this.date,
    required this.imageUrl,
  });
}

class PhotoListScreen extends ConsumerWidget {
  PhotoListScreen({super.key});

  // ダミーデータ
  final List<FoodItem> _dummyItems = [
    FoodItem(
      shopName: '〇〇喫茶店',
      menuName: '〇〇',
      date: '2025.06.04',
      imageUrl: 'images/dish1.png', // この画像はassetsに追加してください
    ),
    FoodItem(
      shopName: '〇〇喫茶店',
      menuName: '〇〇',
      date: '2025.06.04',
      imageUrl: 'images/dish2.png', // この画像はassetsに追加してください
    ),
    FoodItem(
      shopName: '〇〇喫茶店',
      menuName: '〇〇',
      date: '2025.06.04',
      imageUrl: 'images/dish3.png', // この画像はassetsに追加してください
    ),
    FoodItem(
      shopName: '〇〇喫茶店',
      menuName: '〇〇',
      date: '2025.06.04',
      imageUrl: 'images/dish4.png', // この画像はassetsに追加してください
    ),
    // 必要に応じてダミーデータを追加
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景画像
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'), // 元の背景画像を維持
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
                  decoration: BoxDecoration(
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
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          context.pop(); // 前の画面に戻る
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.brown[700], // UI画像の色に合わせる
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'カテゴリー選択',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          context.go('/add'); // 写真追加画面へ遷移
                        },
                      ),
                    ],
                  ),
                ),
                // コンテンツ部分 (リスト表示)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: AssetImage('images/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _dummyItems.length,
                      itemBuilder: (context, index) {
                        final item = _dummyItems[index];
                        // 奇数番目と偶数番目でレイアウトを反転
                        final bool isEven = index % 2 == 0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isEven) // 奇数番目はテキストが左
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end, // 右寄せ
                                    children: [
                                      Text(
                                        item.shopName,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        item.menuName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        item.date,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black38),
                                      ),
                                    ],
                                  ),
                                ),
                              if (!isEven) const SizedBox(width: 16),
                              Expanded(
                                flex: 2, // 画像を少し大きく
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 150, // 画像の高さを固定
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 150,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (isEven) const SizedBox(width: 16),
                              if (isEven) // 偶数番目はテキストが右
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 左寄せ
                                    children: [
                                      Text(
                                        item.shopName,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        item.menuName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        item.date,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black38),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // フッター部分 (ページネーション)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.black, size: 20),
                        onPressed: () {
                          print('前のページへ');
                        },
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.brown[700], // UI画像の色に合わせる
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          '1ページ目',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.black, size: 20),
                        onPressed: () {
                          print('次のページへ');
                        },
                      ),
                    ],
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
