class AppRoutes {
  static const home = '/';
  static const discover = '/discover';
  static const alphabet = '/alphabet';
  static const translate = '/translate';
  static const quiz = '/quiz';
  static const favorites = '/favorites';
  static const history = '/history';
  static const about = '/about';

  static String runeDetail(String runeId) => '/alphabet/$runeId';
}
