import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/screens/payment_bloc/payment_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPaymentContainer extends StatelessWidget {
  const RazorPaymentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(razorpay: Razorpay()),
      child: RazorpayPayment(),
    );
  }

}

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
      'key': 'rzp_test_1DP5mmOlF565ag',
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
    return BlocListener<PaymentBloc, PaymentState>(
      listenWhen: (prev, curr) =>
      prev.paymentStatus != curr.paymentStatus,

      listener: (context, state) {
        if (state.paymentStatus == PaymentStatus.success) {
          Fluttertoast.showToast(
            msg: "Payment Successful",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
        else if (state.paymentStatus == PaymentStatus.failure) {
          Fluttertoast.showToast(
            msg: "Payment Failed",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      },
      child: Scaffold(
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
                  // validator: (value){
                  //   if(value ==  null || value.isEmpty){
                  //     return 'Please enter amount to be paid';
                  //   }return null;
                  // },
                  onChanged: (value) {
                    final decimalValue = Decimal.tryParse(value.trim());
                    if (decimalValue != null) {
                      context.read<PaymentBloc>().add(OnAmountChangedEvent(decimalValue));
                    }
                  },
                ),
              ),
              SizedBox(height: 30,),
              Container(padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (state.amount > Decimal.zero) {
                          context
                              .read<PaymentBloc>()
                              .add(OnMakePaymentEvent(state.amount));
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please enter a valid amount",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                      },
                      /*onPressed: (){
                    if(amountController.text.toString().isNotEmpty){
                      setState(() {
                        int amount = int.parse(amountController.text.toString());
                        openCheckout(amount);
                      });
                    }
                  },*/
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
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
