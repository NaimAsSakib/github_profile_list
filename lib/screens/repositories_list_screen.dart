import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/github_controller.dart';
import '../utils/AppColor.dart';
import '../widgets/repository_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'repository_detail_screen.dart';

class RepositoriesListScreen extends StatelessWidget {
  final GitHubController controller = Get.find<GitHubController>();
  final ScrollController scrollController = ScrollController();

  RepositoriesListScreen({Key? key}) : super(key: key) {
    // Load repositories when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.repositories.isEmpty) {
        controller.fetchRepositories(refresh: true);
      }
    });

    // pagination setup
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (controller.hasMoreRepos.value &&
            !controller.isLoadingMore.value) {
          controller.fetchRepositories();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.colorPrimary,
          title: Obx(() => Text(
            '${controller.currentUsername.value}\'s Repos',
            style: const TextStyle(color: Colors.white),
          )),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

      body: Container(
        color: AppColor.whiteColor,
        child: Obx(() {
          if (controller.isLoadingRepos.value && controller.repositories.isEmpty) {
            return const LoadingWidget(message: 'Loading repositories...');
          }

          if (controller.reposError.isNotEmpty && controller.repositories.isEmpty) {
            return ErrorDisplayWidget(
              message: controller.reposError.value,
              onRetry: () => controller.fetchRepositories(refresh: true),
            );
          }

          if (controller.repositories.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No repositories found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchRepositories(refresh: true),
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.repositories.length +
                  (controller.hasMoreRepos.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.repositories.length) {
                  return controller.isLoadingMore.value
                      ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : const SizedBox.shrink();
                }

                final repo = controller.repositories[index];
                return RepositoryCard(
                  repository: repo,
                  onTap: () {
                    controller.selectRepository(repo);
                    Get.to(() => RepositoryDetailScreen());
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
