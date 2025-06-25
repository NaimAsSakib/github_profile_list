import 'package:get/get.dart';
import '../controllers/github_controller.dart';
import '../services/github_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GitHubService>(GitHubService());
    Get.put<GitHubController>(GitHubController());
  }
}