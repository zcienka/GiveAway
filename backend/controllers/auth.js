const User = require('../models/User');
const bcrypt = require('bcrypt');
const asyncWrapper = require('../middleware/auth')
const jwt = require('jsonwebtoken');
require('dotenv').config()

const registerUser = async (req, res) => {
    try {
        const existingUser = await User.findOne({username: req.body.username});
        if (existingUser) {
            return res.status(409).json({message: 'User already exists'});
        }

        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(req.body.password, salt);

        const newUser = new User({
            username: req.body.username,
            password: hashedPassword
        });

        const user = await newUser.save();

        return res.status(200).json(user);
    } catch (err) {
        return res.status(500).json(err);
    }
}
const loginUser = async (req, res) => {
    try {
        const user = await User.findOne({username: req.body.username});

        if (!user) {
            return res.status(404).send("Invalid login");
        }

        const validPassword = await bcrypt.compare(req.body.password, user.password);

        if (!validPassword) {
            return res.status(404).json('Invalid login');
        }

        const token = jwt.sign({username: user.username}, process.env.ACCESS_TOKEN_SECRET, {expiresIn: '100000s'});

        return res.status(200).json({user, token});

    } catch (err) {
        return res.status(500).json(err);
    }
}

module.exports = {
    registerUser,
    loginUser,
}