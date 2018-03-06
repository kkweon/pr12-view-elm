import datetime
import os
from typing import Dict

import requests


class Data(object):
    def __init__(self,
                 title: str,
                 description: str,
                 pub_date: str,
                 video_id: str) -> None:
        self.title = title
        self.description = description
        self.pub_date = datetime.datetime.strptime(pub_date,
                                                   "%Y-%m-%dT%H:%M:%S.%fZ")
        self.video_id = video_id

    def __str__(self) -> str:
        template = """
- id:
  title: {}
  speaker:
  link: {}"""

        return template.format(self.title, self.youtube_link())

    def youtube_link(self) -> str:
        path = "https://www.youtube.com/watch?v={}"
        return path.format(self.video_id)


def parse_element(data: Dict) -> Data:
    snippet = data["snippet"]
    content_details = data["contentDetails"]

    title = snippet["title"]
    description = snippet["description"]
    video_published = snippet["publishedAt"]
    video_id = content_details["videoId"]

    return Data(title, description, video_published, video_id)


API_KEY = os.environ.get("YOUTUBE_API_KEY")
PLAYLIST_ID = "PLlMkM4tgfjnJhhd4wn5aj8fVTYJwIpWkS"
YOUTUBE_API_URL = "https://www.googleapis.com/youtube/v3/playlistItems"

payload = {
    "part": "snippet,contentDetails",
    "playlistId": PLAYLIST_ID,
    "key": API_KEY,
    "maxResults": 50,
}

res = requests.get(YOUTUBE_API_URL, params=payload).json()
items = res["items"]

results = map(parse_element, items)

with open("temp_data.yaml", "w") as f:
    for item in results:
        f.write(str(item))
