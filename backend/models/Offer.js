const mongoose = require('mongoose')

const OfferSchema = new mongoose.Schema({
  name: {
    type: String,
  },
})

module.exports = mongoose.model('Offer', OfferSchema)