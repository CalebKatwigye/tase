import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Center(child: Text('Terms and Conditions')),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Terms of Service paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20,right: 10),
            child: Text(
              'Terms of Service',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20,right: 10),
            child: Text(
              'Tase is a mobile loan application where users can sign up and post loan requests for other users to see. When you post a loan request, you still have the ability to delete it before it is accepted by another user. Similarly, you have the ability to accept a loan request posted by another user. Never your own! When a loan request is accepted, the lender is redirected to flutterwave payment website where they can can finalize their transaction. Once they enter their pin and complete the transaction, they can access a summary of that transaction on their profile page. The admin then contacts the borrower to confirm whether or not they would like to proceed with the loan and if they do, an agent is sent over to assess and collect the collateral. Upon receipt of the collateral, the loan is approved and its details can be accessed by the borrower from the "Track My Loans" tile in the sidebar menu. This displays a card where the summary of Loan is displayed including the start and end dates. The borrower can tap the green button to make their monthly installment. They are redirected to the flutterwave website to carry out their transaction.',
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
            ),
          ),

           //What is a Loan Request? paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 40,right: 10),
            child: Text(
              'What is a Loan Request?',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20, right: 10),
            child: Text(
              'Inside the app is a function we call the "Calculator", which can be accessed from the sidebar menu and from the button on the Home page. This is where a user can enter the "Amount" which is the money they intend to borrow. "Collateral", which they offer in exchange for the loan. They can specify the interest and the loan period(in months) as well.',
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10,right: 10),
            child: Text(
              'Note that it is like an auction and as a borrower you have to request a loan that is appealing to a potential lender otherwise if no one likes the terms of your loan request, it may sit there on the loan request wall for an indefinite period of time.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),

          //Loan details paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 40, right: 10),
            child: Text(
              'Loan Details',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20,right: 10),
            child: Text(
              'When the user clicks the "Calculate" button, the following details appear;',
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
            ),
          ),

          //principal paragraph

          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 10),
            child: Text(
              'Principal:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Text(
              'This refers to the amount a user would like to borrow. The minimum amount one can borrow on this application is UGX 20,000',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20),
            ),
          ),


          //Total interest paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 10),
            child: Text(
              'Total interest:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Text(
              'This refers to the total amount of interest on the loan that the borrower will pay back.',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20),
            ),
          ),


          //net interest paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 10),
            child: Text(
              'Net interest:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Text(
              'This refers to the net amount of interest from a given loan that the lender will receive. The company charges 30% on the interest from any given loan',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20),
            ),
          ),

          //payment period paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 10),
            child: Text(
              'Payment period:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Text(
              'This refers to the amount of time in months in which a user intends to pay a given loan. The maximum payment period for a loan is 5 months.',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20),
            ),
          ),

          //monthly installment paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 10),
            child: Text(
              'Monthly installment:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Text(
              'This refers to the total amount of money in a month that a borrower has to pay in order to complete their loan payment.',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20),
            ),
          ),

          //collateral paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 10),
            child: Text(
              'Collateral:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Text(
              'This refers to item that a borrower hands over in exchange for a loan. A borrower will NOT receive any money without presenting the collateral. The maximum period for this process of collecting collateral is 36 hours. After this period, the loan is cancelled and the money is returned to the lender. In addition, the collateral must be as valuable as the principal or more, NOT less, otherwise the agent is free to reject it after assessment and cancel the loan.',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20),
            ),
          ),

          //total payment paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 10),
            child: Text(
              'Total payment:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Text(
              'This refers to the total amount of money that a borrower pays back. It is the sum of the total interest and the principal',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20),
            ),
          ),

          //Loan request card paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 40, right: 10),
            child: Text(
              'Loan Request Card',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20,right: 10),
            child: Text(
              'When the user clicks the "Post" button, a card containing a summary of the above details appears on the homepage. However, a new field appears and that is;',
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 10),
            child: Text(
              'Net payment:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Text(
              'This refers to the total amount of money that a lender receives. It is the sum of the net interest and the principal. Not to be confused with the "Total payment"',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20),
            ),
          ),

          //Loan request card paragraph
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 40, right: 10),
            child: Text(
              'What happens in the event that a loan is not repaid?',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20,right: 10),
            child: Text(
              'When the borrower fails to repay the loan, the lender can be given the collateral or they can opt for the option where we seel the collateral and send them their money. Note that we do not reimburse the initial sending charges imposed on the lender. Therefore there is a possibility of incurring a loss.',
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
            ),
          ),


          //conclusion
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 30, right: 10),
            child: Text(
              'Participating in this process means the you read through these terms and understood them properly, and you agree with them',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(height: 30,)
        ],
      )),
    );
  }
}
