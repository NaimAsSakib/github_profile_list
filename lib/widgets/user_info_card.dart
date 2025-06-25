import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:github_profile_app/utils/AppColor.dart';
import '../models/github_user.dart';
import '../controllers/github_controller.dart';
import '../screens/repositories_list_screen.dart';

class UserInfoCard extends StatelessWidget {
  final GitHubUser user;
  final GitHubController controller = Get.find<GitHubController>();

  UserInfoCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            color: AppColor.whiteColor,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Clip the corners slightly
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar and Name
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(user.avatarUrl),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    user.name ?? user.login,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (user.name != null)
                    Text(
                      '@${user.login}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),

                  if (user.bio != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      user.bio!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  if (user.location != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          user.location!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Followers',
                  count: user.followers,
                  icon: Icons.people,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  title: 'Following',
                  count: user.following,
                  icon: Icons.person_add,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  title: 'Repos',
                  count: user.publicRepos,
                  icon: Icons.folder,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // View Repositories Button
          if (user.publicRepos > 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.to(() => RepositoriesListScreen()),
                icon: const Icon(Icons.folder_open),
                label: const Text('View Repositories'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColor.colorPrimaryDark,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: AppColor.whiteColor,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}