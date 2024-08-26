#!/usr/bin/python3 -u
from internetarchive import upload
from random import randint
import hashlib
import os
import sys
import requests

def info(text): print(f"\033[94mINFO: \033[00m{text}")
def warning(text): print(f"\033[93mWARNING: \033[00m{text}")
def error(text): print(f"\033[91mERROR: \033[00m{text}")

if os.path.split(os.getcwd())[-1] != "Opensource":
    error("Current directory is not 'Opensource'")
    exit(1)

args = sys.argv[1:]
item = "samsung-sm8650"
metadata_url = f"https://archive.org/metadata/{item}"
info("Getting metadata")
metadata = requests.get(metadata_url).text
file_queue = {}

for file in args:
    if (".zip" or ".tar.gz") not in file:
        warning(f"{file} does not contain '.zip' or '.tar.gz' in the filename")
    info(f"Checking whether {file} has already been uploaded")
    with open(file, 'rb') as file_to_check:
        data = file_to_check.read()
        md5 = hashlib.md5(data).hexdigest()
        if f'"md5":"{md5}"' in metadata:
            warning(f"{file} has already been uploaded")
            continue
        else:
            if file in metadata:
                warning(f"{file} has already been uploaded with a different checksum. Uploading anyway under different file name")
                suffix = randint(0, 9999)
                while f"{file}_fixme_{suffix}" in metadata:
                    suffix = randint(0, 9999)
                else:
                    file_queue.update({f"Opensource/{file}_fixme_{suffix}": file})
            else:
                info(f"Adding {file} to upload queue")
                file_queue.update({f"Opensource/{file}": file})

if file_queue != {}:
    upload(identifier=item, files=file_queue, verify=True, checksum=True, verbose=True, retries=9999, retries_sleep=60)
else:
    info("No need to upload any files")
