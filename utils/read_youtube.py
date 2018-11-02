import datetime
import os
from typing import Dict, Any, Iterable, Optional, Union, Tuple
from itertools import chain

import requests
import re


PR_REGEX = re.compile(r"(PR)[^\d]?(\d+)", flags=re.IGNORECASE)


def parse_id(text: str) -> Optional[str]:
    """Extract PR-xxx
    >>> parse_id("PR000: aksdjfklsdjf")
    'PR-000'

    >>> parse_id("PR-001: Generative adversarial nets")
    'PR-001'

    >>> parse_id("pr-001: Generative adversarial nets")
    'PR-001'
    """
    match = PR_REGEX.search(text)

    if match:
        pr, num = match.groups()
        return "{}-{}".format(pr, num).upper()


class Data:
    def __init__(
        self, id: str, title: str, description: str, pub_date: str, video_id: str
    ) -> None:
        self.id = id
        self.title = title
        self.description = description
        self.pub_date = datetime.datetime.strptime(pub_date, "%Y-%m-%dT%H:%M:%S.%fZ")
        self.video_id = video_id

    def __str__(self) -> str:
        template = """- id: {}
  title: {}
  speaker:
  link: {}
"""

        return template.format(self.id, self.title, self.youtube_link())

    def youtube_link(self) -> str:
        path = "https://www.youtube.com/watch?v={}"
        return path.format(self.video_id)


def parse_element(data: Dict[str, Any]) -> Data:
    snippet = data["snippet"]
    content_details = data["contentDetails"]

    title = snippet["title"]
    description = snippet["description"]
    video_published = snippet["publishedAt"]
    video_id = content_details["videoId"]

    id = parse_id(title)

    return Data(id, title, description, video_published, video_id)


PLAYLIST_ID = "PLWKf9beHi3Tg50UoyTe6rIm20sVQOH1br"
YOUTUBE_API_URL = "https://www.googleapis.com/youtube/v3/playlistItems"


def get_items(
    api_key: str, page_token: Optional[str] = None
) -> Optional[Tuple[Iterable[Data], Optional[str]]]:
    print("Requesting with pageToken: {}".format(page_token))
    payload: Dict[str, Union[str, int]] = {
        "part": "snippet,contentDetails",
        "playlistId": PLAYLIST_ID,
        "key": api_key,
        "maxResults": 50,
    }

    if page_token:
        payload["pageToken"] = page_token

    res = requests.get(YOUTUBE_API_URL, params=payload).json()
    items = res.get("items", [])
    next_page_token = res.get("nextPageToken")

    if items:
        return map(parse_element, items), next_page_token
    return None


def write(items: Iterable[Data]):
    with open("temp_data.yaml", "w") as f:
        for item in items:
            f.write(str(item))


def main():
    API_KEY = os.environ.get("YOUTUBE_API_KEY")

    if not API_KEY:
        raise ValueError("$YOUTUBE_API_KEY is not found")

    done = False
    token = None

    list_of_list_data = []

    while not done:
        result = get_items(API_KEY, page_token=token)

        if not result:
            done = True
        else:
            iterable, token = result

            list_of_list_data.append(iterable)

            if not token:
                done = True
            else:
                print("Next list is found")

    result = chain(*list_of_list_data)
    result = filter(lambda x: x.id, result)
    write(sorted(result, key=lambda x: x.id))


if __name__ == "__main__":
    main()
