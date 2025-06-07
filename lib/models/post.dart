// lib/model/post.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id, // FastAPIの id に対応
    required String username,
    required String title,
    required String imageUrl,
    required DateTime createdAt, // FastAPIの created_at に対応
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
