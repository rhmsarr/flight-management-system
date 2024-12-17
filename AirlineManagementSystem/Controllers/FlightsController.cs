using Microsoft.AspNetCore.Mvc;

namespace AirlineManagementSystem.Controllers{
    public class FlightsController : Controller{
        public IActionResult Index() {
            return View();
         }
        public IActionResult Checkout() {
            return View();
        }
        public IActionResult LastCheckout(){
            return View();
        }
    }
}