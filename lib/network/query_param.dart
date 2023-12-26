class QP {
  const QP._();

  // Top Headlines
  static Map<String, String> apiQP(
          {required String apiKey, required String country}) =>
      {'country': country, 'apiKey': apiKey};

  // Category
  static Map<String, String> categoryQP(
          {required String apiKey,
          required String country,
          required String category}) =>
      {'country': country, 'apiKey': apiKey, 'category': category};

  // Sources
  static Map<String, String> sourceQP(
          {required String apiKey, required String sources}) =>
      {'sources': sources, 'apiKey': apiKey};

// Search
  static Map<String, String> searchQP(
          {required String apiKey, required String q}) =>
      {'q': q, 'apiKey': apiKey};

  // User Login
  static Map<String, String> searchUser(
          {required String username, required String password}) =>
      {'username': username, 'password': password};

  // const { username, author, title, urlToImage, description, url, publishedAt, content, sourceName } = req.body;

// New Article
  static Map<String, String> newArticle(
          {required String username,
          required String author,
          required String title,
          required String urlToImage,
          required String description,
          required String url,
          required String publishedAt,
          required String content,
          required String sourceName}) =>
      {
        'username': username,
        'author': author,
        'title': title,
        'urlToImage': urlToImage,
        'description': description,
        'url': url,
        'publishedAt': publishedAt,
        'content': content,
        'sourceName': sourceName
      };

  // Delete Article
  static Map<String, String> deleteArticle(
      {required String title, required String username}) =>
      {'title': title, 'username': username};
}

// https://newsapi.org/v2/top-headlines?sources=the-hindu&apiKey=ab424053c14248b6bbb7da59fa401cfd
