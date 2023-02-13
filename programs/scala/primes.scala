import scala.collection.mutable.HashMap
import scala.collection.immutable.Vector
import scala.math.sqrt
import scala.math.pow
import scala.math.BigInt

def get_keys(n: Long, half_size:Long): Vector[Long] =
  var v = Vector.range(0L, half_size + 1L).map(i => n / (i + 1))
  val vmax = v(half_size.asInstanceOf[Int])
  v ++ Vector.range(1L, vmax).reverse

def get_sums(keys: Vector[Long]) : HashMap[Long, BigInt] =
  var hmap = HashMap.empty[Long, BigInt]
  for key <- keys do
    val k = BigInt(key)
    val value = (k * (k + 1)) / 2 - 1
    hmap.put(key, value)
  hmap 

def calculate_sums(hmap: HashMap[Long, BigInt], keys: Vector[Long], square_n: Long): HashMap[Long, BigInt] =
  var cmap = hmap.clone()
  for p <- (2L to square_n) do
    val current_sum = cmap(p - 1)
    if (cmap(p) > current_sum) {
      val p_square = p * p
      for key <- keys.takeWhile(p => p >= p_square) do
        val new_value = cmap(key) - p * (cmap(key / p) - current_sum)
        cmap.update(key, new_value)
    }
  cmap

def primes(n: Long): BigInt =
  val square_n = sqrt(n.asInstanceOf[Float]).asInstanceOf[Long]
  val half_size = square_n - 1
  val keys = get_keys(n, half_size)
  var all_sums = get_sums(keys)
  all_sums = calculate_sums(all_sums, keys, square_n)
  all_sums(n)

def add_space(i:Int, string:String) : String =
  if (i == 0){
    return string
  } else {
    return add_space(i - 1, string.concat(" "))
  }

def format(dist:Int, string: String): String =
  add_space(dist - string.length(), string)

@main def main() =
  println("Power | Time (µs) | Resultat")
  println("========================================")
  for power <- (1 to 8) do
    val start = System.nanoTime
    val n = pow(10.0, power.asInstanceOf[Double]).asInstanceOf[Long]
    val result = primes(n)
    val duration = ((System.nanoTime - start) / 1e3d).asInstanceOf[Int]
    println(s"${format(5, s"$power")} | ${format(9, s"$duration")} | $result")

