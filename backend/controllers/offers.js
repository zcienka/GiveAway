const Offer = require('../models/Offer')
const asyncWrapper = require('../middleware/async')

const getAllOffers = asyncWrapper(async (req, res) => {
  const offers = await Offer.find({})
  res.status(200).json({ offers })
})

module.exports = {
    getAllOffers
}