import 'package:flutter/material.dart';

import '../widgets/favorites_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset('lib/assets/images/broken.png',width: 100,height: 100,),
      //       Text('No favorites yet',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        title: Text('Favorites',style: textTheme.titleLarge,),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return FavoritesItem(isDark: isDark, textTheme: textTheme, onDelete: (){}, onMoveToCart: (){}, title: 'Item $index', description: 'Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index Item $index ', image: 'lib/assets/images/shirt.jpg');
        },
      ),
    );
  }
}
