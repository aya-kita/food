import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:food/models/post.dart'; // Postモデルのパスに合わせてください

part 'photo_list_view_model.g.dart';

/// ページネーションされた投稿データを保持するクラス
class PaginatedPosts {
  final List<Post> posts;
  final int currentPage;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedPosts({
    required this.posts,
    required this.currentPage,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

    // 追加: hasNextPageゲッター
  bool get hasNextPage => hasNext;

  // 追加: hasPreviousPageゲッター
  bool get hasPreviousPage => hasPrevious;


  factory PaginatedPosts.fromJson(Map<String, dynamic> json) {
    return PaginatedPosts(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int,
      totalPages: json['total_pages'] as int,
      hasNext: json['has_next'] as bool,
      hasPrevious: json['has_previous'] as bool,
    );
  }
}

/// 投稿リストの取得とページネーションを管理するViewModel
@riverpod
class PostListViewModel extends _$PostListViewModel {
  @override
  Future<PaginatedPosts> build() async {
    return _fetchPaginatedPosts(page: 1);
  }

  Future<PaginatedPosts> _fetchPaginatedPosts({required int page}) async {
    final uri = Uri.parse('http://127.0.0.1:8000/posts/?page=$page');
    print('Fetching posts from: $uri');

    try {
      final response = await http.get(uri);
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        return PaginatedPosts.fromJson(decoded);
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      rethrow;
    }
  }

  Future<void> refreshPosts() async {
    if (state.hasValue) {
      final currentPage = state.value!.currentPage;
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => _fetchPaginatedPosts(page: currentPage));
    }
  }

  Future<void> goToNextPage() async {
    if (state.hasValue) {
      final data = state.value!;
      print('goToNextPage called, current page: ${data.currentPage}');
      if (data.hasNext) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchPaginatedPosts(page: data.currentPage + 1));
      }
    }
  }

  Future<void> goToPreviousPage() async {
    if (state.hasValue) {
      final data = state.value!;
      print('goToPreviousPage called, current page: ${data.currentPage}');
      if (data.hasPrevious) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchPaginatedPosts(page: data.currentPage - 1));
      }
    }
  }

  Future<void> goToPage(int page) async {
    if (state.hasValue) {
      final data = state.value!;
      if (page >= 1 && page <= data.totalPages) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchPaginatedPosts(page: page));
      }
    }
  }
}
