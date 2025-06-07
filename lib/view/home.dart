import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 吹き出しの表示状態と内容を管理するStateProvider
final StateProvider<String?> masterSpeechProvider =
    StateProvider<String?>((ref) => null);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // 仮のドリンク提案メソッド (Google Colab連携のPlaceholder)
  Future<String> _suggestDrink() async {
    await Future.delayed(const Duration(seconds: 1)); // ネットワーク遅延をシミュレート
    final List<String> drinks = [
      'スペシャルブレンドコーヒー',
      '季節のフルーツスムージー',
      '自家製レモネード',
      'カプチーノ',
      'ハーブティー',
    ];
    final int randomIndex = DateTime.now().millisecond % drinks.length;
    return drinks[randomIndex];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 画面のサイズを取得
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 吹き出しの表示内容を監視
    final String? masterSpeech = ref.watch(masterSpeechProvider);

    return Scaffold(
      body: Stack(
        children: [
          // 画面全体の背景画像
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage('images/restaurant_pixel_art.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // メニュー表ボタン (既存のコード)
          Positioned(
            left: screenWidth * 0.07,
            top: screenHeight * 0.625,
            child: GestureDetector(
              onTap: () {
                context.go('/list');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'MENU',
                    style: TextStyle(
                      color: Color.fromARGB(255, 61, 37, 37),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 0),
                  Icon(
                    Icons.menu_book,
                    color: const Color.fromARGB(255, 61, 37, 37),
                    size: 110,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // マスターのアイコンとドリンク提案機能
          Positioned(
            left: screenWidth * 0.70, // カウンターの位置に合わせて左からの距離を調整
            top: screenHeight * 0.50, // カウンターの位置に合わせて上からの距離を調整
            child: GestureDetector(
              onTap: () async {
                // 吹き出しの表示状態をクリア
                ref.read(masterSpeechProvider.notifier).state = null;
                // ドリンク提案処理を実行
                final String recommendedDrink = await _suggestDrink();
                // 吹き出しの内容を更新して表示
                ref.read(masterSpeechProvider.notifier).state =
                    recommendedDrink;

                // 3秒後に吹き出しを非表示にする
                Future.delayed(const Duration(seconds: 3), () {
                  if (ref.read(masterSpeechProvider) == recommendedDrink) {
                    // 同じメッセージの場合のみ非表示にする
                    ref.read(masterSpeechProvider.notifier).state = null;
                  }
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person, // 人のアイコン
                    color:
                        const Color.fromARGB(255, 228, 198, 190), // マスターに見立てた色
                    size: 80, // アイコンのサイズ
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'マスター',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ★吹き出しのUIを追加★
          if (masterSpeech != null) // masterSpeechがnullでない場合のみ表示
            Positioned(
              left: screenWidth * 0.50, // 吹き出しの左位置（マスターの右側に配置する想定）
              top: screenHeight * 0.40, // 吹き出しの上位置（マスターの頭上くらい）
              child: Container(
                padding: const EdgeInsets.all(12),
                constraints:
                    BoxConstraints(maxWidth: screenWidth * 0.4), // 吹き出しの最大幅
                decoration: BoxDecoration(
                  color: Colors.white, // 吹き出しの背景色
                  borderRadius: BorderRadius.circular(15), // 角丸
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '「$masterSpeech」はいかがですか？', // 提案内容をテキストに挿入
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
