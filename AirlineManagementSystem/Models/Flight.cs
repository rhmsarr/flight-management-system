namespace AirlineManagementSystem.Models{
    public class Flight{
        public int FlightID {get; set;}
        public int FlightCoordinatorID {get; set;}
        public int PlaneID {get; set;}
        public int RouteID {get; set;}
        public int TerminalID {get; set;}
        public bool Retard {get; set;}
        public string ArrivalTime {get; set;}
        public string DepartureTime {get; set;}
        public float Price {get; set;}
    }
}