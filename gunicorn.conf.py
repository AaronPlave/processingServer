import multiprocessing

daemon = True
accesslog = "logs/access.log"
errorlog = "logs/error.log"
workers = multiprocessing.cpu_count() * 2 + 1
backlog = 100
timeout = 200
port=8000