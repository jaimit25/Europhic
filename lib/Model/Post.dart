class Post {
  var userPhoto;
  var name;
  var text;
  var type;
  var image;
  var email;
  var comments;
  var DateTime;

  var lat, lng, likes, track, address;
  Post(
      {this.userPhoto,
      this.text,
      this.type,
      this.image,
      this.email,
      this.comments,
      this.DateTime,
      this.lat,
      this.lng,
      this.track,
      this.address,
      this.name});

  factory Post.fromDocument(doc) {
    return Post(
        userPhoto: doc['userPhoto'],
        text: doc['text'],
        type: doc['type'],
        image: doc['image'],
        email: doc['email'],
        comments: doc['comments'],
        DateTime: doc['DateTime'],
        lat: doc['lat'],
        lng: doc['lng'],
        track: doc['track'],
        address: doc['address'],
        name: doc['name']);
  }
}
