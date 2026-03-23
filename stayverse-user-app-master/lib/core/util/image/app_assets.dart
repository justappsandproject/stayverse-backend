class AppAsset {
  static String base = 'assets/images';
  static String baseSvg = '$base/svgs';
  static String baseIconSvg = '$base/icons/svgs';
  static String baseIconPng = '$base/icons/pngs';
  static String basePng = '$base/pngs';
  static String baseIcon = '$base/icons';
  static String basegif = '$base/gif';
  static String baseJson = 'assets/json';
  static String baseSound = 'assets/sound';

  ///png
  static String example = '$basePng/example.png';
  static String cab = '$basePng/cab.png';
  static String chef = '$basePng/chef.png';
  static String shortlet = '$basePng/shortlet.png';
  static String apartment = '$basePng/apartment.png';
  static String smallSmile = '$basePng/icon-small-smile.png';
  static String location = '$basePng/location.png';
  static String chefProfile = '$basePng/chef-profile.png';
  static String chefBackground = '$basePng/chef-background.png';
  static String car = '$basePng/car.png';
  static String car2 = '$basePng/car-two.png';
  static String carType = '$basePng/car-type.png';
  static String profilePic = '$basePng/profile-pic.png';
  static String bigSmile = '$baseIconPng/big-smile.png';
  static String states(String name) =>
      '$basePng/${name.toLowerCase()}-state.png';
  static String apartmentMarker = '$basePng/apartment-marker.png';
  static String pngLogo = '$basePng/logo.png';

  ///svg
  static String backgoroungFade = '$baseSvg/background-fade.svg';
  static String verified = '$baseSvg/verified.svg';
  static String petPawSolid = '$baseIconSvg/pet-paw-solid.svg';
  static String solarGallery = '$baseIconSvg/solar_gallery.svg';
  static String symbolsWifi = '$baseIconSvg/symbols_wifi.svg';
  static String washer = '$baseIconSvg/washer.svg';
  static String airConditioner = '$baseIconSvg/air-conditioner.svg';
  static String carGarage = '$baseIconSvg/car-garage.svg';
  static String chatIcon = '$baseIconSvg/chat-icon.svg';
  static String bed = '$baseIconSvg/bed.svg';
  static String mountainView = '$baseIconSvg/mountain_symbol.svg';
  static String pool = '$baseIconSvg/pool_symbol.svg';
  static String snooker = '$baseIconSvg/snooker_symbol.svg';
  static String security = '$baseIconSvg/security_symbol.svg';
  static String garage = '$baseIconSvg/garage_symbol.svg';
  static String gym = '$baseIconSvg/gym_symbol.svg';
  static String balcony = '$baseIconSvg/balcony_symbol.svg';
  static String fluentPeople = '$baseIconSvg/fluent_people.svg';
  static String chevronRight = '$baseIconSvg/chevron-right.svg';
  static String chevronLeft = '$baseIconSvg/chevron-left.svg';
  static String solarBath = '$baseIconSvg/solar_bath.svg';
  static String vectorShape = '$baseSvg/vector-shape.svg';
  static String pattern = '$baseSvg/pattern.svg';
  static String logo = '$baseSvg/logo.svg';
  static String appleLogo = '$baseSvg/apple-logo.svg';
  static String googleLogo = '$baseSvg/google-logo.svg';

  ///gif
  static String appIconsGif = '$basegif/app-icon.gif';
  static String splashingGif = '$basegif/splashing.GIF';
  static String laodingGif = '$basegif/loading.GIF';

  //json
  static String mapStyle = '$baseJson/map_style.json';

  static String loading = '$baseJson/loading.json';
  static String empty = '$baseJson/empty.json';
  static String apartmentEmpty = '$baseJson/apartment-empty.json';
  static String chefEmpty = '$baseJson/chefs-empty.json';
  static String ridesEmpty = '$baseJson/rides-empty.json';

  //Sound
  static String ouGoingCall = '$baseSound/outgoing-call.wav';
}
