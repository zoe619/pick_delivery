class Bank {
  final String bank;
  final String accountName;
  final String accountNumber;


  Bank({
    this.bank,
    this.accountName,
    this.accountNumber

  });

  factory Bank.fromJson(Map<String, dynamic> json)
  {
    return Bank(
        bank: json['bank_name'] as String,
        accountName: json['account_name'] as String,
        accountNumber: json['account_number'] as String

    );
  }
}