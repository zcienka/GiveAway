namespace Backend.Models
{
    public class Offer
    {
        public string? Id { get; set; } = Guid.NewGuid().ToString("N");
        public string? Title { get; set; }
        public string? Description { get; set; }
        public List<String> Stars { get; set; } = new List<String>();
        public string? Img { get; set; }
        public string? Location { get; set; }
    }
}
