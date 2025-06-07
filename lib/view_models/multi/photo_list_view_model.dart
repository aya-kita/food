// lib/view_models/multi/photo_list_view_model.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:food/models/post.dart'; // あなたのPostモデルのパスに合わせてください

part 'photo_list_view_model.g.dart'; // あなたのファイル名に合っていることを確認

/// ページネーションされた投稿データを保持するクラス
/// ViewModelのstateとして利用されます。
class PaginatedPosts {
  final List<Post> posts;
  final int currentPage;
  final int totalCount;
  final int itemsPerPage;

  PaginatedPosts({
    required this.posts,
    this.currentPage = 1,
    this.totalCount = 0,
    this.itemsPerPage = 10, // 1ページあたりのデフォルト表示件数
  });

  /// 現在のPaginatedPostsオブジェクトをコピーして一部のプロパティを変更します。
  PaginatedPosts copyWith({
    List<Post>? posts,
    int? currentPage,
    int? totalCount,
    int? itemsPerPage,
  }) {
    return PaginatedPosts(
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }

  /// 総ページ数を計算します。
  int get totalPages {
    if (itemsPerPage <= 0) return 1; // 0除算防止と、最低1ページは保証
    return (totalCount / itemsPerPage).ceil(); // 切り上げてページ数を計算
  }

  /// 次のページが存在するかどうかを判断します。
  bool get hasNextPage => currentPage < totalPages;
  
  /// 前のページが存在するかどうかを判断します。
  bool get hasPreviousPage => currentPage > 1;
}


/// 投稿リストの取得とページネーションを管理するViewModel
/// Riverpodのコードジェネレータで利用するため @riverpod を付与
@riverpod
class PostListViewModel extends _$PostListViewModel {
  /// ViewModelの初期状態を構築します。
  /// アプリ起動時やプロバイダの初回watch時に呼び出されます。
  @override
  Future<PaginatedPosts> build() async {
    print('PostListViewModel build called.');
    // 初期ロード時に全投稿数を取得し、それを元に最初のページをフェッチ
    int initialTotalCount = await _fetchTotalPostsCount();
    return _fetchPaginatedPosts(page: 1, totalCount: initialTotalCount);
  }

  /// FastAPIから全投稿数を取得します。
  Future<int> _fetchTotalPostsCount() async {
    final uri = Uri.parse('http://127.0.0.1:8000/total_posts/');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return json['total_count'] as int;
      } else {
        throw Exception('全投稿数の取得に失敗しました: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching total posts count: $e');
      rethrow; // エラーを再スローしてRiverpodでキャッチできるようにする
    }
  }

  /// 指定されたページ番号に基づいて投稿データをフェッチします。
  ///
  /// [page]: 取得したいページ番号 (1から始まる)
  /// [totalCount]: 現在知っている全投稿数。省略されたり0の場合、再取得されます。
  Future<PaginatedPosts> _fetchPaginatedPosts({required int page, int? totalCount}) async {
    // 現在のstateから1ページあたりの件数を取得。なければデフォルトの10件。
    final int itemsPerPage = state.hasValue ? state.value!.itemsPerPage : 10;
    // スキップする件数を計算 (例: 2ページ目なら (2-1)*10 = 10件スキップ)
    final int skip = (page - 1) * itemsPerPage;
    // FastAPIのエンドポイントURLを構築
    final uri = Uri.parse('http://127.0.0.1:8000/posts/?skip=$skip&limit=$itemsPerPage');

    print('Fetching posts from: $uri');
    
    try {
      final response = await http.get(uri);
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print('Parsed JSON list length: ${jsonList.length}');
        
        // JSONデータをPostモデルのリストに変換
        final posts = jsonList.map((json) => Post.fromJson(json)).toList();
        
        // 全投稿数を更新。引数で渡されたtotalCountがあればそれを使用、なければ現在のstateから取得。
        // ただし、初回ロード時や1ページ目に戻った場合は確実に再取得します。
        int currentTotalCount = totalCount ?? (state.hasValue ? state.value!.totalCount : 0);
        if (currentTotalCount == 0 || page == 1) { 
           currentTotalCount = await _fetchTotalPostsCount();
        }

        // 新しいPaginatedPostsオブジェクトを構築して返します。
        return PaginatedPosts(
          posts: posts,
          currentPage: page,
          totalCount: currentTotalCount,
          itemsPerPage: itemsPerPage,
        );
      } else {
        // HTTPエラーの場合
        print('Failed to load posts with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      // ネットワークエラーなどの場合
      print('Error fetching posts in PostListViewModel: $e'); 
      rethrow; // エラーを再スローしてRiverpodでキャッチできるようにする
    }
  }

  /// 投稿リストを現在のページで再ロード（リフレッシュ）します。
  Future<void> refreshPosts() async {
    final currentPage = state.hasValue ? state.value!.currentPage : 1; // 現在のページを保持
    state = const AsyncValue.loading(); // ローディング状態に更新
    
    // リフレッシュ時には全投稿数も再取得し、最新の状態を反映
    final refreshedTotalCount = await _fetchTotalPostsCount();
    
    // AsyncValue.guardで非同期処理をラップし、完了後にstateを更新
    state = await AsyncValue.guard(() => _fetchPaginatedPosts(page: currentPage, totalCount: refreshedTotalCount));
  }

  /// 次のページに移動します。
  Future<void> goToNextPage() async {
    if (state.hasValue) { // 現在のデータが存在する場合のみ処理
      final data = state.value!; // AsyncValueからPaginatedPostsオブジェクトを取得
      if (data.hasNextPage) { // 次のページが存在する場合のみ
        state = const AsyncValue.loading(); // UIにローディングフィードバックを表示
        // await を付けてFutureが完了するのを待ってからstateを更新
        state = await AsyncValue.guard(() => _fetchPaginatedPosts(page: data.currentPage + 1, totalCount: data.totalCount));
      }
    }
  }

  /// 前のページに移動します。
  Future<void> goToPreviousPage() async {
    if (state.hasValue) { // 現在のデータが存在する場合のみ処理
      final data = state.value!; // AsyncValueからPaginatedPostsオブジェクトを取得
      if (data.hasPreviousPage) { // 前のページが存在する場合のみ
        state = const AsyncValue.loading(); // UIにローディングフィードバックを表示
        // await を付けてFutureが完了するのを待ってからstateを更新
        state = await AsyncValue.guard(() => _fetchPaginatedPosts(page: data.currentPage - 1, totalCount: data.totalCount));
      }
    }
  }

  /// 特定のページに移動します。
  ///
  /// [page]: 移動したいページ番号
  Future<void> goToPage(int page) async {
    if (state.hasValue) { // 現在のデータが存在する場合のみ処理
      final data = state.value!; // AsyncValueからPaginatedPostsオブジェクトを取得
      // ページ番号が有効範囲内にある場合のみ
      if (page >= 1 && page <= data.totalPages) {
        state = const AsyncValue.loading(); // UIにローディングフィードバックを表示
        // await を付けてFutureが完了するのを待ってからstateを更新
        state = await AsyncValue.guard(() => _fetchPaginatedPosts(page: page, totalCount: data.totalCount));
      }
    }
  }
}