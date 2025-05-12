import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final logo = Theme.of(context).brightness == Brightness.dark ? 'lib/assets/images/logo-white.png' : 'lib/assets/images/logo-black.png';
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(tag: 'logo', child: Image.asset(logo,width: 40,height: 40,)),
            const SizedBox(width: 5),
            Hero(tag: 'title', child: Material(color: Colors.transparent,child: Text('VERCASE',style: textTheme.titleMedium))),
          ],
        ),
      ),      
      body: Center(
        child: Text('Initial Screen'),
      ),
    );
  }
}
