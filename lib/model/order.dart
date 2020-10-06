class Order {
  final String id;
  final String riderName;
  final String riderPhone;
  final String riderEmail;
  final String item;
  final String time;
  final String senderName;
  final String senderPhone;
  final String senderEmail;
  final String receiverName;
  final String receiverPhone;
  final String pickAddress;
  final String deliveryAddress;
  final String pickLatitude;
  final String pickLongitude;
  final String deliveryLatitude;
  final String deliveryLongitude;
  final String amount;
  final String distance;
  final String status;


  Order({
    this.id,
    this.riderName,
    this.riderPhone,
    this.riderEmail,
    this.item,
    this.time,
    this.senderName,
    this.senderPhone,
    this.senderEmail,
    this.receiverName,
    this.receiverPhone,
    this.pickAddress,
    this.deliveryAddress,
    this.pickLatitude,
    this.pickLongitude,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.amount,
    this.distance,
    this.status

  });

  factory Order.fromJson(Map<String, dynamic> json)
  {
    return Order(
        id: json['id'] as String,
        riderName: json['riderName'] as String,
        riderPhone: json['riderPhone'] as String,
        riderEmail: json['riderEmail'] as String,
        item: json['item'] as String,
        time: json['date_added'] as String,
        senderName: json['senderName'] as String,
        senderPhone: json['senderPhone'] as String,
        senderEmail: json['senderEmail'] as String,
        receiverName: json['receiverName'] as String,
        receiverPhone: json['receiverPhone'] as String,
        pickAddress: json['pickAddress'] as String,
        deliveryAddress: json['deliveryAddress'] as String,
        pickLatitude: json['pickLatitude'] as String,
        pickLongitude: json['pickLongitude'] as String,
        deliveryLatitude: json['deliveryLatitude'] as String,
        deliveryLongitude: json['deliveryLongitude'] as String,
        amount: json['price'] as String,
        distance: json['distance'] as String,
        status: json['stat'] as String

    );
  }
}