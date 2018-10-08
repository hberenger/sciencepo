// DICHOTOMY
int min = 0;
int max = 2000000000;
final int secret = 456789090;
int guess = -1;

while(guess != secret) {
  guess = (min + max) / 2;
  println("Trying " + guess);
  if (guess > secret) {
    println("Too high");
    max = guess;
  }
  if (guess < secret) {
    println("Too low");
    min = guess;
  }
}
println("Found it ; secret number was " + guess);
