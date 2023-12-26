import 'package:json_annotation/json_annotation.dart';
@JsonSerializable(createToJson: false)
class UserRegister {
  @JsonKey(defaultValue: 'Unknown')
  int? id;
  String? username;
  String? password;

  UserRegister({
    this.id,
    this.username,
    this.password,
  });

  UserRegister.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int? ?? 0;
    username = json["username"] as String? ?? 'Unknown';
    password = json["password"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["username"] = username;
    data["password"] = password;
    return data;
  }
}
