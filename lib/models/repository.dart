class Repository {
  final String name;
  final String? description;
  final int stargazersCount;
  final String? language;
  final String htmlUrl;

  Repository({
    required this.name,
    this.description,
    required this.stargazersCount,
    this.language,
    required this.htmlUrl,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'] ?? '',
      description: json['description'],
      stargazersCount: json['stargazers_count'] ?? 0,
      language: json['language'],
      htmlUrl: json['html_url'] ?? '',
    );
  }
}