import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyLoanPost extends StatefulWidget {
  final String email;
  final String txRef;
  final double totalInterest;
  final double netInterest;
  final String selected;
  final double monthlyInstallment;
  final String collateral;
  final double totalAmount;
  final double paymentAmount;
  final int principal;
  final DateTime timeStamp;
  final bool verified;
  const MyLoanPost(
      {super.key,
      required this.email,
      required this.txRef,
      required this.totalInterest,
      required this.netInterest,
      required this.selected,
      required this.monthlyInstallment,
      required this.collateral,
      required this.totalAmount,
      required this.paymentAmount,
      required this.principal,
      required this.timeStamp,
      required this.verified});

  @override
  State<MyLoanPost> createState() => _MyLoanPostState();
}

class _MyLoanPostState extends State<MyLoanPost> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ' + widget.email),
            Text('Transaction Reference: ' + widget.txRef),
            Text('Principal: ' + widget.principal.toStringAsFixed(2)),
            //Text('Total Interest: '+ widget.totalInterest.toStringAsFixed(2)),
            Text('Net Interest: ' + widget.netInterest.toStringAsFixed(2)),
            Text('Net Payment: ' + widget.paymentAmount.toStringAsFixed(2)),
            Text('Payment Period: ' + widget.selected + ' months'),
            Text('Monthly Installment: ' +
                widget.monthlyInstallment.toStringAsFixed(2)),
            Text('Collateral: ' + widget.collateral),
            //Text('Total Amount: ' + widget.totalAmount.toStringAsFixed(2)),

            Text('Timestamp: ' + widget.timeStamp.toLocal().toString()),
            Text('Verified: ' + widget.verified.toString()),
          ],
        ),
      ),
    );
  }
}
