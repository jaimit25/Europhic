class FollowingModel {
  var myemail, name, useremail, photo, username;

  FollowingModel(
      {this.myemail, this.name, this.useremail, this.photo, this.username});

  factory FollowingModel.fromDocument(doc) {
    return FollowingModel(
        myemail: doc['myemail'],
        name: doc['name'],
        useremail: doc['useremail'],
        photo: doc['photo'],
        username: doc['username']);
  }
}
