import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'time_day_response.dart';

class OpeningDayResponse {
  bool closed;
  bool alwaysOpen;
  int dayOfWeek;
  List<TimeDayResponse> times;
  OpeningDayResponse({
    @required this.closed,
    @required this.alwaysOpen,
    @required this.dayOfWeek,
    @required this.times,
  });
  

  OpeningDayResponse copyWith({
    bool closed,
    bool alwaysOpen,
    int dayOfWeek,
    List<TimeDayResponse> times,
  }) {
    return OpeningDayResponse(
      closed: closed ?? this.closed,
      alwaysOpen: alwaysOpen ?? this.alwaysOpen,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      times: times ?? this.times,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'closed': closed,
      'alwaysOpen': alwaysOpen,
      'dayOfWeek': dayOfWeek,
      'times': times?.map((x) => x.toMap())?.toList(),
    };
  }

  factory OpeningDayResponse.fromMap(Map<String, dynamic> map) {
    return OpeningDayResponse(
      closed: map['closed'],
      alwaysOpen: map['alwaysOpen'],
      dayOfWeek: map['dayOfWeek'],
      times: List<TimeDayResponse>.from(map['times']?.map((x) => TimeDayResponse.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OpeningDayResponse.fromJson(String source) => OpeningDayResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OpeningDayResponse(closed: $closed, alwaysOpen: $alwaysOpen, dayOfWeek: $dayOfWeek, times: $times)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OpeningDayResponse &&
      other.closed == closed &&
      other.alwaysOpen == alwaysOpen &&
      other.dayOfWeek == dayOfWeek &&
      listEquals(other.times, times);
  }

  @override
  int get hashCode {
    return closed.hashCode ^
      alwaysOpen.hashCode ^
      dayOfWeek.hashCode ^
      times.hashCode;
  }
}
