import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../../cubit/bottom_nav_state.dart';
import '../widgets/auto_scroll_text.dart';
import '../widgets/gradient_image.dart';

// Add SliverPersistentHeaderDelegate implementation
class _HorizontalCategoriesDelegate extends SliverPersistentHeaderDelegate {
  final TextStyle textStyle;

  _HorizontalCategoriesDelegate(this.textStyle);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final categoryItems = [
            {'icon': Icons.shop_2_rounded, 'label': 'Shop'},
            {'icon': Icons.new_releases_outlined, 'label': 'New'},
            {'icon': Icons.star_border, 'label': 'Featured'},
            {'icon': Icons.local_offer_outlined, 'label': 'Sale'},
            {'icon': Icons.checkroom_outlined, 'label': 'Men'},
            {'icon': Icons.diamond_outlined, 'label': 'Women'},
            {'icon': Icons.watch_outlined, 'label': 'Watches'},
            {'icon': Icons.wallet_outlined, 'label': 'Bags'},
            {'icon': Icons.style_outlined, 'label': 'Accessories'},
            {'icon': Icons.favorite_border, 'label': 'Wishlist'},
          ];
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 15, top: 5),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {},
                child: Container(
                  width: 70,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(categoryItems[index]['icon'] as IconData, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          categoryItems[index]['label'] as String, 
                          style: textStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant _HorizontalCategoriesDelegate oldDelegate) {
    return textStyle != oldDelegate.textStyle;
  }
}

// Add a sliver delegate for parallax header
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  
  @override
  double get maxExtent => maxHeight;
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }
  
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final logo =
        Theme.of(context).brightness == Brightness.dark
            ? 'lib/assets/images/logo-white.png'
            : 'lib/assets/images/logo-black.png';
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 85,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            child: DropdownButtonFormField<String>(
              value: 'women',
              style: textTheme.bodyMedium,
              icon: const Icon(Icons.arrow_drop_down),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              dropdownColor: isDark ? Colors.black : Colors.white,
              padding: EdgeInsets.zero,
              items: [
                DropdownMenuItem(
                  value: 'men',
                  child: Text('Men\'s', style: textTheme.bodyMedium),
                ),
                DropdownMenuItem(
                  value: 'women',
                  child: Text('Women\'s', style: textTheme.bodyMedium),
                ),
              ],
              onChanged: (value) {
                print(value);
              },
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(tag: 'logo', child: Image.asset(logo, width: 40, height: 40)),
            const SizedBox(width: 5),
            Hero(
              tag: 'title',
              child: Material(
                color: Colors.transparent,
                child: Text('VERCASE', style: textTheme.titleMedium),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            iconAlignment: IconAlignment.end,
            onPressed: () {
              context.read<BottomNavCubit>().select(
                const BottomNavState.search(),
              );
            },
            icon: Icon(Icons.search, size: 15),
            label: Text('Search', style: textTheme.bodyMedium),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Replace SliverToBoxAdapter with SliverPersistentHeader
          SliverPersistentHeader(
            pinned: true,
            delegate: _HorizontalCategoriesDelegate(textTheme.bodyMedium!),
          ),
          
          // Parallax feature image
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              minHeight: 50.0, 
              maxHeight: 500.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Hero(
                      tag: 'feature-banner',
                      child: GradientImage(
                        imagePath: 'lib/assets/images/img.jpg',
                        width: double.infinity,
                        title: 'Summer 2025',
                        subtitle: 'Shop Now',
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // New arrivals section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: AutoScrollText(
                text: 'New Arrivals -',
                style: textTheme.displayLarge?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
                itemWidth: 435,
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'product-$index',
                        child: Image.asset(
                          index == 0 || index == 3
                              ? 'lib/assets/images/img.jpg'
                              : 'lib/assets/images/shirt.jpg',
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: 4),
            ),
          ),
          
          // Trending section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: AutoScrollText(
                text: 'Trending -',
                style: textTheme.displayLarge?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
                itemWidth: 325,
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        index == 0
                            ? 'lib/assets/images/img.jpg'
                            : 'lib/assets/images/shirt.jpg',
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                );
              }, childCount: 2),
            ),
          ),
          
          // Collections section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: AutoScrollText(
                text: 'Collections -',
                style: textTheme.displayLarge?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
                itemWidth: 395,
              ),
            ),
          ),
          
          SliverList.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: GradientImage(
                    imagePath: index == 0
                        ? 'lib/assets/images/collection1.jpg'
                        : 'lib/assets/images/collection2.jpg',
                    width: double.infinity,
                    height: 400,
                    title: 'Collections by Sabrina',
                    subtitle: 'View Collection',
                    onPressed: () {},
                  ),
                ),
              );
            },
            itemCount: 2,
          ),
          
          // Add spacing at the bottom
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}
