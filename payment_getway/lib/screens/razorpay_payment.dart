import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment extends StatefulWidget {
  const RazorpayPayment({super.key});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  late Razorpay _razorpayPayment;
  final TextEditingController amountController = TextEditingController();

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_RNrCqXfo4M0jBf',
      'amount': amount,
      'name': 'My Payment',
      'prefill': {'contact': '1234567890', 'email': 'test@gmail.com'},
      'external': {'wallets': 'paytm'},
    };

    try {
      _razorpayPayment.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Successful: ${response.paymentId!}",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.error!}",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet: ${response.walletName!}",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpayPayment = Razorpay();
    _razorpayPayment.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpayPayment.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpayPayment.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpayPayment.clear();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            SizedBox(
              height: 200,
              width: 300,
              child: Image.asset('images/payment.jpg'),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Welcome to Razorpay Payment Gateway",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
              ),
            ),
            SizedBox(height: 30,),
            Padding(
                padding: EdgeInsets.all(15),
              child: TextFormField(
                controller: amountController,
                cursorColor: Colors.black12,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: false,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  //labelText: "Enter amount",
                  hintText: "Enter amount to be paid",
                  //label: Text("Enter amount"),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.black12,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    )
                  ),
                  errorStyle: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                  )
                ),
                validator: (value){
                  if(value ==  null || value.isEmpty){
                    return 'Please enter amount to be paid';
                  }return null;
                },
              ),
            ),
            SizedBox(height: 30,),
            Container(padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){
                    if(amountController.text.toString().isNotEmpty){
                      setState(() {
                        int amount = int.parse(amountController.text.toString());
                        openCheckout(amount);
                      });
                    }
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
                  child: Text(
                    "Make Payment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
