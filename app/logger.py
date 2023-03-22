import logging
import os
from datetime import datetime

def setup_logger():
    logs_dir = 'logs'
    os.makedirs(logs_dir, exist_ok=True)

    log_file = os.path.join(logs_dir, f"{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.log")

    logging.basicConfig(
        filename=log_file,
        format='%(asctime)s [%(levelname)s] %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        level=logging.INFO
    )

    return logging.getLogger('polygon-client')
