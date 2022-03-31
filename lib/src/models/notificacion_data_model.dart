import 'dart:convert';

NotificacionData notificacionDataFromJson(String str) =>
    NotificacionData.fromJson(json.decode(str));

String notificacionDataToJson(NotificacionData data) =>
    json.encode(data.toJson());

class NotificacionData {
  NotificacionData({
    this.title,
    this.body,
  });

  String? title;
  String? body;

  factory NotificacionData.fromJson(Map<String, dynamic> json) =>
      NotificacionData(
        title: json["title"] == null ? null : json["title"],
        body: json["body"] == null ? null : json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "body": body == null ? null : body,
      };
}
