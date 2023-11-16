import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/loanpost.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  //postloanmethod
  void postLoanRequest() {
    //post only if something is in the text field
    
      //store in firebase
      /*
      FirebaseFirestore.instance.collection("User Loan Posts").add({
        'UserEmail': user.email,
        'TotalInterest': totalInterest,
        'NetInterest': netInterest,
        'Selected': selected,
        'MonthlyInstallment': monthlyInstallment,
        'Collateral': collateral,
        'TotalAmount': ttAmount,
        'TimeStamp': Timestamp.now()
      });
       */
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.black,
      ),
       body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("User Loan Posts")
                        .orderBy(
                          "TimeStamp",
                          descending: false,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              //get the message
                              final post = snapshot.data!.docs[index];
                              return LoanPost(
                                  postId: post.id,
                                  totalInterest:post['TotalInterest'],
                                  netInterest: post['NetInterest'],
                                  selected:post['Selected'],
                                  monthlyInstallment:post['MonthlyInstallment'],
                                  collateral:post['Collateral'],
                                  ttAmount:post['TotalAmount'], user: 'UserEmail',
                                  );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error:${snapshot.error}'),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    })),])

    ));
  }
}