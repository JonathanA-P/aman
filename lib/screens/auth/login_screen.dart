import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as flutter_dotenv;
import 'forgot_password_screen.dart';
import '../main_navigation_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _showPassword = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  void _validateAndSubmit() {
    if (_isLoading || _isGoogleLoading) return;
    setState(() {
      _emailError = null;
      _passwordError = null;

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      bool isValid = true;

      if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
        _emailError = 'Masukkan email dengan benar';
        isValid = false;
      }

      if (password.isEmpty || password.length < 6) {
        _passwordError = 'Password harus minimal 6 karakter';
        isValid = false;
      }

      if (isValid) {
        _performLogin(email, password);
      }
    });
  }

  Future<void> _performLogin(String email, String password) async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        if (res.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan saat login')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading || _isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);
    
    try {
      final webClientId = flutter_dotenv.dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      if (webClientId == null || webClientId.isEmpty || webClientId == 'MASUKKAN_WEB_CLIENT_ID_KAMU_DISINI') {
        throw 'GOOGLE_WEB_CLIENT_ID belum dikonfigurasi di .env';
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isGoogleLoading = false);
        return; // User cancelled
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'Gagal mendapatkan akses token dari Google.';
      }

      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/login_top_shape.svg',
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/auth_bottom_illus.png', 
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 180),
                  RichText(
                    text: const TextSpan(
                      text: 'Selamat Datang di\n',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Color(0xFF102F50),
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'AMAN?',
                          style: TextStyle(color: Color(0xFF2F2B8E)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Pahami dulu, baru bertindak.",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color(0xFF020E1A),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color(0xFF100E34),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                         color: _emailError != null ? const Color(0xFFFB2C36) : const Color(0xFFC8C6F9),
                         width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        color: Color(0xFF100E34), 
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan email kamu",
                        hintStyle: TextStyle(
                          fontFamily: 'Manrope',
                          color: const Color(0xFF100E34).withAlpha(128), 
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Color(0xFFCC9913)),
                        suffixIcon: _emailError != null 
                            ? const Icon(Icons.close, size: 20, color: Color(0xFFFB2C36))
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  if (_emailError != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        _emailError!,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFFFB2C36),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color(0xFF100E34),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _passwordError != null ? const Color(0xFFFB2C36) : const Color(0xFFC8C6F9),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        color: Color(0xFF100E34), 
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan password",
                        hintStyle: TextStyle(
                          fontFamily: 'Manrope',
                          color: const Color(0xFF100E34).withAlpha(128), 
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline, size: 20, color: Color(0xFFCC9913)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            size: 20,
                            color: const Color(0xFF100E34).withAlpha(128),
                          ),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  if (_passwordError != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        _passwordError!,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFFFB2C36),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: const Color(0xFF4E61F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(
                                color: const Color(0xFF5A7FBA).withAlpha(115),
                                width: 1.5,
                              ),
                              onChanged: (val) => setState(() => _rememberMe = val ?? false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Ingat saya",
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              color: Color(0xFF020E1A),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text(
                          "Lupa password?",
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            color: Color(0xFF2F2B8E),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC9913),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _signInWithGoogle,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFC8C6F9), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isGoogleLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF100E34),
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Masuk dengan Google",
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    color: Color(0xFF100E34),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.5,
                          color: const Color(0xFFC8C6F9),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Belum punya akun?",
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            color: Color(0xFF807F9F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.5,
                          color: const Color(0xFFC8C6F9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2F2B8E),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF2F2B8E), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Daftar sekarang",
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
