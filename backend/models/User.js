const mongoose = require('mongoose')

const UserSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        min: 3,
        max: 20,
        unique: true
    },
    password: {
        type: String,
        require: true,
        min: 8
    },
    profilePicture: {
        type: String,
        default: "/avatar.png"
    },
    likedOffers: {
        type: Array,
        default: []
    },
})

module.exports = mongoose.model('User', UserSchema)
