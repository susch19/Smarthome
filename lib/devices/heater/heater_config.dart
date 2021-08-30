import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'heater_config.g.dart';

enum DayOfWeek { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

const DayOfWeekToStringMap = <DayOfWeek, String>{
  DayOfWeek.Mon: 'Mo',
  DayOfWeek.Tue: 'Di',
  DayOfWeek.Wed: 'Mi',
  DayOfWeek.Thu: 'Do',
  DayOfWeek.Fri: 'Fr',
  DayOfWeek.Sat: 'Sa',
  DayOfWeek.Sun: 'So'
};

const DayOfWeekToFlagMap = <DayOfWeek, int>{
  DayOfWeek.Mon: 1 << 1,
  DayOfWeek.Tue: 1 << 2,
  DayOfWeek.Wed: 1 << 3,
  DayOfWeek.Thu: 1 << 4,
  DayOfWeek.Fri: 1 << 5,
  DayOfWeek.Sat: 1 << 6,
  DayOfWeek.Sun: 1 << 7
};

const FlagToDayOfWeekMap = <int, DayOfWeek>{
  1 << 1: DayOfWeek.Mon,
  1 << 2: DayOfWeek.Tue,
  1 << 3: DayOfWeek.Wed,
  1 << 4: DayOfWeek.Thu,
  1 << 5: DayOfWeek.Fri,
  1 << 6: DayOfWeek.Sat,
  1 << 7: DayOfWeek.Sun
};

const DayOfWeekStringToFlagMap = <String, int>{'Mo': 1 << 1, 'Di': 1 << 2, 'Mi': 1 << 3, 'Do': 1 << 4, 'Fr': 1 << 5, 'Sa': 1 << 6, 'So': 1 << 7};

const DayOfWeekToLongStringMap = <DayOfWeek, String>{
  DayOfWeek.Mon: 'Montag',
  DayOfWeek.Tue: 'Dienstag',
  DayOfWeek.Wed: 'Mittwoch',
  DayOfWeek.Thu: 'Donnerstag',
  DayOfWeek.Fri: 'Freitag',
  DayOfWeek.Sat: 'Samstag',
  DayOfWeek.Sun: 'Sonntag'
};

@JsonSerializable()
class HeaterConfig extends Equatable implements Comparable {
  final DayOfWeek dayOfWeek;
  @JsonKey(toJson: timeOfDayToJson, fromJson: timeOfDayFromJson)
  final TimeOfDay timeOfDay;
  final double temperature;

  HeaterConfig.easyInit()
      : dayOfWeek = DayOfWeek.Mon,
        timeOfDay = TimeOfDay.now(),
        temperature = 21.0;

  HeaterConfig(this.dayOfWeek, this.timeOfDay, this.temperature);

  static String timeOfDayToJson(TimeOfDay? val) {
    if (val == null) return "";
    final now = new DateTime.now();
    return (new DateTime(now.year, now.month, now.day, val.hour, val.minute)).toIso8601String();
  }

  static TimeOfDay timeOfDayFromJson(String val) {
    final dt = DateTime.tryParse(val)!.toLocal();
    new TimeOfDay(hour: 0, minute: 0);
    return TimeOfDay.fromDateTime(dt);
  }

  factory HeaterConfig.fromJson(Map<String, dynamic> json) => _$HeaterConfigFromJson(json);

  Map<String, dynamic> toJson() => _$HeaterConfigToJson(this);

  @override
  int compareTo(other) {
    return (dayOfWeek.index * 1440 + timeOfDay.hour * 60 + timeOfDay.minute) -
        (other.dayOfWeek.index * 1440 + other.timeOfDay.hour * 60 + other.timeOfDay.minute) as int;
  }

  @override
  List<Object?> get props => [dayOfWeek, timeOfDay, temperature];
}
