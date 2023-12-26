import 'package:json_annotation/json_annotation.dart';
@JsonSerializable(createToJson: false)
class ArticleBookmark {
  @JsonKey(defaultValue: 'Unknown')
  int? id;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;
  String? sourceName;

  ArticleBookmark({
    this.id,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.sourceName
  });

  ArticleBookmark.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int? ?? 0;
    author = json["author"] as String? ?? 'Unknown';
    title = json["title"];
    description = json["description"];
    url = json["url"];
    urlToImage = json["urlToImage"];
    publishedAt = json["publishedAt"];
    content = json["content"];
    sourceName = json["sourceName"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["author"] = author;
    data["url"] = url;
    data["title"] = title;
    data["description"] = url;
    data["urlToImage"] = urlToImage;
    data["publishedAt"] = publishedAt;
    data["sourceName"] = sourceName;

    return data;
  }
}
