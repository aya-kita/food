import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/app_router.dart';
import 'package:go_router/go_router.dart';

class PhotoAddScreen extends ConsumerWidget {
  const PhotoAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ADD PAGE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20), // スペース
                  ElevatedButton(
                    onPressed: () {
                      context.go('/list'); // ここに画面遷移のコードを挿入します
                    },
                    child: const Text("Go To List Screen"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
