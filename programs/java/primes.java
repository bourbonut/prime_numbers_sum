import java.util.HashMap;
import java.util.Vector;
import java.lang.Math;

public class Main{

    static Vector<Integer> get_keys(Integer n, Integer half_size){
        Vector<Integer> V = new Vector<>();
        for (Integer i = 0; i < half_size; i++){
            V.add(n / (i + 1));
        }
        Integer vmax = V.get(V.size() - 1) - 1;
        for (Integer i = vmax; i > 0; i--){
            V.add(i);
        }
        return V;
    }

    static HashMap<Integer, Long> get_sums(Vector<Integer> keys){
        HashMap<Integer, Long> hmap = new HashMap<>();
        for (int key: keys){
            long big_key = key;
            long value = (big_key * (big_key + 1)) / 2 - 1;
            hmap.put(key, value);
        }
        return hmap;
    }

    static HashMap<Integer, Long> calculate_sums(HashMap<Integer, Long> hmap, Vector<Integer> keys, int square_n){
        for (Integer p = 2; p < square_n + 1; p++){
            long current_sum = hmap.get(p - 1);
            if (hmap.get(p) > current_sum){
                long p_square = p * p;
                for (int key: keys){
                    if (key < p_square){
                        break;
                    }
                    long new_value = hmap.get(key) - (long)p * (hmap.get(key / p) - current_sum);
                    hmap.put(key, new_value);
                }
            }
        }
        return hmap;
    }

    static long primes(int n){
        int square_n = (int) Math.sqrt(n);
        assert square_n * square_n <= n && (square_n + 1) * (square_n + 1) > n;
        int half_size = square_n - 1;
        Vector<Integer> keys = Main.get_keys(n, half_size);
        HashMap<Integer, Long> all_sums = Main.get_sums(keys);
        all_sums = Main.calculate_sums(all_sums, keys, square_n);
        return all_sums.get(n);
    }

    static String format(int dist, String value){
        return value + " ".repeat(dist - value.length());
    }

    public static void main(String[] args){
        Main App = new Main();
        System.out.println("Power | Time (µs) | Resultat");
        System.out.println("========================================");
        primes(100);
        for (int i = 1; i < 9; i++){
            long start = System.nanoTime();
            long result = primes((int) Math.pow(10, i));
            long duration = (System.nanoTime() - start) / 1_000;
            System.out.println(
                Main.format(5, String.valueOf(i)) + " | " +
                Main.format(9, String.valueOf(duration)) + " | " +
                String.valueOf(result)
            );
        }
    }
}
