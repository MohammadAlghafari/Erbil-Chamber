import 'dart:convert';

import 'package:flutter/material.dart';

class TimeDayResponse {
  String open;
  String close;
  TimeDayResponse({
    @required this.open,
    @required this.close,
  });

  TimeDayResponse copyWith({
    String open,
    String close,
  }) {
    return TimeDayResponse(
      open: open ?? this.open,
      close: close ?? this.close,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'open': open,
      'close': close,
    };
  }

  factory TimeDayResponse.fromMap(Map<String, dynamic> map) {
    return TimeDayResponse(
      open: map['open'],
      close: map['close'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeDayResponse.fromJson(String source) =>
      TimeDayResponse.fromMap(json.decode(source));

  @override
  String toString() => 'TimeDayResponse(open: $open, close: $close)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeDayResponse &&
        other.open == open &&
        other.close == close;
  }

  @override
  int get hashCode => open.hashCode ^ close.hashCode;
}
