class userprofile {
  var email, name;

  userprofile({
    this.email,
    this.name,
  });

  factory userprofile.fromDocument(doc) {
    return userprofile(
      email: doc['email'],
      name: doc['name'],
      // aboutus: doc['aboutus'],
      // uid: doc['uid'],
      // Photo: doc['Photo'],
      // city: doc['city'],
      // occupation: doc['occupation'],
      // phone: doc['phone']
    );
  }
}
