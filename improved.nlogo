extensions [matrix]

globals [
  aircrafts
  ships
  p-hit
  p-dmg
  idx_tbd_devs
  idx_sbd_daunts
  idx_tbf_aves
  idx_b26s
  idx_b17s
  idx_f4fs
  idx_f2as
  idx_yorktowns
  idx_acruisers
  idx_adestroyers
  idx_d3as
  idx_b5ns
  idx_d4ys
  idx_zeros
  idx_amagis
  idx_tosas
  idx_hiryus
  idx_soryus
  idx_kongos
  idx_tones
  idx_nagaras
  idx_kageros
  tick-rate
  teleport_time
  wave_launch
]

turtles-own [
  ; Personal Parameters
  v
  hp
  max_hp
  flee_thresh
  p_escape
  idx
  ; Radii
  r_detect
  r_engage
  r_patrol
  r_radar
  ; States
  ship
  offensive
  class
  engaged
  flee
  teleport
  american
  ; Defence
  breached
  defence_state
  group
  ; Ships
  spawn_rate
  aa_rate
  max_cap
  cap_commit
  evade
  ; Teleport
  curr_tick
]

; Create template
; create-breed X [
;  setxy 20 10
;  set color green
;  set size 3
;  set heading 0
;  ; Personal Parameters
;  set v
;  set hp
;  set max_hp
;  set flee_thresh
;  set p_escape
;  set idx
;  ; Radii
;  set r_detect
;  set r_engage
;  ; States
;  set ship
;  set offensive
;  set class
;  set engaged
;  set flee
;  set teleport
;  set american
;  ; Defence
;  set breached
;  set defence_state
;  set group
;]

directed-link-breed [chases chase]
undirected-link-breed[battles battle]

; American ORBAT
; Bombers
breed[tbd_devs tbd_dev]
breed[sbd_daunts sbd_daunt]
breed[tbf_aves tbf_ave]
breed[b26s b26]
breed[b17s b17]
; Fighters
breed[f4fs f4f]
breed[f2as f2a]
; Carriers
breed[yorktowns yorktown]
; Screen
breed[acruisers acruiser]
breed[adestroyers adestroyer]

; Japanese ORBAT
; Bombers
breed[d3as d3a]
breed[b5ns b5n]
breed[d4ys d4y]
; Fighters
breed[zeros zero]
; Carriers
breed[amagis amagi]
breed[tosas tosa]
breed[hiryus hiryu]
breed[soryus soryu]
; Screen
breed[kongos konge]
breed[tones tone]
breed[nagaras natara]
breed[kageros kagero]

breed[breaches breach]


to setup
  clear-all
  set-shape
  setup-patches
  setup-sprites
  setup-idx
  init-jap-fleet
  init-amer-fleet
  setup-p
  reset-ticks
end

to set-shape
  set-default-shape tbd_devs "airplane 2"
  set-default-shape sbd_daunts "airplane 2"
  set-default-shape tbf_aves "airplane 2"
  set-default-shape b26s "airplane 2"
  set-default-shape b17s "airplane 2"
  set-default-shape f4fs "airplane 2"
  set-default-shape f2as "airplane 2"
  set-default-shape yorktowns "boat top"
  set-default-shape acruisers "boat top"
  set-default-shape adestroyers "boat top"
  set-default-shape d3as "airplane 2"
  set-default-shape b5ns "airplane 2"
  set-default-shape d4ys "airplane 2"
  set-default-shape zeros "airplane 2"
  set-default-shape amagis "boat top"
  set-default-shape tosas "boat top"
  set-default-shape hiryus "boat top"
  set-default-shape soryus "boat top"
  set-default-shape kongos "boat top"
  set-default-shape tones "boat top"
  set-default-shape nagaras "boat top"
  set-default-shape kageros "boat top"
end

to setup-idx
  set wave_launch 0
  set tick-rate 30
  set teleport_time 200
  set idx_tbd_devs 0
  set idx_sbd_daunts 1
  set idx_tbf_aves 2
  set idx_b26s 3
  set idx_b17s 4
  set idx_f4fs 5
  set idx_f2as 6
  set idx_yorktowns 7
  set idx_acruisers 8
  set idx_adestroyers 9
  set idx_d3as 10
  set idx_b5ns 11
  set idx_d4ys 12
  set idx_zeros 13
  set idx_amagis 14
  set idx_tosas 15
  set idx_hiryus 16
  set idx_soryus 17
  set idx_kongos 18
  set idx_tones 19
  set idx_nagaras 20
  set idx_kageros 21
end

to setup-p
  set p-hit matrix:from-row-list [
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 30 1 0 1 1 1 1 1 1];0 tbd_devs
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 30 20 0 20 20 0 0 0 0];1 sbd_daunts
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 30 1 0 1 1 1 1 1 1];2 tbf_aves
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 60 1 0 1 1 0 0 0 0];3 b26s
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 95 1 0 1 1 0 0 0 0];4 b17s
                              [0 0 0 0 0 0 0 0 0 0 50 60 0 10 0 0 0 0 0 0 0 0];5 f4fs
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];6 f2as
                              [0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0];7 yorktowns
                              [0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0];8 acruisers
                              [0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0];9 adestroyers
                              [0 0 0 0 0 30 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];10 d3as
                              [0 0 0 0 0 30 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];11 b5ns
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];12 d4ys
                              [80 50 60 90 95 30 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];13 zeros
                              [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];14 amagis
                              [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];15 tosas
                              [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];16 hiryus
                              [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];17 soryus
                              [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];18 kongos
                              [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];19 tones
                              [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];20 nagaras
                              [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];21 kageros
                                                                                       ]
  set p-dmg matrix:from-row-list [
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 20 100 0 100 100 0 0 0 0];0 tbd_devs
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 20 100 0 100 100 0 0 0 0];1 sbd_daunts
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 20 100 0 100 100 0 0 0 0];2 tbf_aves
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 40 50 0 50 50 0 0 0 0];3 b26s
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 100 50 0 50 50 0 0 0 0];4 b17s
                              [0 0 0 0 0 0 0 0 0 0 80 80 0 100 0 0 0 0 0 0 0 0];5 f4fs
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];6 f2as
                              [0 0 0 0 0 0 0 0 0 0 60 60 60 60 0 0 0 0 0 0 0 0];7 yorktowns
                              [0 0 0 0 0 0 0 0 0 0 60 60 60 60 0 0 0 0 0 0 0 0];8 acruisers
                              [0 0 0 0 0 0 0 0 0 0 60 60 60 60 0 0 0 0 0 0 0 0];9 adestroyers
                              [0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];10 d3as
                              [0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];11 b5ns
                              [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];12 d4ys
                              [20 20 20 3 1 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];13 zeros
                              [20 20 20 20 20 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];14 amagis
                              [20 20 20 20 20 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];15 tosas
                              [20 20 20 20 20 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];16 hiryus
                              [20 20 20 20 20 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];17 soryus
                              [20 20 20 20 20 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];18 kongos
                              [20 20 20 20 20 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];19 tones
                              [20 20 20 20 20 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];20 nagaras
                              [20 20 20 20 20 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];21 kageros
                                                                                       ]

  ask turtles with [american = true] [
    if class = 0 [
      set spawn_rate 30
    ]
    set r_radar 30
    set r_patrol 40
    set cap_commit 50
    set max_cap 20
    set evade false
  ]
  ask turtles with [american = false] [
    if class = 0 [
      set spawn_rate 30
    ]
    set r_radar 30
    set r_patrol 40
    set cap_commit 50
    set max_cap 20
    set evade false
  ]
  ask turtles [
    set curr_tick -1
  ]
end

to setup-patches
  ; import-drawing "background.png"
  ask patches [set pcolor blue]
  ask patches with [pxcor < -50 and pxcor > -90]
  [
    set pcolor white;
  ]
end

to setup-sprites
  set-default-shape sbd_daunts "airplane 2"
  set-default-shape zeros "airplane 2"
  set-default-shape f4fs "airplane 2"
  set-default-shape yorktowns "boat top"
  set-default-shape amagis "boat top"
  set-default-shape tosas "boat top"
  set-default-shape soryus "boat top"
  set-default-shape hiryus "boat top"
  set-default-shape tones "boat top"
  set-default-shape nagaras "boat top"
  set-default-shape kageros "boat top"
  set-default-shape kongos "boat top"
end

to init-jap-fleet
  print "init"
  ; CAP
  create-zeros 11 [
    setxy 0 10
    set color green
    set size 3
    set heading 0
    ; Personal Parameters
    set v 1
    set hp 10
    set max_hp 10
    set flee_thresh 5
    set p_escape 50
    set idx idx_zeros
    ; Radii
    set r_detect 15
    set r_engage 5
    ; States
    set ship false
    set offensive false
    set class 1
    set engaged false
    set flee false
    set teleport false
    set american false
    ; Defence
    set defence_state "Patrol"
  ]
  ; Carriers
  create-amagis 1 [
    setxy 0 -10
    set color red
    set size 8
    set heading 270
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_amagis
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 0
    set engaged false
    set flee false
    set teleport false
    set american false
  ]
  create-tosas 1 [
    setxy 20 -10
    set color red
    set size 8
    set heading 270
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_tosas
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 0
    set engaged false
    set flee false
    set teleport false
    set american false
  ]
  create-soryus 1 [
    set color red
    set size 8
    set heading 270
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_soryus
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 0
    set engaged false
    set flee false
    set teleport false
    set american false
  ]
  create-hiryus 1 [
    setxy 20 10
    set color red
    set size 8
    set heading 270
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_hiryus
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 0
    set engaged false
    set flee false
    set teleport false
    set american false
  ]
  ; Screen
  create-kongos 1 [
    setxy -10 -30
    set color grey
    set size 5
    set heading 270
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_kongos
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 1
    set engaged false
    set flee false
    set teleport false
    set american false
  ]
  create-tones 1 [
    setxy -10 30
    set color grey
    set size 5
    set heading 270
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_tones
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 1
    set engaged false
    set flee false
    set teleport false
    set american false
  ]
  create-nagaras 1 [
    setxy -23 -25
    set color grey
    set size 5
    set heading 270
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_nagaras
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 1
    set engaged false
    set flee false
    set teleport false
    set american false
  ]
  create-kageros 1 [
    setxy -23 25
    set color grey
    set size 5
    set heading 270
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_kageros
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 1
    set engaged false
    set flee false
    set teleport false
    set american false
  ]
end

to init-amer-fleet
  ; Carriers
  create-yorktowns 1 [
    setxy -150 10
    set color yellow
    set size 8
    set heading 90
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_yorktowns
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 0
    set engaged false
    set flee false
    set teleport false
    set american true
  ]
  create-yorktowns 1 [
    setxy -150 0
    set color yellow
    set size 8
    set heading 90
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_yorktowns
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 0
    set engaged false
    set flee false
    set teleport false
    set american true
  ]
  create-yorktowns 1 [
    setxy -150 -10
    set color yellow
    set size 8
    set heading 90
    ; Personal Parameters
    set v 0
    set hp 100
    set max_hp 100
    set flee_thresh 0
    set p_escape 0
    set idx idx_yorktowns
    ; Radii
    set r_detect 120
    set r_engage 30
    ; States
    set ship true
    set offensive false
    set class 0
    set engaged false
    set flee false
    set teleport false
    set american true
  ]
end
to midway-wave
  create-f4fs 6 [
    setxy -47 -47
    set color white
    set size 3
    set v 1
    set hp 30
    set r_detect 15
    set r_engage 5
    set flee_thresh 5
    set p_escape 50
    set engaged false
    set flee false
    set offensive true
    set ship false
    set class 1
    set breached false
    set group 0
    set idx idx_f4fs
    ]
  create-sbd_daunts 3 [
    setxy -45 -45
    set color yellow
    set size 3
    set v 1
    set hp 30
    set r_detect 20
    set r_engage 5
    set flee_thresh 5
    set p_escape 50
    set engaged false
    set flee false
    set offensive true
    set ship false
    set class 0
    set breached false
    set group 0
    set idx idx_sbd_daunts
    ]
  create-sbd_daunts 3 [
    setxy 45 45
    set color yellow
    set size 3
    set v 1
    set hp 30
    set r_detect 20
    set r_engage 5
    set flee_thresh 5
    set p_escape 50
    set engaged false
    set flee false
    set offensive true
    set ship false
    set class 0
    set breached false
    set group 0
    set idx idx_sbd_daunts
    ]
end

to go
  set aircrafts turtles with [ship = false]
  set ships turtles with [ship = true]
  disengage
  engage
  dogfight
  move
  teleportation
  spawn
  antiair
  add_midway_waves
  add_attack_waves
  ask ships [
    set label round hp
  ]
  ask aircrafts [
    set label ""
  ]
  ask turtles [
    if hp <= 0 [
      die
    ]
    if not any? battle-neighbors [
      set engaged false
    ]
    if ycor < -47 [
      die
    ]
  ]
  tick
end

to disengage
  ;print "disengage"
  let offense aircrafts with [offensive = true]
  ask offense with [engaged = true] [
  if hp < flee_thresh [
    set engaged false
    set flee true
    ]
  ]
  ask offense with [flee = true] [
    ifelse random 100 < p_escape [
      set heading 180
      jump v
    ]
    [
      die
    ]
  ]
end

to engage
  ;print "engage"
  ask ships with [class = 0] [
    let one-american american
    ifelse count aircrafts with [american != one-american] in-radius r_radar > 0 [
      set evade true
      set color grey
    ][
      set evade false
      ifelse one-american = false [
        set color red
      ] [
        set color yellow
      ]
    ]
  ]

  let offense aircrafts with [offensive = true and engaged = false and flee = false]

  ask offense [
    let one-american american
    let defence_air aircrafts with [offensive = false and american = not one-american]
    let defence_ship ships with [offensive = false and american = not one-american and class = 0]
    ;print "defence ship"
    ;print count defence_ship
    (ifelse count defence_air in-radius r_engage > 0 [
      let target one-of defence_air in-radius r_engage
      if class = 1 [
        set engaged true
        ask target [
          set engaged true
        ]
      ]
      create-battle-with target
    ]
    count defence_ship in-radius r_engage > 0 [
      print"bombs"
      ;print "attacking ship"
      let target min-one-of defence_ship [distance myself]
      if random 100 < (matrix:get p-hit idx [idx] of target) [
        ;print "bombing"
        let dmg random (matrix:get p-dmg idx [idx] of target) * [max_hp] of target / 100
        ask target [
          set hp hp - dmg
        ]
      ]
      if class = 0 [
        set flee true
      ]
    ])
  ]
  ;print "engaged"
end

to move
  ;print "move"
  let offense aircrafts with [offensive = true]
  let defence aircrafts with [offensive = false]
  ask offense with [flee = false and engaged = false and teleport = false] [
   ; print "check disengaged"
    let one-american american
    set defence aircrafts with [offensive = false and american != one-american]
    if class = 0 [
      let carriers ships with [class = 0 and american != one-american]
      face min-one-of carriers [distance myself]
      jump v
    ]
    if class = 1 [
      if count my-out-chases = 0 [
        let detected defence in-radius r_detect
        ;print(detected)
        let attacked detected with [count in-chase-neighbors < 2]
        let help attacked with [count out-chase-neighbors > 0]
        let selected detected
        ifelse any? help[
          set selected help
        ]
        [
          if any? attacked [
            set selected attacked
          ]
        ]
        if any? selected [
          create-chase-to min-one-of selected [distance myself]
        ]
      ]
      ifelse any? out-chase-neighbors [
        face one-of out-chase-neighbors
      ]
      [
        let escorting offense with [class = 0 and american = one-american]
        if count escorting > 0 [
          face min-one-of escorting [distance myself]
        ]
      ]
      jump v
    ]
  ]

  ; Defence
  set defence aircrafts with [offensive = false]
  ask defence [
    let patrol_x 0
    let patrol_y 0
    let one_american american
    if one_american = true [
      set patrol_x -150
      set patrol_y 0
    ]
    set r_radar [r_radar] of min-one-of ships with [american = american and class = 0] [distance myself]
    set r_patrol [r_patrol] of min-one-of ships with [american = american and class = 0] [distance myself]
    set cap_commit [cap_commit] of min-one-of ships with [american = american and class = 0] [distance myself]
    let new_offense offense
    let curr_radar r_radar
    ask offense [
      set new_offense offense with [(distancexy patrol_x patrol_y) < curr_radar and breached = false and american != one_american]
    ]
    if count new_offense > 0 [
      ; Take only the first one, one breach processed per tick
      let rep one-of new_offense

      ;Once a breach is detected, we decide the entire group associated with the breach
      ; is also seen. This simplifies the logic for now
      let new_group [group] of rep

      ;Mark whole group as breached
      ask offense with [group = new_group] [
        set breached true
      ]
      ;Pick n patroling craft to address the breech
      let patroling defence with [defence_state = "Patrol" and american = one_american]
      let num_patroling count patroling
      let num_sending round(num_patroling * cap_commit / 100)
      ask min-n-of num_sending patroling [distance rep] [
        face rep
        set defence_state "Investigate"
        ;print "New Investigators"
      ]
    ]

    if defence_state = "Patrol" and engaged = false and flee = false [
      ; If outside patrol radius
      ifelse (distancexy patrol_x patrol_y) > r_patrol [
        ;head towards radius
        face patch patrol_x patrol_y
      ]
      [
        ; if inside patrol radius ( hard coded tolerance )
        ifelse (distancexy patrol_x patrol_y) < r_patrol - 5 [
          ; Head towards radius
          ifelse xcor = patrol_x and ycor = patrol_y [
            set heading 45
          ][
            set heading atan (xcor - patrol_x) (ycor - patrol_y)
          ]
        ]
        [
          ; head in a circle using quickmaths
          set heading atan (xcor - patrol_x) (ycor - patrol_y) + 90
        ]
      ]
      jump v
    ]

    ; Investigate defence_state
    ; Take the heading you have been set on, and
    ; Proceed until no ships are left in ship radius, or
    ; You enter detection range with a craft

    if defence_state = "Investigate" and engaged = false and flee = false [
      let one-american american
      set offense aircrafts with [offensive = true and american != one-american]
      if count offense in-radius r_detect > 0 [
        set defence_state "Intercept"
      ]
      if count offense with [(distancexy patrol_x patrol_y) < curr_radar] = 0[
        set defence_state "Patrol"
      ]
      jump v
    ]

    ;This intercept defence_state is a direct copy of the defence_state used for offensive planes, with the
    ; Added terminating condiion

    if defence_state = "Intercept" and engaged = false and flee = false [
      let one-american american
      set offense aircrafts with [offensive = true and american != one-american]
      if count my-out-chases = 0 [
        let detected offense in-radius r_detect
        ;print(detected)
        let bombers detected with [class = 0]
        ifelse any? bombers[
          create-chase-to min-one-of bombers [distance myself]
        ][
          let attacked detected with [count in-chase-neighbors < 2]
          let help attacked with [count out-chase-neighbors > 0]
          let selected detected
          ifelse any? help[
            set selected help
          ]
          [
            if any? attacked [
              set selected attacked
            ]
          ]
          if any? selected[
            create-chase-to min-one-of selected [distance myself]
          ]
        ]
      ]
      ifelse any? out-chase-neighbors [
        face one-of out-chase-neighbors
      ]
      [
        set defence_state "Investigate"
      ]
      jump v
    ]
  ]
  ;print "moved"
end

to spawn
  foreach sort ships with [spawn_rate > 0] [one-ship ->
    let x 0
    let y 0
    let one-cap 0
    let one-spawn 0
    let one-american false
    ask one-ship [
      set one-cap max_cap
      set max_cap max_cap - 1
      set x xcor
      set y ycor
      set one-spawn spawn_rate
      set one-american american
    ]
    if ticks mod one-spawn = 0 and one-cap > 0 [
      ifelse one-american = false [
        create-zeros 1 [
          setxy x y
          set color green
          set size 3
          set heading 0
          ; Personal Parameters
          set v 1
          set hp 10
          set max_hp 10
          set flee_thresh 5
          set p_escape 50
          set idx idx_zeros
          ; Radii
          set r_detect 15
          set r_engage 5
          ; States
          set ship false
          set offensive false
          set class 1
          set engaged false
          set flee false
          set teleport false
          set american false
          ; Defence
          set defence_state "Patrol"
        ]
      ]
      [
        create-f4fs 1 [
          setxy x y
          set color yellow
          set size 3
          set heading 0
          ; Personal Parameters
          set v 1
          set hp 10
          set max_hp 10
          set flee_thresh 5
          set p_escape 50
          set idx idx_zeros
          ; Radii
          set r_detect 15
          set r_engage 5
          ; States
          set ship false
          set offensive false
          set class 1
          set engaged false
          set flee false
          set teleport false
          set american true
          ; Defence
          set defence_state "Patrol"
        ]
      ]
    ]
  ]

end

to dogfight
  ;print "dogfight"
  ; this method simulated the dogfight phase between one or more aircraft
  ask battles [

    let attacker one-of both-ends
    let defender one-of both-ends
    ask attacker [
      set defender other-end
    ]
    ask defender [
      ; if target evasion unsuccessful and hit successful, dmg dealt
      if random 100 < matrix:get p-hit [idx] of attacker idx [
        set hp hp - random (matrix:get p-dmg [idx] of attacker idx) * max_hp / 100
      ]
    ]
  ]
end

to teleportation
  ask turtles [
    if [pcolor] of patch-here = white [
      if curr_tick = -1 [
        set curr_tick ticks
        set teleport true
      ]
      if ticks - curr_tick > teleport_time [
        ifelse american = true [
          set heading 90
        ][
          set heading 270
        ]
        jump 50
        set curr_tick 0
        set teleport false
      ]
    ]
  ]
end

to antiair
  ask ships [
    let one-american american
    let offense aircrafts with [offensive = true and american != one-american]
    foreach sort offense in-radius r_engage [target ->
      if random 100 < matrix:get p-hit idx [idx] of target [
        let dmg random (matrix:get p-dmg idx [idx] of target) * max_hp / 100
        ask target [
          set hp hp - dmg
        ]
      ]
    ]
  ]
end

to add_attack_waves
  let wave_init 30 + toa; Time of Attack Slider
  if wave_launch = 0 [
    set wave_launch wave_init
  ]
  ask ships with [american = false and class = 0] [
    if ticks = wave_launch [
      ifelse evade = false [
        hatch-b5ns 10 [
          set color black
          set size 3
          ; Personal Parameters
          set v 1
          set hp 30
          set max_hp 30
          set flee_thresh 5
          set p_escape 50
          set idx idx_b5ns
          ; Radii
          set r_detect 20
          set r_engage 5
          ; States
          set ship false
          set offensive true
          set class 0
          set engaged false
          set flee false
          set teleport false
          set american false
          ; Defence
          set breached false
          set group -1
          ; Teleport
          set curr_tick -1
        ]
        hatch-zeros 5 [
          set color green
          set size 3
          ; Personal Parameters
          set v 1
          set hp 30
          set max_hp 30
          set flee_thresh 5
          set p_escape 50
          set idx idx_b5ns
          ; Radii
          set r_detect 20
          set r_engage 5
          ; States
          set ship false
          set offensive true
          set class 1
          set engaged false
          set flee false
          set teleport false
          set american false
          ; Defence
          set breached false
          set group -1
          ; Teleport
          set curr_tick -1
        ]
      ][
        set wave_launch wave_launch + 200
      ]
    ]
  ]
  set aircrafts turtles with [ship = false]
end

to add_midway_waves
  let wave_2 30 ; 8:22 am right now randomly selected time
  let wave_3 100 ; 9:22 am
  let wave_4 150 ; 9:22 am
  if ticks = wave_2 [
    create-sbd_daunts 3 [
      setxy -45 -45
      set color yellow
      set size 3
      ; Personal Parameters
      set v 1
      set hp 30
      set max_hp 30
      set flee_thresh 5
      set p_escape 50
      set idx idx_sbd_daunts
      ; Radii
      set r_detect 20
      set r_engage 5
      ; States
      set ship false
      set offensive true
      set class 0
      set engaged false
      set flee false
      set teleport false
      set american true
      ; Defence
      set breached false
      set group 3
    ]
    set aircrafts turtles with [ship = false]
  ]
  if ticks = wave_3[

    let indexer ( range 0 7 )
    let bombIndexer ( range 0 10 )

    foreach bombIndexer [ ind ->
      let ycoord (-24 + 1 * ind)
      let xcoord (35 + 2 * ind)
      create-sbd_daunts 1 [
        setxy xcoord ycoord
        set color yellow
        set size 3
        ; Personal Parameters
        set v 1
        set hp 30
        set max_hp 30
        set flee_thresh 5
        set p_escape 50
        set idx idx_sbd_daunts
        ; Radii
        set r_detect 20
        set r_engage 5
        ; States
        set ship false
        set offensive true
        set class 0
        set engaged false
        set flee false
        set teleport false
        set american true
        ; Defence
        set breached false
        set group 3
      ]
    ]
    foreach indexer [ ind ->
      let ycoord (-30 + 1 * ind)
      let xcoord (32 + 2 * ind)
      create-f4fs 1 [
        setxy xcoord ycoord
        set color white
        set size 3
        ; Personal Parameters
        set v 1
        set hp 30
        set max_hp 30
        set flee_thresh 5
        set p_escape 50
        set idx idx_f4fs
        ; Radii
        set r_detect 15
        set r_engage 5
        ; States
        set ship false
        set offensive true
        set class 1
        set engaged false
        set flee false
        set teleport false
        set american true
        ; Defence
        set breached false
        set group 3
      ]
    ]
    set aircrafts turtles with [ship = false]

  ]

  if ticks = wave_4[
    let indexer ( range 0 7 )
    let bombIndexer ( range 0 10 )

    foreach bombIndexer [ ind ->
      let ycoord (30 + 1 * ind)
      let xcoord (42 + 2 * ind)
      create-sbd_daunts 1 [
        setxy xcoord ycoord
        set color yellow
        set size 3
        ; Personal Parameters
        set v 1
        set hp 30
        set max_hp 30
        set flee_thresh 5
        set p_escape 50
        set idx idx_sbd_daunts
        ; Radii
        set r_detect 20
        set r_engage 5
        ; States
        set ship false
        set offensive true
        set class 0
        set engaged false
        set flee false
        set teleport false
        set american true
        ; Defence
        set breached false
        set group 4
      ]
    ]
    foreach indexer [ ind ->
      let ycoord (30 + 1 * ind)
      let xcoord (42 + 2 * ind)
      create-f4fs 1 [
        setxy xcoord ycoord
        set color white
        set size 3
        ; Personal Parameters
        set v 1
        set hp 30
        set max_hp 30
        set flee_thresh 5
        set p_escape 50
        set idx idx_f4fs
        ; Radii
        set r_detect 15
        set r_engage 5
        ; States
        set ship false
        set offensive true
        set class 1
        set engaged false
        set flee false
        set teleport false
        set american true
        ; Defence
        set breached false
        set group 4
      ]
    ]
    set aircrafts turtles with [ship = false]

  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
2223
524
-1
-1
5.0
1
10
1
1
1
0
0
0
1
-200
200
-50
50
0
0
1
ticks
30.0

BUTTON
43
44
106
77
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
68
173
131
206
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
11
266
183
299
toa
toa
0
100
100.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

airplane 2
true
0
Polygon -7500403 true true 150 26 135 30 120 60 120 90 18 105 15 135 120 150 120 165 135 210 135 225 150 285 165 225 165 210 180 165 180 150 285 135 282 105 180 90 180 60 165 30
Line -7500403 false 120 30 180 30
Polygon -7500403 true true 105 255 120 240 180 240 195 255 180 270 120 270

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat top
true
0
Polygon -7500403 true true 150 1 137 18 123 46 110 87 102 150 106 208 114 258 123 286 175 287 183 258 193 209 198 150 191 87 178 46 163 17
Rectangle -16777216 false false 129 92 170 178
Rectangle -16777216 false false 120 63 180 93
Rectangle -7500403 true true 133 89 165 165
Polygon -11221820 true false 150 60 105 105 150 90 195 105
Polygon -16777216 false false 150 60 105 105 150 90 195 105
Rectangle -16777216 false false 135 178 165 262
Polygon -16777216 false false 134 262 144 286 158 286 166 262
Line -16777216 false 129 149 171 149
Line -16777216 false 166 262 188 252
Line -16777216 false 134 262 112 252
Line -16777216 false 150 2 149 62

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
