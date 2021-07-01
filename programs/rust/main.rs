use std::collections::HashMap;
use std::time::Instant;

type Dict = HashMap<u64, u128>;

fn get_keys(n: u64, half_size: u64) -> Vec<u64> {
    // calculation of keys used in the hashmap
    let mut v: Vec<u64> = Vec::new();
    for i in 0..half_size + 1 {
        v.push(n / (i + 1));
    }
    let v_max = v[half_size as usize];
    for i in (1..v_max).rev() {
        v.push(i);
    }
    v
}

fn get_sums(keys: &[u64]) -> Dict {
    //initialisation du hashmap
    let mut hmap = HashMap::new();
    for key in keys.iter() {
        let big_key = *key as u128;
        let value = (big_key * (big_key + 1)) / 2 - 1;
        hmap.insert(*key, value);
    }
    hmap
}

fn calculate_sums(mut hmap: Dict, keys: &[u64], square_n: u64) -> Dict {
    for p in 2..square_n + 1 {
        let current_sum = hmap[&(p - 1)];
        if hmap[&p] > current_sum {
            let p_square = p * p;
            for key in keys.iter() {
                if *key < p_square {
                    break;
                }
                let new_value = hmap[&key] - (p as u128) * (hmap[&(key / p)] - current_sum);
                hmap.insert(*key, new_value);
            }
        }
    }
    hmap
}

fn primes(n: u64) -> u128 {
    let square_n = (n as f64).sqrt() as u64;
    assert!(square_n * square_n <= n && (square_n + 1).pow(2) > n);
    let half_size = square_n - 1;
    let keys = get_keys(n, half_size);
    let p_keys = &keys;
    let mut all_sums = get_sums(p_keys);
    all_sums = calculate_sums(all_sums, p_keys, square_n);
    all_sums[&n]
}

fn format(dist: usize, value: &String) -> String{
    let mut v: String = value.to_string();
    for _ in 1..(dist-(*value).len()){
        v+=&" ";
    }
    return v;
}

fn main() {
    println!("Power | Time (µs) | Resultat");
    println!("========================================");
    for i in 1..9 {
        let now = Instant::now();
        let n: u64 = (10_u64).pow(i);
        // println!("Puissance: {}", i);
        // println!("{}", primes(n));
        let value: u128 = primes(n);
        let new_now = Instant::now();
        println!("{} | {} | {}", format(6, &(i.to_string())), format(10, &(new_now.duration_since(now).as_micros().to_string())), value);
    }
}
