import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/product_list_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShopyApp());
}

class ShopyApp extends StatelessWidget {
  const ShopyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoppyy',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF252A5A),
        ),
      ),

      home: ProductListScreen(),
    );
  }
}