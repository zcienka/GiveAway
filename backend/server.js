const express = require("express");
const app = express();
const offers = require("./routes/offers");
const connectDB = require("./db/connect");

require("dotenv").config();

app.use(express.json());

app.use("/api/v1/offers", offers);

const port = process.env.PORT || 5000;

const start = async () => {
  try {
    await connectDB(process.env.MONGO_URI);
    app.listen(5000, () =>
      console.log(`Server is listening on port ${port}...`)
    );
  } catch (error) {
    console.log(error);
  }
};

start();
