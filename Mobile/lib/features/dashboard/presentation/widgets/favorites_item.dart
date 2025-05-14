import 'package:flutter/material.dart';

class FavoritesItem extends StatelessWidget {
  const FavoritesItem({
    super.key,
    required this.isDark,
    required this.textTheme,
    required this.onDelete,
    required this.onMoveToCart,
    required this.title,
    required this.description,
    required this.image,
  });

  final bool isDark;
  final TextTheme textTheme;
  final VoidCallback onDelete;
  final VoidCallback onMoveToCart;
  final String title;
  final String description;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
          border: Border.all(color: isDark ? Colors.white : Colors.black, width: 0.5),
        ),
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(3)),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(description,style: textTheme.bodySmall,maxLines: 2,overflow: TextOverflow.ellipsis,),
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          fixedSize: Size(double.infinity, 40),
                        ),
                        onPressed: onMoveToCart,
                        icon: Icon(Icons.add_shopping_cart,size: 18,),
                        label: Text('Move to cart',style: textTheme.labelSmall?.copyWith(color: isDark ? Colors.black : Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 10,
        right: 10,
        child: IconButton(onPressed: onDelete, icon: Icon(Icons.close,size: 20,)),
      ),
      ],
    );
  }
}
