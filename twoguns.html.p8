pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- title: two guns - two bullets
-- author: shadow

game_state = "menu"
menu_frame = 0
lvl_points= 4

function _init()
 current_level = 1
 max_level = 3
 
 music(01)
 
 if game_state == "menu" 
 then return end
    
 init_player()
    
 init_bot()
    
 bullets = {}
    
 base_spawn_delay=60
 init_ammo()
end

function _update()
menu_frame += 1

	if game_state == "menu" then
 	if btnp(🅾️) then
    game_state = "play"
    _init()
    music(-1)
  end
  return
	elseif game_state == "play" then
  update_bullets()
  update_player(p1)
  update_bot()
  update_ammo_spawn()
  update_ammo_pickup()
  update_blood()
        
  if p1.score >= current_level * lvl_points and current_level < max_level then
   game_state = "level_complete"
  end
    
  if p1.score >= max_level * lvl_points then
   game_state = "game_win"
  end
 elseif game_state == "level_complete" 
 and btnp(🅾️) then
  next_level()
 elseif game_state == "game_win" 
 and btnp(🅾️) then
  game_state = "menu"
  music(01)
 elseif game_state == "game_lose" 
 and btnp(🅾️) then
 	game_state = "menu"
 	music(01)
 end
end


function _draw()
	cls()
	
	game_menu()
	
	if game_state ~= "menu" then
		map()
		spr(3,p1.x,p1.y,2,2,true)
		spr(bot_sprite[current_level],bot.x,bot.y,2,2)
		
		for b in all(bullets) do
	  if b.dir == 1 then
	   spr(9, b.x, b.y, 1, 1)  
	  else
	   spr(11, b.x, b.y, 1, 1)
	  end
	 end
	 
	 draw_blood()
	 
	 if ammo_p1.active then
	  spr(10,ammo_p1.x, ammo_p1.y, 1, 1)  -- オくオまオやオまオみ (オまオはカ█オゆオむ)
	 end
	 if ammo_bot.active then
	  spr(10,ammo_bot.x, ammo_bot.y, 1, 1)  -- オあカ█オぬカ▒オやカ⬅️オみ (オねオゆカ🐱)
	 end
	 
	 print("score: "
	 ..p1.score, 2, 2, 11)
	 print("ammo: "
	 ..p1.bullets, 2, 9, 10)
	 print("bot ammo: "
	 ..bot.bullets, 80, 9, 10)
	 print("level: "
	 ..current_level, 80, 2, 11)
	 
	 level_complete()
	 game_win()
	 game_lose()
	end
end
-->8
--- player --

function init_player()
	p1 = {
  x = 8, y = 64,
  bullets = 2,         
  cooldown = 0,
  score = 0,
  can_shoot = true,
  side = 1,
  speed = 2,
  bullet_speed = 3,
 }
end

function player_move(p)
	if btn(⬆️) then
		if p.y>17 then 
			p.y-=p.speed
		end
	elseif btn(⬇️) then
			if p.y<112 then 
			p.y+=p.speed
			end
	end
end

function player_shoot(p)
	if btn(❎) and p.can_shoot and p.bullets > 0 then
		shoot(p.x+13,p.y+3, p.side, p.bullet_speed)
		p.bullets -=1
		p.can_shoot = false
	end
	
	if not btn(❎) then
  p.can_shoot = true
 end
end

function update_player(p)
	player_move(p)
	player_shoot(p)
end
-->8
-- helpers --
function next_level()
 current_level += 1
 init_bot()
 init_ammo()
 game_state = "play"
 bullets = {}
end

function level_complete()
	if game_state == "level_complete" then
  rectfill(20,40,108,90,0)
  rect(20,40,108,90,7)
  print("level complete!",
   35, 45, 11)
  print("next level: "
  ..(current_level+1), 39, 60, 7)
			if (menu_frame%30) < 20 then
  		print("press z or 🅾️ ", 39, 70, 7)
  		print("to continue", 43, 80, 7)
 		end end
end

function game_win()
	if game_state == "game_win" then
  rectfill(20,40,108,90,0)
  rect(20,40,108,90,7)
  print("you kill all bandits!",
   24, 45, 11)
  print("final score: "
  ..p1.score, 35, 60, 7)
			if (menu_frame%30) < 20 then
  		print("press z or 🅾️ ", 39, 70, 7)
  		print("to restart", 45, 80, 7)
 		end 
 	end
end

function game_lose()
	if game_state == "game_lose" then
  rectfill(20,40,108,90,0)
  rect(20,40,108,90,7)
  print("bandits defeat you!",
   28, 45, 8)
  print("final score: "..p1.score,
   37, 60, 7)
  if (menu_frame%30) < 20 then
  	print("press z or 🅾️ ", 39, 70, 7)
  	print("to restart", 45, 80, 7)
 	end
 end
end

function game_menu()
	if game_state == "menu" then
		rectfill(0,0,127,127,15)
  for i=0,3 do
   line(0,i*4,127,i*4,5)    
   line(0,127-i*4,127,127-i*4,5)
  end
  
  local gun_y = 64 + cos(menu_frame/30)*3
  spr(12, 10, gun_y, 2, 2)       
  spr(12, 104, gun_y, 2, 2, true) 
	
   print("two guns - two bullets",
    23, 20, 0)
        
   print("up: ⬆️ down: ⬇️",
    33, 40, 13)
   print("shoot: x",
    46, 50, 13)
        
   print("pick your ammo,",
    36, 65, 0)
   print("and remember,",
    39, 75, 0)
   print("two guns - two bullets",
    23, 85, 0)

			if (menu_frame%30) < 20 then        
   	print("press z or 🅾️ to start", 
   	21, 100, 3)
   end
  return
 end
end
-->8
-- guns --

function shoot(x, y, dir, speed)
    sfx(00)
    
    add(bullets, {
        x = x, y = y,
        dir = dir,
        speed = speed
    })
end

function update_bullets()
	for b in all(bullets) do
		b.x += b.dir * b.speed
		
		if b.dir == 1 then
			if b.x > bot.x - 3 
			and b.x < bot.x + 3 
			and b.y > bot.y - 4 
			and b.y < bot.y + 14 
			then
				create_blood(bot.x, bot.y)
				p1.score +=1
				del(bullets,b)
			end
		else
			if b.x > p1.x - 3 
			and b.x < p1.x + 3 
			and b.y > p1.y - 4 
			and b.y < p1.y + 14 
			then 
				create_blood(p1.x, p1.y)
				game_state = "game_lose"
   end
		end
		
		if b.x < 0 or b.x > 128 then
			del(bullets,b)
		end
	end
end
-->8
-- bots --

function init_bot()
 bot = {
 	x = 108, y = 64,
  bullets = 2,
 	cooldown = 0,
  side = -1,
  speed = 2,
  ai_mode = "chase",
  ai_timer = 0,
  avoid_bullets = true,
  last_ammo_x=0,
  last_ammo_y=0,
  bullet_speed = 2.5 + current_level * 0.7
 }
 bot_sprite = {7, 33, 35}         
 bot_ammo_delay = {60, 40, 20} 
end

function bot_shoot()
	if bot.bullets > 0 and abs(p1.y - bot.y) < 15 then
  shoot(bot.x, bot.y, -1, bot.bullet_speed)
  bot.bullets -= 1
 end
end

function bot_move()
	bot.ai_timer += 1
 if bot.ai_timer % 60 == 0 then
 	if bot.bullets <1 then
 		bot.ai_mode = "ammo"
 	else
  	bot.ai_mode = rnd({"chase", "ammo", "avoid"})
 	end
 end
 
 if bot.ai_timer % 15 == 0 then
 	bot_shoot()
 end
	
	if bot.ai_mode == "chase" then
  if p1.y > bot.y + 5 then
  	bot.y += bot.speed
  elseif p1.y < bot.y - 5 then
   bot.y -= bot.speed
  end
  
 elseif bot.ai_mode == "ammo" then
 	if ammo_bot.active then
 		bot.last_ammo_x = ammo_bot.x
 		bot.last_ammo_y = ammo_bot.y
 	end
 	
 	if ammo_bot.active and bot.last_ammo_y > bot.y + 5 then
 		bot.y +=bot.speed
 	elseif ammo_bot.active and bot.last_ammo_y < bot.y - 5 then
 		bot.y -=bot.speed
 	end
 elseif bot.ai_mode == "avoid" then
 	bot_avoid_mode()
 end
end

function update_bot()
	bot_move()
end
-->8
-- ammo --

function init_ammo()
 ammo_p1= {
 	x=0,
 	y=0,
 	active=false,
  spawn_timer=0, 
  cur_delay=base_spawn_delay
 }
 ammo_bot={
  x=0,
  y=0,
  active=false,
  spawn_timer=0,
  cur_delay=bot_ammo_delay[current_level] or 60
 }
end

function spawn_ammo(target)
	local ammo = (target == "p1") and ammo_p1 or ammo_bot
	local player = (target == "p1") and p1 or bot

	ammo.x = player.x
	
	repeat
		ammo.y = rnd(128 - 40) + 20
	until abs(ammo.y - player.y) > 20
	
	ammo.active = true
end

function update_ammo_spawn()
	ammo_p1.spawn_timer+=1
	
	if ammo_p1.spawn_timer>=ammo_p1.cur_delay 
	and not ammo_p1.active then
		spawn_ammo("p1")
		ammo_p1.spawn_timer=0
	end
	
	ammo_bot.spawn_timer+=1
	if ammo_bot.spawn_timer>=ammo_bot.cur_delay 
	and not ammo_bot.active then
		spawn_ammo("bot")
		ammo_bot.spawn_timer=0
	end
end

function update_ammo_pickup()
 if ammo_p1.active
 and p1.bullets < 2
 and abs(p1.x - ammo_p1.x) < 10 
 and abs(p1.y - ammo_p1.y) < 10 
 then
  p1.bullets = min(2, p1.bullets + 1)
  ammo_p1.active = false
  ammo_p1.cur_delay = base_spawn_delay  
 elseif not ammo_p1.active 
 and ammo_p1.spawn_timer == 0 then
  ammo_p1.cur_delay = base_spawn_delay + 90  
 end
 
 if ammo_bot.active 
 and bot.bullets < 2
 and abs(bot.x - ammo_bot.x) < 10 
 and abs(bot.y - ammo_bot.y) < 10
 then
  bot.bullets = min(2, bot.bullets + 1)
  ammo_bot.active = false
  ammo_bot.cur_delay = base_spawn_delay
 elseif not ammo_bot.active 
 and ammo_bot.spawn_timer == 0 then
  ammo_bot.cur_delay = base_spawn_delay + 90
 end
end
	
-->8
-- avoid --

function bot_avoid_mode()
	if bot.run_start == nil then
        bot.run_start = true
        bot.avoid_direction = rnd(2) < 1 and -1 or 1  -- オ★カ⬅️オねオまカ█オぬオふオも オやオぬオよカ█オぬオのオめオふオやオまオふ オゆオひオまオや カ█オぬオほ
        bot.avoid_timer = 0
    end

    local bullet_near = false
    for b in all(bullets) do
        if b.dir == 1 and b.x > bot.x - 40 and b.x < bot.x + 15 and abs(b.y - bot.y) < 25 then
            bullet_near = true
            break
        end
    end

    if bullet_near then
        bot.avoid_timer = 60  
        
        local new_y = bot.y + (bot.avoid_direction * bot.speed)
        
        if new_y < 17 then
            bot.avoid_direction = 1
            new_y = bot.y + bot.speed
        elseif new_y > 112 then
            bot.avoid_direction = -1
            new_y = bot.y - bot.speed
        end
        
        bot.y = new_y
    else
        if bot.avoid_timer <= 0 then
            if rnd(100) < 3 then  -- 3% カ☉オぬオやカ▒ カ▒オもオふオやオまカ🐱カ😐 オやオぬオよカ█オぬオのオめオふオやオまオふ
                bot.avoid_direction = -bot.avoid_direction
            end
            
            local new_y = bot.y + (bot.avoid_direction)
            
            if new_y < 17 or new_y > 112 then
                bot.avoid_direction = -bot.avoid_direction
            else
                bot.y = new_y
            end
        end
        
        if bot.avoid_timer > 0 then
            bot.avoid_timer -= 1
        end
    end
end
-->8
-- blood --
function create_blood(x, y)
 for i=1,5 do  
  add(blood_particles, {
   x = x,
   y = y,  
   life = 30,
  })
 end
end

function update_blood()
 for par in all(blood_particles) do
  par.life -= 1
  if par.life <= 0 then
   del(blood_particles, par)
  end
 end
end

function draw_blood()
 for par in all(blood_particles) do
		spr(14, par.x-4, par.y-4,1,1) 
	end
end
__gfx__
00000000000044400000000000000004440000000000222000000000000000022200000000000000655555560000000000000000000000000880000000000000
00000000004444444000000000000444444400000022222220000000000002222222000000000000566666650000000000000000000000000000800000000000
00700700000077700000000000000007770000000000777000000000000000077700000000000000565555650000000000000005000000000080000000000000
00077000000077700000000000000007770000000000777000000000000000077700000000aa400056545465004aa00000555555000000000000008000000000
0007700000044444000000000000004444400000000ddddd00000000000000ddddd0000000000000565a5a650000000005555555000000000000000000000000
007007000066656644000000000006665644400000d2ddd2d000000000000d2ddd2d000000000000565a5a650000000004450500000000000080080000000000
00000000060665666400000055500666566440000d0222d2d000000055500d222d2d000000000000566666650000000004405000000000008000000000000000
0000000060066566644000000075556656644400d0022222d0000000007ddd22222d000000000000655555560000000004400000000000000000000000000000
00000000060666666440000000000766664444000d022222d000000000000022222d000000000000000000000000000000000000000000000000000000000000
0000000000799a997440000000000099a944440000744a447000000000000099a997000000000000000000000000000000000000000000000000000000000000
00000000000555554440000000000055554444000005555500000000000000555550000000000000000000000000000000000000000000000000000000000000
00000000000550554400000000000055055440000005505500000000000000550550000000000000000000000000000000000000000000000000000000000000
00000000000500050000000000000050005000000005000500000000000000500050000000000000000000000000000000000000000000000000000000000000
00000000000500050000000000000050005000000005000500000000000000500050000000000000000000000000000000000000000000000000000000000000
00000000000400040000000000000040004000000004000400000000000000400040000000000000000000000000000000000000000000000000000000000000
00000000004400040000000000000440004000000044000400000000000004400040000000000000000000000000000000000000000000000000000000000000
00000000000000011100000000000000111000007777777777777777000000000000000000000000000000000000000000000000ffffffffffffffff00000000
00000000000001111111000000000011111110007777700088777777000000000000000000000000000000000000000000000000ffffffffffffffff00000000
000000000000000777000000000000007770000077755f5058887707000000000000000000000000000000000000000000000000ffffffffffffffff00000000
000000000000000777000000000000008870000075555ff505888607000000000000000000000000000000000000000000000000fffffff33fffffff00000000
00000000000000444440000000000001888100000005555550558007000000000000000000000000000000000000000000000000ffffff3bb3ffffff00000000
00000000000004881840000050000014884100007778555555555507000000000000000000000000000000000000000000000000fff33f3bb3ffffff00000000
00000000655554881840000055555514444100007788555558855557000000000000000000000000000000000000000000000000fff3bf3bb3f33fff00000000
00000000057455744440000004475547111100008885555558755567000000000000000000000000000000000000000000000000fff3bf3bb3fb3fff00000000
000000000000008818800000005400544444000005500055577050670000000000000000fffffffffffffffffffffffff3fffffffff3bf3bb3fb3fffffffffff
0000000000000099a9900000000000099a99000070088555577575670000000000000000fffffffffffffffffffffffff33fff3ffff3bbbbb3fb3fffffffffff
000000000000005555500000000000055555000077880000447770000000000000000000ffffffffffffffffffffffffff33f3fffff333bbb3fb3ffffffeefff
000000000000005505500000000000055055000088850004999ff4f70000000000000000fff6ffffff65ffffffffffff3ff333f3ffffff3bbbbb3fffffb333ff
0000000000000050005000000000000500050000055500049aaaff770000000000000000ff65fffff6665fffffffffff33ff3f33ffffff3bbb333fffffbb33ff
0000000000000050005000000000000500050000700077000ffff7770000000000000000ffffffff666655fffffffffff3ff3f3fffffff3bb3ffffffffbbb3ff
000000000000004000400000000000040004000077777777744477770000000000000000ffffffffffffffffffffffffff33333fffffff3bb3ffffffffbbb3ff
000000000000044000400000000000440004000077777777777777770000000000000000fffffffffffffffffffffffffff333ffffffff3bb3fffffffffbbfff
77777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffff000f0f0ff00ffffff00f0f0f00fff00fffffffffffff000f0f0ff00fffff000f0f0f0fff0fff000f000ff00ffffffffffffffffff
ffffffffffffffffffffffff0ff0f0f0f0fffff0fff0f0f0f0f0ffffffffffffffff0ff0f0f0f0fffff0f0f0f0f0fff0fff0ffff0ff0ffffffffffffffffffff
ffffffffffffffffffffffff0ff0f0f0f0fffff0fff0f0f0f0f000fffff000ffffff0ff0f0f0f0fffff00ff0f0f0fff0fff00fff0ff000ffffffffffffffffff
ffffffffffffffffffffffff0ff000f0f0fffff0f0f0f0f0f0fff0ffffffffffffff0ff000f0f0fffff0f0f0f0f0fff0fff0ffff0ffff0ffffffffffffffffff
ffffffffffffffffffffffff0ff000f00ffffff000ff00f0f0f00fffffffffffffff0ff000f00ffffff000ff00f000f000f000ff0ff00fffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffdfdfdddffffffffffdddddffffffddfffddfdfdfddfffffffffffdddddfffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffdfdfdfdffdffffffdddfdddfffffdfdfdfdfdfdfdfdffdffffffddfffddffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffdfdfdddfffffffffddfffddfffffdfdfdfdfdfdfdfdfffffffffddfffddffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffdfdfdffffdffffffddfffddfffffdfdfdfdfdddfdfdffdffffffdddfdddffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffddfdffffffffffffdddddffffffdddfddffdddfdfdffffffffffdddddfffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffddfdfdffddffddfdddfffffffffdfdfffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffdfffdfdfdfdfdfdffdfffdffffffdfdfffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffdddfdddfdfdfdfdffdfffffffffffdffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdffdfffdffffffdfdfffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffddffdfdfddffddfffdffffffffffdfdfffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffff5ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5fffffffffffffff
ffffffffffff555555ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff555555ffffffffff
fffffffffff5555555ffffffffffffffffff000f000ff00f0f0fffff0f0ff00f0f0f000fffff000f000f000ff00fffffffffffffffffffff5555555fffffffff
fffffffffff445f5ffffffffffffffffffff0f0ff0ff0fff0f0fffff0f0f0f0f0f0f0f0fffff0f0f000f000f0f0fffffffffffffffffffffff5f544fffffffff
fffffffffff44f5fffffffffffffffffffff000ff0ff0fff00ffffff000f0f0f0f0f00ffffff000f0f0f0f0f0f0ffffffffffffffffffffffff5f44fffffffff
fffffffffff44fffffffffffffffffffffff0ffff0ff0fff0f0fffffff0f0f0f0f0f0f0fffff0f0f0f0f0f0f0f0ff0fffffffffffffffffffffff44fffffffff
ffffffffffffffffffffffffffffffffffff0fff000ff00f0f0fffff000f00fff00f0f0fffff0f0f0f0f0f0f00ff0fffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff000f00ff00ffffff000f000f000f000f000f000f000f000ffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff0f0f0f0f0f0fffff0f0f0fff000f0fff000f0f0f0fff0f0ffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff000f0f0f0f0fffff00ff00ff0f0f00ff0f0f00ff00ff00fffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff0f0f0f0f0f0fffff0f0f0fff0f0f0fff0f0f0f0f0fff0f0ff0fffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff0f0f0f0f000fffff0f0f000f0f0f000f0f0f000f000f0f0f0ffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffff000f0f0ff00ffffff00f0f0f00fff00fffffffffffff000f0f0ff00fffff000f0f0f0fff0fff000f000ff00ffffffffffffffffff
ffffffffffffffffffffffff0ff0f0f0f0fffff0fff0f0f0f0f0ffffffffffffffff0ff0f0f0f0fffff0f0f0f0f0fff0fff0ffff0ff0ffffffffffffffffffff
ffffffffffffffffffffffff0ff0f0f0f0fffff0fff0f0f0f0f000fffff000ffffff0ff0f0f0f0fffff00ff0f0f0fff0fff00fff0ff000ffffffffffffffffff
ffffffffffffffffffffffff0ff000f0f0fffff0f0f0f0f0f0fff0ffffffffffffff0ff000f0f0fffff0f0f0f0f0fff0fff0ffff0ffff0ffffffffffffffffff
ffffffffffffffffffffffff0ff000f00ffffff000ff00f0f0f00fffffffffffffff0ff000f00ffffff000ff00f000f000f000ff0ff00fffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffff333f333f333ff33ff33fffff333ffffff33f333ffffff33333ffffff333ff33ffffff33f333f333f333f333ffffffffffffffffffff
fffffffffffffffffffff3f3f3f3f3fff3fff3fffffffff3fffff3f3f3f3fffff33fff33ffffff3ff3f3fffff3ffff3ff3f3f3f3ff3fffffffffffffffffffff
fffffffffffffffffffff333f33ff33ff333f333ffffff3ffffff3f3f33ffffff33f3f33ffffff3ff3f3fffff333ff3ff333f33fff3fffffffffffffffffffff
fffffffffffffffffffff3fff3f3f3fffff3fff3fffff3fffffff3f3f3f3fffff33fff33ffffff3ff3f3fffffff3ff3ff3f3f3f3ff3fffffffffffffffffffff
fffffffffffffffffffff3fff3f3f333f33ff33ffffff333fffff33ff3f3ffffff33333fffffff3ff33ffffff33fff3ff3f3f3f3ff3fffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

__map__
404141414141414141414141414141423b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
505151515151515151515151515151523b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b3b3b3c3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3c3b393b3b3b3b3b3b3a3b3b3b3c3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3f3b3c3b3b3b3b3b3b3f3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3a3b3b3b3b3b3b3b3b3c3b3b3b3a3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3a3b3b3b3b3b3b3b3b3b3c3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3c3b3b3b3b3b3b3a3b3b3b393b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
393b3b3b3b3f3b3b3b3b3b3b3b3b2d2e3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3c3b3b3b393b3b3b3f3b3b3d3e3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3a3b3b3a3b3b3b3b3c3b3b3b3b393b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3c3b3b3b3c3b3b3b3b3b3a3b3c3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b3b3b3f3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b393b3f3b3b3b3b3b3b3b3b3f3b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3a3b3b3b393b3b3b3b3b3a3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3c3b3b3b3b3b3b3b3b3c3b3b2d2e3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b393b3b3b3b393b3b3c3b3b3b3b3d3e3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00040000090300b030076300e000086000a6000b6000a5000e50015100151001410013100111000f1000e1000d1000c1000c1000b1000a1000910008100071000000000000000000000000000000000000000000
010f021228512000002651228512000001c5121d512000001f51200000235121c512000001d5121f51221512235121c5120000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 00414344
03 01424344

