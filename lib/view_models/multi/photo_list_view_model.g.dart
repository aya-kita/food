// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postListViewModelHash() => r'a85561a0b1446dc71b54bfe981ea774382aee366';

/// 投稿リストの取得とページネーションを管理するViewModel
/// Riverpodのコードジェネレータで利用するため @riverpod を付与
///
/// Copied from [PostListViewModel].
@ProviderFor(PostListViewModel)
final postListViewModelProvider = AutoDisposeAsyncNotifierProvider<
    PostListViewModel, PaginatedPosts>.internal(
  PostListViewModel.new,
  name: r'postListViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postListViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostListViewModel = AutoDisposeAsyncNotifier<PaginatedPosts>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
