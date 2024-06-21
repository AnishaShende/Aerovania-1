import 'package:flutter/material.dart';
import '../main.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'forgot_password_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var isLoading = false;
  var isGoogleLoading = false; // New variable for Google login loading
  var passwordVisible = false;

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authServices = ref.read(authServicesProvider);
      try {
        setState(() {
          isLoading = true;
        });
        await authServices.signInWithEmailAndPassword(
            _enteredEmail, _enteredPassword);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void signInWithGoogle() async {
    final authService = ref.read(authServicesProvider);
    try {
      setState(() {
        isGoogleLoading = true;
      });
      final user = await authService.signInWithGoogle();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('User not found. Please register first.'),
          action: SnackBarAction(
            label: 'Register',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
          ),
        ));
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      isGoogleLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Text(
                        "Welcome back! Glad to see you, Again!",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8F9),
                        border: Border.all(color: const Color(0xFFE8ECF4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(color: Color(0xFF8391A1)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8F9),
                        border: Border.all(color: const Color(0xFFE8ECF4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: passwordVisible,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your password',
                            hintStyle:
                                const TextStyle(color: Color(0xFF8391A1)),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgotPasswordScreen()));
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xFF6A707C)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        // if (isLoading)
                        //   const Center(
                        //       child:
                        //           Center(child: CircularProgressIndicator())),
                        // if (!isLoading)
                        Expanded(
                          child: MaterialButton(
                            color: const Color(0xFF1E232C),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onPressed: () {
                              signIn();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE8ECF4),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Or Login With"),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE8ECF4),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              signInWithGoogle();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFE8ECF4)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: isGoogleLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : Image.asset(
                                        "assets/images/google.png",
                                        height: 32,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account? ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              color: Color(0xFF35C2C1),
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
