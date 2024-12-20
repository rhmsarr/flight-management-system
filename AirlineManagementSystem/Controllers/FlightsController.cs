using Microsoft.AspNetCore.Mvc;
using AirlineManagementSystem.Models;
using Npgsql;
using AirlineManagementSystem.ViewModels;

namespace AirlineManagementSystem.Controllers{
    public class FlightsController : Controller{
        private readonly string _connectionString;

        public FlightsController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("Database");
        }

        [HttpPost]
        public IActionResult Index(SelectFlight flight) {
        
            if(!ModelState.IsValid) {
                return Redirect("/Home/Index");
            }
            List<Flight> flights = new List<Flight>();
            
            string query = @$"
            SELECT 
                ""DepartureAirport"".""CountryName"",
                ""DepartureAirport"".""CityName"",
                ""DepartureAirport"".""AirportName"",
                ""ArrivalAirport"".""CountryName"",
                ""ArrivalAirport"".""CityName"",
                ""ArrivalAirport"".""AirportName"",
                ""Flight"".""DepartureTime"",
                ""Flight"".""ArrivalTime"",
                ""Flight"".""Price"",
                ""Airline"".""AirlineName"",
                ""Flight"".""FlightID""
            FROM ""Flight""
            INNER JOIN ""Plane"" ON ""Flight"".""PlaneID"" = ""Plane"".""PlaneID""
            INNER JOIN ""Airline"" ON ""Airline"".""AirlineID"" = ""Plane"".""AirlineID""
            INNER JOIN ""Route"" ON ""Flight"".""RouteID"" = ""Route"".""RouteID""
            INNER JOIN ""Airport"" AS ""DepartureAirport"" ON ""Route"".""DeparturePlace"" = ""DepartureAirport"".""AirportID""
            INNER JOIN ""Airport"" AS ""ArrivalAirport"" ON ""Route"".""ArrivalPlace"" = ""ArrivalAirport"".""AirportID""
            WHERE ""Flight"".""DepartureTime""::date = '{flight.Date.ToString("yyyy-MM-dd")}'
            and  ""DepartureAirport"".""CountryName"" = '{flight.DepartureCountry}'
            and ""ArrivalAirport"".""CountryName"" = '{flight.ArrivalCountry}';
            ";

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            connection.Open();
            using (var command = new NpgsqlCommand(query, connection))
            {
                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        flights.Add(new Flight
                        {
                            DepartureCountry = reader.GetString(reader.GetOrdinal("CountryName")),
                            DepartureCity = reader.GetString(reader.GetOrdinal("CityName")),
                            DepartureAirport = reader.GetString(reader.GetOrdinal("AirportName")),
                            ArrivalCountry = reader.GetString(reader.GetOrdinal("CountryName")),
                            ArrivalCity = reader.GetString(reader.GetOrdinal("CityName")),
                            ArrivalAirport = reader.GetString(reader.GetOrdinal("AirportName")),
                            DepartureTime = reader.GetDateTime(reader.GetOrdinal("DepartureTime")),
                            ArrivalTime = reader.GetDateTime(reader.GetOrdinal("ArrivalTime")),
                            Price = reader.GetDecimal(reader.GetOrdinal("Price")),
                            AirlineName = reader.GetString(reader.GetOrdinal("AirlineName")),
                            FlightID = reader.GetInt32(reader.GetOrdinal("FlightID"))
                        });
                    }
                }
            }
        }

        

            return View(flights);
         }

         [HttpGet]
        public IActionResult Checkout(int FlightID) {

            return View();
        }
        [HttpPost]
        public IActionResult Checkout(Ticket model) {

            return View();
        }
        public IActionResult LastCheckout(){
            return View();
        }
    }
}