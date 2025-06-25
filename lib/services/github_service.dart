import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_user.dart';
import '../models/repository.dart';
import 'api_constants.dart'; // adjust path as needed

class GitHubService {
  Future<GitHubUser> getUser(String username) async {
    final uri = Uri.parse(ApiConstants.user(username));
    try {
      final response = await http.get(uri, headers: ApiConstants.defaultHeaders);

      switch (response.statusCode) {
        case 200:
          return GitHubUser.fromJson(json.decode(response.body));
        case 404:
          throw Exception('User not found');
        default:
          throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<List<Repository>> getRepositories(
      String username, {
        int page = 1,
        int perPage = 10,
      }) async {
    final uri = Uri.parse(ApiConstants.userRepos(username, page: page, perPage: perPage));
    try {
      final response = await http.get(uri, headers: ApiConstants.defaultHeaders);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((repo) => Repository.fromJson(repo)).toList();
      } else {
        throw Exception('Failed to fetch repositories');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
