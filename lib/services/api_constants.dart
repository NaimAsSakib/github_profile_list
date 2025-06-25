class ApiConstants {
  static const String baseUrl = 'https://api.github.com';

  static String user(String username) => '$baseUrl/users/$username';

  static String userRepos(String username, {int page = 1, int perPage = 10}) =>
      '$baseUrl/users/$username/repos?per_page=$perPage&page=$page';

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/vnd.github.v3+json',
  };
}
