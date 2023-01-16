import 'dart:convert';

import 'package:flutter/material.dart';

import 'ad_picture_response.dart';

class AdResponse {
  AdPictureResponse picture;
  String companyId;
  String externalURL;
  String id;
  int type;
  AdResponse({
    @required this.picture,
    @required this.companyId,
    @required this.externalURL,
    @required this.id,
    @required this.type,
  });

  AdResponse copyWith({
    AdPictureResponse picture,
    String companyId,
    String externalURL,
    String id,
    int type,
  }) {
    return AdResponse(
      picture: picture ?? this.picture,
      companyId: companyId ?? this.companyId,
      externalURL: externalURL ?? this.externalURL,
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'picture': picture.toMap(),
      'companyId': companyId,
      'externalURL': externalURL,
      'id': id,
      'type': type,
    };
  }

  factory AdResponse.fromMap(Map<String, dynamic> map) {
    return AdResponse(
      picture: AdPictureResponse.fromMap(map['picture']),
      companyId: map['companyId'],
      externalURL: map['externalURL'],
      id: map['id'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AdResponse.fromJson(String source) => AdResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdResponse(picture: $picture, companyId: $companyId, externalURL: $externalURL, id: $id, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AdResponse &&
      other.picture == picture &&
      other.companyId == companyId &&
      other.externalURL == externalURL &&
      other.id == id &&
      other.type == type;
  }

  @override
  int get hashCode {
    return picture.hashCode ^
      companyId.hashCode ^
      externalURL.hashCode ^
      id.hashCode ^
      type.hashCode;
  }
}
