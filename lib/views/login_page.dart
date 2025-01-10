import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pbm_project1_uas/views/components/custom_textfield.dart';
import 'package:pbm_project1_uas/views/home_page.dart';
import 'package:pbm_project1_uas/views/widgets/wg_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  bool isPassword = true;

  bool showPassword = false;

  Future<UserCredential> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool> loginUser(String emailUser, String passwordUser) async {
    bool login = false;
    try {
      final UserCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: passwordUser);
      //debugPrint("user : $user");

      // setState(() {
      //   user = userCredential.user!;
      // });
      if (UserCredential.user != null) {
        login = true;
      }
    } catch (e) {
      debugPrint("Error at : $e");
      return false;
    }
    return login;
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
                "Login",
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
            wgTextField(password, "password", "Passwords", isPassword),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                    value: showPassword,
                    onChanged: (bool? newValue) {
                      setState(() {
                        showPassword = newValue!;
                      });
                    }),
                const Text("Show password"),
              ],
            ),
            const SizedBox(height: 10.0),
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
                onPressed: () async {
                  debugPrint(
                      "Email : ${email.text} \n Password : ${password.text}");
                  isLoading = true;
                  if (email.text.isEmpty || password.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Silakan isi semua form")));
                  } else {
                    bool login = await loginUser(email.text, password.text);
                    if (login) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Gagal")));
                    }
                  }
                  isLoading = false;
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Masuk",
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
                    "Atau Masuk menggunakan",
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
                  onPressed: loginWithGoogle,
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
                const Text("Belum punya akun? silahkan"),
                const SizedBox(
                  width: 5.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    "Daftar",
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
