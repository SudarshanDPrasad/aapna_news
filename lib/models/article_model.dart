import 'package:json_annotation/json_annotation.dart';
@JsonSerializable(createToJson: false)
class Article {
  @JsonKey(defaultValue: 'Unknown')
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;
  ArticleSource? source;

  Article({
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.source,
  });

  Article.fromJson(Map<String, dynamic> json) {
    author = json["author"] as String? ?? 'Unknown';
    title = json["title"];
    description = json["description"];
    url = json["url"];
    urlToImage = json["urlToImage"];
    publishedAt = json["publishedAt"];
    content = json["content"];
    source = ArticleSource.fromJson(json["source"] as Map<String,dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["author"] = author;
    data["title"] = title;
    data["description"] = url;
    data["urlToImage"] = urlToImage;
    data["publishedAt"] = publishedAt;
    data["source"] = source;

    return data;
  }
}

@JsonSerializable(createToJson: false)
class ArticleSource {
  String? id;
  String? name;

  ArticleSource({this.name, this.id});

  ArticleSource.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    return data;
  }
}
