import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/helper/firebase_services.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isSaveLoading = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Map<String, dynamic> initialUserData = {};

  FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    try {
      super.initState();
      final user = FirebaseAuth.instance.currentUser;
      final uid = user!.uid;
      fetchUserData(uid);
    } catch (e) {
      print(e);
    }
    setState(() => isLoading = false);
  }

  void fetchUserData(String uid) async {
    try {
      var data = await firebaseService.getUserData(uid);
      userData = data;
      initialUserData = Map.from(data);
      fullNameController.text = userData!['username'] ?? '';
      emailController.text = userData!['email'] ?? '';
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void saveChanges(String uid) async {
    setState(() => isSaveLoading = true);
    try {
      print('savechange function');
      await firebaseService.updateUserData(uid, {
        'username': fullNameController.text,
        'email': emailController.text,
      });
      initialUserData['username'] = fullNameController.text;
      initialUserData['email'] = emailController.text;
      ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Profile updated successfully!')));
    } catch (e) {
      print("Error saving changes: $e");
      ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error updating profile!')));
    }
    setState(() => isSaveLoading = false);
  }

  void discardChanges() {
    setState(() {
      fullNameController.text = initialUserData['username'];
      emailController.text = initialUserData['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbfe0f8),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/applogo.png',
                                    ))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    buildTextField("Full Name", fullNameController, false),
                    buildTextField("E-mail", emailController, false),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: discardChanges,
                          child: const Text("CANCEL",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: isSaveLoading
                              ? null
                              : () {
                                  final User? user =
                                      FirebaseAuth.instance.currentUser;
                                  final uid = user?.uid;
                                  saveChanges(uid!);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: isSaveLoading
                              ? CircularProgressIndicator()
                              : const Text(
                                  "SAVE",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: '',
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
