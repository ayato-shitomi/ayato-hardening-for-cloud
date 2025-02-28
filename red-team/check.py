import main 
import time

teams = {
	1: "8.209.241.84",
	2: "8.211.137.20"
}

for i in range(16):
	for i in teams:
		if main.chk_alive(i):
			main.add_score(i, 10)
	time.sleep(60)

