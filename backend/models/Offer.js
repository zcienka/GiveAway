const mongoose = require('mongoose')

const OfferSchema = new mongoose.Schema({
    title: {
        type: String,
    },
    description: {
        type: String,
    },
    stars: {
        type: Array,
        default: []
    },
    img: {
        type: String
    },
    location: {
        type: String
    }
})

module.exports = mongoose.model('Offer', OfferSchema)
