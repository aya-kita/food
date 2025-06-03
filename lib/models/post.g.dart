// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
      username: json['username'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
      'username': instance.username,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
    };
