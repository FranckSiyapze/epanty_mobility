class OnBoarding {
  final String title;
  final String image;

  OnBoarding({
    required this.title,
    required this.image,
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
    title: 'Welcome to\n EPANTY MOBILITY',
    image: 'assets/images/EPS.png',
  ),
  OnBoarding(
    title: 'NAVIGATION',
    image: 'assets/images/NAVIGATION.PNG',
  ),
  OnBoarding(
    title: 'NOTIFICATION',
    image: 'assets/images/NOTIFICATION.PNG',
  ),
  OnBoarding(
    title: 'GEOLOCATION',
    image: 'assets/images/GEOLOCALISATION.PNG',
  ),
  OnBoarding(
    title: 'FORUM',
    image: 'assets/images/FORUM.PNG',
  ),
];
