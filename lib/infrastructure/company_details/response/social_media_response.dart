import 'dart:convert';

import 'package:flutter/material.dart';

class SocialMediaResponse {
  String url;
  bool published;
  int type;
  SocialMediaResponse({
    @required this.url,
    @required this.published,
    @required this.type,
  });

  SocialMediaResponse copyWith({
    String url,
    bool published,
    int type,
  }) {
    return SocialMediaResponse(
      url: url ?? this.url,
      published: published ?? this.published,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'published': published,
      'type': type,
    };
  }

  factory SocialMediaResponse.fromMap(Map<String, dynamic> map) {
    if ( map != null)
    return SocialMediaResponse(
      url: map['url'],
      published: map['published'],
      type: map['type'],
    );
    return null;
  }

  String toJson() => json.encode(toMap());

  factory SocialMediaResponse.fromJson(String source) => SocialMediaResponse.fromMap(json.decode(source));

  @override
  String toString() => 'SocialMediaReponse(url: $url, published: $published, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SocialMediaResponse &&
      other.url == url &&
      other.published == published &&
      other.type == type;
  }

  @override
  int get hashCode => url.hashCode ^ published.hashCode ^ type.hashCode;
}
