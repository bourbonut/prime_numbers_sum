import re
from math import log
from pathlib import Path
import json

path = Path().absolute().parent / "results"

json_data = {}

def extract_data(file):
    with open(file, "r") as file:
        lines = list(file)[2:]
    values = [line.split("|") for line in lines]
    x, y = [], []
    for (exp, time, _) in values:
        x.append(int(re.search(r"\d+", exp)[0]))
        y.append(int(re.search(r"\d+", time)[0]))
    return x, y


for file in path.glob("*.txt"):
    language = file.name.split("_")[0]
    x_data, y_data = extract_data(file)
    log_data = [log(e) for e in y_data]
    json_data[language] = {"x": x_data, "y":y_data, "log":log_data}

json.dump(json_data, open("allresults.json", "w"))
