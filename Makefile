
stress_raw:
	ab -c 200 -n 200 http://127.0.0.1:8000/
stress:
	ab -c 200 -n 200 http://127.0.0.1:8000/ 2>&1 | grep '#/sec'

