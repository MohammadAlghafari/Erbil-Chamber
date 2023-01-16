import 'dart:convert';

import 'package:flutter/material.dart';

class PictureResponse {
  String lg;
  String md;
  String xs;
  PictureResponse({
    @required this.lg,
    @required this.md,
    @required this.xs,
  });

  PictureResponse copyWith({
    String lg,
    String md,
    String xs,
  }) {
    return PictureResponse(
      lg: lg ?? this.lg,
      md: md ?? this.md,
      xs: xs ?? this.xs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lg': lg,
      'md': md,
      'xs': xs,
    };
  }

  factory PictureResponse.fromMap(Map<String, dynamic> map) {
    if (map != null)
      return PictureResponse(
        lg: map['lg'],
        md: map['md'],
        xs: map['xs'],
      );
    else
      return null;
  }

  String toJson() => json.encode(toMap());

  factory PictureResponse.fromJson(String source) =>
      PictureResponse.fromMap(json.decode(source));

  @override
  String toString() => 'PictureResponse(lg: $lg, md: $md, xs: $xs)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PictureResponse &&
        other.lg == lg &&
        other.md == md &&
        other.xs == xs;
  }

  @override
  int get hashCode => lg.hashCode ^ md.hashCode ^ xs.hashCode;
}
