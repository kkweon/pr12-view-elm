from read_data import *


def test_convesrt2elm():

    input_ = {
        'id': 'PR000',
        'title': '논문 읽기 각오를 다집니다.',
        'speaker': 'all',
        'link': 'https://www.youtube.com/watch?v=auKdde7Anr8&list=PLlMkM4tgfjnJhhd4wn5aj8fVTYJwIpWkS'
    }

    expected_output = """
{ id = "PR000"
, title = "논문 읽기 각오를 다집니다."
, speaker = "all"
, link = "https://www.youtube.com/watch?v=auKdde7Anr8&list=PLlMkM4tgfjnJhhd4wn5aj8fVTYJwIpWkS"
}"""

    assert convert2elm(input_) == expected_output
