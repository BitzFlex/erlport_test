import sys
from datetime import datetime

def get_current_datetime_str():
    # ISO 8601 형식의 문자열로 반환
    return datetime.now().isoformat()

def get_sys_path():
    return sys.path

def greet(name):
    return f"Hello , {name}!"

def add(a, b):
    return a + b

