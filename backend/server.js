const cors = require("cors")
const express = require("express");
const app = express();
app.use(cors());
app.options('*', cors());
const offers = require("./routes/offers");
const auth = require("./routes/auth");
const connectDB = require("./db/connect");

require("dotenv").config();




app.use(express.json());

app.use("/api/v1/offers", offers);
app.use("/api/v1/auth", auth);

const port = process.env.PORT || 5000;

const start = async () => {
    try {
        await connectDB(process.env.MONGO_URI);
        app.listen(port, () =>
            console.log(`Server is listening on port ${port}...`)
        );
    } catch (error) {
        console.log(error);
    }
};

start();
