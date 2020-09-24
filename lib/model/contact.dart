class Contact {
  final String phone;
  final String email;
  final String address;
  final String website;


  Contact({
    this.phone,
    this.email,
    this.address,
    this.website

  });

  factory Contact.fromJson(Map<String, dynamic> json)
  {
    return Contact(
        phone: json['phone'] as String,
        email: json['email'] as String,
        address: json['address'] as String,
        website: json['website'] as String

    );
  }
}