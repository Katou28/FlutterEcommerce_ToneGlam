import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  final String undertone;
  final String imageAsset;
  final List<Map<String, String>> articles;

  const ArticlePage({
    Key? key,
    required this.undertone,
    required this.imageAsset,
    required this.articles,
  }) : super(key: key);

  Color get undertoneColor {
    switch (undertone.toLowerCase()) {
      case 'warm':
        return Colors.orange.shade300;
      case 'cool':
        return Colors.blue.shade300;
      case 'neutral':
        return Colors.green.shade300;
      default:
        return Colors.pink.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$undertone Undertone Articles'),
        backgroundColor: undertoneColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Best Tips & Articles for $undertone Undertone',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: undertoneColor,
                ),
              ),
            ),
            ...articles
                .map((article) => _ArticleCard(article: article))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Map<String, String> article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: article['image'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  article['image']!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              )
            : null,
        title: Text(
          article['title'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(article['subtitle'] ?? ''),
      ),
    );
  }
}

// Example usage (to be used in navigation):
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => ArticlePage(
//       undertone: 'Warm',
//       imageAsset: 'assets/ArticlePhoto/warm_example.jpg',
//       articles: [
//         {
//           'title': 'Top 5 Foundations for Warm Undertones',
//           'subtitle': 'Find your perfect match!',
//           'image': 'assets/ArticlePhoto/foundation_warm.jpg',
//         },
//         // ... more articles
//       ],
//     ),
//   ),
// );
