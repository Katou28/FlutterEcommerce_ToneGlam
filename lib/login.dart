import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toneglam/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _loginError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          bottom: const TabBar(
            tabs: [Tab(text: 'Log In'), Tab(text: 'Sign Up')],
            indicatorColor: Colors.pink,
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            _buildLoginForm(),
            _buildSignUpForm(), // Add your Sign Up form here
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Image.asset(
              'assets/logo/Toneglam.png',
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 2),
            const Text(
              'ToneGlam',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 1),
            const Text(
              'Perfect Shade, Perfect You!',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 130, 130, 130),
              ),
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email or Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email or phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                errorText: _loginError,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                      activeColor: Colors.pink,
                    ),
                    const Text('Remember me'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Add forgot password logic
                    print('Forgot Password pressed');
                  },
                  child: const Text(
                    'Forgot Password ?',
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final prefs = await SharedPreferences.getInstance();
                    final savedEmail = prefs.getString('saved_email');
                    final savedPass = prefs.getString('saved_password');

                    if (_emailController.text == savedEmail &&
                        _passwordController.text == savedPass) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );

                      // Add navigation logic here, e.g., Navigator.pushReplacement(...)
                    } else {
                      setState(() {
                        _loginError = 'Invalid email or password';
                      });
                    }
                  }
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Or'),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 30),
            _buildSocialButton(
              icon: Image.asset('assets/google.png', height: 24),
              text: 'Continue with Google',
              color: Colors.white,
              onPressed: () {
                print('Google login pressed');
              },
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              icon: Image.asset('assets/facebook.png', height: 24),
              text: 'Continue with Facebook',
              color: Colors.blue,
              onPressed: () {
                print('Facebook login pressed');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    final TextEditingController signUpEmailController = TextEditingController();
    final TextEditingController signUpPasswordController =
        TextEditingController();
    final TextEditingController signUpConfirmPasswordController =
        TextEditingController();
    final signUpFormKey = GlobalKey<FormState>();
    bool signUpObscurePassword = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: signUpFormKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join ToneGlam today!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: signUpEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email or Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: signUpPasswordController,
                  obscureText: signUpObscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        signUpObscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          signUpObscurePassword = !signUpObscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: signUpConfirmPasswordController,
                  obscureText: signUpObscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        signUpObscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          signUpObscurePassword = !signUpObscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != signUpPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (signUpFormKey.currentState!.validate()) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(
                          'saved_email',
                          signUpEmailController.text,
                        );
                        await prefs.setString(
                          'saved_password',
                          signUpPasswordController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account created successfully!'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        icon: icon,
        label: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
