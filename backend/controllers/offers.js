const Offer = require('../models/Offer')
// const = require('../middleware/auth')
const mongoose = require('mongoose')
const asyncWrapper = require("../middleware/auth");

const getAllOffers = asyncWrapper(async (req, res) => {
    try {
        const offer = await Offer.find();
        return res.status(200).json(offer);
    } catch (err) {
        return res.status(404).json({message: err.message});
    }
})

const getOffer = async (req, res, next) => {
    const offerId = req.params.id;

    try {
        if (!mongoose.isValidObjectId(offerId)) {
            return res.status(400).json("Invalid offer id");
        }

        const offer = await Offer.findById(offerId).exec();

        if (!offer) {
            return res.status(404).json("Offer not found");
        } else {
            return res.status(200).json(offer);
        }

    } catch (error) {
        next(error);
    }
}


const createOffer = asyncWrapper(async (req, res, next) => {
    const title = req.body.title;
    const description = req.body.description;
    const img = req.body.img;
    const location = req.body.location;

    try {
        if (!title) {
            return res.status(400).json("Offer must have a title.");
        }

        if (!description) {
            return res.status(400).json("Offer must have a description.");
        }

        if (!img) {
            return res.status(400).json("Offer must have an image.");
        }

        if (!location) {
            return res.status(400).json("Offer must have a location.");
        }

        const newOffer = await Offer.create({
            title: title,
            description: description,
            img: img,
            location: location,
        });

        return res.status(201).json(newOffer);
    } catch (error) {
        next(error);
    }
})

const deleteOffer = asyncWrapper(async (req, res, next) => {
    const offerId = req.params.offerId;

    try {
        if (!mongoose.isValidObjectId(offerId)) {
            return res.status(400).json("Invalid offer id");
        }

        const offer = await Offer.findById(offerId).exec();

        if (!offer) {
            return res.status(404).json("Offer not found");
        }

        await offer.remove();

        return res.sendStatus(204);
    } catch (error) {
        next(error);
    }
})


module.exports = {
    getAllOffers,
    getOffer,
    createOffer,
    deleteOffer
}