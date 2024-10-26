extends GutTest

class TestPoints:
	extends GutTest
	
	var profileScript = load('res://scripts/services/profile_service.gd')		
	var profile

	func before_each():
		profile = profileScript.new()
		profile.init(Profile.new())
	
	func test_initial_value_0():
		assert_true(profile.profile.points == 0)
	
	func test_get():
		assert_true(profile.get_points() ==  profile.profile.points)
		
	func test_after_set():
		profile.profile.points = 10
		assert_true(profile.get_points() == 10)
		assert_true(profile.get_points() ==  profile.profile.points)
	
	func test_add():
		assert_eq(0, profile.get_points())
		profile.add_points(1)
		assert_eq(1, profile.get_points())
		profile.add_points(100)
		assert_eq(101, profile.get_points())
	
	func test_add_zero():
		profile.add_points(0)
		assert_eq(0, profile.get_points())		
		profile.add_points(-1)
		assert_eq(0, profile.get_points())
	
	func test_has_points():
		assert_eq(0, profile.get_points())
		assert_false(profile.has_points(1))
		profile.add_points(5)
		assert_true(profile.has_points(1))
		assert_true(profile.has_points(5))
		assert_false(profile.has_points(6))

	func test_spend_points():
		profile.add_points(5)
		assert_true(profile.spend_points(1))
		assert_eq(4, profile.get_points())
		assert_true(profile.spend_points(2))
		assert_eq(2, profile.get_points())
		assert_false(profile.spend_points(3))
		assert_eq(2, profile.get_points())

	func test_singal():
		assert_has_signal(profile, "on_points_changed")
		watch_signals(profile)
		profile.add_points(1)
		assert_signal_emitted_with_parameters(profile, "on_points_changed", [0, 1])
		profile.add_points(5)
		assert_signal_emitted_with_parameters(profile, "on_points_changed", [1, 6])

class TestDiceSets:
	extends GutTest
	
	var profileScript = load('res://scripts/services/profile_service.gd')		
	var profile

	func before_each():
		profile = profileScript.new()
		profile.init(Profile.new())

	func test_initial_value_0():
		assert_eq(0, profile.profile.dice_sets.size())
	
	func test_add_dice_set():
		profile.add_dice_set()
		assert_eq(1, profile.profile.dice_sets.size())
		profile.add_dice_set()
		assert_eq(2, profile.profile.dice_sets.size())
	
	func test_count():
		profile.profile.dice_sets.append(1)
		assert_eq(1, profile.count_dice_sets())
		profile.profile.dice_sets.append(1)
		assert_eq(2, profile.count_dice_sets())
	
	func test_singal():
		assert_has_signal(profile, "on_dice_set_bought")
		watch_signals(profile)
		profile.add_dice_set()
		assert_signal_emitted_with_parameters(profile, "on_dice_set_bought", [1])
		profile.add_dice_set()
		assert_signal_emitted_with_parameters(profile, "on_dice_set_bought", [2])		
	
