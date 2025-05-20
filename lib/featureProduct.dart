import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/undertone_quiz.dart';
import 'package:toneglam/models/cart_manager.dart';
import 'package:toneglam/widgets/bottom_nav_bar.dart';

final Map<String, List<Map<String, String>>> productsByTone = {
  'Warm': [
    {
      'name': 'Vice Cosmetics – One & Done Brontour Stick',
      'price': 'P 395.00',
      'shade': 'Push, Achieve',
      'image':
          'assets/Products/Warm/Vice Cosmetics – One & Done Brontour Stick(achieve).png'
    },
    {
      'name': 'Vice Cosmetics – Dew It All Liquid Blush',
      'price': 'P 175.00',
      'shade': 'Always Blushin\'',
      'image':
          'assets/Products/Warm/Vice Cosmetics – Dew It All Liquid Blush.png'
    },
    {
      'name': 'ISSY – Creme Cheek Blush',
      'price': 'P 349.00',
      'shade': 'Bang',
      'image': 'assets/Products/Warm/ISSY – Creme Cheek Blush(bang).jpg'
    },
    {
      'name': 'ISSY – Creme Cheek Blush',
      'price': 'P 349.00',
      'shade': 'Karma',
      'image': 'assets/Products/Warm/ISSY – Creme Cheek Blush(karma).png'
    },
    {
      'name': 'Colourette – First Base Skin Tint',
      'price': 'P 599.00',
      'shade': 'Siargao',
      'image':
          'assets/Products/Warm/Colourette – First Base Skin Tint(siargao).png'
    },
    {
      'name': 'ISSY – Skin Tint',
      'price': 'P 499.00',
      'shade': 'Brulee',
      'image': 'assets/Products/Warm/ISSY – Skin Tint(brulee).jpg'
    },
  ],
  'Cool': [
    {
      'name': 'Strokes – Soft Veil Filter Foundation',
      'price': 'P 648.00',
      'shade': 'Light 01',
      'image':
          'assets/Products/Cool/Strokes – Soft Veil Filter Foundation(light 01).png'
    },
    {
      'name': 'Strokes – Face Sculpt Cream Contour Stick',
      'price': 'P 498.00',
      'shade': 'Peanut',
      'image':
          'assets/Products/Cool/Strokes – Face Sculpt Cream Contour Stick(peanut).png'
    },
    {
      'name': 'Blk Cosmetics – Life-proof Airy Concealer',
      'price': 'P 319.00',
      'shade': 'Creme',
      'image':
          'assets/Products/Cool/Blk Cosmetics – Life-proof Airy Concealer(cream).png'
    },
    {
      'name': 'Happy Skin – Second Skin Tinted Moisturizer',
      'price': 'P 449.00',
      'shade': 'Light Beige',
      'image':
          'assets/Products/Cool/Happy Skin – Second Skin Tinted Moisturizer(light).png'
    },
    {
      'name': 'GRWM – Milk Tint Creamy Tint',
      'price': 'P 379.00',
      'shade': 'Material Girl',
      'image':
          'assets/Products/Cool/GRWM – Milk Tint Creamy Tint(material girl).png'
    },
    {
      'name': 'Ever Bilena – Two Way Cake',
      'price': 'P 150.00',
      'shade': 'Oriental',
      'image': 'assets/Products/Cool/Ever Bilena – Two Way Cake(Oriental).png'
    },
  ],
  'Neutral': [
    {
      'name': 'Maybelline – Matte + Poreless Liquid Foundation',
      'price': 'P 499.00',
      'shade': 'Buff Beige',
      'image':
          'assets/Products/Neutral/Maybelline – Matte + Poreless Liquid Foundation(buff beige).png'
    },
    {
      'name': 'Maybelline - Sunkisser Hazy Matte Blush',
      'price': 'P 399.00',
      'shade': 'Spicy Red',
      'image':
          'assets/Products/Neutral/Maybelline - Sunkisser Hazy Matte Blush(spicy red).jpg'
    },
    {
      'name': 'Sunnies Face – Skin So Goog The powder',
      'price': 'P 490.00',
      'shade': 'Sesame',
      'image':
          'assets/Products/Neutral/Sunnies Face – Skin So Goog The powder(sesame).png'
    },
    {
      'name': 'Colourette – Second Base Concealer',
      'price': 'P 379.00',
      'shade': 'Lazi',
      'image':
          'assets/Products/Neutral/Colourette – Second Base Concealer(lazi).png'
    },
    {
      'name': 'Teviant - The Ultimate Skin Master Foundation',
      'price': 'P 995.00',
      'shade': 'Eggshell (Light 3)',
      'image':
          'assets/Products/Neutral/Teviant - The Ultimate Skin Master Foundation(Eggshell (Light 3).png'
    },
    {
      'name': 'Careline - Acne Spot Concealer',
      'price': 'P 289.00',
      'shade': 'Natural',
      'image':
          'assets/Products/Neutral/Careline - Acne Spot Concealer(natural).jpg'
    },
  ],
};

class FeatureProductPage extends StatefulWidget {
  @override
  _FeatureProductPageState createState() => _FeatureProductPageState();
}

class _FeatureProductPageState extends State<FeatureProductPage> {
  String _selectedTone = 'Warm'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shop Products",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.pink[300]),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildToneTabs(),
          Expanded(child: _buildProductList()),
          _buildQuizContainer(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
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

  Widget _buildToneTabs() {
    final tones = ['Warm', 'Cool', 'Neutral'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tones.map((tone) {
          final isSelected = _selectedTone == tone;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.pink[300] : Colors.pink[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => setState(() => _selectedTone = tone),
            child: Text(
              tone,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.pink[300],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductList() {
    final selectedProducts = productsByTone[_selectedTone] ?? [];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: selectedProducts.length,
      itemBuilder: (context, index) {
        final product = selectedProducts[index];
        return CustomProductCard(
          name: product['name']!,
          price: product['price']!,
          shade: product['shade']!,
          imageUrl: product['image']!,
        );
      },
    );
  }

  Widget _buildQuizContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink[50]!,
            Colors.pink[100]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[100]!.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.quiz,
                  color: Colors.pink[300],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "Take our undertone quiz to find your perfect match!",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.pink[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UndertoneQuiz()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              minimumSize: Size(0, 28),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_circle_outline, size: 14),
                const SizedBox(width: 4),
                const Text(
                  "Quiz",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return const BottomNavBar(currentIndex: 0);
  }
}

class CustomProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String shade;
  final String imageUrl;

  const CustomProductCard({
    required this.name,
    required this.price,
    required this.shade,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Shade: $shade',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                          color: Colors.pink[300], fontWeight: FontWeight.bold),
                    ),
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
