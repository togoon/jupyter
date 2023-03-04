import logging
import sys

formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

def make_logger(name, log_level=logging.INFO, log_file="log.txt", file_mode="w"):
    logger = logging.getLogger(name)
    logger.setLevel(level=log_level)
    handler = logging.FileHandler(log_file, mode=file_mode)
    handler.setLevel(level=log_level)
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(level=log_level)
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger
