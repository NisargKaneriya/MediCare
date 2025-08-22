// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import '../database/database_helper.dart';
// import '../models/user_model.dart';
//
// import 'signup_page.dart';
// import 'home_page.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _rememberMe = false;
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     ));
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final result = await DatabaseHelper().loginUser(
//         usernameOrEmail: _usernameController.text.trim(),
//         password: _passwordController.text, email:  '',
//       );
//
//       if (result['success']) {
//         final userData = result['user'];
//         UserModel user = UserModel.fromMap(result['user']);
//         Get.offAll(() => HomePage(user: user));
//
//
//         Get.offAll(() => HomePage(user: user));
//       } else {
//         if (mounted) {
//           _showErrorSnackBar(result['message']);
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar('Login failed. Please try again.');
//       }
//     }
//
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.blue[400]!,
//               Colors.purple[400]!,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height -
//                      MediaQuery.of(context).padding.top - 48,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),
//
//                   // Logo and Title Section
//                   FadeInDown(
//                     duration: const Duration(milliseconds: 1000),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 120,
//                           width: 120,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(60),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 10),
//                               ),
//                             ],
//                           ),
//                           child: Icon(
//                             Icons.medical_services_outlined,
//                             size: 60,
//                             color: Colors.blue[600],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           'MediCare',
//                           style: GoogleFonts.poppins(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           'Your Medicine Reminder',
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             color: Colors.white.withOpacity(0.8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 50),
//
//                   // Login Form
//                   FadeInUp(
//                     duration: const Duration(milliseconds: 1200),
//                     child: Container(
//                       // padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Text(
//                               'Welcome Back!',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey[800],
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 30),
//
//                             // Username/Email Field
//                             FadeInLeft(
//                               duration: const Duration(milliseconds: 1400),
//                               child: TextFormField(
//                                 controller: _usernameController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Username or Email',
//                                   prefixIcon: Icon(
//                                     Icons.person_outline,
//                                     color: Colors.blue[600],
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Colors.grey[300]!,
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Colors.blue[600]!,
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter username or email';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//
//                             const SizedBox(height: 20),
//
//                             // Password Field
//                             FadeInRight(
//                               duration: const Duration(milliseconds: 1400),
//                               child: TextFormField(
//                                 controller: _passwordController,
//                                 obscureText: _obscurePassword,
//                                 decoration: InputDecoration(
//                                   labelText: 'Password',
//                                   prefixIcon: Icon(
//                                     Icons.lock_outline,
//                                     color: Colors.blue[600],
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _obscurePassword
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       color: Colors.grey[600],
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         _obscurePassword = !_obscurePassword;
//                                       });
//                                     },
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Colors.grey[300]!,
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Colors.blue[600]!,
//                                       width: 2,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter password';
//                                   }
//                                   if (value.length < 6) {
//                                     return 'Password must be at least 6 characters';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//
//                             const SizedBox(height: 10),
//
//                             // Remember Me and Forgot Password
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Checkbox(
//                                       value: _rememberMe,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           _rememberMe = value ?? false;
//                                         });
//                                       },
//                                       activeColor: Colors.blue[600],
//                                     ),
//                                     Text(
//                                       'Remember me',
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     // TODO: Implement forgot password
//                                   },
//                                   child: Text(
//                                     'Forgot Password?',
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.blue[600],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 10),
//
//                             // Login Button
//                             FadeInUp(
//                               duration: const Duration(milliseconds: 1600),
//                               child: ElevatedButton(
//                                 onPressed: _isLoading ? null : _handleLogin,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue[600],
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 3,
//                                 ),
//                                 child: _isLoading
//                                     ? const SizedBox(
//                                         height: 20,
//                                         width: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor: AlwaysStoppedAnimation<Color>(
//                                             Colors.white,
//                                           ),
//                                         ),
//                                       )
//                                     : Text(
//                                         'Login',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const Spacer(),
//
//                   // Debug Section (for testing - remove in production)
//                   FadeInUp(
//                     duration: const Duration(milliseconds: 1700),
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//
//                       ),
//                     ),
//                   ),
//
//                   // Sign Up Link
//                   FadeInUp(
//                     duration: const Duration(milliseconds: 1800),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Don't have an account? ",
//                           style: GoogleFonts.poppins(
//                             color: Colors.white.withOpacity(0.8),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Get.to(() => const SignupPage());
//                           },
//                           child: Text(
//                             'Sign Up',
//                             style: GoogleFonts.poppins(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../models/user_model.dart';
import 'signup_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await DatabaseHelper().loginUser(
        usernameOrEmail: _usernameController.text.trim(),
        password: _passwordController.text,
        email: '',
      );

      if (result['success']) {
        UserModel user = UserModel.fromMap(result['user']);
        Get.offAll(() => HomePage(user: user));
      } else {
        if (mounted) _showErrorSnackBar(result['message']);
      }
    } catch (e) {
      if (mounted) _showErrorSnackBar('Login failed. Please try again.');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isTablet = screenWidth >= 600;
    final isSmall = screenWidth < 360;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.purple[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  // 🔹 Adjust padding and spacing based on available space
                  final horizontalPadding = constraints.maxWidth * 0.08;
                  final verticalSpacing = constraints.maxHeight * 0.025;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalSpacing,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight -
                            media.padding.top -
                            verticalSpacing,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(height: verticalSpacing * 2),

                            /// 🔹 Logo & Title (top section)
                            FadeInDown(
                              child: Column(
                                children: [
                                  Container(
                                    height: orientation == Orientation.portrait
                                        ? screenHeight * 0.10
                                        : screenHeight * 0.25,
                                    width: orientation == Orientation.portrait
                                        ? screenHeight * 0.15
                                        : screenHeight * 0.25,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.medical_services_outlined,
                                      size: isTablet ? 80 : 60,
                                      color: Colors.blue[600],
                                    ),
                                  ),
                                  SizedBox(height: verticalSpacing),
                                  Text(
                                    'MediCare',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet
                                          ? 40
                                          : isSmall
                                          ? 24
                                          : 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Your Medicine Reminder',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet
                                          ? 20
                                          : isSmall
                                          ? 12
                                          : 16,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: verticalSpacing * 2),

                            /// 🔹 Login Form
                            FadeInUp(
                              child: Container(
                                padding: EdgeInsets.all(
                                  isTablet ? 32 : 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Welcome Back!',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet ? 28 : 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      SizedBox(height: verticalSpacing * 1.5),

                                      /// Username / Email
                                      TextFormField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Username or Email',
                                          prefixIcon: Icon(
                                            Icons.person_outline,
                                            color: Colors.blue[600],
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter username or email';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: verticalSpacing),

                                      /// Password
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.blue[600],
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed: () {
                                              setState(() => _obscurePassword =
                                              !_obscurePassword);
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter password';
                                          }
                                          if (value.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: verticalSpacing * 0.5),

                                      /// Remember Me & Forgot Password
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _rememberMe,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _rememberMe =
                                                        value ?? false;
                                                  });
                                                },
                                                activeColor: Colors.blue[600],
                                              ),
                                              Text(
                                                'Remember me',
                                                style: GoogleFonts.poppins(
                                                  fontSize:
                                                  isSmall ? 10 : 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Forgot password
                                            },
                                            child: Text(
                                              'Forgot Password?',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                isSmall ? 10 : 12,
                                                color: Colors.blue[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: verticalSpacing),

                                      /// Login Button
                                      ElevatedButton(
                                        onPressed:
                                        _isLoading ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[600],
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                            orientation == Orientation.portrait
                                                ? 16
                                                : 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          elevation: 3,
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                            AlwaysStoppedAnimation<
                                                Color>(Colors.white),
                                          ),
                                        )
                                            : Text(
                                          'Login',
                                          style: GoogleFonts.poppins(
                                            fontSize: isTablet ? 18 : 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            /// 🔹 Sign Up Link
                            FadeInUp(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmall ? 12 : 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => const SignupPage());
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: GoogleFonts.poppins(
                                        fontSize: isSmall ? 12 : 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
