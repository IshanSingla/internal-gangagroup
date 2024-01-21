import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internal/app/services/PushNotificationService.dart';
import 'app/routes/app_pages.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService().setupInteractedMessage();
  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
