using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using System.Collections;
using Microsoft.AspNetCore.Authorization;
using Microsoft.CodeAnalysis;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class OffersController : Controller
    {
        private readonly ApplicationDbContext _context;

        public OffersController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetOffers()
        {
            if (_context.Offer == null)
            {
                return NotFound();
            }

            return Ok(_context.Offer.ToList());
        }

        [HttpPost]
        public async Task<ActionResult> Create(Offer offer)
        {
            _context.Offer.Add(offer);


            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {

                    throw;
            }

            return Ok(offer);
        }
        private bool OfferExists(string id)
        {
            return (_context.Offer?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}