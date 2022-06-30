class Users {
  String id;
  String userDate;
  String from;
  String to;
  String status;

  Users({
    required this.id,
    required this.userDate,
    required this.from,
    required this.to,
    required this.status,
  });

  Map<String, dynamic> tojson() => {
        'id': id,
        'userDate': userDate,
        'from': from,
        'to': to,
        'status': status
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
      userDate: json['userDate'],
      from: json['from'],
      to: json['to'],
      status: json['status'],
      id: json['id']);
}
