
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/picsum_image.dart';

class ImageDetailScreen extends StatelessWidget {
  final PicsumImage image;

  const ImageDetailScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = image.images.isNotEmpty
        ? image.images.first
        : image.thumbnail;

    return Scaffold(
      appBar: AppBar(
        title: Text(image.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (_, __) =>
                  const CircularProgressIndicator(),
                  errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 60),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              image.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
