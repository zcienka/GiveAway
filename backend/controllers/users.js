const User = require("../models/User");
const router = require("express").Router();
const bcrypt = require("bcrypt");
const session = require('express-session')

router.get('/query/:userId', async (req, res) => {
    try {
        const user = await User.findById(req.params.userId);
        res.send(user)
    } catch (err) {
        res.status(404).json(err)
    }
})

router.get('/', async (req, res) => {
    try {
        const username = req.query.user;
        const user = await User.findOne({username: username});
        if (user) res.send(user)
        else res.send("No user found")
    } catch (err) {
        res.status(500).json(err)
    }
})


module.exports = router;