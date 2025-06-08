// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postListViewModelHash() => r'541d68050d1876240e06dd06cb38b281df6d0c06';

/// 投稿リストの取得とページネーションを管理するViewModel
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
