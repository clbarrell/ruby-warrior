
class Player
  def play_turn(warrior)
    # warrior. walk feel direction_of_stairs
    # Count number of surrounding enemies
    @directions = [:left, :right, :forward, :backward]
    enemy_count(warrior)

    #Feel space I want to walk in
    space = warrior.feel(warrior.direction_of_stairs)

    if any_ticking?(warrior) then
      move_to_sound(warrior)
    elsif @can_move == TRUE then
      # rest_or_move in direction of stiares
      rest_or_move(warrior)
    else
      # attack or defend or release
      attack_or_else(warrior, warrior.listen[0])
    end
  end

  def rest_or_move(warrior)
    # When space is empty and not taking damage
    if warrior.health < 20 then
      warrior.rest!
    elsif @nothing_left == TRUE then
      warrior.walk!(warrior.direction_of_stairs)
    else
      move_to_sound(warrior)
    end
  end

  def attack_or_else(warrior, space)
    # when there is somethign in front
    any_ticking?(warrior) ? @healthvar = 8 : @healthvar = 20
    if @en_count > 1 then
      bind_them(warrior)
    elsif too_many_enemies?(warrior, warrior.direction_of(space)) then
      warrior.detonate!(warrior.direction_of(space))
    elsif @en_count == 1 then
      attack_enemy(warrior)
    elsif @en_count == 0 && warrior.health < @healthvar then
      warrior.rest!
    elsif @captive_count > 0 then
      rescue_them(warrior)
    end
  end

  def enemy_count(warrior)
    # Look in all directions, return hash
    @empty_count = 0
    @en_count = 0
    @captive_count = 0
    @directions.each do |d|
      #look in each direction
      @en_count += 1 if warrior.feel(d).enemy?
      @empty_count += 1 if warrior.feel(d).empty?
      @captive_count += 1 if warrior.feel(d).captive?
    end
    # Move logic
    if @en_count == 0 && @captive_count == 0 then
      @can_move = TRUE
    else
      @can_move = FALSE
    end

    if warrior.listen.size > 0 then
      @nothing_left = FALSE
    else
      @nothing_left = TRUE
    end
  end

  def bind_them(warrior)
    #Start binding in overwhelming times
    if warrior.feel(:left).enemy? then
      warrior.bind!(:left)
    elsif warrior.feel(:right).enemy? then
      warrior.bind!(:right)
    elsif  warrior.feel(:forward).enemy? then
      warrior.bind!(:forward)
    elsif  warrior.feel(:backward).enemy? then
      warrior.bind!(:backward)
    end
  end

  def rescue_them(warrior)
    #Rescue in all directions
    if warrior.feel(:left).captive? then
      warrior.rescue!(:left)
    elsif warrior.feel(:right).captive? then
      warrior.rescue!(:right)
    elsif warrior.feel(:forward).captive? then
      warrior.rescue!(:forward)
    elsif warrior.feel(:backward).captive? then
      warrior.rescue!(:backward)
    end
  end

  def attack_enemy(warrior)
    #Attack single enemy
    @directions.each do |d|
      #bind in the direction if enemy
      warrior.attack!(d) if warrior.feel(d).enemy?
    end
  end

  def move_to_sound(warrior)
    # When you can hear somethign, move to it
    # If it's ticking, go first!
    if any_ticking?(warrior) then
      warrior.listen.each do |space|
        if space.ticking? then
          # Try to go towards ticking
          if warrior.feel(warrior.direction_of(space)).empty? then
            warrior.health > 8 ? warrior.walk!(warrior.direction_of(space)) : warrior.rest!
          else
            attack_or_else(warrior, space)
          end
        end
      end
    else
      warrior.walk!(warrior.direction_of(warrior.listen[0]))
    end
  end

  def any_ticking?(warrior)
    # returns true if any space is ticking
    warrior.listen.any? { |space| space.ticking? }
  end

  def too_many_enemies?(warrior, direction)
    # More than 2 enemies in a row
    @en_line = 0
    warrior.look(direction).each do |d|
      #look in each direction
      @en_line += 1 if d.enemy?
    end
    @en_line > 1 ? TRUE : FALSE
  end

end
