﻿using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using Backend.Data;
using Backend.Models;
using Backend.Requests;
using FluentValidation;
using FluentValidation.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.EntityFrameworkCore;

namespace Backend.Controllers
{
    [Route("api/auth/")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly JwtHandler _jwtHandler;

        public AuthController(
            ApplicationDbContext context,
            JwtHandler jwtHandler
        )
        {
            _context = context;
            _jwtHandler = jwtHandler;
        }

        public static string PasswordCreator(string password, byte[] salt)
        {
            string pw = Convert.ToBase64String(KeyDerivation.Pbkdf2(
                password: password,
                salt: salt,
                prf: KeyDerivationPrf.HMACSHA256,
                iterationCount: 100000,
                numBytesRequested: 256 / 8
            ));

            return pw;
        }

        private static byte[] GenerateSaltNewInstance(int size)
        {
            using (var generator = RandomNumberGenerator.Create())
            {
                var salt = new byte[size];
                generator.GetBytes(salt);
                return salt;
            }
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(LoginRegisterRequest request)
        {
            if (UserNameExists(request.UserName))
            {
                return StatusCode(409, "User with that username already exists.");
            }

            var salt = GenerateSaltNewInstance(32);
            string password = PasswordCreator(request.Password, salt);
            var user = new User
                { UserName = request.UserName, PasswordHash = password, PasswordSalt = Convert.ToBase64String(salt) };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            var userJwt = new UserDto { UserName = request.UserName };

            var secToken = _jwtHandler.GetToken(userJwt);
            var jwt = new JwtSecurityTokenHandler().WriteToken(secToken);

            return Ok(new { jwt });
        }

        [HttpPost("jwt")]
        public async Task<IActionResult> GetJwt(UserDto userDto)
        {
            var secToken = _jwtHandler.GetToken(userDto);
            var jwt = new JwtSecurityTokenHandler().WriteToken(secToken);
            return Ok(new { jwt });
        }
            
        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginRegisterRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(p => p.UserName == request.UserName);
            if (user == null)
            {
                return Unauthorized(new LoginResult()
                {
                    Success = false
                });
            }


            var saltedByte = Convert.FromBase64String(user.PasswordSalt);
            var passwordSubmitted = PasswordCreator(request.Password, saltedByte);

            if (String.Compare(user.PasswordHash, passwordSubmitted) == 0)
            {
                var userJwt = new UserDto { UserName = request.UserName };

                var secToken =  _jwtHandler.GetToken(userJwt);
                var jwt = new JwtSecurityTokenHandler().WriteToken(secToken);

                return Ok(new { jwt });
            }

            return Unauthorized(new LoginResult()
            {
                Success = false,
            });
        }

        [HttpDelete("user/{username}")]
        [Authorize]
        public async Task<IActionResult> DeleteUser(string username)
        {
            if (_context.Users == null)
            {
                return NotFound();
            }


            var user = await _context.Users.FirstOrDefaultAsync(p => p.UserName == username);

            if (user == null)
            {
                return NotFound();
            }

            if (user.UserName != username)
            {
                return Forbid();
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        public bool UserNameExists(string username)
        {
            return (_context.Users?.Any(e => e.UserName == username)).GetValueOrDefault();
        }
    }
}