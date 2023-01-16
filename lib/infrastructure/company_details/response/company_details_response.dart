import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../common_response/city_response.dart';
import '../../common_response/company_response.dart';
import '../../common_response/picture_response.dart';
import 'opening_day_response.dart';
import 'social_media_response.dart';

class CompanyDetailsResponse {
  String merchantName;
  String commercialName;
  String address;
  String about;
  String category;
  int registrationNumber;
  String reservationDate;
  String registrationDate;
  CityResponse city;
  PictureResponse logo;
  double longitude;
  double latitude;
  List<CompanyResponse> branches;
  List<OpeningDayResponse> openingDays;
  List<SocialMediaResponse> socialMedia;
  List<String> contactNumbers;
  List<PictureResponse> pictures;
  List<PictureResponse> menu;
  String id;
  CompanyDetailsResponse({
    @required this.merchantName,
    @required this.commercialName,
    @required this.address,
    @required this.about,
    @required this.category,
    @required this.registrationNumber,
    @required this.reservationDate,
    @required this.registrationDate,
    @required this.city,
    @required this.logo,
    @required this.longitude,
    @required this.latitude,
    @required this.branches,
    @required this.openingDays,
    @required this.socialMedia,
    @required this.contactNumbers,
    @required this.pictures,
    @required this.menu,
    @required this.id,
  });

  CompanyDetailsResponse copyWith({
    String merchantName,
    String commercialName,
    String address,
    String about,
    String category,
    int registrationNumber,
    String reservationDate,
    String registrationDate,
    CityResponse city,
    PictureResponse logo,
    double longitude,
    double latitude,
    List<CompanyResponse> branches,
    List<OpeningDayResponse> openingDays,
    List<SocialMediaResponse> socialMedia,
    List<String> contactNumbers,
    List<PictureResponse> pictures,
    List<PictureResponse> menu,
    String id,
  }) {
    return CompanyDetailsResponse(
      merchantName: merchantName ?? this.merchantName,
      commercialName: commercialName ?? this.commercialName,
      address: address ?? this.address,
      about: about ?? this.about,
      category: category ?? this.category,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      reservationDate: reservationDate ?? this.reservationDate,
      registrationDate: registrationDate ?? this.registrationDate,
      city: city ?? this.city,
      logo: logo ?? this.logo,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      branches: branches ?? this.branches,
      openingDays: openingDays ?? this.openingDays,
      socialMedia: socialMedia ?? this.socialMedia,
      contactNumbers: contactNumbers ?? this.contactNumbers,
      pictures: pictures ?? this.pictures,
      menu: menu ?? this.menu,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'merchantName': merchantName,
      'commercialName': commercialName,
      'address': address,
      'about': about,
      'category': category,
      'registrationNumber': registrationNumber,
      'reservationDate': reservationDate,
      'registrationDate': registrationDate,
      'city': city.toMap(),
      'logo': logo.toMap(),
      'longitude': longitude,
      'latitude': latitude,
      'branches': branches?.map((x) => x.toMap())?.toList(),
      'openingDays': openingDays?.map((x) => x.toMap())?.toList(),
      'socialMedia': socialMedia?.map((x) => x.toMap())?.toList(),
      'contactNumbers': contactNumbers,
      'pictures': pictures?.map((x) => x.toMap())?.toList(),
      'menu': menu?.map((x) => x.toMap())?.toList(),
      'id': id,
    };
  }

  factory CompanyDetailsResponse.fromMap(Map<String, dynamic> map) {
    return CompanyDetailsResponse(
      merchantName: map['merchantName'],
      commercialName: map['commercialName'],
      address: map['address'],
      about: map['about'],
      category: map['category'],
      registrationNumber: map['registrationNumber'],
      reservationDate: map['reservationDate'],
      registrationDate: map['registrationDate'],
      city: CityResponse.fromMap(map['city']),
      logo: PictureResponse.fromMap(map['logo']),
      longitude: map['longitude'],
      latitude: map['latitude'],
      branches: List<CompanyResponse>.from(
          map['branches']?.map((x) => CompanyResponse.fromMap(x))),
      openingDays: List<OpeningDayResponse>.from(
          map['openingDays']?.map((x) => OpeningDayResponse.fromMap(x))),
      socialMedia: map['socialMedia'] != null
          ? List<SocialMediaResponse>.from(map['socialMedia']
              ?.map((x) => SocialMediaResponse.fromMap(x)))
          : null,
      contactNumbers: List<String>.from(map['contactNumbers']),
      pictures: List<PictureResponse>.from(
          map['pictures']?.map((x) => PictureResponse.fromMap(x))),
      menu: map['menu'] != null
          ? List<PictureResponse>.from(
              map['menu']?.map((x) => PictureResponse.fromMap(x)))
          : null,
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyDetailsResponse.fromJson(String source) =>
      CompanyDetailsResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompanyDetailsResponse(merchantName: $merchantName, commercialName: $commercialName, address: $address, about: $about, category: $category, registrationNumber: $registrationNumber, reservationDate: $reservationDate, registrationDate: $registrationDate, city: $city, logo: $logo, longitude: $longitude, latitude: $latitude, branches: $branches, openingDays: $openingDays, socialMedia: $socialMedia, contactNumbers: $contactNumbers, pictures: $pictures, menu: $menu, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CompanyDetailsResponse &&
        other.merchantName == merchantName &&
        other.commercialName == commercialName &&
        other.address == address &&
        other.about == about &&
        other.category == category &&
        other.registrationNumber == registrationNumber &&
        other.reservationDate == reservationDate &&
        other.registrationDate == registrationDate &&
        other.city == city &&
        other.logo == logo &&
        other.longitude == longitude &&
        other.latitude == latitude &&
        listEquals(other.branches, branches) &&
        listEquals(other.openingDays, openingDays) &&
        listEquals(other.socialMedia, socialMedia) &&
        listEquals(other.contactNumbers, contactNumbers) &&
        listEquals(other.pictures, pictures) &&
        listEquals(other.menu, menu) &&
        other.id == id;
  }

  @override
  int get hashCode {
    return merchantName.hashCode ^
        commercialName.hashCode ^
        address.hashCode ^
        about.hashCode ^
        category.hashCode ^
        registrationNumber.hashCode ^
        reservationDate.hashCode ^
        registrationDate.hashCode ^
        city.hashCode ^
        logo.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        branches.hashCode ^
        openingDays.hashCode ^
        socialMedia.hashCode ^
        contactNumbers.hashCode ^
        pictures.hashCode ^
        menu.hashCode ^
        id.hashCode;
  }
}
