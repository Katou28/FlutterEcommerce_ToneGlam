import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/featureProduct.dart';
import 'package:toneglam/communityFeed.dart';
import 'package:toneglam/profilePage.dart';
import 'package:toneglam/undertone_quiz.dart';
import 'package:toneglam/widgets/bottom_nav_bar.dart';
import 'package:toneglam/models/cart_manager.dart';
import 'package:toneglam/article_page.dart';
import 'package:toneglam/models/post_manager.dart' as pm;
import 'dart:io';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmetics Hub',
      theme: ThemeData(
        primaryColor: Colors.pink[300],
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildUndertoneQuiz(),
            _buildSectionTitle('Featured Products'),
            _buildProductGrid(),
            _buildSectionTitle('Community Posts'),
            _buildCommunityFeed(),
            _buildSectionTitle('Beauty Articles'),
            _buildArticlesList(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.pink[300],
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/logo/Toneglam.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                    children: const [
                      TextSpan(text: 'Tone'),
                      TextSpan(
                        text: 'Glam',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Perfect Shade, Perfect You!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.pink[100],
              child: Icon(
                Icons.person,
                color: Colors.pink[300],
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildUndertoneQuiz() {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade200, Colors.pink.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100.withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(Icons.quiz_rounded, color: Colors.pink[300], size: 36),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Your Perfect Undertone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[800],
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Take our quick quiz and find your ideal shade!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.pink[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 120,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UndertoneQuiz()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 4,
                      shadowColor: Colors.pink[200],
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Take the Quiz',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (title != 'Beauty Articles') ...[
            const Spacer(),
            TextButton(
              child: Text('See All', style: TextStyle(color: Colors.pink[300])),
              onPressed: () {
                if (title == 'Featured Products') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FeatureProductPage()),
                  );
                } else if (title == 'Community Posts') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CommunityPage()),
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final List<Map<String, String>> featuredProducts =
        productsByTone['Warm']!.take(5).toList();
    return Container(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredProducts.length,
        itemBuilder: (context, index) {
          final product = featuredProducts[index];
          return _buildProductCard(
            product['name']!,
            product['price']!,
            product['shade']!,
            product['image']!,
          );
        },
      ),
    );
  }

  Widget _buildCommunityFeed() {
    final posts = context.watch<pm.PostManager>().posts;
    final int count = posts.length >= 2 ? 2 : posts.length;
    return Container(
      height: 200,
      child: count == 0
          ? Center(child: Text('No community posts yet'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: count,
              itemBuilder: (context, index) {
                final post = posts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommunityPage()),
                    );
                  },
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: post.imagePath != null
                          ? DecorationImage(
                              image: post.imagePath!.startsWith('assets/')
                                  ? AssetImage(post.imagePath!) as ImageProvider
                                  : FileImage(File(post.imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Colors.grey[200],
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          post.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 6,
                                offset: Offset(0, 2),
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

  Widget _buildArticlesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _ArticleCategoryCard(
            title: 'Warm Undertone',
            imageAsset: 'assets/ArticlePhoto/WARM.png',
            color: Colors.orange.shade300,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticlePage(
                    undertone: 'Warm',
                    imageAsset: 'assets/ArticlePhoto/WARM.png',
                    articles: [
                      {
                        'title': '5 Makeup Tips for Warm Skin Tones',
                        'subtitle':
                            'Follow these makeup tips for warm undertones to create a face-flattering makeup look.',
                        'image': 'assets/ArticlePhoto/WARM.png',
                      },
                      {
                        'title': 'Choose the Right Foundation',
                        'subtitle':
                            'Pick a foundation with yellow undertones for a flawless base.',
                        'image': 'assets/ArticlePhoto/WARM (2).png',
                      },
                      {
                        'title': 'Use Bronze and Gold Eyeshadows',
                        'subtitle':
                            'Gold and rust shades complement warm undertones beautifully.',
                        'image': 'assets/ArticlePhoto/(WARM).png',
                      },
                      {
                        'title': 'Rock a Purple Shade on Your Lips',
                        'subtitle':
                            'Warm purple lipsticks add a pretty pop of color.',
                        'image': 'assets/ArticlePhoto/WARM.png',
                      },
                      {
                        'title': 'Shine Bright With Highlighter',
                        'subtitle':
                            'Apply warm highlighter for a glowing complexion.',
                        'image': 'assets/ArticlePhoto/WARM (2).png',
                      },
                      {
                        'title': 'Blush It Up',
                        'subtitle':
                            'Use blush shades like amber or rosewood for a natural flush.',
                        'image': 'assets/ArticlePhoto/(WARM).png',
                      },
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _ArticleCategoryCard(
            title: 'Cool Undertone',
            imageAsset: 'assets/ArticlePhoto/COOL.png',
            color: Colors.blue.shade300,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticlePage(
                    undertone: 'Cool',
                    imageAsset: 'assets/ArticlePhoto/COOL.png',
                    articles: [
                      {
                        'title':
                            'Makeup Tips: The Telltale Signs of Cool Skin Tones',
                        'subtitle':
                            'Learn how to identify and enhance your cool undertones.',
                        'image': 'assets/ArticlePhoto/COOL.png',
                      },
                      {
                        'title':
                            'The Best Foundation Shades for Your Skin Tone',
                        'subtitle':
                            'Choose neutral or pink-based foundations for a flawless finish.',
                        'image': 'assets/ArticlePhoto/COOL (2).png',
                      },
                      {
                        'title': 'Enhance with Rosy Cheeks and Soft Pink Pout',
                        'subtitle':
                            'Monochromatic rose tones flatter cool undertones.',
                        'image': 'assets/ArticlePhoto/COOL (3).png',
                      },
                      {
                        'title': 'Add a Pop of Jewel-Toned Eyeshadow',
                        'subtitle':
                            'Blue, purple, and green eyeshadows complement cool skin.',
                        'image': 'assets/ArticlePhoto/COOL.png',
                      },
                      {
                        'title':
                            'Nighttime Drama: Deeper Lips and Colored Liner',
                        'subtitle':
                            'Go bold with berry lips and colored liner for evening looks.',
                        'image': 'assets/ArticlePhoto/COOL (2).png',
                      },
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _ArticleCategoryCard(
            title: 'Neutral Undertone',
            imageAsset: 'assets/ArticlePhoto/NEUTRAL.png',
            color: Colors.green.shade300,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticlePage(
                    undertone: 'Neutral',
                    imageAsset: 'assets/ArticlePhoto/NEUTRAL.png',
                    articles: [
                      {
                        'title': 'The Versatility of Neutral Undertones',
                        'subtitle':
                            'Discover the balance and flexibility of neutral undertones.',
                        'image': 'assets/ArticlePhoto/NEUTRAL.png',
                      },
                      {
                        'title': 'Lip Tints for Neutral Undertones',
                        'subtitle':
                            'Experiment with a wide range of lip tint shades.',
                        'image': 'assets/ArticlePhoto/NEUTRAL (2).png',
                      },
                      {
                        'title': 'Blush Recommendations for Neutral Undertones',
                        'subtitle':
                            'Brighten your complexion with these blush picks.',
                        'image': 'assets/ArticlePhoto/NEUTRAL (3).png',
                      },
                      {
                        'title': 'Eyeshadow Palettes for Neutral Undertones',
                        'subtitle':
                            'Rock both warm earth tones and cool neutrals.',
                        'image': 'assets/ArticlePhoto/NEUTRAL.png',
                      },
                      {
                        'title':
                            'Embrace and Celebrate Your Neutral Undertones',
                        'subtitle':
                            'Tips for achieving flawless, harmonious looks.',
                        'image': 'assets/ArticlePhoto/NEUTRAL (2).png',
                      },
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
      String name, String price, String shade, String imageUrl) {
    return Container(
      width: 180,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child:
                            Icon(Icons.error_outline, color: Colors.grey[400]),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(price, style: TextStyle(color: Colors.pink[300])),
                    Text('Shade: $shade',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon:
                    Icon(Icons.shopping_cart_outlined, color: Colors.pink[300]),
                onPressed: () {
                  final cartManager =
                      Provider.of<CartManager>(context, listen: false);
                  cartManager.addItem(
                    CartItem(
                      id: name + shade,
                      name: name,
                      price: price,
                      shade: shade,
                      imageUrl: imageUrl,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to cart: $name'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                iconSize: 20,
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCategoryCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final Color color;
  final VoidCallback onTap;

  const _ArticleCategoryCard({
    required this.title,
    required this.imageAsset,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imageAsset),
              radius: 32,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
