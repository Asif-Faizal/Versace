import 'package:flutter/material.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 200,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterChip(
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  pressElevation: 5,
                  label: Text('Standard Shipping'),
                  selected: true,
                  onSelected: (value) {},
                  showCheckmark: false,
                  selectedColor: isDark ? Colors.white : Colors.black,
                  checkmarkColor: isDark ? Colors.black : Colors.white,
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  pressElevation: 5,
                  label: Text('Premium Shipping'),
                  selected: false,
                  onSelected: (value) {},
                  showCheckmark: false,
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                    color: isDark ? Colors.white : Colors.black,
                    width: 0.5,
                  ),
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(
            3,
            (index) => CartItem(
              isDark: isDark,
              textTheme: textTheme,
              onDelete: () {
                // Implement delete functionality
              },
              onMoveToCart: () {
                // Implement move to cart functionality
              },
              title: 'Product ${index + 1}',
              description: 'This is a sample product description for item ${index + 1}',
              image: 'lib/assets/images/shirt.jpg',
              price: 100.00,
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping:',
                  style: textTheme.bodySmall,
                ),
                Expanded(
                  child: Text(
                    'Apt. 853 27239 Nitzsche Centers, Lake Morris, Nitzsche Centers, Lake Morris, NC 77791',
                    style: textTheme.bodySmall?.copyWith(decoration: TextDecoration.underline),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total (3 items):',
                  style: textTheme.titleSmall,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$310.00',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'View full breakdown',
                      style: textTheme.bodySmall?.copyWith(decoration: TextDecoration.underline, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Implement checkout functionality
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                ),
                child: Text(
                  'Proceed to Checkout',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
