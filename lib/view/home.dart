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
              child: GestureDetector(
                onTap: () {
                  context.go('/list');
                },
                child: Text(
                  '画面一杯に画像',
                  style: TextStyle(
                    color: Colors.white,
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
