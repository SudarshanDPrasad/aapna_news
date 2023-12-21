class QP {
  const QP._();

  static Map<String, String> apiQP(
          {required String apiKey, required String country}) =>
      {'country': country, 'apiKey': apiKey};

  static Map<String, String> categoryQP(
          {required String apiKey,
          required String country,
          required String category}) =>
      {'country': country, 'apiKey': apiKey, 'category': category};

  static Map<String, String> sourceQP(
          {required String apiKey, required String sources}) =>
      {'sources': sources, 'apiKey': apiKey};


  static Map<String, String> searchQP(
      {required String apiKey, required String q}) =>
      {'q': q, 'apiKey': apiKey};
}


// https://newsapi.org/v2/top-headlines?sources=the-hindu&apiKey=ab424053c14248b6bbb7da59fa401cfd
