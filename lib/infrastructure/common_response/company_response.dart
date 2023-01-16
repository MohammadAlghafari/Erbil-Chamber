import 'dart:convert';

import 'package:flutter/material.dart';

import 'picture_response.dart';

class CompanyResponse {
  String id;
  String merchantName;
  String commercialName;
  String categoryId;
  String category;
  String address;
  String about;
  PictureResponse logo;
  double distance;
  double longitude;
  double latitude;
  CompanyResponse({
    @required this.id,
    @required this.merchantName,
    @required this.commercialName,
    @required this.categoryId,
    @required this.category,
    @required this.address,
    @required this.about,
    @required this.logo,
    @required this.distance,
    @required this.longitude,
    @required this.latitude,
  });
  

  CompanyResponse copyWith({
    String id,
    String merchantName,
    String commercialName,
    String categoryId,
    String category,
    String address,
    String about,
    PictureResponse logo,
    double distance,
    double longitude,
    double latitude,
  }) {
    return CompanyResponse(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      commercialName: commercialName ?? this.commercialName,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      address: address ?? this.address,
      about: about ?? this.about,
      logo: logo ?? this.logo,
      distance: distance ?? this.distance,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'merchantName': merchantName,
      'commercialName': commercialName,
      'categoryId': categoryId,
      'category': category,
      'address': address,
      'about': about,
      'logo': logo.toMap(),
      'distance': distance,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory CompanyResponse.fromMap(Map<String, dynamic> map) {
    return CompanyResponse(
      id: map['id'],
      merchantName: map['merchantName'],
      commercialName: map['commercialName'],
      categoryId: map['categoryId'],
      category: map['category'],
      address: map['address'],
      about: map['about'],
      logo: PictureResponse.fromMap(map['logo']),
      distance: map['distance'] != 0 ? map['distance'] : 0.0,
      longitude: map['longitude'] != 0 ? map['longitude'] : 0.0,
      latitude: map['latitude'] != 0 ? map['latitude'] : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyResponse.fromJson(String source) => CompanyResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompanyResponse(id: $id, merchantName: $merchantName, commercialName: $commercialName, categoryId: $categoryId, category: $category, address: $address, about: $about, logo: $logo, distance: $distance, longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CompanyResponse &&
      other.id == id &&
      other.merchantName == merchantName &&
      other.commercialName == commercialName &&
      other.categoryId == categoryId &&
      other.category == category &&
      other.address == address &&
      other.about == about &&
      other.logo == logo &&
      other.distance == distance &&
      other.longitude == longitude &&
      other.latitude == latitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      merchantName.hashCode ^
      commercialName.hashCode ^
      categoryId.hashCode ^
      category.hashCode ^
      address.hashCode ^
      about.hashCode ^
      logo.hashCode ^
      distance.hashCode ^
      longitude.hashCode ^
      latitude.hashCode;
  }
}
