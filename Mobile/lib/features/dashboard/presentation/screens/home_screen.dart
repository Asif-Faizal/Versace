import 'package:flutter/material.dart';
import '../widgets/auto_scroll_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final logo =
        Theme.of(context).brightness == Brightness.dark
            ? 'lib/assets/images/logo-white.png'
            : 'lib/assets/images/logo-black.png';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 85,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            child: DropdownButton<String>(
              value: 'women',
              style: textTheme.bodyMedium,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down),
              dropdownColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
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
            onPressed: () {},
            icon: Icon(Icons.search, size: 15),
            label: Text('Search', style: textTheme.bodyMedium),
          ),
        ],
      ),
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {},
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.shop_2_rounded, size: 40),
                              Text('Shop', style: textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(
                height: 1,
                color: Colors.grey,
              ),
            ),
            SliverToBoxAdapter(
              child: AutoScrollText(
                text: 'New Arrivals',
                style: textTheme.displayLarge?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      color: index % 2 == 0 ? Colors.grey[200] : Colors.grey[300],
                      child: Center(
                        child: Text(
                          'Item ${index + 1}',
                          style: textTheme.titleLarge,
                        ),
                      ),
                    );
                  },
                  childCount: 4,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(
                height: 1,
                color: Colors.grey,
              ),
            ),
            SliverToBoxAdapter(
              child: AutoScrollText(
                itemWidth: 300,
                text: 'Trending',
                style: textTheme.displayLarge?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
