import 'dart:convert';

// class RoomCreation {
//   String roomId;
//   String creatorName;
//   String oppName;
//   bool plyaerOneStatus;
//   bool plyaerTwoStatus;
//   int playerOneScore;
//   int playerTwoScore;

//   RoomCreation(
//       {required this.roomId,
//       required this.creatorName,
//       required this.oppName,
//       required this.plyaerOneStatus,
//       required this.plyaerTwoStatus,
//       required this.playerOneScore,
//       required this.playerTwoScore});
//   Map<String, dynamic> toJason() => {
//         'roomId': roomId,
//         'creatorName': creatorName,
//         'oppName':oppName,
//         'plyaerOneStatus': plyaerOneStatus,
//         'plyaerTwoStatus': plyaerTwoStatus,
//         'playerOneScore': playerOneScore,
//         'playerTwoScore': playerTwoScore,
//       };
// }
// To parse this JSON data, do
//
//     final roomModel = roomModelFromJson(jsonString);

Map<String, RoomModel> roomModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, RoomModel>(k, RoomModel.fromJson(v)));

String roomModelToJson(Map<String, RoomModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class RoomModel {
  RoomModel({
    required this.creatorName,
    required this.oppName,
    required this.playerOneScore,
    required this.playerTwoScore,
    required this.plyaerOneStatus,
    required this.plyaerTwoStatus,
    required this.roomId,
  });

  String creatorName;
  String oppName;
  int playerOneScore;
  int playerTwoScore;
  bool plyaerOneStatus;
  bool plyaerTwoStatus;
  String roomId;

  RoomModel copyWith({
    String? creatorName,
    String? oppName,
    int? playerOneScore,
    int? playerTwoScore,
    bool? plyaerOneStatus,
    bool? plyaerTwoStatus,
    String? roomId,
  }) =>
      RoomModel(
        creatorName: creatorName ?? this.creatorName,
        oppName: oppName ?? this.oppName,
        playerOneScore: playerOneScore ?? this.playerOneScore,
        playerTwoScore: playerTwoScore ?? this.playerTwoScore,
        plyaerOneStatus: plyaerOneStatus ?? this.plyaerOneStatus,
        plyaerTwoStatus: plyaerTwoStatus ?? this.plyaerTwoStatus,
        roomId: roomId ?? this.roomId,
      );

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        creatorName: json["creatorName"],
        oppName: json["oppName"] ?? '',
        playerOneScore: json["playerOneScore"],
        playerTwoScore: json["playerTwoScore"],
        plyaerOneStatus: json["plyaerOneStatus"],
        plyaerTwoStatus: json["plyaerTwoStatus"],
        roomId: json["roomId"],
      );

  Map<String, dynamic> toJson() => {
        "creatorName": creatorName,
        "oppName": oppName,
        "playerOneScore": playerOneScore,
        "playerTwoScore": playerTwoScore,
        "plyaerOneStatus": plyaerOneStatus,
        "plyaerTwoStatus": plyaerTwoStatus,
        "roomId": roomId,
      };
}
