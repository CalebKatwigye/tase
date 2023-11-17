import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/button.dart';
import 'package:tase/components/textfield.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});
  final Function()? onTap;

  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign up method
  void signUserUp () async{
    if (passwordController.text == confirmPasswordController.text){
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text);

      //after creating the user, create a new document in cloud firestore called users
      FirebaseFirestore.instance
      .collection("Users")
      .doc(userCredential.user!.email)
      .set({
        'username' : emailController.text.split('@')[0],
        'phonenumber': 'Empty phonenumber..',
        'address': 'Empty address..'
      });
    } else {
      print('error');
    }
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
                  size: 70,
                  ),
      
                const SizedBox(height: 50,),
      
                //welcome back
                Text(
                  'Welcome!',
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
                  const SizedBox(height: 25,),

                  //confirm password 
                  MyTextFeild(
                    controller: confirmPasswordController, 
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25,),
                  
                  
      
                  //button
                  MyButton(
                    text: "Sign Up",
                    onTap: signUserUp,
                  ),
                  const SizedBox(height: 25,),

                  //already a member login
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a Member? ',
                      style: TextStyle(color: Color.fromARGB(255, 97, 96, 96)),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text('Log In',
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