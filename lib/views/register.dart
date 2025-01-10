import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pbm_project1_uas/views/components/custom_textfield.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  late Future<UserCredential> user;

  bool isLoading = false;
  // Future<UserCredential> registerWithGoogle() async {
  //   final G? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future<void> onRegister() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text, password: password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            const Center(
              child: Text(
                "Registrasi",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Center(
                child: Hero(
              tag: 'ImgLogin',
              child: Container(
                width: 352.0,
                height: 330.0,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                      'assets/images/2782e144f3467e6939ecf36b2abf7600.png'),
                )),
              ),
            )),
            const SizedBox(height: 40.0),
            CustomTextfield(
              textController: email,
              label: "Masukkan email",
              show: false,
              type: "text",
            ),
            CustomTextfield(
              textController: password,
              label: "Password",
              type: "password",
              show: true,
            ),
            CustomTextfield(
              textController: confirmPassword,
              label: "Konfirmasi Password",
              show: true,
              type: 'password',
            ),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  debugPrint(
                      "Email : ${email.text} \n Password : ${password.text}");
                  isLoading = true;
                  if (email.text.isEmpty ||
                      password.text.isEmpty ||
                      confirmPassword.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Silakan isi semua form")));
                  } else {
                    if (password.text != confirmPassword.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Password tidak sesuai")));
                    } else {
                      user =
                          FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Berhasil mendaftar")));
                    }
                  }
                  isLoading = false;
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Mendaftar",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xffC0C0C0),
                    height: 3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Text(
                    "Atau daftar menggunakan",
                    style: TextStyle(color: Color(0xffC0C0C0)),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xffC0C0C0),
                    height: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            Material(
              color: Colors.white,
              child: SizedBox(
                height: 52.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 33,
                        height: 33,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/google.png'),
                        )),
                      ),
                      const Text(
                        "Masuk dengan Google",
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20.0)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 49,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun? silahkan"),
                const SizedBox(
                  width: 5.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    "Masuk",
                    style: TextStyle(color: Color(0xff3498DB)),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
