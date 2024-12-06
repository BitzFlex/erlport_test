import sys
from datetime import datetime

def get_current_datetime_str():
    # ISO 8601 형식의 문자열로 반환
    return datetime.now().isoformat()

def get_sys_path():
    return sys.path

def greet(name):
    return str(f"Hello, {name.decode('utf-8')}!")

def add(a, b):
    return a + b

def large_list():
    string_list = []
    for i in range(1, 10000):
        string_list.append(f"String-{i}")
    return string_list
