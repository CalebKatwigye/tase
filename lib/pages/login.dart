import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/button.dart';
import 'package:tase/components/textfield.dart';

class LoginPage extends StatelessWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});
  

  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in method
  void signUserIn () async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const SizedBox(height: 35,),
      
      
                //logo
                const Icon(
                  Icons.lock,
                  size: 100,
                  ),
      
                const SizedBox(height: 50,),
      
                //welcome back
                Text(
                  'Welcome back you\'ve been missed',
                  style: TextStyle(
                    color: Color.fromARGB(255, 97, 86, 86),
                    fontSize: 16,
                  ),
                  ),
      
                  const SizedBox(height: 50,),
      
                  //username 
                  MyTextFeild(
                    controller: emailController, 
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 25,),
      
                  //password 
                  MyTextFeild(
                    controller: passwordController, 
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15,),
                  
                  //forgot password
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('forgot password?',
                      style: TextStyle(color: Color.fromARGB(255, 97, 96, 96)),
                      )
                    ],
                  ),
                  ),
                  const SizedBox(height: 35,),
      
                  //button
                  MyButton(
                    text: "Sign In",
                    onTap: signUserIn,
                  ),
                  const SizedBox(height: 25,),

                  //forgot password
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a Member? ',
                      style: TextStyle(color: Color.fromARGB(255, 97, 96, 96)),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text('Register Now',
                        style: TextStyle(color: Color.fromARGB(255, 30, 137, 236),
                        fontWeight: FontWeight.bold
                        ),
                        ),
                      )
                    ],
                  ),
                  ),
                  const SizedBox(height: 35,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}