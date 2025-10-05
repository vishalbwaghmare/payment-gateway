import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_getway/core/app_config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final Razorpay razorpay;
  PaymentBloc({required this.razorpay}) : super(PaymentState.initial()) {
    on<OnAmountChangedEvent>(_onAmountChanged);
    on<OnMakePaymentEvent>(_onMakePaymentEvent);
    on<OnPaymentSuccessEvent>(_onPaymentSuccessEvent);
    on<OnPaymentFailedEvent>(_onPaymentFailedEvent);
    on<OnPaymentExternalWallet>(_onPaymentExternalWallet);

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      add(OnPaymentSuccessEvent((response as PaymentSuccessResponse).paymentId ?? ''));
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      add(OnPaymentFailedEvent((response as PaymentFailureResponse).message ?? 'Payment failed'));
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
      add(OnPaymentExternalWallet((response as ExternalWalletResponse).walletName ?? 'Unknown'));
    });
  }

  void _onAmountChanged(OnAmountChangedEvent event, Emitter<PaymentState> emit){
    emit(state.copyWith(
      amount: event.amount,
      paymentId: "",
      error: null,
    ));
  }
  void _onMakePaymentEvent(OnMakePaymentEvent event, Emitter<PaymentState> emit){
    final int amountInPaise = (event.amount * Decimal.fromInt(100)).toBigInt().toInt();
    emit(state.copyWith(
      paymentStatus: PaymentStatus.inProgress,
    ));

    final options = {
      'key': AppConfig.instance.razorpayKey,
      'amount': amountInPaise,
      'name': 'Payment',
      'description': 'Payment for order',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@gmail.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try{
      razorpay.open(options);
    }catch(e){
      emit(state.copyWith(
        paymentStatus: PaymentStatus.failure,
        error: "Error opening payment gateway: $e",
      ));
    }
  }
  void _onPaymentSuccessEvent(OnPaymentSuccessEvent event, Emitter<PaymentState> emit){
    emit(state.copyWith(
      paymentStatus: PaymentStatus.success,
      paymentId: event.paymentID,
    ));
  }
  void _onPaymentFailedEvent(OnPaymentFailedEvent event, Emitter<PaymentState> emit){
    emit(state.copyWith(
      paymentStatus: PaymentStatus.failure,
      error: event.error,
    ));
  }
  void _onPaymentExternalWallet(OnPaymentExternalWallet event, Emitter<PaymentState> emit){
    emit(state.copyWith(
      paymentStatus: PaymentStatus.success,
      paymentId: event.walletName,
    ));
  }
}
