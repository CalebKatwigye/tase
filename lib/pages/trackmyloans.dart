import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/components/adminloancard.dart';
import 'package:tase/components/trackmyloancard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackMyLoans extends StatefulWidget {
  const TrackMyLoans({super.key});

  @override
  State<TrackMyLoans> createState() => _TrackMyLoansState();
}



class _TrackMyLoansState extends State<TrackMyLoans> {

  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      // Call your future function here
      processloanpayments();
    }
  });
}

  final user = FirebaseAuth.instance.currentUser!;
Future processloanpayments () async {
   final collectionReference =
          FirebaseFirestore.instance.collection('Loan Repayment Transactions');
      final querySnapshot = await collectionReference.get();
  
      for (final doc in querySnapshot.docs) {
        final txRef = doc['txref'];
         final docid = doc['post-id'];
        try {
          final Map<String, String> headers = {
            'Authorization':
                'Bearer FLWSECK-69fda727ee7df02bab6a24cdcd7e3ffd-18b5c7c3f10vt-X',
            "Content-Type": "application/json",
          };
          final response = await http.get(
            Uri.parse(
                'https://api.flutterwave.com/v3/transactions/verify_by_reference?tx_ref=${txRef}'),
            headers: headers,
          );
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            final transactions = responseData['data'];
            // final verifiedPayments = transactions.map((transaction) => transaction['tx_ref']).toList();

            final amount = responseData['data']['amount'];
           
             final paymentcollection =
          FirebaseFirestore.instance.collection('Pending Loans');
         
      final paymentquerySnapshot = await paymentcollection.doc(docid).get();
       
      final balance = paymentquerySnapshot['Balance'];
      final balremaining = balance - amount;
     
      if (balremaining >= 0){
         FirebaseFirestore.instance
                .collection('Pending Loans')
                .doc('${docid}')
                .update({
              'Balance': balremaining,
            });
      } else {
         FirebaseFirestore.instance
                .collection('Pending Loans')
                .doc('${docid}')
                .update({
              'verified': true,
            });
      }
 await doc.reference.delete();
      print(balance);
           
          } else {
            print(
                'Failed to fetch verified payments: ${responseData['message']}');
          }
        } catch (err) {
          print('Error making Flutterwave payment: ${err}');
        }
        
        }
}


  @override
  Widget build(BuildContext context) {
    processloanpayments();
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Center(child: Text('Track my Loans')),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Pending Loans")
                      .where('Email', isEqualTo: user.email)
                      .where('verified', isEqualTo: false)
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
                                  DateTime startDate =
                                      (post['start-date'] as Timestamp)
                                          .toDate();
                                  DateTime endDate =
                                      (post['end-date'] as Timestamp).toDate();
                                  return TrackMyLoanCard(
                                    postId: post['txref'],
                                    totalInterest: post['TotalInterest'],
                                    netInterest: post['NetInterest'],
                                    selected: post['Selected'],
                                    monthlyInstallment:
                                        post['MonthlyInstallment'],
                                    collateral: post['Collateral'],
                                    ttAmount: post['Balance'],
                                    user: post['Email'],
                                    paymentAmount: post['PaymentAmount'],
                                    principal: post['Principal'],
                                    now: startDate,
                                    fourMonthsLater: endDate,
                                  );
                                });
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
