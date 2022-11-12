
const express = require('express');
const app = express();
const mongoose = require('mongoose')
const port = 5000;


let MONGO_URI = "mongodb+srv://abhinav:abhinav123@cluster0.nqn9r9i.mongodb.net/test";
const mongo = require("mongodb").MongoClient;
let db;
let deleterequests, feedbacks, forwards;
let grievances, institutes, officers;
let regionaladmins, regionalofficers;
let superadmins, uniadmins, users;




app.get('/', (req, res) => {
	res.send('Hello World');
})

app.get("/deleterequests", (req, res) => {
	deleterequests.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ deleterequests: items });
	});
});
app.get("/feedbacks", (req, res) => {
	feedbacks.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ feedbacks: items });
	});
});
app.get("/forwards", (req, res) => {
	forwards.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ forwards: items });
	});
});
app.get("/grievances", (req, res) => {
	grievances.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ grievances: items });
	});
});

app.get("/institutes", (req, res) => {
	institutes.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ institutes: items });
	});
});

app.get("/officers", (req, res) => {
	officers.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ officers: items });
	});
});




app.get("/regionaladmins", (req, res) => {
	regionaladmins.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ regionaladmins: items });
	});
});


app.get("/regionalofficers", (req, res) => {
	regionalofficers.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ regionalofficers: items });
	});
});


app.get("/superadmins", (req, res) => {
	superadmins.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ superadmins: items });
	});
});
app.get("/uniadmins", (req, res) => {
	uniadmins.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ uniadmins: items });
	});
});
app.get("/users", (req, res) => {
	users.find().toArray((err, items) => {
		if (err) {
			console.error(err);
			res.status(500).json({ err: err });
			return;
		}
		res.status(200).json({ users: items });
	});
});

app.listen(port, (req, res) => {
	console.log(`server started on port http://localhost:${port}`);
});

mongo.connect(
	MONGO_URI,
	{
		useNewUrlParser: true,
		useUnifiedTopology: true,
	},
	(err, client) => {
		if (err) {
			console.error(err);
			return;
		}
		db = client.db("Grievance");
		db = client.db("test");

		deleterequests = db.collection("deleterequests");
		feedbacks = db.collection("feedbacks");
		forwards = db.collection("forwards");
		feedbacks = db.collection("feedbacks");
		grievances = db.collection("grievances");
		institutes = db.collection("institutes");
		officers = db.collection("officers");
		regionalofficers = db.collection("regionalofficers");
		regionaladmins = db.collection("regionaladmins");
		superadmins = db.collection("superadmins");
		uniadmins = db.collection("uniadmins");
		users = db.collection("users");
	}
);