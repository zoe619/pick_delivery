class Rider {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String fee;


  Rider({
    this.name,
    this.phone,
    this.email,
    this.address,
    this.fee

  });

  factory Rider.fromJson(Map<String, dynamic> json)
  {
    return Rider(
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        address: json['address'] as String,
        fee: json['charge'] as String

    );
  }
}