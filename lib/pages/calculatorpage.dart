import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tase/pages/homepage.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

//import 'package:tase/pages/settingspage.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  TextEditingController _controller3 = new TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  String selected = '';
  double totalInterest = 0;
  int principal = 0;
  double monthlyInterest = 0;
  double monthlyInstallment = 0;
  double ttAmount = 0;
  String collateral = '';
  double netInterest = 0;
  double paymentAmount = 0;

  void loancalculation() {
    final amount = int.parse(_controller1.text);
    final tinterest =
        amount * (double.parse(_controller3.text) / 100) * int.parse(selected);

    //final minterest = tinterest / (int.parse(selected * 12));
    final security = _controller2.text;

    final totalAmount = tinterest + amount;
    final ntInterest = tinterest - (tinterest * 0.3);
    final pAmount = amount + ntInterest;
    final minstall = (amount + tinterest) / (int.parse(selected));
    setState(() {
      totalInterest = tinterest;
      //monthlyInterest = minterest;
      monthlyInstallment = minstall;
      ttAmount = totalAmount;
      collateral = security;
      netInterest = ntInterest;
      paymentAmount = pAmount;
      principal = amount;
      selected = selected;
    });
  }

  //dialog for accepting loan
  void postLoan() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Loan Request Posted!',
                style: TextStyle(color: Colors.white)),
            content: Text(
                'Your loan request has been posted! You will be notified when it is accepted.',
                style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  void postLoanRequest() {
    //post only if something is in the text field

    //store in firebase
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    FirebaseFirestore.instance
        .collection("User Loan Posts")
        .doc('${formattedDate}')
        .set({
      'UserEmail': user.email,
      'post-id': formattedDate,
      'TotalInterest': totalInterest,
      'NetInterest': netInterest,
      'Selected': selected,
      'MonthlyInstallment': monthlyInstallment,
      'Collateral': collateral,
      'TotalAmount': ttAmount,
      'PaymentAmount': paymentAmount,
      'Principal': principal,
      'TimeStamp': Timestamp.now(),
      'taken': false,
      'sent': false
    });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Loan Request Posted!',
                style: TextStyle(color: Colors.white)),
            content: Text(
                'Your loan request has been posted! You will be notified when it is accepted.',
                style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text('View'),
              ),
            ],
          );
        });
    //clear the textfield
    setState(() {
      _controller1.clear();
      _controller2.clear();
      _controller3.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey[350],
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  height: 170,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            "Calculate loan",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 20),
                      child: Text(
                        "Amount",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _controller1,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 78, 78, 78))),
                            fillColor: Color.fromARGB(255, 218, 217, 217),
                            filled: true,
                            hintText:
                                'e.g 20000(NB: UGX 20,000 is the minimum amount)',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 20),
                      child: Text(
                        "Collateral",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _controller2,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 78, 78, 78))),
                            fillColor: Color.fromARGB(255, 218, 217, 217),
                            filled: true,
                            hintText: 'e.g phone(NB: specify the type)',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 20),
                      child: Text(
                        "Interest rate",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _controller3,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 78, 78, 78))),
                            fillColor: Color.fromARGB(255, 218, 217, 217),
                            filled: true,
                            hintText: 'e.g 2.5',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 20),
                      child: Text(
                        "Loan Period (months)",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        top: 20,
                      ),
                      child: Row(
                        children: [
                          loanPeriod("1"),
                          loanPeriod("2"),
                          loanPeriod("3"),
                          loanPeriod("4"),
                          loanPeriod("5"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),

                    //button for calculation
                    GestureDetector(
                      onTap: () {
                        //call for calculation function
                        loancalculation();
                        if (int.parse(_controller1.text) < 100) {
                          final snackBar = SnackBar(
                            /// need to set following properties for best effect of awesome_snackbar_content
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'On Snap!',
                              color: Colors.grey,

                              message:
                                  'Please enter an amount more than 20,000 ',

                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        } else if (int.parse(_controller3.text) < 1) {
                          final snackBar = SnackBar(
                            /// need to set following properties for best effect of awesome_snackbar_content
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'On Snap!',
                              color: Colors.grey,

                              message:
                                  'Please enter an interest more than 10% ',

                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        } else {
                          //delay time for calculation
                          Future.delayed(Duration.zero);
                          showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 700,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 30, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "Loan Details",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        resultInt(
                                            title: "Principal",
                                            amount: principal),
                                        result(
                                            title: "Total Interest",
                                            amount: totalInterest),
                                        result(
                                            title: "Net Interest",
                                            amount: netInterest),
                                        resultMonth(
                                            title: "Payment Period",
                                            value: selected),
                                        result(
                                            title: "Monthly Installment",
                                            amount: monthlyInstallment),
                                        resultText(
                                            title: "Collateral",
                                            value: collateral),
                                        result(
                                            title: "Total payment",
                                            amount: ttAmount),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: postLoanRequest,
                                          child: Container(
                                            padding: const EdgeInsets.all(25),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Center(
                                              child: Text(
                                                "Post Loan",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Calculate",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget resultInt({required String title, required int amount}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Text(
          'UGX ' + amount.toStringAsFixed(2),
          style: TextStyle(fontSize: 19),
        ),
      ),
    );
  }

  Widget result({required String title, required double amount}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Text(
          'UGX ' + amount.toStringAsFixed(2),
          style: TextStyle(fontSize: 19),
        ),
      ),
    );
  }

  Widget resultText({required String title, required String value}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(fontSize: 19),
        ),
      ),
    );
  }

  Widget resultMonth({required String title, required String value}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Text(
          value.toUpperCase() + " Months",
          style: TextStyle(fontSize: 19),
        ),
      ),
    );
  }

  Widget loanPeriod(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 20, 0),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              border: title == selected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              color: Colors.black,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
