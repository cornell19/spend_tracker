import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spend_tracker/support/icon_helper.dart';

class ItemType {
  ItemType({
    this.urlId,
    @required this.name,
    @required this.codePoint,
  });

  final String urlId;
  final String name;
  final int codePoint;

  IconData get iconData => IconHelper.createIconData(codePoint);

  Map<String, dynamic> toMap() => {
        'urlId': urlId,
        'name': name,
        'codePoint': codePoint,
      };

  String toJson() {
    return json.encode({
      'fields': {
        'name': {'stringValue': name},
        'codePoint': {'integerValue': codePoint}
      }
    });
  }

  static List<ItemType> fromJson(String jsonString) {
    var map = json.decode(jsonString);
    if (map['documents'] == null) return [];
    List<ItemType> types = List<ItemType>();
    map['documents'].forEach((data) {
      var fields = data['fields'];
      types.add(ItemType(
        urlId: data['name'],
        codePoint: int.parse(fields['codePoint']['integerValue']),
        name: fields['name']['stringValue'],
      ));
    });
    return types;
  }

  factory ItemType.fromMap(Map<String, dynamic> map) => ItemType(
        urlId: map['urlId'],
        name: map['name'],
        codePoint: map['codePoint'],
      );
}
