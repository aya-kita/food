// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'created_at': instance.created_at.toIso8601String(),
    };
