import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/AppBinding.dart';
import 'screens/github_profile_screen.dart';
import 'screens/repositories_list_screen.dart';
import 'screens/repository_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GitHub Profile App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialBinding: AppBinding(),
      initialRoute: '/profile',
      getPages: [
        GetPage(
          name: '/profile',
          page: () => GitHubProfileScreen(),
        ),
        GetPage(
          name: '/repositories',
          page: () => RepositoriesListScreen(),
        ),
        GetPage(
          name: '/repository-detail',
          page: () => RepositoryDetailScreen(),
        ),
      ],
    );
  }
}
