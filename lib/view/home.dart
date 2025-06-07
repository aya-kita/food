import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/app_router.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('images/restaurant_pixel_art.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 25, top: 470, right: 20),
                child: GestureDetector(
                  onTap: () {
                    // メニュー表をタップしたら閲覧画面へ遷移
                    context.go('/list');
                  },
                  child: Column(
                    // アイコンとテキストを縦に並べる
                    mainAxisSize: MainAxisSize.min, // 必要なサイズだけ占める
                    children: [
                      const Text(
                        'MENU',
                        style: TextStyle(
                          color: Color.fromARGB(255, 61, 37, 37),
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // テキストサイズを調整
                          shadows: [
                            // テキストにも影をつける
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 0), // アイコンとテキストの間隔
                      Icon(
                        Icons.menu_book, // 開いている本のアイコン
                        color: const Color.fromARGB(255, 61, 37, 37), // アイコンの色
                        size: 110, // アイコンのサイズを大きくする
                        shadows: [
                          // 影をつけて少し立体感を出す
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
            ),
          ],
        ),
      ),
    );
  }
}

/*
app_routerに画面遷移を定義
画面遷移の例：
return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/add');←ボタンを押したらadd画面に遷移するように設定
          },
          child: const Text(
            "Go To About Screen",
          ),
        ),
      ),
    );
*/
