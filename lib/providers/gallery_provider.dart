
import 'package:flutter/material.dart';

import '../models/picsum_image.dart';
import '../services/picsum_service.dart';

class GalleryProvider extends ChangeNotifier {
  final PicsumService _service = PicsumService();

  final List<PicsumImage> _images = [];

  List<PicsumImage> get images => List.unmodifiable(_images);

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

  String? error;

  int _skip = 0;
  final int _limit = 20;

  Future<void> fetchImages({bool refresh = false}) async {
    if (isLoading || isLoadingMore) return;
    if (!refresh && !hasMore) return;

    if (refresh) {
      _skip = 0;
      hasMore = true;
    }

    if (_skip == 0) {
      isLoading = true;
    } else {
      isLoadingMore = true;
    }

    error = null;
    notifyListeners();

    try {
      final result = await _service.fetchImages(
        skip: _skip,
        limit: _limit,
      );

      if (_skip == 0) {
        _images.clear();
      }

      _images.addAll(result);

      _skip += result.length;

      hasMore = result.length == _limit;
    } catch (e) {
      error = 'Unable to load images. Please try again.';
      debugPrint('API Error: $e');
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
