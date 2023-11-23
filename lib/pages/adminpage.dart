import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/adminloancard.dart';
import 'package:tase/components/loanpost.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
   final user = FirebaseAuth.instance.currentUser!;
    
DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        elevation: 0,
          title: Center(child: Text('Admin')),
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
                      .where('taken', isEqualTo: true)
                      .where('sent', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //get the message
                            final post = snapshot.data!.docs[index];
                            return StreamBuilder<Object>(
                              stream: null,
                              builder: (context, snapshot) {
                                return AdminLoanCard(
                                  postId: post['post-id'],
                                  totalInterest: post['TotalInterest'],
                                  netInterest: post['NetInterest'],
                                  selected: post['Selected'],
                                  monthlyInstallment: post['MonthlyInstallment'],
                                  collateral: post['Collateral'],
                                  ttAmount: post['TotalAmount'],
                                  user: post['UserEmail'],
                                  paymentAmount: post['PaymentAmount'],
                                  principal: post['Principal'],
                                  now: now, 
                                  fourMonthsLater: now,
                                );
                              }
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
                  }),
            ),

            
            const SizedBox(
              height: 20,
            ),
            Text(
              'Logged in as ' + user.email!,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}