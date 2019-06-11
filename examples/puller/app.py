import time
import os
import pathlib
import subprocess
import logging

logger = logging.getLogger("puller")
logging.basicConfig(format='[%(asctime)s] %(message)s', level=logging.INFO)

LOOP_DELAY = int(os.getenv("LOOP_DELAY", 1))
REPOSITORY = os.getenv("REPOSITORY", "https://github.com/palnabarun/k8s-workshop-static")
STORAGE_PATH = os.getenv("STORAGE_PATH", "/shared-data")

def run_command_and_log(command):
    try:
        process = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        log_lines = [l.strip() for l in process.stdout.decode('ascii').split('\n') if l.strip()]
        for line in log_lines:
            logger.info(line)
    except subprocess.CalledProcessError as e:
        logger.info('Failed to run command: {} Error: {}'.format(command, str(e)))

def loop():
    storage_path = pathlib.Path(STORAGE_PATH)
    git_folder = storage_path / '.git'
    if git_folder.exists():
        logger.info('Pulling latest changes...')
        pull_command = "cd {} && git pull".format(STORAGE_PATH)
        run_command_and_log(pull_command)
    else:
        logger.info('Repository does not exist...')
        logger.info('Cloning {} to {}'.format(REPOSITORY, STORAGE_PATH))
        clone_command = "git clone {} {}".format(REPOSITORY, STORAGE_PATH)
        run_command_and_log(clone_command)

if __name__ == "__main__":
    while True:
        loop()
        time.sleep(LOOP_DELAY)
