
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/picsum_image.dart';
import '../providers/gallery_provider.dart';
import 'image_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String searchQuery = '';
  int selectedCategory = 0;

  static const Color background = Color(0xFF090814);
  static const Color surface = Color(0xFF171426);
  static const Color primary = Color(0xFFA78BFA);
  static const Color secondary = Color(0xFFE879F9);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider =
      Provider.of<GalleryProvider>(context, listen: false);

      if (provider.images.isEmpty) {
        provider.fetchImages();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PicsumImage> getFilteredImages(
      List<PicsumImage> images) {
    if (searchQuery.trim().isEmpty) return images;

    return images.where((image) {
      return image.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Consumer<GalleryProvider>(
          builder: (context, provider, child) {
            final images = getFilteredImages(provider.images);

            return RefreshIndicator(
              color: primary,
              backgroundColor: surface,
              onRefresh: () =>
                  provider.fetchImages(refresh: true),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(provider),
                  ),

                  SliverToBoxAdapter(
                    child: _buildSearchBar(),
                  ),

                  SliverToBoxAdapter(
                    child: _buildCategorySection(),
                  ),

                  SliverToBoxAdapter(
                    child: _buildSectionTitle(images.length),
                  ),

                  if (provider.isLoading && images.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primary,
                        ),
                      ),
                    )
                  else if (provider.error != null &&
                      images.isEmpty)
                    SliverFillRemaining(
                      child: _buildError(provider),
                    )
                  else if (images.isEmpty)
                      const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No images found',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final image = images[index];

                              return _buildImageCard(
                                image,
                                index,
                              );
                            },
                            childCount: images.length,
                          ),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                        ),
                      ),

                  if (provider.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primary,
                          ),
                        ),
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: _buildLoadMore(provider),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 30),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(GalleryProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [primary, secondary],
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PIXORA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'VISUAL COLLECTION',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          const Text(
            'Explore the',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w300,
            ),
          ),

          const Text(
            'Beautiful World.',
            style: TextStyle(
              color: primary,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Discover inspiring visuals and creative moments.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF302052),
                  Color(0xFF19142C),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: primary.withOpacity(0.22),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.photo_library_outlined,
                  color: primary,
                  size: 28,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Gallery',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${provider.images.length} Beautiful Images',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.07),
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search your favourite images...',
            hintStyle: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: primary,
            ),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  searchQuery = '';
                });
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white54,
              ),
            )
                : const Icon(
              Icons.tune_rounded,
              color: Colors.white54,
            ),
            border: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      'All',
      'Popular',
      'Nature',
      'Lifestyle',
    ];

    return SizedBox(
      height: 75,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 18,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 19,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                  colors: [primary, secondary],
                )
                    : null,
                color: isSelected ? null : surface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 5, 22, 18),
      child: Row(
        children: [
          const Text(
            'Featured Collection',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            '$count photos',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(PicsumImage image, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageDetailScreen(image: image),
          ),
        );
      },
      child: Hero(
        tag: 'gallery_${image.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            color: surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: image.thumbnail,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    color: surface,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: primary,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 35,
                    ),
                  );
                },
              ),

              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.3, 0.55, 1],
                  ),
                ),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),

              Positioned(
                left: 13,
                right: 10,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      image.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          color: primary,
                          size: 12,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Explore photo',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(GalleryProvider provider) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: primary,
            size: 55,
          ),
          const SizedBox(height: 15),
          const Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your internet connection.',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => provider.fetchImages(refresh: true),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMore(GalleryProvider provider) {
    if (provider.isLoading ||
        provider.isLoadingMore ||
        !provider.hasMore ||
        provider.images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: () => provider.fetchImages(),
          icon: const Icon(Icons.add),
          label: const Text('Load More Images'),
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
