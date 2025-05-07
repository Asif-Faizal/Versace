import 'package:flutter/material.dart';
import 'package:versace/core/theme/widgets/theme_switch.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final logo = Theme.of(context).brightness == Brightness.dark ? 'lib/assets/images/logo-white.png' : 'lib/assets/images/logo-black.png';
    return Scaffold(
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
        actions: const [
          ThemeSwitch(),
          SizedBox(width: 16),
        ],
      ),      
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Versace',style: textTheme.bodyLarge,),
              Text('Versace',style: textTheme.bodyMedium,),
              Text('Versace',style: textTheme.bodySmall,),
              Text('Versace',style: textTheme.labelLarge),
              Text('Versace',style: textTheme.labelMedium),
              Text('Versace',style: textTheme.labelSmall),
              Text('Versace',style: textTheme.titleLarge),
              Text('Versace',style: textTheme.titleMedium),
              Text('Versace',style: textTheme.titleSmall),
              Text('Versace',style: textTheme.headlineLarge),
              Text('Versace',style: textTheme.headlineMedium),
              Text('Versace',style: textTheme.headlineSmall),
              Text('Versace',style: textTheme.displayLarge),
              Text('Versace',style: textTheme.displayMedium),
              Text('Versace',style: textTheme.displaySmall),
              ElevatedButton(onPressed: (){}, child: Text('Elevated Button')),
              OutlinedButton(onPressed: (){}, child: Text('Outlined Button')),
              TextButton(onPressed: (){}, child: Text('Text Button')),
              IconButton(onPressed: (){}, icon: Icon(Icons.add)),
              TextButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text('Text Button Icon')),
              OutlinedButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text('Outlined Button Icon')),
              ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text('Elevated Button Icon')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your text',
                  )
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Text('Card'),
                    Text('Card'),
                    Text('Card'),
                    Text('Card'),
                    Text('Card'),
                    Text('Card'),
                    Text('Card'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
