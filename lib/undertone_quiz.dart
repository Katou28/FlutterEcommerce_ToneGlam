import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/models/cart_manager.dart';
import 'package:toneglam/featureProduct.dart';

class UndertoneQuiz extends StatefulWidget {
  @override
  _UndertoneQuizState createState() => _UndertoneQuizState();
}

class _UndertoneQuizState extends State<UndertoneQuiz> {
  int _currentQuestion = 0;
  int _warmPoints = 0;
  int _coolPoints = 0;
  int _neutralPoints = 0;
  String? _result;
  int? _selectedAnswerIndex;

  final Map<String, List<Map<String, String>>> _undertoneArticles = {
    'Warm': [
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
        'subtitle': 'Warm purple lipsticks add a pretty pop of color.',
        'image': 'assets/ArticlePhoto/WARM.png',
      },
      {
        'title': 'Shine Bright With Highlighter',
        'subtitle': 'Apply warm highlighter for a glowing complexion.',
        'image': 'assets/ArticlePhoto/WARM (2).png',
      },
    ],
    'Cool': [
      {
        'title': 'Makeup Tips: The Telltale Signs of Cool Skin Tones',
        'subtitle': 'Learn how to identify and enhance your cool undertones.',
        'image': 'assets/ArticlePhoto/COOL.png',
      },
      {
        'title': 'The Best Foundation Shades for Your Skin Tone',
        'subtitle':
            'Choose neutral or pink-based foundations for a flawless finish.',
        'image': 'assets/ArticlePhoto/COOL (2).png',
      },
      {
        'title': 'Enhance with Rosy Cheeks and Soft Pink Pout',
        'subtitle': 'Monochromatic rose tones flatter cool undertones.',
        'image': 'assets/ArticlePhoto/COOL (3).png',
      },
      {
        'title': 'Add a Pop of Jewel-Toned Eyeshadow',
        'subtitle': 'Blue, purple, and green eyeshadows complement cool skin.',
        'image': 'assets/ArticlePhoto/COOL.png',
      },
      {
        'title': 'Nighttime Drama: Deeper Lips and Colored Liner',
        'subtitle':
            'Go bold with berry lips and colored liner for evening looks.',
        'image': 'assets/ArticlePhoto/COOL (2).png',
      },
    ],
    'Neutral': [
      {
        'title': 'The Versatility of Neutral Undertones',
        'subtitle':
            'Discover the balance and flexibility of neutral undertones.',
        'image': 'assets/ArticlePhoto/NEUTRAL.png',
      },
      {
        'title': 'Lip Tints for Neutral Undertones',
        'subtitle': 'Experiment with a wide range of lip tint shades.',
        'image': 'assets/ArticlePhoto/NEUTRAL (2).png',
      },
      {
        'title': 'Blush Recommendations for Neutral Undertones',
        'subtitle': 'Brighten your complexion with these blush picks.',
        'image': 'assets/ArticlePhoto/NEUTRAL (3).png',
      },
      {
        'title': 'Eyeshadow Palettes for Neutral Undertones',
        'subtitle': 'Rock both warm earth tones and cool neutrals.',
        'image': 'assets/ArticlePhoto/NEUTRAL.png',
      },
      {
        'title': 'Embrace and Celebrate Your Neutral Undertones',
        'subtitle': 'Tips for achieving flawless, harmonious looks.',
        'image': 'assets/ArticlePhoto/NEUTRAL (2).png',
      },
    ],
  };

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What type of jewelry looks best on you?',
      'options': ['Gold', 'Silver', 'Both'],
      'points': [
        {'type': 'warm', 'points': 1},
        {'type': 'cool', 'points': 1},
        {'type': 'neutral', 'points': 1},
      ],
    },
    {
      'question':
          'When you\'re at the beach or poolside, how does your skin react to the sun?',
      'options': ['I tan easily', 'I usually burn'],
      'points': [
        {'type': 'warm', 'points': 1},
        {'type': 'cool', 'points': 1},
      ],
    },
    {
      'question': 'How would you describe your skin tone?',
      'options': [
        'Fair',
        'Light',
        'Medium',
        'Olive',
        'Dark',
        'Deep',
        'Prefer not to say',
      ],
      'points': [], // Optional question, no points
    },
    {
      'question': 'When you\'re out in the sun, what happens to your skin?',
      'options': [
        'I tan easily and evenly',
        'I burn and turn red',
        'I don\'t burn or tan much',
      ],
      'points': [
        {'type': 'warm', 'points': 1},
        {'type': 'cool', 'points': 1},
        {'type': 'neutral', 'points': 1},
      ],
    },
    {
      'question': 'Imagine wearing a yellow or orange shirt. How do you look?',
      'options': [
        'Not great — I prefer cool shades like blue',
        'Great — it gives my skin a warm glow',
        'I can wear almost any color and look fine',
      ],
      'points': [
        {'type': 'cool', 'points': 1},
        {'type': 'warm', 'points': 1},
        {'type': 'neutral', 'points': 1},
      ],
    },
    {
      'question':
          'Hold a white sheet of paper next to your bare face. What do you notice?',
      'options': [
        'My skin looks clear and bright',
        'My complexion looks dull or yellowish',
        'It looks about the same — no major difference',
      ],
      'points': [
        {'type': 'cool', 'points': 1},
        {'type': 'warm', 'points': 1},
        {'type': 'neutral', 'points': 1},
      ],
    },
    {
      'question':
          'What color are the veins on your inner wrist (in natural light)?',
      'options': [
        'Blue or purple',
        'Green',
        'Hard to tell / they match my skin',
      ],
      'points': [
        {'type': 'cool', 'points': 1},
        {'type': 'warm', 'points': 1},
        {'type': 'neutral', 'points': 1},
      ],
    },
    {
      'question': 'What color are your eyes?',
      'options': [
        'Blue, gray, or other cool tones',
        'Green or hazel',
        'Dark brown or black',
      ],
      'points': [
        {'type': 'cool', 'points': 1},
        {'type': 'neutral', 'points': 1},
        {'type': 'warm', 'points': 1},
      ],
    },
    {
      'question': 'What is your natural hair color (before dyeing)?',
      'options': [
        'Jet black, ash blonde, or cool brown',
        'Golden, red, or warm brown',
        'Not sure',
      ],
      'points': [
        {'type': 'cool', 'points': 1},
        {'type': 'warm', 'points': 1},
        {'type': 'neutral', 'points': 1},
      ],
    },
    {
      'question': 'When you wear a plain white top, how does your skin appear?',
      'options': [
        'Rosy or pinkish',
        'Yellowish or golden',
        'Neutral — blends well with white',
      ],
      'points': [
        {'type': 'cool', 'points': 1},
        {'type': 'warm', 'points': 1},
        {'type': 'neutral', 'points': 1},
      ],
    },
  ];

  void _answerQuestion(int selectedIndex) {
    setState(() {
      _selectedAnswerIndex = selectedIndex;
    });
  }

  void _nextQuestion() {
    if (_selectedAnswerIndex == null) return;
    if (_currentQuestion != 2) {
      final points =
          _questions[_currentQuestion]['points'][_selectedAnswerIndex!];
      setState(() {
        switch (points['type']) {
          case 'warm':
            _warmPoints += (points['points'] as int);
            break;
          case 'cool':
            _coolPoints += (points['points'] as int);
            break;
          case 'neutral':
            _neutralPoints += (points['points']) as int;
            break;
        }
      });
    }
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswerIndex = null;
      });
    } else {
      _calculateResult();
    }
  }

  void _calculateResult() {
    String result;
    if (_warmPoints > _coolPoints && _warmPoints > _neutralPoints) {
      result = 'Warm';
    } else if (_coolPoints > _warmPoints && _coolPoints > _neutralPoints) {
      result = 'Cool';
    } else {
      result = 'Neutral';
    }

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Undertone Quiz',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.pink[300],
        elevation: 0,
      ),
      body: _result == null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.pink[50]!,
                    Colors.white,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink[100]!.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Question ${_currentQuestion + 1} of ${_questions.length}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.pink[300],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _questions[_currentQuestion]['question'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ...List.generate(
                        _questions[_currentQuestion]['options'].length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                            onPressed: () => _answerQuestion(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedAnswerIndex == index
                                  ? Colors.pink[300]
                                  : Colors.white,
                              foregroundColor: _selectedAnswerIndex == index
                                  ? Colors.white
                                  : Colors.pink[800],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: _selectedAnswerIndex == index
                                      ? Colors.pink[300]!
                                      : Colors.pink[100]!,
                                  width: 2,
                                ),
                              ),
                              elevation: _selectedAnswerIndex == index ? 4 : 0,
                              shadowColor: Colors.pink[200],
                            ),
                            child: Text(
                              _questions[_currentQuestion]['options'][index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildQuizNavigation(),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.pink[50]!,
                    Colors.white,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink[100]!.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Your Undertone Result',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.pink[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.pink[200]!,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                _result!,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[300],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _getResultDescription(_result!),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink[100]!.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Recommended Products for You',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 280,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) =>
                                    _buildRecommendedProduct(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink[100]!.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Articles for Your Undertone',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ..._undertoneArticles[_result!]!.map((article) =>
                                Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        article['image']!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      article['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    subtitle: Text(
                                      article['subtitle']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink[300],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 4,
                              shadowColor: Colors.pink[200],
                            ),
                            child: const Text(
                              'Back to Home',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentQuestion = 0;
                                _warmPoints = 0;
                                _coolPoints = 0;
                                _neutralPoints = 0;
                                _result = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink[100],
                              foregroundColor: Colors.pink[800],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Retake Quiz',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildRecommendedProduct(int index) {
    final selectedProducts = productsByTone[_result!] ?? [];
    final product = selectedProducts[index % selectedProducts.length];

    return Container(
      width: 180,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
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
                    product['image']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Shade: ${product['shade']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      product['price']!,
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
                      id: product['name']! + product['shade']!,
                      name: product['name']!,
                      price: product['price']!,
                      shade: product['shade']!,
                      imageUrl: product['image']!,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to cart: ${product['name']}'),
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

  String _getResultDescription(String result) {
    switch (result) {
      case 'Warm':
        return 'You have a warm undertone! This means you look best in gold jewelry and warm colors like yellow, orange, and red. Your skin has a golden or peachy undertone.';
      case 'Cool':
        return 'You have a cool undertone! This means you look best in silver jewelry and cool colors like blue, purple, and pink. Your skin has a pink or blue undertone.';
      case 'Neutral':
        return 'You have a neutral undertone! This means you can wear both warm and cool colors, and both gold and silver jewelry look great on you. Your skin has a balanced undertone.';
      default:
        return '';
    }
  }

  Widget _buildQuizNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentQuestion > 0)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentQuestion--;
                _selectedAnswerIndex = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[100],
              foregroundColor: Colors.pink[800],
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Back'),
          ),
        ElevatedButton(
          onPressed: _selectedAnswerIndex != null ? _nextQuestion : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[300],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            shadowColor: Colors.pink[200],
          ),
          child: Text(
            _currentQuestion == _questions.length - 1 ? 'Finish' : 'Next',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
