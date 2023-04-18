class FollowersModel {
  var myemail, name, useremail, userimg, username;

  FollowersModel(
      {this.myemail, this.name, this.useremail, this.userimg, this.username});

  factory FollowersModel.fromDocument(doc) {
    return FollowersModel(
        myemail: doc['myemail'],
        name: doc['name'],
        useremail: doc['useremail'],
        userimg: doc['userimg'],
        username: doc['username']);
  }
}
