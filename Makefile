
stress-light:
	#ab -c 10 -n 10 http://127.0.0.1:8000/
	ab -c 10 -n 10 http://127.0.0.1:8000/ 2>&1 | grep '#/sec'
stress:
	#ab -c 200 -n 200 http://127.0.0.1:8000/
	ab -c 200 -n 200 http://127.0.0.1:8000/ 2>&1 | grep '#/sec'

