using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Hosting;

namespace Backend.Models
{
    public class UserDto
    {
        public string? UserName { get; set; } = null!;
    }
}