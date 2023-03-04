import logging
import sys

formatter = logging.Formatter('%(asctime)s:%(levelname)s:%(name)s:%(filename)s:%(lineno)d:%(funcName)s:%(process)s: %(message)s')

def make_logger(name, log_level=logging.INFO, log_file="log.txt", file_mode="a"): #w写 a追加
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
