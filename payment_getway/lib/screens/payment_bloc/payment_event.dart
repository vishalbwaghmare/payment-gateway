part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class OnAmountChangedEvent extends PaymentEvent{
  final Decimal amount;
  const OnAmountChangedEvent(this.amount);

  @override
  List<Object?> get props => [amount];
}

class OnMakePaymentEvent extends PaymentEvent{
  final Decimal amount;
  const OnMakePaymentEvent (this.amount);
  @override
  List<Object?> get props => [amount];

}

class OnPaymentSuccessEvent extends PaymentEvent{
  final String paymentID;
  const OnPaymentSuccessEvent (this.paymentID);
  @override
  List<Object?> get props => [paymentID];

}

class OnPaymentFailedEvent extends PaymentEvent{
  final String error;
  const OnPaymentFailedEvent (this.error);
  @override
  List<Object?> get props => [error];

}

class OnPaymentExternalWallet extends PaymentEvent{
  final String walletName;
  const OnPaymentExternalWallet (this.walletName);
  @override
  List<Object?> get props => [walletName];
}


