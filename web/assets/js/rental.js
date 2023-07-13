function redirectToPrice(price) {
  // Get the current URL.
  window.location.href = "./find?price=" + encodeURIComponent(price);


}

// Attach the click event handler to the radio buttons.
$("input[name='price']").click(function() {
  // Get the value of the radio button that was clicked.
  var price = $(this).val();

  // Redirect to the URL with the price as a query parameter.
  redirectToPrice(price);
});

const cities = ["Hà Nội", "Hải Phòng", "Đà Nẵng", "Hồ Chí Minh", "Cần Thơ", "An Giang", "Bình Dương", "Bà Rịa - Vũng Tàu",
    "Bắc Giang", "Bắc Kạn", "Bạc Liêu", "Bắc Ninh", "Bến Tre", "Bình Phước", "Bình Thuận", "Bình Định", "Cà Mau", "Cao Bằng",
    "Gia Lai", "Hà Giang", "Hà Nam", "Hà Tĩnh", "Huế", "Hải Dương", "Hậu Giang", "Hòa Bình", "Hưng Yên", "Khánh Hòa", "Kiên Giang",
    "Kon Tum", "Lai Châu", "Lâm Đồng", "Lạng Sơn", "Lào Cai", "Long An", "Nam Định", "Nghệ An", "Ninh Bình", "Ninh Thuận", "Phú Thọ",
    "Phú Yên", "Quảng Bình", "Quảng Nam", "Quảng Ngãi", "Quảng Ninh", "Quảng Trị", "Sóc Trăng", "Sơn La", "Tây Ninh", "Thái Bình",
    "Thái Nguyên", "Thanh Hóa", "Tiền Giang", "Trà Vinh", "Tuyên Quang", "Vĩnh Long", "Vĩnh Phúc", "Yên Bái", "Đắk Lắk", "Đắk Nông", "Điện Biên", "Đồng Nai", "Đồng Tháp"];


const searchCitySelect = document.getElementById("search_city");

cities.forEach((city) => {
  const option = document.createElement("option");
  option.value = city;
  option.textContent = city;
  searchCitySelect.appendChild(option);
});

searchCitySelect.addEventListener("change", function() {
  const selectedCity = this.value;
  if (selectedCity) {
    window.location.href = `find?city=${encodeURIComponent(selectedCity)}`;
  }
});