import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'heater_config.g.dart';

enum DayOfWeek { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

const DayOfWeekToStringMap = <DayOfWeek, dynamic>{
  DayOfWeek.Mon: 'Mo',
  DayOfWeek.Tue: 'Di',
  DayOfWeek.Wed: 'Mi',
  DayOfWeek.Thu: 'Do',
  DayOfWeek.Fri: 'Fr',
  DayOfWeek.Sat: 'Sa',
  DayOfWeek.Sun: 'So'
};

@JsonSerializable()
class HeaterConfig extends Comparable {
  DayOfWeek? dayOfWeek;
  @JsonKey(toJson: timeOfDayToJson, fromJson: timeOfDayFromJson)
  TimeOfDay? timeOfDay;
  double? temperature;

  HeaterConfig() {
    dayOfWeek = DayOfWeek.Mon;
    timeOfDay = TimeOfDay.now();
    temperature = 21.0;
  }

  static String timeOfDayToJson(TimeOfDay? val) {
    if(val == null)
    return "";
    final now = new DateTime.now();
    return (new DateTime(now.year, now.month, now.day, val.hour, val.minute)).toIso8601String();
  }

  static TimeOfDay? timeOfDayFromJson(String val) {
    final dt = DateTime.tryParse(val)!.toLocal();
    if (dt == null) return new TimeOfDay(hour: 0, minute: 0);
    return TimeOfDay.fromDateTime(dt);
  }

  factory HeaterConfig.fromJson(Map<String, dynamic> json) => _$HeaterConfigFromJson(json);

  Map<String, dynamic> toJson() => _$HeaterConfigToJson(this);

  @override
  int compareTo(other) {
    return (dayOfWeek!.index * 1440 + timeOfDay!.hour * 60 + timeOfDay!.minute) - (other.dayOfWeek.index * 1440 + other.timeOfDay.hour * 60 + other.timeOfDay.minute) as int;
  }
}
