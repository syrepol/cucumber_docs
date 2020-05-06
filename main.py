from gherkin.parser import Parser
from flask import Flask, render_template, send_from_directory
import mistune
import os
import copy

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


@app.route('/')
def index():
    features_dir = os.path.join(os.path.dirname(
        os.path.abspath(__file__)), "features")

    paths = []
    pattern = ""

    for i, (dirname, dirnames, filenames) in enumerate(os.walk(features_dir)):
        # if 1st iter, store pattern to remove
        if i == 0:
            pattern = dirname

        for subdirname in dirnames:
            paths.append(os.path.join(
                dirname, subdirname).replace(pattern, ""))

        for filename in filenames:
            paths.append(os.path.join(dirname, filename).replace(pattern, ""))

    paths = list(map(lambda item: item[1:].split("/"), paths))

    formatted_paths = []

    for path in paths:
        for route in path:
            if ".feature" in route:
                formatted_paths.append(
                    [os.path.join("features", *path), route])

    return render_template('index.html', data=formatted_paths)


@app.route('/get-feature/<path:path>')
def feature(path):
    try:
        with open(os.path.join(BASE_DIR, path), "r") as file:
            data = file.read()
    except FileNotFoundError:
        return "Not found"

    parser = Parser()
    parsed_data = parser.parse(data)
    parsed_data["feature"]["description"] = mistune.markdown(
        parsed_data["feature"]["description"])

    new_feature_children = copy.deepcopy(parsed_data["feature"]["children"])

    for part_i, part in enumerate(parsed_data["feature"]["children"]):
        if ("examples" in part):
            for table_i, table in enumerate(part["examples"]):

                for row_i, row in enumerate(table["tableBody"]):
                    endpoint = ""

                    for cell_i, cell in enumerate(row["cells"]):
                        json_name = ""

                        if cell["value"].startswith("/"):
                            endpoint = cell["value"].replace("/", "")
                        if cell["value"].endswith(".json"):
                            json_name = cell["value"]

                        if endpoint and json_name:
                            try:
                                # remove .feature part of path (last one) and try to get JSON there
                                with open(os.path.join(BASE_DIR, "/".join(path.split("/")[:-1]), json_name), "r") as file:
                                    data = file.read()
                                    new_feature_children[part_i]["examples"][table_i][
                                        "tableBody"][row_i]["cells"][cell_i]["json"] = data

                            except FileNotFoundError:
                                pass

    parsed_data["feature"]["children"] = new_feature_children

    return render_template('feature.html', data=parsed_data)


@app.route('/static/<path:path>')
def send_js(path):
    return send_from_directory('static', path)


@app.route('/static/<path:path>')
def send_css(path):
    return send_from_directory('static', path)
