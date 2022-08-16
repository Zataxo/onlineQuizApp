// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);

import 'dart:convert';

Map<String, Model> modelFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Model>(k, Model.fromJson(v)));

String modelToJson(Map<String, Model> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Model {
  Model({
    required this.options,
    required this.title,
  });

  List<Map<String, bool>> options;
  String title;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        options: List<Map<String, bool>>.from(json["options"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, bool>(k, v)))),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "options": List<dynamic>.from(options.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "title": title,
      };
}
