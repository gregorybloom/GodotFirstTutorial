extends Node

var score = 0

#@onready var score_label = $ScoreLabel

func add_point():
	score += 1
#	score_label.text = "Coins: " + str(score)
	print(score)

# setting to a Singleton => right-click node in nodetree view > Access as Unique Name
# adding global Music node => Project Settings > Autoload
# adding control actions => Project Settings > Input Map



# more stuff?
# expand level?
# effects? animation/particles
# spikes? traps?
# main menu?
# powerups? weapons? damage to enemies?
# switch scenes via an autoload manager?
