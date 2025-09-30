part of 'payment_bloc.dart';

enum PaymentStatus { initial, inProgress, success, failure }

class PaymentState extends Equatable {
  final PaymentStatus paymentStatus;
  final String paymentId;
  final String error;
  final Decimal amount;

  const PaymentState({
    required this.paymentStatus,
    required this.paymentId,
    required this.error,
    required this.amount,
});

  factory PaymentState.initial(){
    return PaymentState(
        paymentStatus: PaymentStatus.initial,
        paymentId: "",
        error: "",
      amount: Decimal.zero,
    );
  }
  PaymentState copyWith({
    PaymentStatus? paymentStatus,
    String? paymentId,
    String? error,
    Decimal? amount,
  }){
    return PaymentState(
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentId: paymentId ?? this.paymentId,
        error: error ?? this.error,
        amount: amount ?? this.amount,
    );
}

  @override
  List<Object?> get props => [
    paymentStatus,
    paymentId,
    error,
    amount,
  ];
}

