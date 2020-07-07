class Profile {
  int id;
  String profilePic;

  Profile({this.id, this.profilePic,});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profilepic': profilePic.toString(),
    };
  }
  Map<String, dynamic> toMapAutoID() {
    return {
      'profilepic': profilePic.toString(),
    };
  }
}