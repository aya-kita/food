import 'dart:io'; // Fileクラスを使用するために必要
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:food/app_router.dart'; // go_routerが直接使えるため不要
import 'package:go_router/go_router.dart';
//import 'package:image_picker/image_picker.dart'; // 画像ピッカー用
//import 'package:intl/intl.dart'; // 日付フォーマット用

class PhotoAddScreen extends ConsumerStatefulWidget {
  // ConsumerStatefulWidget に変更
  const PhotoAddScreen({super.key});

  @override
  ConsumerState<PhotoAddScreen> createState() =>
      _PhotoAddScreenState(); // createState を変更
}

class _PhotoAddScreenState extends ConsumerState<PhotoAddScreen> {
  // ConsumerState に変更
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _menuNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedCategory;
  File? _selectedImage;
  DateTime? _selectedDate;

  final List<String> _categories = [
    '和食',
    '洋食',
    '中華',
    'カフェ',
    'その他',
  ];

  @override
  void dispose() {
    _shopNameController.dispose();
    _menuNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // 日付ピッカーを表示する関数
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('ja', 'JP'), // 日本語ロケールを設定
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        //_dateController.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  /* 画像ピッカーを表示する関数
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // galleryまたはcamera
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  */

  // 保存ボタンが押された時の処理 (現時点ではダミー)
  void _saveItem() {
    print('店名: ${_shopNameController.text}');
    print('メニュー名: ${_menuNameController.text}');
    print('日付: ${_dateController.text}');
    print('カテゴリ: $_selectedCategory');
    print('画像パス: ${_selectedImage?.path}');

    // 保存後に前の画面に戻る
    context.pop(); // GoRouterで前の画面に戻る
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarはScaffoldのappBarプロパティで設定
      appBar: AppBar(
        title: const Text(
          '追加画面',
          style: TextStyle(color: Colors.black), // 文字色を黒に
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // アイコン色を黒に
          onPressed: () {
            context.go('/list'); // GoRouterで前の画面に戻る
          },
        ),
        backgroundColor: const Color(0xFFF8F5EC), // AppBarの背景色を本体の背景色に合わせる
        elevation: 0, // 影をなくす
      ),
      body: Stack(
        children: [
          // 元の背景画像
          Container(
            decoration: const BoxDecoration(
              // color: Colors.black, // 背景画像があるので不要か、調整
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // オーバーレイでUI要素を配置
          SafeArea(
            child: Container(
              // 背景画像の上に薄い背景色を重ねることで、UI要素を見やすくする
              color: const Color(0xFFF8F5EC).withOpacity(0.9), // 背景画像の上に重ねる色
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 店名入力
                    TextField(
                      controller: _shopNameController,
                      decoration: const InputDecoration(
                        labelText: '店名',
                        hintText: '店名を入力してください',
                        border: UnderlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.black), // ラベルの色
                        hintStyle: TextStyle(color: Colors.grey), // ヒントの色
                        enabledBorder: UnderlineInputBorder(
                          // 通常時の下線
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          // フォーカス時の下線
                          borderSide: BorderSide(color: Colors.red), // UIに合わせた色
                        ),
                      ),
                      style: const TextStyle(color: Colors.black), // 入力文字の色
                    ),
                    const SizedBox(height: 20),

                    // メニュー名入力
                    TextField(
                      controller: _menuNameController,
                      decoration: const InputDecoration(
                        labelText: 'メニュー名',
                        hintText: 'メニュー名を入力してください',
                        border: UnderlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),

                    // 日付選択
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            labelText: '日付',
                            hintText: '日付を選択してください',
                            border: UnderlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today,
                                color: Colors.black), // アイコンの色
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // カテゴリ選択
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      hint: const Text(
                        'カテゴリー選択',
                        style: TextStyle(color: Colors.black), // ヒントの色
                      ),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black), // アイコンの色
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      items: _categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                color: Colors.black), // ドロップダウン項目の文字色
                          ),
                        );
                      }).toList(),
                      dropdownColor:
                          const Color(0xFFF8F5EC), // ドロップダウンメニュー自体の背景色
                    ),
                    const SizedBox(height: 30),

                    // 画像選択エリア
                    GestureDetector(
                      //onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: _selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.orange[300],
                                    size: 80,
                                  ),
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.orange[300],
                                    size: 30,
                                  ),
                                ],
                              )
                            : ClipRRect(
                                // 画像がコンテナからはみ出さないようにクリップ
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 保存ボタン
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          '保存',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
