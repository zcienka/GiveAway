const express = require('express')
const router = express.Router()

const {
    getAllOffers,
    getOffer,
    createOffer,
    deleteOffer
} = require('../controllers/offers')

router.route('/').get(getAllOffers)
router.route('/:offerId').get(getOffer)
router.route('/').post(createOffer)
router.route('/:offerId').delete(deleteOffer)

module.exports = router 