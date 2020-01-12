// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  /// All images are made by user iconixar https://www.flaticon.com/authors/iconixar
  /// from https://www.flaticon.com/
  String _getWeatherImagePath() {
    switch (widget.model.weatherCondition) {
      case WeatherCondition.cloudy:
        return "images/cloud.png";
        break;
      case WeatherCondition.foggy:
        return "images/fog.png";
        break;
      case WeatherCondition.rainy:
        return "images/rain.png";
        break;
      case WeatherCondition.snowy:
        return "images/snow.png";
        break;
      case WeatherCondition.sunny:
        return "images/sun.png";
        break;
      case WeatherCondition.thunderstorm:
        return "images/storm.png";
        break;
      case WeatherCondition.windy:
        return "images/windy.png";
        break;
    }

    return "images/sun.png";
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final period = DateFormat("a").format(_dateTime);

    final size = MediaQuery.of(context).size;
    final paddingVertical = size.height * 0.12;
    final paddingHorizontal = size.width * 0.1;

    final imagePath = _getWeatherImagePath();

    Color backgroundColor = Color(0xFF212121);

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        left: paddingHorizontal,
        right: paddingHorizontal,
        top: paddingVertical,
        bottom: paddingVertical,
      ),
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.clip,
        children: <Widget>[
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$hour : $minute",
                        style: TextStyle(
                          fontSize: size.height / 3.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 24),
                        child: Text(
                          period,
                          style: TextStyle(
                              fontSize: size.height / 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.model.location,
                    style: TextStyle(
                        fontSize: size.height / 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              )),
          Align(
            widthFactor: 1,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width * 0.35,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.03),
                    offset: Offset(-3, -3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(3, 3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    imagePath,
                    width: size.height * 0.1,
                    height: size.height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      widget.model.temperatureString,
                      style: TextStyle(
                          fontSize: size.height * 0.1,
                          color: Colors.white,
                          fontWeight: FontWeight.w200),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
