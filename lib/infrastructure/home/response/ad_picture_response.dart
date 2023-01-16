import 'dart:convert';

import 'package:flutter/material.dart';

class AdPictureResponse {
  String id;
  String name;
  String lg;
  String md;
  String xs;
  AdPictureResponse({
    @required this.id,
    @required this.name,
    @required this.lg,
    @required this.md,
    @required this.xs,
  });

  AdPictureResponse copyWith({
    String id,
    String name,
    String lg,
    String md,
    String xs,
  }) {
    return AdPictureResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      lg: lg ?? this.lg,
      md: md ?? this.md,
      xs: xs ?? this.xs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lg': lg,
      'md': md,
      'xs': xs,
    };
  }

  factory AdPictureResponse.fromMap(Map<String, dynamic> map) {
    if (map != null)
      return AdPictureResponse(
        id: map['id'],
        name: map['name'],
        lg: map['lg'],
        md: map['md'],
        xs: map['xs'],
      );
    return null;
  }

  String toJson() => json.encode(toMap());

  factory AdPictureResponse.fromJson(String source) =>
      AdPictureResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdPictureResponse(id: $id, name: $name, lg: $lg, md: $md, xs: $xs)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdPictureResponse &&
        other.id == id &&
        other.name == name &&
        other.lg == lg &&
        other.md == md &&
        other.xs == xs;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        lg.hashCode ^
        md.hashCode ^
        xs.hashCode;
  }
}
