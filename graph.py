from matplotlib import pyplot as plt
import re
from math import log


def extract_data(filename):
    with open(f"results/{filename}", "r") as file:
        lines = list(file)[2:]
    values = [line.split("|") for line in lines]
    x, y = [], []
    for (exp, time, _) in values:
        x.append(int(re.search(r"\d+", exp)[0]))
        y.append(int(re.search(r"\d+", time)[0]))
    return x, y


languages = (
    "cpp",
    "cython",
    "elixir",
    "python",
    "rust",
)
fig, axs = plt.subplots(1, 2)
for language in languages:
    x, y = extract_data(language + "_results.txt")
    axs[0].plot(x, y, label=language)
    y = [log(e) for e in y]
    axs[1].plot(x, y, label=language)


fig.suptitle("Evolution of time of program's execution between different languages")
axs[0].set(xlabel="Exponent (10eX)", ylabel="Time [µs]")
axs[1].set(xlabel="Exponent (10eX)", ylabel="Time [log(µs)]")
plt.legend()
plt.show()
