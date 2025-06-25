import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:github_profile_app/utils/AppColor.dart';
import '../controllers/github_controller.dart';
import '../widgets/user_info_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class GitHubProfileScreen extends StatelessWidget {
  final GitHubController controller = Get.find<GitHubController>();

  GitHubProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.colorPrimary,
        title: const Text(
          'GitHub Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Section
                  Card(
                    color: AppColor.whiteColor,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: controller.usernameController,
                            decoration: const InputDecoration(
                              labelText: 'GitHub Username',
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: 'Enter username',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.colorAccent, width: 2),
                              ),
                            ),
                            onSubmitted: (value) => controller.searchUser(),
                          ),


                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: controller.searchUser,
                              label: const Text(
                                'Search User',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.colorPrimaryDark,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: const BorderSide(color: AppColor.colorPrimaryDark),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // User Profile Section
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6, // Adjust based on design
                    child: Obx(() {
                      if (controller.isLoadingUser.value) {
                        return const LoadingWidget(message: 'Fetching user data...');
                      }

                      if (controller.userError.isNotEmpty) {
                        return ErrorDisplayWidget(
                          message: controller.userError.value,
                          onRetry: () =>
                              controller.fetchUser(controller.currentUsername.value),
                        );
                      }

                      if (controller.user.value != null) {
                        return UserInfoCard(user: controller.user.value!);
                      }

                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_search, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Enter a GitHub username to get started',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}