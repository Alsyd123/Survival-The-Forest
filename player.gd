extends CharacterBody2D

@export var speed: float = 160.0
@export var health: float = 100.0
@export var max_health: float = 100.0

var attack_cooldown: float = 0.0
var attack_damage: float = 15.0

func _ready():
    update_health_label()

func _physics_process(delta):
    var direction = Vector2.ZERO
    direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    direction = direction.normalized()

    velocity = direction * speed
    move_and_slide()

    if direction != Vector2.ZERO:
        var angle = direction.angle()
        $WeaponPivot.rotation = angle

    attack_cooldown -= delta
    if Input.is_action_just_pressed("ui_accept") and attack_cooldown <= 0:
        attack()

func attack():
    attack_cooldown = 0.5
    var attack_range = 32.0
    var enemies = get_tree().get_nodes_in_group("enemies")

    for enemy in enemies:
        if enemy == null:
            continue
        if global_position.distance_to(enemy.global_position) <= attack_range:
            if enemy.has_method("take_damage"):
                enemy.take_damage(attack_damage)

func take_damage(amount: float):
    health = max(0, health - amount)
    update_health_label()
    if health <= 0:
        print("Player defeated")

func update_health_label():
    if has_node("HealthLabel"):
        $HealthLabel.text = "HP: %d" % health
