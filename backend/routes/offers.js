const express = require('express')
const router = express.Router()

const {
  getAllOffers,
} = require('../controllers/offers')

router.route('/').get(getAllOffers)

module.exports = router 