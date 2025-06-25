import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/github_user.dart';
import '../models/repository.dart';
import '../services/github_service.dart';

class GitHubController extends GetxController {
  late final GitHubService _gitHubService;

  // User data
  final Rx<GitHubUser?> user = Rx<GitHubUser?>(null);
  final RxBool isLoadingUser = false.obs;
  final RxString userError = ''.obs;

  // Repositories data
  final RxList<Repository> repositories = <Repository>[].obs;
  final RxBool isLoadingRepos = false.obs;
  final RxString reposError = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreRepos = true.obs;
  final RxBool isLoadingMore = false.obs;
  final TextEditingController usernameController = TextEditingController();

  // Selected repository for detail view
  final Rx<Repository?> selectedRepository = Rx<Repository?>(null);

  // Search
  final RxString currentUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _gitHubService = Get.find<GitHubService>();
  }

  Future<void> fetchUser(String username) async {
    try {
      currentUsername.value = username;
      isLoadingUser.value = true;
      userError.value = '';

      final userData = await _gitHubService.getUser(username);
      user.value = userData;

      // Reset repositories when fetching new user
      repositories.clear();
      currentPage.value = 1;
      hasMoreRepos.value = true;

    } catch (e) {
      userError.value = e.toString().replaceAll('Exception: ', '');
      user.value = null;
    } finally {
      isLoadingUser.value = false;
    }
  }

  Future<void> fetchRepositories({bool refresh = false}) async {
    if (currentUsername.isEmpty) return;

    try {
      if (refresh) {
        currentPage.value = 1;
        hasMoreRepos.value = true;
        repositories.clear();
        isLoadingRepos.value = true;
      } else {
        isLoadingMore.value = true;
      }

      reposError.value = '';

      final repos = await _gitHubService.getRepositories(
        currentUsername.value,
        page: currentPage.value,
        perPage: 10,
      );

      if (repos.length < 10) {
        hasMoreRepos.value = false;
      }

      if (refresh) {
        repositories.assignAll(repos);
      } else {
        repositories.addAll(repos);
      }

      currentPage.value++;

    } catch (e) {
      reposError.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoadingRepos.value = false;
      isLoadingMore.value = false;
    }
  }

  void selectRepository(Repository repository) {
    selectedRepository.value = repository;
  }

  Future<void> openRepository(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
        if (!launched) throw 'launchUrl returned false';
      } else {
        throw 'canLaunchUrl returned false';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open URL: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  void searchUser() {
    final username = usernameController.text.trim();
    if (username.isNotEmpty) {
      fetchUser(username);
    } else {
      Get.snackbar(
        'Error',
        'Please enter a username',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  void clearData() {
    user.value = null;
    repositories.clear();
    userError.value = '';
    reposError.value = '';
    currentUsername.value = '';
    currentPage.value = 1;
    hasMoreRepos.value = true;
  }
}