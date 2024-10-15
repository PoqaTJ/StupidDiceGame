extends GutTest

class TestGet:
	extends GutTest
	
	var profileScript = load('res://scripts/managers/profile_manager.gd')		
	var profile

	func before_each():
		profile = profileScript.new()
	
	func test_initial_value_0():
		assert_true(profile.points == 0)
	
	func test_get():
		assert_true(profile.get_points() ==  profile.points)
		
	func test_after_set():
		profile.points = 10
		assert_true(profile.get_points() == 10)
		assert_true(profile.get_points() ==  profile.points)


class TestAdd:
	extends GutTest

	var profileScript = load('res://scripts/managers/profile_manager.gd')		
	var profile

	func before_each():
		profile = profileScript.new()
	
	func test_add():
		assert_eq(profile.get_points(), 0)
		profile.add_points(1)
		assert_eq(profile.get_points(), 1)
		profile.add_points(100)
		assert_eq(profile.get_points(), 101)
	
	func test_add_zero():
		profile.add_points(0)
		assert_eq(profile.get_points(), 0)		
		profile.add_points(-1)
		assert_eq(profile.get_points(), 0)
	
	func test_has_points():
		assert_eq(profile.get_points(), 0)
		assert_false(profile.has_points(1))
		profile.add_points(5)
		assert_true(profile.has_points(1))
		assert_true(profile.has_points(5))
		assert_false(profile.has_points(6))

	func test_spend_points():
		profile.add_points(5)
		assert_true(profile.spend_points(1))
		assert_eq(profile.get_points(), 4)
		assert_true(profile.spend_points(2))
		assert_eq(profile.get_points(), 2)
		assert_false(profile.spend_points(3))
		assert_eq(profile.get_points(), 2)
