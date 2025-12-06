class Payment {
  final int id;
  final String paymentDate;
  final int paymentId;
  final int orderId;
  final double amountDue;
  final double tips;
  final double discount;
  final double totalPaid;
  final String paymentType;
  final String paymentStatus;

  Payment({
    required this.id,
    required this.paymentDate,
    required this.paymentId,
    required this.orderId,
    required this.amountDue,
    required this.tips,
    required this.discount,
    required this.totalPaid,
    required this.paymentType,
    required this.paymentStatus,
  });

  factory Payment.fromMap(Map<String, dynamic> m) => Payment(
    id: m['id'] as int,
    paymentDate: m['paymentDate'] as String,
    paymentId: m['paymentId'] as int,
    orderId: m['orderId'] as int,
    amountDue: (m['amountDue'] as num).toDouble(),
    tips: (m['tips'] as num).toDouble(),
    discount: (m['discount'] as num).toDouble(),
    totalPaid: (m['totalPaid'] as num).toDouble(),
    paymentType: m['paymentType'] as String,
    paymentStatus: m['paymentStatus'] as String,
  );
}
