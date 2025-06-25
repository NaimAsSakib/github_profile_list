import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/github_controller.dart';
import '../models/repository.dart';
import '../utils/AppColor.dart';
import '../widgets/buildStatItem.dart';

class RepositoryDetailScreen extends StatelessWidget {
  final GitHubController controller = Get.find<GitHubController>();

  RepositoryDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.colorPrimary,
        title: Obx(() => Text(
          controller.selectedRepository.value?.name ?? 'Repository',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white), // White title text
        )),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // White icons (e.g., back button)
      ),

      body: Obx(() {
        final repo = controller.selectedRepository.value;
        if (repo == null) {
          return const Center(
            child: Text('No repository selected'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: AppColor.whiteColor,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.folder, size: 28, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              repo.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (repo.description != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          repo.description!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                color: AppColor.whiteColor,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Repository Statistics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: buildStatItem(
                              icon: Icons.star,
                              label: 'Stars',
                              value: repo.stargazersCount.toString(),
                              color: Colors.amber,
                            ),
                          ),
                          SizedBox(width: 10),
                          if (repo.language != null)
                            Expanded(
                              child: buildStatItem(
                                icon: Icons.code,
                                label: 'Language',
                                value: repo.language!,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                color: AppColor.whiteColor,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => controller.openRepository(repo.htmlUrl),
                          icon: const Icon(Icons.open_in_browser),
                          label: const Text('Open in Browser'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: AppColor.colorPrimaryDark,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

}