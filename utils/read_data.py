import yaml
import argparse
import subprocess
from typing import List, Dict

parser = argparse.ArgumentParser()
parser.add_argument(
    "--data", type=str, default="./data.yaml", help="data.yaml file")
parser.add_argument(
    "--target", type=str, default="Database.elm", help="target.elm file")
args = parser.parse_args()


def read_yaml(filename: str) -> List[Dict[str, str]]:
    """Reads `data.yaml` file

    Args:
        filename (str): `data.yaml`

    Returns:
        yaml_data(List[Dict[str, str]]): See `Examples`

    Examples:

        `data.yaml`

            - id: "P000"
            title: "title"
            speaker: "speaker"
            link: "youtube/link"
            - id: "P001"
            title: "title"
            speaker: "speaker"
            link: "youtube/link"


    """
    with open(filename, "r") as f:
        return yaml.load(f.read())


def convert2elm(input_: Dict[str, str]) -> str:
    """Given data dictionary, returns elm data structure

    Args:
        input_ (Dict[str, str]): Result of `read_yaml("data.yaml")`

    Returns:
        str: Elm `type alias`
    """
    element = """
  {{ id = "{id}"
   , title = "{title}"
   , speaker = "{speaker}"
   , link = "{link}"
   }}
"""

    return element.format(**input_)


def to_elm_list(message: str) -> str:
    """Wraps it as a list"""
    return "[{}]".format(message)


def to_elm_module(message: str) -> str:
    """Creates a full module template"""
    return """
module Database exposing (..)


type alias Video =
    {{ id : String
    , title : String
    , speaker : String
    , link : String
    }}

videoList : List Video
videoList = {}
""".format(message)


def write_file(dest: str, data: str) -> None:
    """Saves to `.elm` file"""
    with open(dest, "w") as f:
        f.write(data)


def format_elm_file(target_elm: str) -> None:
    """Subprocess call `elm-format`"""
    cmd = "elm-format {} --yes".format(target_elm)
    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
    output, error = process.communicate()

    if error is not None:
        print(error)
        print("Error!")
    else:
        print(output)
        print("Success!")


if __name__ == '__main__':
    ret = read_yaml(args.data)
    ret = ",".join(map(convert2elm, ret))

    ret = to_elm_list(ret)
    ret = to_elm_module(ret)

    write_file(args.target, ret)
    format_elm_file(args.target)
