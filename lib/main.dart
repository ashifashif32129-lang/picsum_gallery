
import 'package:flutter/material.dart';
import 'package:picsum_gallery/screens/spalsh_screen.dart';
import 'package:provider/provider.dart';

import 'providers/gallery_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GalleryProvider(),
      child: const PicsumGalleryApp(),
    ),
  );
}

class PicsumGalleryApp extends StatelessWidget {
  const PicsumGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Picsum Gallery',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF100D24),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7138E8),
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
