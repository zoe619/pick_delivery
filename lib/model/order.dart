class Order {
  final String riderName;
  final String riderPhone;
  final String item;
  final String time;
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;
  final String pickAddress;
  final String deliveryAddress;
  final double pickLatitude;
  final double pickLongitude;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final double amount;
  final double distance;


  Order({
    this.riderName,
    this.riderPhone,
    this.item,
    this.time,
    this.senderName,
    this.senderPhone,
    this.receiverName,
    this.receiverPhone,
    this.pickAddress,
    this.deliveryAddress,
    this.pickLatitude,
    this.pickLongitude,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.amount,
    this.distance

  });

  factory Order.fromJson(Map<String, dynamic> json)
  {
    return Order(
        riderName: json['riderName'] as String,
        riderPhone: json['riderPhone'] as String,
        item: json['item'] as String,
        senderName: json['senderName'] as String,
        senderPhone: json['senderPhone'] as String,
        receiverName: json['receiverName'] as String,
        receiverPhone: json['receiverPhone'] as String,
        pickAddress: json['pickAddress'] as String,
        deliveryAddress: json['deliveryAddress'] as String,
        pickLatitude: json['pickLatitude'] as double,
        pickLongitude: json['pickLongitude'] as double,
        deliveryLatitude: json['deliveryLatitude'] as double,
        deliveryLongitude: json['deliveryLongitude'] as double,
        amount: json['price'] as double,
        distance: json['distance'] as double

    );
  }
}