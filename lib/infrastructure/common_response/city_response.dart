import 'dart:convert';

import 'package:flutter/material.dart';

class CityResponse {
  String name;
  String id;
  CityResponse({
    @required this.name,
    @required this.id,
  });

  CityResponse copyWith({
    String name,
    String id,
  }) {
    return CityResponse(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory CityResponse.fromMap(Map<String, dynamic> map) {
    return CityResponse(
      name: map['name'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CityResponse.fromJson(String source) => CityResponse.fromMap(json.decode(source));

  @override
  String toString() => 'CityResponse(name: $name, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CityResponse &&
      other.name == name &&
      other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
