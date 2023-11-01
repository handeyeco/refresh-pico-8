pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- main
musicp = false

function _update()
  if (btnp(4) or currq == nil) then
    currq = rndq()
    gengarden()
  end
  
  if (btnp(5)) then
    musicp = not musicp
    
    if (musicp) then
      music(0)
    else
      music(-1,300)
    end
  end
  
  uplayer()
end

function _draw()
  rectfill(0,0,127,127,15)
  dgarden()
  printq(currq)
  dplayer()
end
-->8
-- quotes

usedq = {}

function unused(newq)
  for q in all(usedq) do
    if (q == newq) then
      return false
    end
  end
  
  return true
end

function rndq()
  while true do
    newq = rnd(quotes)
    if (unused(newq)) then
      add(usedq,newq)
      break
    end
  end
  
  if (#usedq == #quotes) then
    usedq = {}
  end
  
  return newq
end

quotes = {
  "invent the perfect school lunch for mermaids.",
  "draw an elephant without looking.",  
  "create a new emoji that, if it existed, you would use all the time.",
  "invent a breakfast food that only uses three ingrediants.",
  "find an object that you use in your life every day that won't exist in 20 years.",
  "invent a new rhyming nickname for yourself that reflects your best traits.",
  "write a lesson as if you are the teacher for today. what's the one thing you most want to teach the class?",
  "draw a flag that represents your neighborhood.",
  "draw your name in block letters and decorate with doodles.",
  "write or draw what you would do if you were six inches taller.",
  "if you could create a new holiday, what would it be?",
  "draw a picture of a person using only triangles.",
  "invent a robot that does the chore you hate the most.",
  "write or draw your best guess about how the balloon was invented.",
  "design a sandwich that reflects your personality. weird ingrediants encouraged.",
  "write a three-sentence apology letter from the perspective of the villain in your favorite movie.",
  "design a logo for the world's new biggest show company that includes your last name.",
  "chill. close your eyes and imagine you are going to your favorite friend's house.",
  "create your own personal kudos poster. what are you most proud of?",
  "write a knock knock joke about what you learned in school yesterday.",
  "make a list of all the things you could use a pencil for - except writing.",
  "draw a combination of your two least favorite animals.",
  "write down one thing that you wish more people knew about you.",
  "write or draw the thing you'd most want to do if you were able to time travel.",
  "share your best moment and worst moment of the week so far (if you want to.)",
  "draw a map of a non-existent place and name the capital and 2 other cities.",
  "chill. take 10 deep breaths with your eyes closed.",
  "if you could choose to fly or be invisible, which one would you pick and why?",
  "design a superhero suit that's made only for you.",
  "do you have a place where you feel the most like you? share if you want to.",
  "who is the young person (18 or under) who most inspires you and why?",
  "make a list of as many ice cream flavors as you can think of.",
  "draw or write what you think a tiger dreams of.",
  "grab a pen and draw a combination of a fruit and an animal to make a new creature.",
  "invent a piece of jewelry that helps keep you healthy.",
  "draw and label a trophy for someone else in this class.",
  "write a letter to your least favorite subject as if it were a person.",
  "write a love letter to you favorite snack.",
  "list out three uses for a hat when it's not on your head.",
  "describe this year as a food. what would it taste like and why?",
  "make a list of three things that you and your teacher have in common.",
  "create a kudos board for a friend, teacher, or parent. what do you appreciate most about this person?",
  "make a list of three items that make you happy, two items that discourage you & one thing that you learned today.",
  "if you had a million dollars and you had to give it away, who would you donate it to and why? write it out on a piece of paper.",
  "write out a word that it seems like you can never spell right (and don't worry about spelling it right!)",
  "create your own personal recipe for your own happiness - one cup of this, one dash of that, mix together well...",
  "write a three-sentence complaint letter about something that's been bothering you, then, throw it away.",
  "draw nine triangles by making three straight lines through a capital letter m.",
  "how long do you think it would take you to travel the world by boat?",
  "chill. stand up, reach down to you toes, and then reach far up to the sky. repeat 3 times.",
  "do you think it is easier to be kind to yourself of others? write down why you think so.",
}
-->8
-- render quotes

-- line height (px)
lh=6
-- char width (px)
cw=4
-- number of lines high
lineh = 21
-- pico-8 dim
screen = 128
-- l/r pad
xpad = 3
-- t/b pad
ypad = 5

-- split quote for word wrap
function splitq(q)
  local s = split(q," ")
  local lines = {}
  local curr = ""
  
  for w in all(s) do
    if (#curr > 0) then
      comb = curr.." "..w
    else
      comb = w
    end
    
    if (#comb*cw > screen-(xpad*2)) then
      add(lines,curr)
      curr = w
    else
      curr = comb
    end
  end
  
  if (#curr > 0) then
    add(lines,curr)
  end
  
  return lines
end

-- print an individual line
function printl(lines, i)
  local l = lines[i]
  local xpos = flr(
    (128-(#l*cw))/2
  )
  local yoff = flr(
    (lineh-#lines)/2
  )*lh
  local ypos = ((i-1)*lh)+yoff

  rectfill(
    0,
    ypos-1,
    127,
    ypos+lh-1,
    15
  )
  print(l,xpos,ypos,14)
end

function printq(q)
  local lines=splitq(q)
  for i=1,#lines do
    printl(lines,i)
  end
end
-->8
-- player

x=10
y=10
-- flip sprite
fspr=false
frame=0
moving=false

function uplayer()
  local moved=false
  if (btn(0)) then
    x=max(x-1,0)
    fspr=true
    moved=true
  end
  if (btn(1)) then
    x=min(x+1,127-8)
    fspr=false
    moved=true
  end
  if (btn(2)) then
    y=max(y-1,0)
    moved=true
  end
  if (btn(3)) then
    y=min(y+1,127-8)
    moved=true
  end
  
  if (not moving and moved) then
    frame = 0
  end
  
  if (moved) then
    frame = (frame + 1) % 40
  end
  
  moving=moved
end

function dplayer()
  palt(0,false)
  palt(11,true)

  spr(getspr(),x,y,1,1,fspr)

  palt(0,true)
  palt(11,false)
end

function getspr()
  if (not moving) then
    return 1
  end
  
  if (frame < 10) then
    return 2
  end
  
  if (frame < 20) then
    return 3
  end
  
  if (frame < 30) then
    return 2
  end
  
  if (frame < 40) then
    return 1
  end
end
-->8
-- garden gen
sprdim=8
layout={}

function gengarden()
  layout = {}
  for x=1,16 do
    for y=1,16 do
      local tile = nil
      if (rnd() < 0.2) then
        tile = 48 + rnd(8) 
      end
      
      local xpos = (x-1)*sprdim
      local ypos = (y-1)*sprdim
      local flpt = rnd() < 0.5
      local tdata = {
        xpos=xpos,
        ypos=ypos,
        tile=tile,
        flpt=flpt,
      }
      add(layout, tdata)
    end
  end
end

function dgarden()
  for t in all(layout) do
    if (t.tile ~= nil) then
      spr(
        t.tile,
        t.xpos,
        t.ypos,
        1,1,
        t.flpt
      )
    end
  end
end
__gfx__
00000000bbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700bb33bbbbbbbbbbbbbbb33bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b3636bbbb33636bbb33636bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b3030bbb3330303b3330303b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700b3333bbbb33333bbb33b333b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb33bbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffffffffffffffffffffffffffffafffffffeffffffffffffffffffffff000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffefffffffffefaeafffffeaefffffffffffffffffffff000000000000000000000000000000000000000000000000
ffffffffffffffffffefffffffffffffffffffffffffffff3a3fffff3e3fffffffffefffffffffff000000000000000000000000000000000000000000000000
ffffffffffffffafffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000
fffffffffffffaeafffffffffffeffffffffffffffffffffffffefffffffffffffffffffffffffff000000000000000000000000000000000000000000000000
fefffffffffff3a3fffffefffffffffffffffffffffffffffffeaeffffffffafefffffffffffffff000000000000000000000000000000000000000000000000
eaefffffffffffffffffffffffffffffffffffffffeffffffff3e3fffffffaeaffffffefffffffff000000000000000000000000000000000000000000000000
3e3ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff3a3ffffffffffffffff000000000000000000000000000000000000000000000000
__map__
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202030202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020203020203020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020302020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020203020202030202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203020202020202020202020202020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
c151001a1a7541e7542175425754217541e7541a754197541e7542175425754207042170415754197541c754207441e7541a75425754217541e7541a7540a7040870407704077040a704127041a7041c70420704
__music__
03 00424344

