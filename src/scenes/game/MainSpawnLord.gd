extends SpawnLord


var start_shifts = [1, 8, 15, 30]
var spawner_delays = [10, 9, 10, 11]
var spawner_min_delays = [4, 3, 4, 5]


var time = 0.0
var raise_difficulty_time = 40.0


func start():
	for i in range(spawners.size()):
		spawners[i].mode = 1
		spawners[i].time = spawner_delays[i] - start_shifts[i]
		spawners[i].delay = spawner_delays[i]


func do_process(delta: float) -> void:
	time += delta
	if time >= raise_difficulty_time:
		for i in range(spawners.size()):
			if spawner_delays[i] > spawner_min_delays[i]:
				spawner_delays[i] -= 1
				spawners[i].delay = spawner_delays[i]
		time = 0.0

