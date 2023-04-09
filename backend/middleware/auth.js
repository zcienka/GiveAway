const jwt = require('jsonwebtoken');

const asyncWrapper = (handler) => async (req, res, next) => {
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
        req.user = decoded;
        handler(req, res, next);
    } catch (err) {
        res.status(401).json({ message: 'Unauthorized' });
    }
};
const express = require("express");
const app = express();

module.exports = asyncWrapper;
