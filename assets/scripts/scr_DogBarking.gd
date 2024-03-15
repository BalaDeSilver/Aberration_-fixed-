extends AudioStreamPlayer3D

func _on_finished():
	var timer
	if get_node_or_null("Timer") == null:
		timer = Timer.new()
		timer.name = "Timer"
		timer.autostart = true
		timer.one_shot = true
		add_child(timer, true)
		timer.timeout.connect(func(): self.play())
	else:
		timer = get_node("Timer")
		#timer.wait_time = QuestManager.rng.randf_range(0.5, 2.0)
		timer.start(QuestManager.rng.randf_range(0.5, 2.0))
