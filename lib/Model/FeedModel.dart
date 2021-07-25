class FeedModel {
  var head, Photo, body, email, name;
  var likes;
  var date;

  FeedModel(
      {this.email,
      this.head,
      this.body,
      this.likes,
      this.Photo,
      this.name,
      this.date});

  factory FeedModel.fromDocument(doc) {
    return FeedModel(
      email: doc['email'],
      head: doc['head'],
      body: doc['body'],
      likes: doc['likes'],
      Photo: doc['Photo'],
      name: doc['name'],
      date: doc['date'],
      // aboutus: doc['aboutus'],
      // uid: doc['uid'],
      // Photo: doc['Photo'],
    );
  }
}
