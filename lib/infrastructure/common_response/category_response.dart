import 'dart:convert';

import 'package:flutter/material.dart';

import 'picture_response.dart';

class CategoryResponse {
  String name;
  int order;
  String parentId;
  PictureResponse picture;
  String id;
  CategoryResponse({
    @required this.name,
    @required this.order,
    @required this.parentId,
    @required this.picture,
    @required this.id,
  });

  CategoryResponse copyWith({
    String name,
    int order,
    String parentId,
    PictureResponse picture,
    String id,
  }) {
    return CategoryResponse(
      name: name ?? this.name,
      order: order ?? this.order,
      parentId: parentId ?? this.parentId,
      picture: picture ?? this.picture,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
      'parentId': parentId,
      'picture': picture.toMap(),
      'id': id,
    };
  }

  factory CategoryResponse.fromMap(Map<String, dynamic> map) {
    return CategoryResponse(
      name: map['name'],
      order: map['order'],
      parentId: map['parentId'],
      picture: PictureResponse.fromMap(map['picture']),
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryResponse.fromJson(String source) => CategoryResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryResponse(name: $name, order: $order, parentId: $parentId, picture: $picture, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CategoryResponse &&
      other.name == name &&
      other.order == order &&
      other.parentId == parentId &&
      other.picture == picture &&
      other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      order.hashCode ^
      parentId.hashCode ^
      picture.hashCode ^
      id.hashCode;
  }
}
