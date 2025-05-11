class SenderId {
  String? iD;
  String? name;
  String? email;
  dynamic age;
  String? id;

  SenderId({this.iD, this.name, this.email, this.age, this.id});

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
        iD: json['_id'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        age: json['age'] as dynamic,
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': iD,
        'name': name,
        'email': email,
        'age': age,
        'id': id,
      };
}
