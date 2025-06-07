import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// PhotoDetailScreen専用のFoodItem定義（外部ファイルとの依存をなくすため）
// ただし、本来は共通のモデルファイルに定義するのが良いプラクティスです。
class FoodItemDetail {
  final String shopName;
  final String menuName;
  final String date;
  final String imageUrl;
  final String category;

  const FoodItemDetail({
    required this.shopName,
    required this.menuName,
    required this.date,
    required this.imageUrl,
    required this.category,
  });

  // MapからFoodItemDetailを生成するファクトリコンストラクタ
  // (もしGoRouterのextraでMapを受け取る場合に備えて残していますが、
  // 現状は直接使用されていません)
  factory FoodItemDetail.fromMap(Map<String, dynamic> map) {
    return FoodItemDetail(
      shopName: map['shopName'] as String,
      menuName: map['menuName'] as String,
      date: map['date'] as String,
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
    );
  }
}

class PhotoDetailScreen extends ConsumerWidget {
  // item をコンストラクタで受け取らず、内部でダミーデータを持つように変更
  const PhotoDetailScreen({super.key});

  // 表示用のダミーデータ。このデータが画面に表示されます。
  final FoodItemDetail _dummyItem = const FoodItemDetail(
    shopName: '〇〇喫茶店',
    menuName: '〇〇',
    date: '2025.06.04',
    imageUrl: 'images/food_dummy_1.png', // この画像はassetsに追加してください
    category: '洋食',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 表示するデータをダミーデータに固定
    final FoodItemDetail currentItem = _dummyItem;

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
          // 背景画像の上に薄い背景色を重ねることで、UI要素を見やすくする
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 中央揃え
                children: [
                  // ヘッダー部分 (戻る、編集、削除アイコン)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          // 前の画面に戻る（GoRouterで）
                          context.go('/list');
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              context.go('/edit');
                              // 編集画面への遷移など、実際の処理をここに記述
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              print('削除ボタンが押されました');
                              // 削除処理をここに記述
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), // 上部余白

                  // コンテンツ部分
                  Text(
                    currentItem.shopName, // ダミーデータを表示
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentItem.menuName, // ダミーデータを表示
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentItem.date, // ダミーデータを表示
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // カテゴリー表示
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade700, // UI画像の色に合わせる
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      currentItem.category, // ダミーデータを表示
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // 写真表示
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      currentItem.imageUrl, // ダミーデータを表示
                      fit: BoxFit.cover,
                      height: 250, // 画像の高さを固定
                      width:
                          MediaQuery.of(context).size.width * 0.8, // 幅を画面の80%に
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.grey, size: 80),
                        );
                      },
                    ),
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
