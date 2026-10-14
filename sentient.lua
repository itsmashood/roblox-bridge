--!nonstrict
--[[
    Cometium Fusions · Adopt Me · Rayfield             v4.6   (was "Comet Hub")
    Place   : 920587237 (Adopt Me!)
    Runtime : Luau, executor with loadstring / HttpGet (getconnections optional)
    Keyless. Settings saved by Rayfield (workspace/CometHub/AdoptMe_v3).

    Load:
        loadstring(readfile("CometHub_AdoptMe_Lite.lua"))()

    Tabs: Farm · Premium · Pets · Shop · Rewards · Halloween · Teleport · Transfer · Settings
    Rayfield's hide key is K.

    ── v4.6 — Premium, in gold (2026-10-12) ─────────────────────────────────────
      Free            the whole farm and all of Halloween stay free, as before.
      Premium         a Comet Track key the seller gives you (lifetime or N days). New Premium
                      tab, in gold, right after Farm: the key, Active / Expired / Free, and what
                      it unlocks —
                        · the Comet Track dashboard (nothing is sent online without Premium)
                        · remote control from the dashboard: pause / resume / rejoin / stop one
                          account or all, one template for all ("Remote control", on)
                        · Halloween extras: open Poltergeist Boxes, spend it all in the event's
                          last 12 h, Hauntlet team mode (free = each account plays alone)
                        · a gold theme for this window ("Gold theme", off)
                      Checked at start, every 10 min and when the key changes; an expired key
                      turns the extras off (the farm goes on) and they come back once renewed.
                      Without Premium its switches say "(Premium)" and do nothing.
      Moved           Comet Track key / live stats / local address: Settings → Premium tab;
                      "Open Poltergeist Boxes" and "spend it all": Halloween → Premium tab.
                      Same setting names: saved settings and templates keep working.
      Pause           ▶ FARMING and the dashboard's Pause are one switch: "Paused (remote)" on
                      the status line when it came from the dashboard; Resume turns it back on.

      Performance     Settings › Graphics: Low = no shadows / bloom / particles, lowest quality,
                      the world past ~100 studs in a dark fog; 3D off = no 3D drawing behind a
                      black screen with one small status square (3D comes back on its own if that
                      screen is ever missing — never a white world). Kaitun: LowGraphics = Low.
      Lure            new Rewards tab: collect what your lure caught and bait it again with the
                      free reusable bait (Ice Soup / Campfire Cookie), from anywhere once the
                      lure was seen at home; a free Box Lure placed if your house has none;
                      one-time event baits only if you allow them.
      Daily rewards   daily quests claimed all year (every tab, not only during Halloween), the
                      daily login reward (bucks + stars), achievement rewards, mailbox gifts.

    ── v4.5 — white screen after a while, faster baby, pictures, Halloween (2026-10-12) ──
      White screen    the game's celebration screens (a pen pet aging up, a new pet such as a
                      Skelicorn bought at ~120k candy, an achievement) took the camera, the
                      controls and blurred everything until NICE! — on a farm nobody watches,
                      forever: closed after 4 s. A camera left on the pet after "pet me" is put
                      back (and after 15 s anywhere). No trip / equip / team switch while the
                      game's own fade or trip is on screen; never a 2nd trip while the 1st is
                      still running (slow at low FPS); the watchdog works even without the
                      minigame modules and frees a round instance left long after its end.
                      Kaitun: 3D back on from the first second; no white fog.
      Diagnostics     CometHub/last_<account>.txt every 10 s (memory, white screen, round,
                      camera, status, log); telemetry never stops on one hung request.
      Faster          baby food / drink: exactly the bites the item needs (~3x faster), fewer-
                      bite food chosen; a new need wakes the farm at once (ClientData hook);
                      extras (buys, potions, pen, pay) wait while needs are queued; play keeps
                      the toy in hand; play / walk / ride anywhere on the floor.
      Pictures        Farm tab: baby + farm pets with their picture, age and needs; Pets tab:
                      the pet pen; Halloween tab: the candy pets and the Poltergeist Box.
      Halloween       candy pets bought dearest-first (a cheap one no longer eats the candy a
                      Skelicorn needs), never a pet that isn't on sale; Poltergeist Boxes
                      (opt-in open); "spend it all in the last 12 h" (opt-in); twig coffins
                      when the Jacobin Pigeon is picked; the daily cap seen in the Hauntlet too;
                      how each Hauntlet run ended is logged.
      Easier          ▶ FARMING switch (pause everything); "Recommended settings" (press
                      twice); "Screen white / stuck?" button at the top of the Halloween tab;
                      "Keep at least" understands 100k / 100,000 / 100 000.

    ── v4.4 — white screen fixed, Dusk-speed farm, events (2026-10-11) ───────────
      White screen    the game fades to white, then makes its own trip into a minigame and
                      fades back only after that trip; a 2nd trip at once (the "Teleport there
                      now?" invite answered Yes, the trip lock freed under it, a trip of the
                      farm) left it white for good, Reset asking "exit this game?" forever.
                      Now: the invite is always No, nothing of ours travels / equips / switches
                      team while a minigame is on this client (or the game is taking us out),
                      and a watchdog leaves a round that really hangs the game's own way.
                      Halloween tab: "Fix white screen" button. Kaitun: 3D comes back whenever
                      the black board isn't covering the screen.
      From afar       your house's crib / bath / litter box / bowls are used from wherever you
                      stand (remembered on each visit home): baby + pet bath in ~7 s, no trip
                      home and back. A piece that doesn't count from afar → the old trip.
      Faster          smooth walk / ride loop (counts the whole time), quick needs on their own
                      thread, seats freed and re-used at once, no-trip jobs before area trips,
                      late needs join an area already counting, mystery picks what's doable
                      here, feeds 1 s apart with a retry, play throws as soon as a fetch counts,
                      instant needs while waiting in the minigame queue ring.
      2 pets          a potion target takes only the last slot; every pet of a job is out; the
                      pen never takes your Pet 1 / Pet 2; an expired certificate is reported.
      Hauntlet        doors picked the game's way (no more error spam); the anti-fall net only
                      after a Bouncy Door; a long team run is never cut mid-round.
      Events          every daily tab's reward claimed; the daily candy cap (250 000) pauses the
                      Ghost Gallery 3 h instead of playing for 0.
      Rejoin          a rejoin from the workspace file waits for the game to load.

    ── v4.3 — rolling tasks, ride (2026-10-11) ─────────────────────────────────
      Rolling tasks   baby and pets each take their next bed / bath / litter box / bowl the
                      moment they finish one — no waiting for the slowest (2-4 at once).
      Detection       a seat that isn't counting is used again, then swapped for another,
                      then left; each use waits as long as its own rate says (the flat 40 s
                      cut slow seats at ~80 %: "couldn't clear it" on sleepy / dirty / toilet).
      Ride            a pet that slipped out of the stroller is put back in (2 tries);
                      during Halloween a ride starts with 45 s to spare instead of 100 s.
      2 pets          "Pets at once" is no longer reset to 1 by saved settings.

    ── v4.2 — VIP, travel, minigames, pet pen (2026-10-11) ──────────────────────
      VIP             Roblox no longer lets the client read PrivateServerId: the old test called
                      every VIP "public", so a stuck account was hopped into a public server.
                      Now Adopt Me's own ReplicatedStorage.PlaceSubtype / ClientData is_vip_server.
      Travel          the game's trip lock held 45 s straight is freed by a watcher of its own
                      (the old check reset its clock between waits and never fired).
      Reconnect       Roblox's Reconnect button found in every language (fr "Reconnexion");
                      never reconnects when the account was opened on another device.
      Offline         a client the server dropped sends "Disconnected: …" once, then nothing.
      Minigames       live countdowns (queue, start, round, room); Hauntlet follows each room's
                      timer — waits and items cut short, and a door is always taken before it
                      ends ("out_of_time" = out of the run); stale round times no longer stop
                      the farm.
      Pet pen         claims age-ups when ready; Auto pet pen (priority / excluded kinds, eggs).
      Crypt           a crypt that refuses entry is skipped 10 min instead of a server hop.

    ── v4.1 — two tasks at once (2026-10-11) ──────────────────────────────────
      Together        while an area counts down, its own seats are used too: sleep in the
                      campsite sleeping bags during camping, beds / bowls inside School, Salon,
                      Cat Café and Pizza Shop; a mystery picks the option doable right there.
                      While walking, riding or sitting, the others eat / drink / heal / pick
                      mysteries; a pet that needs a walk follows the stroller ride. Of two areas,
                      the one covering more of the other needs goes first.
      Anti-AFK        idle handlers switched off and re-checked every 30 s, plus a VirtualUser
                      click on Idled and every 8 min.
      Rejoin          the hub comes back by itself after a server change (queued with the
                      loader's jnkie link + key); a kick rejoins the same server first; a lost
                      connection presses Roblox's Reconnect (private servers too); stuck in a
                      private server = the trip lock freed in place.
      Fixes           pet_me / mystery / trips run at the game's identity (Madium, some others).

    ── v4.0 — Cometium Fusions ────────────────────────────────────────────────
      Name            the hub is now "Cometium Fusions" (window, Kaitun board). Saved settings,
                      the CometHub/ folder and the getgenv names stay the same.
      Server hop      a hub relaunched after a hop keeps the loader's CometTrackKey,
                      CometDashboard and CometFPS (getgenv is empty in the new server).
      Own settings    each account has its own settings file (CometHub/AdoptMe_v4_<name>): one
                      shared file made every account copy the others' choices (pets bought…).
      Side tabs       the tabs are a column of icons down the left (Settings › "Tabs down the
                      left side"); the open tab's name shows in the title bar.
      Teleport tab    one tap to any place: your house, every shop / building, beach, campsite,
                      park, town…, the Halloween manor / hotel / crypt. Not during a round; the
                      farm pauses 3 min after (toggle) so it doesn't walk you away.
      Movement        Ghost Gallery: a frozen stand point per ghost + side (detours aren't thrown
                      away any more), wall-clamped side points, "stuck" = no progress for 6 s,
                      props approached from 12 studs; queue rings: no pull-back in the last second.
      Safety          no trip / TP at all while the game has you in a round; long rounds no
                      longer get cut by the worker's guard; crypt / dailies calls time out (10 s);
                      a stale trip clock no longer "unsticks" a normal trip.
      Out of food     the log says when the baby has nothing to eat / drink and "Auto buy food
                      when out" is off (that was the endless "baby thirsty: couldn't clear it").
      Comet Track     the Lite's own dropdowns (pets at once, order, version, when Full Grown)
                      are sent to the site too; the Kaitun's computed labels still aren't.

    ── v3.9 ───────────────────────────────────────────────────────────────────
      Settings save   Settings › "Save my settings" (on): every setting is also saved per
                      account in CometHub/AdoptMe_settings_<name>.json and put back at start,
                      for executors where Rayfield's own save doesn't stick. A loader's
                      getgenv().CometConfig = { … } is applied on top. Auto Farm Baby / Pet
                      are now on by default (a first start used to show everything off).
      VIP             never leaves a private server by itself any more: Auto reconnect used to
                      Teleport() out of a VIP into a public server.
      Pick kinds      Farm tab › "Farm only these kinds": a list of the kinds you own (no typing);
                      Auto farms only those. Kaitun: FarmKinds = { "Cat", … } in CONFIG.
      Show / hide     K as before, plus a key of your choice (Settings, default RightShift) and a
                      round draggable "CH" button for phones (on by default on touch screens).
      Ghost Gallery   pinned against a wall: every 1.2 s without moving it aims at another
                      side of the ghost (0, ±70, ±140°) before giving the ghost up.

    ── v3.8 ───────────────────────────────────────────────────────────────────
      Hauntlet        doors picked from the exact odds: where the ghosts can be (drawn with
                      replacement by ghost_weight) with the phone's reveal folded in, the chance
                      to die behind each door, and what a clean door drops. Items are spent when
                      that chance passes 8 %. Team play: every Comet Hub account in the same
                      round shares one phone per room (refusals are free) and the rainbow wand
                      when ANY of them would likely die (the server broadcasts every runner's
                      health), and they all take the same nexus door. Simulated on the real room
                      generator (50 000 runs): solo reaches room ~22 (was ~20) and wins ~0.6 %;
                      a team of 6 of your accounts in one round: ~40-75 % each reach room 50.

    ── v3.7 ───────────────────────────────────────────────────────────────────
      Comet Track     live stats to the board (CometTrack/start.bat on this PC, or Supabase +
                      Vercel once SupaURL / SupaKey are set): currencies, potions by kind,
                      pets, pet pen, inventory, settings. Templates made on the site change
                      this hub's settings live (Settings › "Send live stats to Comet Track").
      Potions count   the session's potion counter (and the board's) is Age-Up Potions only.
      Practice Dog    the tutorial pet (temporary, can't drink potions) is never farmed or
                      given potions — it was blocking every potion on ultra.

    ── v3.6 ───────────────────────────────────────────────────────────────────
      Hauntlet       the new Halloween minigame (Haunted Hotel, a round every 20 min, 10 min
                      off each Ghost Gallery): one door per room, up to 50 rooms; candy per
                      room reached, bucks every 10 rooms, rusty keys. The hub queues, then picks
                      the door least likely to hide a ghost (each door kind has a ghost weight
                      in HauntletDoorDB), uses the cell phone to reveal one, keys / gold key on
                      locks, the rainbow wand or ghost potion when one more hit would end the
                      run, and the potions for health.
      Lever           the Lightning Lever (a crypt coffin) is equipped, delivered and switched on
                      — that is what puts the Skelicorn on sale.
      Pets            Halloween tab › "Buy Halloween pets": Bolt, Jump Scare, Skelicorn,
                      Jacobin Pigeon (needs 8 twigs) bought with candy when you have the price +
                      "Keep at least"; one of each unless "Buy more than one" is on.

    ── v3.5 ───────────────────────────────────────────────────────────────────
      Potions        Pets tab › "Use potions on": Farm pet (default), Chosen kinds (species
                      you tick in the list below — "Cat", not 300 cats; the pet of those kinds
                      closest to Full Grown gets it; none ticked = any kind), or the old Smart
                      rule (finish neon sets first) — the smart rule was the only mode before,
                      with no way to change it. When a potion is not used, the log says why
                      (farm pet is an egg / Full Grown, "Only on" rules it out, locked, …).

    ── v3.4 ───────────────────────────────────────────────────────────────────
      Wishes          a pet wishing for an item you can't use (not owned / not sold / roller
                      skates) gets a normal stroller ride anyway, and wished food gets ordinary
                      food once — the progress decides; only a try that didn't count is set
                      aside (10 min). PreferenceItemHelper says only the exact item matches,
                      but that was never checked against the server.
      Retry           a failed task is retried after 15 s, 30 s, then every 60 s (was 90 / 180 /
                      300 s).
      Right away      a new area need (beach, park, camp…) starts unless the round is < 70 s
                      off (was 160 s, which held such needs ~3.5 min of every 10); a task right
                      where you stand needs only 15 s.
      Settings        "Set up my house" button and "Taller window" removed: both are automatic.

    ── v3.3 ───────────────────────────────────────────────────────────────────
      Session         Farm tab: "+$X bucks this session" and "+N potions this session" in the
                      big title line under Status.
      House           sleep / bath / toilet always at your house (no toggle), and the house is
                      set up by itself (free crib, bath, bowls, litter box) once a farm runs.
      Eggs            "Auto buy + hatch eggs": buying now also hatches, and with no egg picked
                      it buys the cheapest egg sold for bucks (before: nothing happened).
      Ride            the pet is brought next to you before the stroller; a ride that never
                      started gets the normal retry (only a ride that ran and didn't count, or
                      an item you can't get right now, is set aside — and that expires).
      Review fixes    the baby isn't put in a crib while it eats; extra furniture must be next
                      to the main seat; leash wishes skip the area walk; 2-pet walks don't stop
                      early; wish food isn't replaced by generic food; streaming / rejoin /
                      reconnect only for real breakage and never during a round; "stuck 5 s →
                      another ghost" really fires; the drag bar sits under the taller window;
                      age-ups counted once; boost potions can't be fed every tick if the timer
                      can't be read (Bucks and Aging can run together).

    ── v3.2 ───────────────────────────────────────────────────────────────────
      Stuck fixes     RequestStreamAroundAsync ignores its timeout and hung the cat / beach
                      trips (seen live: > 12 s, then the 260 s watchdog) — now asked on its own
                      thread, 1.5 s max. The cat's server call gets 8 s; a beach / park / camp
                      that stalls on the floor goes down to the ground spot itself.
      Recovery        Settings › Auto rejoin (3 failed trips, the trip lock jammed 3 times, or
                      streaming dead → a fresh public server) and Auto reconnect (kick /
                      disconnect screen → teleport back, every 20 s). The hub runs again there
                      via queue_on_teleport when the file is in the executor's workspace.
      More at once    at home the baby and each pet do DIFFERENT furniture needs together
                      (crib + shower + litter box); during an area: pet_me too, and a walk
                      around the spot on the beach / park / camp.
      Potions         Farm tab: Auto Bonus Bucks potion (x1.2, on) / Bonus Aging (off), kept
                      running on the farm pet, independent of "Auto use potions".
      Dashboard       executed date + time, total bucks gained, age-ups gained (Full Grown).
      Window          a bit taller (up to 560), same width.

    ── v3.1 ───────────────────────────────────────────────────────────────────
      Ride / walk     up to 90 s (a ride from 0 % takes ~60 s; 50 s ended at 80-95 % and was
                      booked as failed), stopping early when the progress stops moving. A wish
                      we can't do — an item we don't own and can't buy, or roller skates (they
                      seat only YOU; verified nothing makes them count) — is set aside until the
                      need changes instead of retried every 5 min. A cut ride unequips.
      Glide           Settings › Glide instead of teleporting (off: instant TP, the default).
      Ghost Gallery   stuck 0.8 s → jump + PathfindingService route round stairs and rails;
                      stuck 5 s → another ghost. Still walking only.
      Fixes           side jobs tried once per area visit (no food burned every second, the
                      area checks keep running); a pet wishing for one exact drink no longer
                      tours 6 places for a bowl; the bowl tour stops before the job's limit; the
                      baby's bites stop when their job is cut; hatching with no egg left farms a
                      pet meanwhile instead of stalling; pets in the pen are never picked.

    ── v3.0 ───────────────────────────────────────────────────────────────────
      Minigame        the game's "Ghost Gallery is starting soon! Teleport there now?" invite is
                      answered Yes (the game takes you to the ring), and the NICE! results
                      screen is closed (it also blocked petting). Nearest ghost first, aimed at
                      the model itself — the way the verified 100 100 round played.
      Rounds          every task / trip is budgeted so it ends before we must queue; the boss
                      phase is read from the ghosts present, never guessed.
      Crypt / cat     Tomb Spider only once every wanted coffin is open, twig cap respected,
                      the cat gets a cheap food (bought if needed), never your pet's drink.
      Players         Settings › "Remove other players in public servers": their characters and
                      pets leave YOUR screen only (less lag); off = put back.

    ── v2.9 ───────────────────────────────────────────────────────────────────
      Halloween tab   Ghost Gallery minigame every 10 min (verified: one round = score 100 100
                      = +5000 candy + a crypt key), crypt coffins with keys, stray cat, dailies.
                      Details in the HALLOWEEN 2026 section.

    ── v2.8 ───────────────────────────────────────────────────────────────────
      Pet wishes      needs that name an item (components.preference = {item_category,
                      item_kind}: hungry / thirsty food, play toy, walk leash, ride stroller or
                      vehicle) use exactly that item — bought if a shop sells it for bucks and
                      it's under "only up to ($)" (Settings). Matching = PreferenceItemHelper.
      Ride            stroller, or a vehicle: SitInVehicle(you → VehicleSeat, pet → Seat) and
                      the vehicle moved in a slow circle with PivotTo (throttle is ignored).
      Areas           if you end up outside the building mid-wait, straight back in.

    ── v2.7 ───────────────────────────────────────────────────────────────────
      Same pet        "Keep the same pet until it's Full Grown" (Farm tab, on): each slot's
                      pet is remembered per account (getgenv + CometHub/AdoptMe_farm_<name>.json)
                      and picked up again after a reload / rejoin / farm off-on; without a
                      memory, the pet already out is kept. "When a pet is Full Grown" moved
                      to the Farm tab.

    ── v2.6 ───────────────────────────────────────────────────────────────────
      Pet me          done through the game's own petting screen (FocusPetApp:capture_focus +
                      petting_handler:start_petting with our "hand") — 4.5 s, verified.
      Low FPS         everything is clock-timed; optional FPS cap (Settings, setfpscap).
      Executors       HttpGet → request / http_request / syn.request fallback, load / loadstring,
                      debug.getupvalues / getupvalues; every executor-only call is guarded.
      Faster          shorter pauses between trips and after reaching the floor.

    ── v2.5 ───────────────────────────────────────────────────────────────────
      Session box     started at · running for · Money $start + $gained (− $spent) = $now ·
                      Potions start + gained (− used) = now, each with a per-hour rate.
      Travel fix      door trips run on their own thread; a trip lock left stuck > 40 s is
                      released (InteriorsM's CriticalSection:signal + entering = false). A
                      stopped/reloaded script no longer cancels its running step.

    ── v2.4 ───────────────────────────────────────────────────────────────────
      Popups off      the $10 playtime cheque is cashed for you (PayAPI/Collect) and switched
                      to silent for the session (PayAPI/DisablePopups — the game's own "do not
                      show again"); promo windows closed; the age-up banner hidden; adoption
                      party / add-friend-after-trade prompts answered "no".
      Trade off       SettingsAPI/SetSetting("trade_requests", 3) = No One (1 = Everyone).
      Trade pets      Transfer tab: player + pet + version, N pets per trade (≤ 18), M trades;
                      never locked / farmed / equipped / pen pets.

    ── v2.3 ───────────────────────────────────────────────────────────────────
      Ride            in a stroller from your backpack (ToolAPI/Equip → seat tagged
                      "StrollerSeat" → AdoptAPI/UseStroller(owner, petModel, seat) → walk).
                      Carrying the pet never counted, and doing it inside an area froze the
                      area's progress (salon stuck at 39 %) — areas now only run item jobs.
      Pet me          the petting screen's own calls: FocusPet → 3.6 s → PetPetted +
                      ProgressPetMeAilment → UnfocusPet (parked like any need if refused).

    ── v2.2 ───────────────────────────────────────────────────────────────────
      Faster tasks    timed areas first; during their ~50 s the farm eats, drinks, heals,
                      picks mysteries and plays; baby bites and pet feeding run together.
      Sick            the Hospital's free healing apple (BuyItem from anywhere, $0); each
                      food item goes to one eater only (sick spreads, 12 studs).
                      Left out: at_work (themed event), party_zone (admin event).
      Dashboard       Status (what + for how long + where) · Needs (live % per need) ·
                      Session (tasks/h, bucks earned and $/h).
      Look            Comet theme (navy + accent) with 6 accents, or any Rayfield theme,
                      swapped live via Window.ModifyTheme; tab icons from Rayfield's Lucide pack.

    ── v2.1 ───────────────────────────────────────────────────────────────────
      The map is never touched: no stripping, no graphics tricks.
      Task floor      gray smooth-plastic tiles OVER the whole main map (top y = 90). The farm
                      waits up there and does eat / drink / play / walk / mystery on it, and
                      beach / park / camping on the floor right above those areas (the game
                      still counts them). Sleep / bath / toilet go home, then back up.
                      A safety tile sits under whatever interior you're in; a void catcher
                      puts you back where you last stood.
      Transfer tab    trading license + sending bucks by mannequin, on their own.
      2 pets          up to EquippedPets.get_max_equip_count() pets farmed together. The 2nd
                      one is ToolAPI/Equip(unique, {equip_as_last = true}) — the backpack's own
                      "second pet" call (ClientToolManager / SpawnSequenceHelper).
      Faster          baby + pets with the same need are worked together: a crib each,
                      a bath each, one trip for an area. Jobs doable where you stand go first.
      Never stuck     every step runs under a time limit and is cancelled past it; a need that
                      keeps failing is parked (90 s, then longer) instead of retried forever.
      Smart potions   age potions go to the pet that completes a neon set (3 Full Grown of its
                      kind already), otherwise to the farm pet; timed boosts only when not
                      running (ResourceMultiplierHelper); instant hatch on farmed eggs;
                      fly / ride on your rarest pet that lacks it. Every use passes the
                      potion's own validate().
      Pay by mannequin
                      AvatarAPI/BuyMannequinOutfit(owner, mannequin_id, outfit_version, price)
                      (OutfitMannequin.buy). The game caps a mannequin at $100, so a payment is
                      several buys; the copied outfit is removed after each with
                      AvatarAPI/DeleteOutfit("player", name) so the next buy isn't blocked.
                      Mannequin data = CollectionService tag "FurnitureMannequin" → child
                      "Mannequin" with attributes price / for_sale / outfit_version + Owner.
                      Seller side: ActivateFurniture(owner, unique, block, {set_price, price}).

    ── WHAT WAS VERIFIED LIVE (Sept 2026, on the client, not guessed) ─────────
      Become a baby    TeamAPI/ChooseTeam:InvokeServer("Babies"|"Parents",
                         {dont_respawn = true, source_for_logging = "avatar_editor"}) -> "success"
      Travel           InteriorsM.enter(dest, door, opts) — MainMap door "Neighborhood!MainDoor",
                         a house needs {house_owner = player}
      Area needs       school/salon/pizza_party/cat_cafe = be inside 50 s;
                       beach_party/bored/camping = stand near a StaticMap anchor 50 s
      Furniture needs  ActivateInteriorFurniture(unique, block, {cframe}, char)   public places
                       ActivateFurniture(owner, unique, block, {cframe}, char)     a house
                       Blocks until the use ends — always fired from its own thread.
      Home furniture   free bowls / crib / bathtub / litter box placed with
                       FurniturePlacer.calculate_placement_on_floor + HousingAPI/BuyFurnitures
      Baby eat/drink   ToolAPI/Equip(food) then ServerUseTool(unique,"START"/"END")
      Pet food/potion  PetObjectAPI/CreatePetObject("__Enum_PetObjectCreatorType_2",
                       {unique_id, pet_unique, spawn_cframe, additional_consume_uniques})
      Shop             ShopAPI/BuyItem(category, kind, {buy_count}) from anywhere (99 cap)
      Eggs             properties.xp vs InventoryDB.pets[id].xp_to_hatch; a hatched egg comes
                       back under a NEW unique; PetAPI/MarkHatched confirms a stuck hatch
      Release          Pet Recycler (Nursery) ActivateInteriorFurniture(u, "UseBlock",
                       {uniques = {[u]=true}}, char); PetRecyclerAPI/TicketsCollected banks
      License          TradeAPI/BeginQuiz + AnswerQuizQuestion(q.answer) -> 3/3, finished
      Mystery          action:_get_ailment_slots(wrapper) + ChooseMysteryAilment(u, key, i, kind)

    ── NOT AUTOMATED, on purpose ──────────────────────────────────────────────
      pet_me (never moved remotely), ride, at_work, party_zone.

    ── EXECUTOR NOTE ──────────────────────────────────────────────────────────
      Calling a game ModuleScript can leave the calling thread unable to write to the
      Rayfield GUI. Every UI update therefore goes through a queue drained on Heartbeat,
      and the UI is fully built before the first game call.
]]

------------------------------------------------------------------------------------------------
-- EXECUTOR SHIMS (2026-10-13) — global assignments only: the main chunk sits at Luau's 200-locals
-- limit (the two locals below end with the block). Customers on Xeno, Solara, "Real"…: a function
-- an executor names differently gets its other name, and a getgenv that is missing or throws
-- ("not supported") becomes the shared global table. Nothing whose ABSENCE a caller decides on
-- is faked (getgc, getconnections, queue_on_teleport, debug.getupvalues… stay nil there). Started
-- from autoexec / a bare loadstring before the place is in: the game and your player first (LP
-- below is read once, and the window's settings file is named after it).
------------------------------------------------------------------------------------------------
do
    local okG, g = pcall(function() return getgenv() end)
    if not (okG and type(g) == "table") then getgenv = function() return _G end end
    if type(setthreadidentity) ~= "function" then
        setthreadidentity = set_thread_identity or setidentity or (syn and syn.set_thread_identity) or nil
    end
    if type(queue_on_teleport) ~= "function" then
        queue_on_teleport = (syn and syn.queue_on_teleport) or queueonteleport or (fluxus and fluxus.queue_on_teleport) or nil
    end
    if type(request) ~= "function" then
        request = http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or nil
    end
    if type(loadstring) ~= "function" and type(load) == "function" then loadstring = load end
    if not game:IsLoaded() then game.Loaded:Wait() end
    while not game:GetService("Players").LocalPlayer do task.wait(0.1) end
end

------------------------------------------------------------------------------------------------
-- SESSION — one instance at a time
------------------------------------------------------------------------------------------------

-- the old run (this hub or the kaitun, which also answers to __CHLITE): its GUI goes first
-- on this clean thread, its destroy on another (a destroy touching a game module would cost
-- this thread the capability it needs to build the new window)
do
    local h = _G.__CHLITE
    if type(h) == "table" and type(h.destroy) == "function" then
        if type(h.Rayfield) == "table" then pcall(function() h.Rayfield:Destroy() end) end
        -- the old run's show / hide button (runs before this run makes its own)
        pcall(function() ((gethui and gethui()) or game:GetService("CoreGui")).CometHubToggle:Destroy() end)
        pcall(function() ((gethui and gethui()) or game:GetService("CoreGui")).CometBlackScreen:Destroy() end)
        if type(h.K) == "table" and h.K.gui then pcall(function() h.K.gui:Destroy() end) end
        task.spawn(function() pcall(h.destroy) end)
    end
end
local SESSION = { dead = false, conns = {} }
local function alive() return not SESSION.dead end
local function track(conn) SESSION.conns[#SESSION.conns + 1] = conn return conn end

local Players           = game:GetService("Players")
local RS                = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local LP                = Players.LocalPlayer

-- Where OUR ScreenGuis go (the show / hide button, the headless status label): gethui() first,
-- then CoreGui, then PlayerGui — some executors have no gethui (or it throws "not supported") and
-- can't write CoreGui ("lacking capability"). Call it from the ui() queue (a clean thread).
-- true = parented. (A table field, not a local: the main chunk is at Luau's 200-locals limit.)
function SESSION.parentGui(sg)
    for _, get in ipairs({
        function() return gethui() end,
        function() return game:GetService("CoreGui") end,
        function() return LP:FindFirstChildOfClass("PlayerGui") end,
    }) do
        local okP, p = pcall(get)
        if okP and typeof(p) == "Instance" and pcall(function() sg.Parent = p end) and sg.Parent == p then
            return true
        end
    end
    return false
end

------------------------------------------------------------------------------------------------
-- CONFIG — Rayfield flags write into this table
------------------------------------------------------------------------------------------------

local C = {
    -- farm tab
    BabyFarm = true, PetFarm = true, HatchEggs = false, HomeTasks = true, SaveSettings = true,
    FarmKinds = {}, TpPause = true, SideTabs = true,
    AutoPen = false, PenClaim = true, PenEggs = false, PenPriority = {}, PenExclude = {},
    -- utility tab
    Potion = false, PotionTypes = { "Age-Up Potion", "Tiny Age Potion" }, PotionOnly = "All pets",
    PotionTarget = "Farm pet", PotionKinds = {},
    Neon = false, Mega = false, NeonKinds = {},
    ReleaseAuto = false, ReleaseBy = "Rarity", ReleaseRarities = {}, ReleaseKinds = {},
    ReleaseVersions = { "Regular" }, ReleaseAges = {}, ReleaseKeep = 0, ReleaseKeepFR = true,
    PayTo = "", PayAmount = 0, PayAuto = false, PayKeep = 0,
    TradeTo = "", TradeKind = nil, TradeVersion = "Any", TradePer = 1, TradeTimes = 1, TradeOff = false,
    NoPopups = true, PrefBuy = true, PrefMax = 250,
    HwOn = true, HwGhost = true, HwHaunt = true, HwLever = true, HwPets = {}, HwPetMany = false,
    HwKeepCandy = 0, HwCrypt = true, HwCat = true, HwDailies = true, HwTwigs = false, HwSpider = true,
    HwOpenBoxes = false, HwSpendEnd = false,
    HidePlayers = true, TrackOn = true, TrackURL = "http://127.0.0.1:8787/push",
    SupaURL = "https://lflcdyiidwfpjiogzwqn.supabase.co",   -- Comet Track online (Supabase)
    SupaKey = "sb_publishable_igt66ybwlZKApI1Z_58Rgw_g9DauNj5",   -- public key, safe to ship
    TrackKey = "",   -- your Premium key (Comet Track; or getgenv().CometTrackKey); "" = free, nothing sent online
    -- Premium (2026-10-12): obey the dashboard's buttons · Hauntlet team mode · gold window
    RemoteOn = true, HwTeam = true, GoldTheme = false,
    -- shop tab
    ShopCategory = "All", ShopSearch = "", ShopItem = nil, ShopAmount = 1,
    ShopAuto = false, ShopMax = false, KeepBucks = 0,
    ShopSort = "Cheapest first", ShopAffordable = false,
    BuyEgg = nil, AutoBuyEggs = false,
    -- settings tab
    PetCount = "2 pets", PetsOut = "As many as the game allows", Pet1 = "Auto", Pet2 = "Auto",
    PetOrder = "Youngest first", PetKind = "Any", PetVersion = "Any pet", StickyPet = true,
    WhenGrown = "Switch to the next pet", PriorityTypes = {},
    PetFood = "Food items first", HatchList = {}, HatchCount = 0,
    Delay = 0.25, AutoBuyFood = true, Skip = {}, TaskFloor = true, SkyBase = true, AntiAFK = true,
    Glide = false, GlideSpeed = 160, AutoRejoin = true, AutoReconnect = true,
    BucksPotion = true, AgingPotion = false, GfxMode = "Min",           -- the minimum by default (2026-10-13)
    AutoLure = true, LureClaim = true, LureConsumable = false, LurePlace = true,
    ClaimDailies = true, ClaimStars = true, ClaimAchievements = true, ClaimMail = true,
}

local AGE_NAME = { "Newborn", "Junior", "Pre-Teen", "Teen", "Post-Teen", "Full Grown" }
local RARITY_RANK = { common = 1, uncommon = 2, rare = 3, ultra_rare = 4, legendary = 5 }

-- kind: age = ages the pet · boost = timed farm boost · egg = eggs only · fly / ride = forever
local POTIONS = {
    { id = "pet_age_potion",                    label = "Age-Up Potion",        kind = "age" },
    { id = "tiny_pet_age_potion",               label = "Tiny Age Potion",      kind = "age" },
    { id = "halloween_2024_sugar_skull_potion", label = "Sugar Skull Potion",   kind = "age" },
    { id = "super_age_potion",                  label = "Super Age-Up Potion",  kind = "age", rareOnly = true },
    { id = "pet_bonus_bucks_potion",            label = "Bonus Bucks Potion",   kind = "boost", flag = "bucks" },
    { id = "pet_bonus_aging_potion",            label = "Bonus Aging Potion",   kind = "boost", flag = "aging" },
    { id = "pet_instant_hatch_potion",          label = "Instant Hatch Potion", kind = "egg" },
    { id = "pet_flying_potion",                 label = "Fly-A-Pet Potion",     kind = "fly" },
    { id = "pet_riding_potion",                 label = "Ride-A-Pet Potion",    kind = "ride" },
}

-- Needs a script can finish, in the order they are worked. Anything else is skipped.
-- The 20 needs in AilmentsDB (read live 2026-09-30): these 16 are done by the farm.
local ORDER = {
    "mystery", "hungry", "thirsty", "sick", "sleepy", "dirty", "toilet", "play", "walk", "ride",
    "pet_me", "school", "pizza_party", "salon", "cat_cafe", "beach_party", "bored", "camping",
}
local RANK = {}
for i, k in ipairs(ORDER) do RANK[k] = i end

local UNSUPPORTED = {
    at_work = "a themed-event job, no place to do it",
    party_zone = "admin event only",
}

-- Timed areas. dest = interior; anchor = spot on the main map.
-- room = the other needs that can be done INSIDE the area while it counts down (furniture there,
-- read live 2026-10-11): School / Salon / Cat Café have beds and bowls, the Pizza Shop bowls,
-- the campsite 12 sleeping bags 15–55 studs from its origin (camping counts within 110). The
-- beach and park have nothing inside their perimeter (the fire hydrants are outside).
local AREA = {
    school      = { dest = "School",    room = { sleepy = true, hungry = true, thirsty = true } },
    salon       = { dest = "Salon",     room = { sleepy = true, hungry = true, thirsty = true } },
    pizza_party = { dest = "PizzaShop", room = { hungry = true, thirsty = true } },
    cat_cafe    = { dest = "CatCafe",   room = { sleepy = true, hungry = true, thirsty = true } },
    beach_party = { dest = "MainMap", anchor = "beach" },
    bored       = { dest = "MainMap", anchor = "bored" },
    camping     = { dest = "MainMap", anchor = "camp", room = { sleepy = true } },
}
local ANCHOR_PATH = {
    beach = { "Beach", "BeachPartyAilmentTarget" },
    bored = { "Park", "BoredAilmentTarget" },
    camp  = { "Campsite", "CampsiteOrigin" },
}
local ANCHOR_FALLBACK = {                                   -- read live on 2026-09-25
    beach = Vector3.new(-670.98, 34.04, -1413.08),
    bored = Vector3.new(-401.63, 27.92, -1760.05),
    camp  = Vector3.new(-18.44, 33.79, -1046.01),
}

-- Where to look for furniture that clears a need, after home and the current location.
local PLACES = {
    sleepy  = { "Nursery", "MainMap", "housing" },
    dirty   = { "housing" },
    toilet  = { "MainMap", "Neighborhood", "housing" },
    sick    = { "Hospital" },
    hungry  = { "PetShop", "Nursery", "CatCafe", "PizzaShop" },   -- bowls are Pets-only
    thirsty = { "PetShop", "Nursery", "CatCafe", "PizzaShop" },
}

-- Free furniture placed in YOUR house when "tasks at home" is on (FurnitureDB cost 0).
local HOME_KIND = {
    hungry  = { kind = "ailments_refresh_2024_cheap_food_bowl",  name = "Cheap Food Bowl",  petsOnly = true },
    thirsty = { kind = "ailments_refresh_2024_cheap_water_bowl", name = "Cheap Water Bowl", petsOnly = true },
    sleepy  = { kind = "basiccrib",                             name = "Basic Crib" },
    dirty   = { kind = "cheapbathtub",                          name = "Cheap Bathtub" },
    toilet  = { kind = "ailments_refresh_2024_litter_box",      name = "Litter Box",       petsOnly = true },
}

-- The task floor: 5 x 5 gray tiles of 2048 studs OVER the main map, top at y = 90.
-- Measured 2026-09-26: Interiors["MainMap!Default"] spans 5485 x 4172 studs around
-- (-1260, -1545), ground mostly y 20–40. The area needs still count up there (read off
-- AilmentsDB 2026-09-30): beach / park accept up to 170 studs above their target, the
-- campsite anything within 110 studs of CampsiteOrigin (y 33.8) — 90 is inside all three.
-- the task floor: dark blue with studs (asked 2026-10-13; it was gray, then invisible)
local FLOOR_BLUE = Color3.fromRGB(20, 36, 84)
local FLOOR_TILE = 2048
local FLOOR_GRID = 5
local FLOOR_TOP  = 90
local MAP_CENTER = Vector3.new(-1260, 0, -1545)

------------------------------------------------------------------------------------------------
-- UI QUEUE — every Rayfield write happens here, on a fresh Heartbeat thread
------------------------------------------------------------------------------------------------

local uiQueue = {}
local function ui(fn) uiQueue[#uiQueue + 1] = fn end
track(RunService.Heartbeat:Connect(function()
    if #uiQueue == 0 then return end
    local batch = uiQueue
    uiQueue = {}
    for _, fn in ipairs(batch) do pcall(fn) end
end))

------------------------------------------------------------------------------------------------
-- STATE + LOG
------------------------------------------------------------------------------------------------

local S = { status = "Loading…", babyDone = 0, petDone = 0, potions = 0, neons = 0, megas = 0,
            bought = 0, eggsBought = 0, hatched = 0, released = 0, paid = 0, log = {}, ageUps = 0, grown = 0,
            start = os.clock() }
_G.CometLite = S

local function log(msg)
    msg = os.date("%H:%M:%S ") .. tostring(msg)
    table.insert(S.log, 1, msg)
    if #S.log > 10 then table.remove(S.log) end
end
local function setStatus(msg)
    if msg ~= S.status then S.statusAt = os.clock() end
    S.status = msg
end
local function num(text)              -- "100k", "100,000", "100 000", "100.000", "1.5m" → numbers
    local s = tostring(text or ""):lower():gsub("[^%d%.km]", "")
    local mult = 1
    if s:sub(-1) == "k" then mult, s = 1e3, s:sub(1, -2)
    elseif s:sub(-1) == "m" then mult, s = 1e6, s:sub(1, -2) end
    if mult == 1 and s:match("^%d+%.%d%d%d$") then s = s:gsub("%.", "") end   -- 100.000 = 100 000
    return math.max(0, math.floor((tonumber(s) or 0) * mult))
end

-- One actor at a time: the worker loop and manual buttons both travel and equip.
local Lock = { held = false }
function Lock:run(fn)
    self.waiting = (self.waiting or 0) + 1
    while self.held and alive() do task.wait(0.2) end
    self.waiting -= 1
    if not alive() then return false end
    self.held = true
    self.byWorker = false                 -- the worker sets it; a manual button leaves it false
    local ok, err = pcall(fn)
    self.held = false
    if not ok then log("error: " .. tostring(err)) end
    return ok
end

------------------------------------------------------------------------------------------------
-- RAYFIELD
------------------------------------------------------------------------------------------------

-- HEADLESS (2026-10-13) — Rayfield couldn't be fetched, or doesn't start on this executor (it
-- needs game:GetObjects and a writable gethui / CoreGui): customers on such executors got one warn
-- in the console and NOTHING — no window, no farm. Now a stand-in takes every call the hub makes
-- (CreateWindow / CreateTab / every Create*, :Set, :Refresh, Flags, Notify, IsVisible,
-- SetVisibility, LoadConfiguration, Destroy), so the rest of the file runs unchanged and the farm
-- runs on the defaults + the Saver's saved settings + the loader's CometConfig + a Comet Track
-- template. Each element is a copy of its settings table: it keeps CurrentValue / CurrentOption,
-- :Set runs its Callback, Flags[Flag] = element (Track and the Saver use them). IsVisible() is
-- false (renderStatus / Look draw nothing); one small label, bottom left, shows the status, and
-- the show / hide button flips it. getgenv().CometHeadless = true asks for it (to test it).
-- A stand-in tab: its elements go in "flags" (also used for one tab Rayfield refused to make).
function SESSION.stubTab(flags)
    local function noop() end
    local function element(kind, o)
        local e = { Type = kind }
        if type(o) == "table" then
            for k, v in pairs(o) do e[k] = v end
        elseif o ~= nil then
            e.Name = tostring(o)
        end
        if kind == "Dropdown" then
            local c = e.CurrentOption
            e.CurrentOption = type(c) == "table" and table.clone(c) or (c ~= nil and { c } or {})
            if type(e.Options) ~= "table" then e.Options = {} end
        end
        function e:Set(v)
            if kind == "Dropdown" then
                v = type(v) == "table" and v or { v }
                if not self.MultipleOptions then v = { v[1] } end
                self.CurrentOption = v
            elseif kind == "Keybind" then
                self.CurrentKeybind = v
                return
            elseif kind == "Paragraph" or kind == "Label" or kind == "Section" or kind == "Divider" or kind == "Button" then
                self.Value = v                    -- text only: a button's action never runs from here
                return
            elseif kind == "ColorPicker" then
                self.Color = v
            else
                self.CurrentValue = v
            end
            if type(self.Callback) == "function" then
                local okC, err = pcall(self.Callback, v)
                if not okC then warn("[Cometium Fusions] " .. tostring(self.Name) .. ": " .. tostring(err)) end
            end
        end
        function e:Refresh(opts)
            if kind == "Dropdown" then self.Options = type(opts) == "table" and opts or {} end
        end
        e.Lock, e.Unlock, e.Destroy, e.SetVisible = noop, noop, noop, noop
        if type(e.Flag) == "string" and e.Flag ~= "" and type(flags) == "table" then flags[e.Flag] = e end
        return e
    end
    local tab = {}
    for _, kind in ipairs({ "Toggle", "Slider", "Dropdown", "Input", "Button", "Paragraph", "Section",
                            "Keybind", "ColorPicker", "Label", "Divider" }) do
        tab["Create" .. kind] = function(_, o) return element(kind, o) end
    end
    return tab
end

function SESSION.headless(why)
    local R = { Flags = {}, Theme = {}, headless = true, hidden = false,
                reason = SESSION.uiWhy or "UI library unreachable" }
    local function noop() end
    local tab = SESSION.stubTab(R.Flags)
    local win = { ModifyTheme = noop, CreateTab = function() return tab end }
    function R:CreateWindow() return win end
    function R:Notify(n)
        local t = type(n) == "table" and n or {}
        local text = tostring(t.Title or "") .. ": " .. tostring(t.Content or "")
        print("[Cometium Fusions] " .. text)
        R.toast = { text = text, at = os.clock() }
    end
    function R:IsVisible() return false end              -- nothing to draw: renderStatus / Look skip
    function R:SetVisibility()                            -- callers pass "not IsVisible()": a flip
        R.hidden = not R.hidden
        ui(function() if R.gui then R.gui.Enabled = not R.hidden end end)
    end
    R.LoadConfiguration, R.SaveConfiguration = noop, noop
    function R:Destroy()
        R.dead = true
        local g = R.gui
        R.gui, R.txt = nil, nil
        if g then pcall(function() g:Destroy() end) end
    end
    ui(function()                                         -- built on the clean queue thread
        if R.dead or not alive() then return end
        local sg = Instance.new("ScreenGui")
        sg.Name, sg.ResetOnSpawn, sg.DisplayOrder = "CometHeadless", false, 998
        local t = Instance.new("TextLabel")
        t.AnchorPoint, t.Position, t.Size = Vector2.new(0, 1), UDim2.new(0, 10, 1, -10), UDim2.new(0.6, 0, 0, 0)
        t.AutomaticSize = Enum.AutomaticSize.Y
        t.BackgroundColor3, t.BackgroundTransparency, t.BorderSizePixel = Color3.fromRGB(14, 17, 30), 0.15, 0
        t.Font, t.TextSize, t.TextColor3 = Enum.Font.GothamBold, 13, Color3.fromRGB(236, 240, 255)
        t.TextWrapped, t.TextXAlignment, t.TextYAlignment = true, Enum.TextXAlignment.Left, Enum.TextYAlignment.Top
        t.Text = "Cometium Fusions running without its window (" .. R.reason .. ")"
        local cap = Instance.new("UISizeConstraint")
        cap.MaxSize = Vector2.new(420, 400)
        cap.Parent = t
        local pad = Instance.new("UIPadding")
        pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 8), UDim.new(0, 8)
        pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 10), UDim.new(0, 10)
        pad.Parent = t
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = t
        t.Parent = sg
        if SESSION.parentGui(sg) then R.gui, R.txt = sg, t else sg:Destroy() end
    end)
    task.spawn(function()                                 -- reads S only; every write through ui()
        while alive() and not R.dead do
            local toast = R.toast and os.clock() - R.toast.at < 6 and ("\n" .. R.toast.text) or ""
            local text = ("Cometium Fusions running without its window (%s)\nStatus: %s\n%s%s"):format(
                R.reason, tostring(S.status), tostring(S.log[1] or ""), toast)
            ui(function() if R.txt and R.txt.Text ~= text then R.txt.Text = text end end)
            task.wait(1)
        end
    end)
    warn("[Cometium Fusions] running WITHOUT its window (" .. R.reason .. "): " .. tostring(why)
        .. " — the farm runs on your saved settings / defaults (getgenv().CometConfig works too)")
    return R
end

-- Executor differences: some have no game:HttpGet (only request / http_request / syn.request /
-- http.request), some call loadstring "load", some can't reach sirius.menu, and some fetch it
-- fine but Rayfield itself won't start there. Tried in order: sirius.menu → the official GitHub
-- copy → the copy cached in the workspace (CometHub/rayfield_cache.lua, written after each good
-- download). A download waits 30 s at most (one that never answered left the hub at nothing).
-- All of them fail = HEADLESS (above): the farm runs anyway, the reason is in the console.
pcall(function() getgenv().DISABLE_RAYFIELD_REQUESTS = true end)
local okR, Rayfield = pcall(function()
    local okE, env = pcall(getgenv)
    if okE and type(env) == "table" and env.CometHeadless == true then
        SESSION.uiWhy = "asked by the loader: getgenv().CometHeadless"
        error("getgenv().CometHeadless = true", 0)
    end
    local compile = loadstring or load
    if type(compile) ~= "function" then
        SESSION.uiWhy = "this executor has no loadstring"
        error("no loadstring / load on this executor", 0)
    end
    local CACHE = "CometHub/rayfield_cache.lua"
    local function fetch(url)                      -- the body, or nil after 30 s / every way failed
        local box = {}
        task.spawn(function()
            local okH, b = pcall(function() return game:HttpGet(url) end)
            if not (okH and type(b) == "string" and b ~= "") then
                okH, b = pcall(function() return game:HttpGetAsync(url) end)
            end
            if not (okH and type(b) == "string" and b ~= "") then
                b = nil
                for _, pick in ipairs({
                    function() return request end, function() return http_request end,
                    function() return syn and syn.request end, function() return http and http.request end,
                    function() return fluxus and fluxus.request end,
                }) do
                    local okP, req = pcall(pick)
                    if okP and type(req) == "function" then
                        local okQ, res = pcall(req, { Url = url, Method = "GET" })
                        local rb = okQ and type(res) == "table" and (res.Body or res.body)
                        if type(rb) == "string" and rb ~= "" and (tonumber(res.StatusCode) or 200) < 400 then
                            b = rb
                            break
                        end
                    end
                end
            end
            box.body, box.done = b, true
        end)
        local t0 = os.clock()
        while not box.done and os.clock() - t0 < 30 do task.wait(0.1) end
        return box.body
    end
    local function start(body, from)               -- the library, or nil + why
        local okC, fn, cerr = pcall(compile, body)
        if not (okC and type(fn) == "function") then
            return nil, from .. ": doesn't compile (" .. tostring(okC and cerr or fn) .. ")"
        end
        local okL, lib = pcall(fn)
        if okL and type(lib) == "table" and type(lib.CreateWindow) == "function" then return lib end
        return nil, from .. ": " .. (okL and "no library returned" or tostring(lib))
    end
    local errs, fetched = {}, false
    for _, url in ipairs({ "https://sirius.menu/rayfield",
                           "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua" }) do
        local body = fetch(url)
        if body then
            fetched = true
            local lib, err = start(body, url)
            if lib then
                -- a copy for the day these sites don't answer: a full library only, and only when it
                -- changed (many accounts start at once on one PC)
                pcall(function()
                    if #body < 20000 or type(writefile) ~= "function" then return end
                    if isfile and isfile(CACHE) and readfile(CACHE) == body then return end
                    if not (isfolder and isfolder("CometHub")) and makefolder then pcall(makefolder, "CometHub") end
                    writefile(CACHE, body)
                end)
                return lib
            end
            errs[#errs + 1] = err
        else
            errs[#errs + 1] = url .. ": no answer"
        end
    end
    local okF, cached = pcall(function() return isfile(CACHE) and readfile(CACHE) or nil end)
    if okF and type(cached) == "string" and cached ~= "" then
        local lib, err = start(cached, "cached copy")
        if lib then
            log("window: the sites didn't answer — the cached copy of the window library is used")
            return lib
        end
        errs[#errs + 1] = err
    end
    SESSION.uiWhy = fetched and "UI library failed to start on this executor" or "UI library unreachable"
    error(table.concat(errs, " · "), 0)
end)
if not okR or type(Rayfield) ~= "table" then
    Rayfield = SESSION.headless(Rayfield)
end

local function notify(title, text)
    ui(function() Rayfield:Notify({ Title = title, Content = text, Duration = 4, Image = 4483362458 }) end)
end

-- Comet look: deep navy with one accent colour (Settings → Look swaps it live through
-- Window.ModifyTheme, which takes a theme name or a colour table).
local ACCENTS = {
    Cyan = Color3.fromRGB(96, 206, 255), Pink = Color3.fromRGB(255, 110, 190),
    Purple = Color3.fromRGB(160, 120, 255), Green = Color3.fromRGB(90, 220, 140),
    Gold = Color3.fromRGB(255, 200, 60), Red = Color3.fromRGB(255, 96, 96),
}
local BLACK, WHITE = Color3.new(0, 0, 0), Color3.new(1, 1, 1)
local function cometTheme(accentName)
    local a = ACCENTS[accentName] or ACCENTS.Cyan
    local rgb = Color3.fromRGB
    return {
        TextColor = rgb(236, 240, 255),
        Background = rgb(14, 17, 30), Topbar = rgb(20, 24, 42), Shadow = rgb(8, 10, 18),
        NotificationBackground = rgb(16, 19, 34), NotificationActionsBackground = rgb(230, 234, 250),
        TabBackground = rgb(30, 36, 60), TabStroke = rgb(44, 52, 84), TabBackgroundSelected = a,
        TabTextColor = rgb(200, 208, 235), SelectedTabTextColor = rgb(12, 14, 24),
        ElementBackground = rgb(24, 29, 50), ElementBackgroundHover = rgb(30, 36, 62),
        SecondaryElementBackground = rgb(18, 22, 38),
        ElementStroke = rgb(40, 48, 78), SecondaryElementStroke = rgb(34, 40, 66),
        SliderBackground = a:Lerp(BLACK, 0.55), SliderProgress = a, SliderStroke = a:Lerp(WHITE, 0.2),
        ToggleBackground = rgb(20, 24, 42), ToggleEnabled = a, ToggleDisabled = rgb(70, 78, 104),
        ToggleEnabledStroke = a:Lerp(WHITE, 0.25), ToggleDisabledStroke = rgb(90, 98, 124),
        ToggleEnabledOuterStroke = a:Lerp(BLACK, 0.4), ToggleDisabledOuterStroke = rgb(44, 50, 74),
        DropdownSelected = rgb(34, 42, 72), DropdownUnselected = rgb(24, 29, 50),
        InputBackground = rgb(20, 24, 42), InputStroke = rgb(48, 56, 90), PlaceholderColor = rgb(130, 140, 170),
    }
end

-- Guarded (2026-10-13): a Rayfield that loaded but throws while building its window (a function
-- it needs is missing or refuses on this executor) ended the whole file here, before the farm.
-- Now the partial window goes and the headless stand-in takes over; the farm still runs.
local Window = (function(opts)
    local okW, w = pcall(function() return Rayfield:CreateWindow(opts) end)
    if okW and type(w) == "table" then return w end
    pcall(function() Rayfield:Destroy() end)
    SESSION.uiWhy = "UI library failed to start on this executor"
    Rayfield = SESSION.headless("CreateWindow: " .. tostring(w))
    return Rayfield:CreateWindow(opts)
end)({
    Name = "Cometium Fusions · Adopt Me",
    Icon = "paw-print",
    LoadingTitle = "Cometium Fusions",
    LoadingSubtitle = "farm · pets · shop · transfer",
    Theme = cometTheme("Cyan"),
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    -- one settings file PER ACCOUNT (2026-10-10): a shared file made every account on the PC
    -- copy the last one's choices — Draven bought 2 Skelicorns ticked on ultra
    ConfigurationSaving = { Enabled = true, FolderName = "CometHub",
        FileName = "AdoptMe_v4_" .. tostring(LP.Name):gsub("[^%w_]", "") },
    Discord = { Enabled = false, Invite = "", RememberJoins = true },
    KeySystem = false,
})

-- Forward declarations: the UI is built before the game layer exists.
local Baby, Farm, Eggs, Potion, Neon, Release, Shop, Floor, Kinds, PetList, Home, License, Pay
local Trade, Popups, Pref, Hallo, Crowd, Haunt, Track, Saver
-- Rayfield elements the game layer writes to. A table, not locals: the main chunk is near
-- Luau's 200-locals-per-function limit ("Out of local registers" at compile).
local UI = {}
-- Rayfield's ScreenGui. Rayfield parents it to gethui() when the executor has one, else to
-- CoreGui.RobloxGui (else CoreGui) — the Look code looked only in gethui() / CoreGui, so on an
-- executor without gethui the side tabs, the taller window, the pictures and the gold Premium page
-- silently never applied. nil when headless.
function UI.rayRoot()
    if type(Rayfield) ~= "table" or Rayfield.headless then return nil end
    local root
    pcall(function() root = gethui():FindFirstChild("Rayfield") end)
    if root then return root end
    pcall(function()
        local cg = game:GetService("CoreGui")
        root = cg:FindFirstChild("Rayfield")
        if not root and cg:FindFirstChild("RobloxGui") then root = cg.RobloxGui:FindFirstChild("Rayfield") end
    end)
    if root then return root end
    pcall(function() root = LP:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Rayfield") end)
    return root
end
-- the shipped defaults, copied before any saved setting loads (Farm › "Recommended settings")
UI.DEFAULTS = {}
for k, v in pairs(C) do UI.DEFAULTS[k] = type(v) == "table" and table.clone(v) or v end

-- A one-choice dropdown saved empty ({}) makes Rayfield's loader set its label to nil
-- ("Unable to assign property Text. string expected, got nil", x3 at launch): those are
-- skipped, then the saved config loads as usual. (A function: no room for loop locals at the
-- bottom of the main chunk.)
function UI.loadConfig()
    for _, f in pairs(Rayfield.Flags or {}) do
        if type(f) == "table" and type(f.CurrentOption) == "table" and not f.MultipleOptions and type(f.Set) == "function" then
            local set = f.Set
            f.Set = function(self, v)
                if type(v) == "table" and v[1] == nil then return end
                return set(self, v)
            end
        end
    end
    Rayfield:LoadConfiguration()
end
local Booted = { ready = false }

local function refreshLists(filter)
    task.spawn(function()
        if Kinds and Kinds.ready then Kinds:build() Kinds:refresh(filter or "") end
        if PetList and PetList.ready then PetList:refresh(filter or "") end
        if Eggs and Eggs.ready then Eggs:build() end
    end)
end

-- Tabs with a Lucide icon (names checked against Rayfield's icon pack); plain tab if the
-- pack didn't load, since an unknown name makes Rayfield throw.
local function newTab(name, icon)
    local ok, tab = pcall(function() return Window:CreateTab(name, icon) end)
    if ok and tab then return tab end
    ok, tab = pcall(function() return Window:CreateTab(name, 4483362458) end)
    if ok and tab then return tab end
    -- Rayfield refused this tab twice: its switches become stand-ins (their defaults stay in C, and
    -- the Saver / CometConfig / a template still set C) instead of ending the whole file here
    warn("[Cometium Fusions] tab \"" .. tostring(name) .. "\" couldn't be made: " .. tostring(tab))
    return SESSION.stubTab({})
end

-- Rayfield's ChangeTheme recolours backgrounds and text but not the tab buttons, toggle
-- switches or slider bars (seen live: the selected tab kept the old accent), so those
-- are repainted here. Selected tab = the opaque one; a toggle is on when its knob sits
-- at X offset -20 (off = -40).
local function repaintRayfield(theme)
    local root = UI.rayRoot()
    local main = root and root:FindFirstChild("Main")
    if not (main and type(theme) == "table") then return end
    for _, t in ipairs(main.TabList:GetChildren()) do
        if t:IsA("Frame") and t:FindFirstChild("Title") and t.Name ~= "Template" then
            local sel = t.BackgroundTransparency < 0.5
            t.BackgroundColor3 = sel and theme.TabBackgroundSelected or theme.TabBackground
            t.Title.TextColor3 = sel and theme.SelectedTabTextColor or theme.TabTextColor
            if t:FindFirstChild("Image") then t.Image.ImageColor3 = t.Title.TextColor3 end
            if t:FindFirstChild("UIStroke") then t.UIStroke.Color = theme.TabStroke end
        end
    end
    for _, page in ipairs(main.Elements:GetChildren()) do
        for _, el in ipairs(page:GetChildren()) do
            local sw = el:FindFirstChild("Switch")
            local knob = sw and sw:FindFirstChild("Indicator")
            if knob then
                local on = knob.Position.X.Offset > -30
                sw.BackgroundColor3 = theme.ToggleBackground
                knob.BackgroundColor3 = on and theme.ToggleEnabled or theme.ToggleDisabled
                if knob:FindFirstChild("UIStroke") then
                    knob.UIStroke.Color = on and theme.ToggleEnabledStroke or theme.ToggleDisabledStroke
                end
                if sw:FindFirstChild("UIStroke") then
                    sw.UIStroke.Color = on and theme.ToggleEnabledOuterStroke or theme.ToggleDisabledOuterStroke
                end
            end
            local bar = el:FindFirstChild("Main")
            if bar and bar:FindFirstChild("Progress") then
                bar.BackgroundColor3 = theme.SliderBackground
                bar.Progress.BackgroundColor3 = theme.SliderProgress
                if bar:FindFirstChild("UIStroke") then bar.UIStroke.Color = theme.SliderStroke end
                if bar.Progress:FindFirstChild("UIStroke") then bar.Progress.UIStroke.Color = theme.SliderStroke end
            end
        end
    end
end

-- Theme picker: applied once after both dropdowns settle (each ModifyTheme notifies).
local Look = { theme = "Comet", accent = "Cyan", applied = "Comet|Cyan", pending = false }

-- Taller window, same width (always). Rayfield sizes Main to its fixed
-- height (475) whenever it opens or un-minimizes, so this re-applies after it, every second:
-- only while the window is open (the minimized bar is 45 tall) and not mid-tween (the
-- height must be the same as a second ago). Written on the UI queue (capability split).
function Look:tall()
    ui(function()
        local root = UI.rayRoot()
        local main = root and root:FindFirstChild("Main")
        if not main then return end
        local cam = Workspace.CurrentCamera
        local vy = cam and cam.ViewportSize.Y or 720
        local want = math.floor(math.clamp(vy - 90, 475, 560))
        local h = main.Size.Y.Offset
        if h >= 300 and h ~= want and h == self.lastH then
            main.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, want)
        end
        self.lastH = h
        -- Rayfield keeps its Drag pill 255 px below Main's centre (just under a 475 window) and
        -- puts it back there on every drag frame: keep it 18 px under the real bottom edge
        local drag = root:FindFirstChild("Drag")
        local nh = main.Size.Y.Offset
        if drag and nh >= 300 and nh == want
           and not game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local p = main.Position
            drag.Position = UDim2.new(p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset + math.floor(nh / 2) + 18)
        end
    end)
end
-- Tabs as a column of icons down the left side (asked 2026-10-10, like other hubs), the page
-- on the right; the open tab's name goes in the title bar. Re-applied every second, so a
-- Rayfield re-layout (minimise, search, theme) never brings the top row back. Off = Rayfield's
-- usual row of tabs on top (Settings › "Tabs down the left side").
Look.SIDE_W, Look.WIDE = 50, 540
-- Premium's gold (2026-10-12), and the accent in use: gold while Premium's gold theme is on
Look.GOLD = Color3.fromRGB(255, 200, 60)
function Look.acc() return ACCENTS[Look.gold and "Gold" or Look.accent] or ACCENTS.Cyan end
function Look.styleTab(tab, pl)
    local img = tab:FindFirstChild("Image")
    if not img then return end
    local open = pl and pl.CurrentPage and pl.CurrentPage.Name == tab.Name
    local accent = Look.acc()
    local want = open and accent or Color3.fromRGB(150, 158, 186)
    if tab.Name == "Premium" then want = Look.GOLD end      -- the Premium crown is always gold
    if tab.BackgroundTransparency ~= 1 then tab.BackgroundTransparency = 1 end
    local stroke = tab:FindFirstChildOfClass("UIStroke")
    if stroke and stroke.Transparency ~= 1 then stroke.Transparency = 1 end
    if img.ImageColor3 ~= want then img.ImageColor3 = want end
    img.Size = open and UDim2.new(0, 25, 0, 25) or UDim2.new(0, 22, 0, 22)
    img.ImageTransparency = open and 0 or 0.15
    local bar = tab:FindFirstChild("CFBar")
    if bar then bar:Destroy() end
end
-- Pictures (asked 2026-10-12): a strip of tiles — picture, name, one line under it, an N / M
-- badge — inside the Rayfield paragraph with this title. Tiles are reused; only what changed is
-- written. Called from renderStatus' ui() batch.
function Look.gallery(title, items)
    local root = UI.rayRoot()
    local main = root and root:FindFirstChild("Main")
    local el = main and main:FindFirstChild("Elements")
    if not el then return end
    Look.cards = Look.cards or {}
    local card = Look.cards[title]
    if not (card and card.Parent) then
        card = nil
        for _, page in ipairs(el:GetChildren()) do
            for _, c in ipairs(page:GetChildren()) do
                local t = c:IsA("Frame") and c:FindFirstChild("Title")
                if t and t:IsA("TextLabel") and t.Text == title then card = c break end
            end
            if card then break end
        end
        if not card then return end
        Look.cards[title] = card
    end
    local strip = card:FindFirstChild("CFGallery")
    if not strip then
        strip = Instance.new("ScrollingFrame")
        strip.Name = "CFGallery"
        strip.BackgroundTransparency, strip.BorderSizePixel = 1, 0
        strip.Position, strip.Size = UDim2.new(0, 10, 0, 30), UDim2.new(1, -20, 0, 108)
        strip.ScrollingDirection, strip.AutomaticCanvasSize = Enum.ScrollingDirection.X, Enum.AutomaticSize.X
        strip.CanvasSize, strip.ScrollBarThickness = UDim2.new(), 3
        local l = Instance.new("UIListLayout")
        l.FillDirection, l.Padding, l.SortOrder = Enum.FillDirection.Horizontal, UDim.new(0, 8), Enum.SortOrder.LayoutOrder
        l.Parent = strip
        local empty = Instance.new("TextLabel")
        empty.Name, empty.BackgroundTransparency, empty.Size = "Empty", 1, UDim2.new(0, 300, 1, 0)
        empty.Font, empty.TextSize, empty.TextColor3 = Enum.Font.Gotham, 12, Color3.fromRGB(150, 158, 186)
        empty.TextXAlignment, empty.LayoutOrder = Enum.TextXAlignment.Left, 999
        empty.Parent = strip
        strip.Parent = card
        local content = card:FindFirstChild("Content")
        if content then content.Visible = false end
    end
    local h = #items > 0 and 146 or 56
    if card.Size.Y.Offset ~= h then card.Size = UDim2.new(card.Size.X.Scale, card.Size.X.Offset, 0, h) end
    strip.Size = UDim2.new(1, -20, 0, #items > 0 and 108 or 20)
    strip.Empty.Visible = #items == 0
    strip.Empty.Text = items.empty or "nothing here yet"
    local accent = Look.acc()
    for i, it in ipairs(items) do
        local tile = strip:FindFirstChild("T" .. i)
        if not tile then
            tile = Instance.new("Frame")
            tile.Name, tile.LayoutOrder = "T" .. i, i
            tile.Size, tile.BackgroundColor3, tile.BackgroundTransparency = UDim2.new(0, 96, 0, 102), Color3.fromRGB(28, 30, 38), 0.15
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = tile
            local img = Instance.new("ImageLabel")
            img.Name, img.BackgroundTransparency, img.ScaleType = "Img", 1, Enum.ScaleType.Fit
            img.Size, img.Position = UDim2.new(0, 54, 0, 54), UDim2.new(0.5, -27, 0, 5)
            img.Parent = tile
            local function label(name, y, size, font, color, hgt)
                local t = Instance.new("TextLabel")
                t.Name, t.BackgroundTransparency = name, 1
                t.Position, t.Size = UDim2.new(0, 4, 0, y), UDim2.new(1, -8, 0, hgt)
                t.Font, t.TextSize, t.TextColor3 = font, size, color
                t.TextWrapped, t.TextTruncate = true, Enum.TextTruncate.AtEnd
                t.Parent = tile
                return t
            end
            label("Lbl", 60, 11, Enum.Font.GothamBold, Color3.fromRGB(235, 238, 248), 14)
            label("Sub", 74, 10, Enum.Font.Gotham, Color3.fromRGB(150, 158, 186), 26)
            local b = label("Badge", 3, 10, Enum.Font.GothamBlack, Color3.new(1, 1, 1), 14)
            b.Position, b.Size = UDim2.new(1, -24, 0, 3), UDim2.new(0, 20, 0, 14)
            b.BackgroundTransparency = 0
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 4)
            bc.Parent = b
            tile.Parent = strip
        end
        tile.Visible = true
        if tile.Img.Image ~= (it.img or "") then tile.Img.Image = it.img or "" end
        if tile.Lbl.Text ~= it.title then tile.Lbl.Text = it.title end
        if tile.Sub.Text ~= (it.sub or "") then tile.Sub.Text = it.sub or "" end
        tile.Badge.Visible = it.badge ~= nil
        if it.badge then
            tile.Badge.Text = it.badge
            tile.Badge.BackgroundColor3 = it.badge == "M" and Color3.fromRGB(170, 80, 230) or accent
        end
        local stroke = tile:FindFirstChildOfClass("UIStroke")
        if it.busy and not stroke then
            stroke = Instance.new("UIStroke")
            stroke.Thickness, stroke.Color = 1.5, accent
            stroke.Parent = tile
        elseif not it.busy and stroke then
            stroke:Destroy()
        end
    end
    for _, c in ipairs(strip:GetChildren()) do
        local n = c:IsA("Frame") and tonumber(c.Name:sub(2))
        if n and n > #items then c.Visible = false end
    end
end

function Look:sidebar()
    ui(function()
        local root = UI.rayRoot()
        local main = root and root:FindFirstChild("Main")
        local tl = main and main:FindFirstChild("TabList")
        local el = main and main:FindFirstChild("Elements")
        local list = tl and tl:FindFirstChildOfClass("UIListLayout")
        if not (tl and el and list) then return end
        local on = C.SideTabs ~= false
        if not on and not self.sideOn then return end
        if not on then                                   -- put Rayfield's own layout back
            self.sideOn = false
            list.FillDirection, list.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 6)
            list.VerticalAlignment = Enum.VerticalAlignment.Center
            tl.AnchorPoint, tl.Position, tl.Size = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0, 72), UDim2.new(1, -25, 0, 36)
            tl.ScrollingDirection, tl.AutomaticCanvasSize = Enum.ScrollingDirection.X, Enum.AutomaticSize.X
            el.AnchorPoint, el.Position, el.Size = Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, 0), UDim2.new(1, 0, 1, -100)
            if main.Size.X.Offset == Look.WIDE then main.Size = UDim2.new(main.Size.X.Scale, 500, main.Size.Y.Scale, main.Size.Y.Offset) end
            local top = main:FindFirstChild("Topbar")
            if top and top.Size.X.Offset == Look.WIDE then top.Size = UDim2.new(0, 500, 0, top.Size.Y.Offset) end
            for _, tab in ipairs(tl:GetChildren()) do
                local title, img = tab:FindFirstChild("Title"), tab:FindFirstChild("Image")
                if tab:IsA("Frame") and title and img and title:IsA("TextLabel") then
                    title.Visible = true
                    img.AnchorPoint, img.Position = Vector2.new(0, 0.5), UDim2.new(0, 11, 0.5, 0)
                    tab.Size = UDim2.new(0, title.TextBounds.X + 52, 0, 30)
                end
            end
            return
        end
        self.sideOn = true
        local w = Look.SIDE_W
        local pl
        list.FillDirection, list.Padding = Enum.FillDirection.Vertical, UDim.new(0, 8)
        list.HorizontalAlignment, list.VerticalAlignment = Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top
        tl.AnchorPoint, tl.Position, tl.Size = Vector2.new(0, 0), UDim2.new(0, 6, 0, 54), UDim2.new(0, w, 1, -62)
        tl.ScrollingDirection, tl.AutomaticCanvasSize = Enum.ScrollingDirection.Y, Enum.AutomaticSize.Y
        tl.CanvasSize, tl.ScrollBarThickness = UDim2.new(0, 0, 0, 0), 0
        local want = UDim2.new(1, -(w + 14), 1, -54)
        -- a little wider than Rayfield's 500 px: the page keeps its width next to the tab column
        local top = main:FindFirstChild("Topbar")
        if main.Size.X.Offset == 500 and main.Size.Y.Offset >= 300 then
            main.Size = UDim2.new(main.Size.X.Scale, Look.WIDE, main.Size.Y.Scale, main.Size.Y.Offset)
        end
        if top and top.Size.X.Offset == 500 then top.Size = UDim2.new(0, Look.WIDE, 0, top.Size.Y.Offset) end
        local resized = el.Size ~= want
        el.AnchorPoint, el.Position, el.Size = Vector2.new(1, 1), UDim2.new(1, -2, 1, -6), want
        -- the page layout keeps the old width until it jumps again: re-centre the open page
        pl = el:FindFirstChildOfClass("UIPageLayout")
        if resized and pl and pl.CurrentPage then task.defer(function() pcall(pl.JumpTo, pl, pl.CurrentPage) end) end
        -- Rayfield paragraphs are 438 px wide and pinned to the right edge (made for the full
        -- width): in the narrower page they ran off the left side. Make them stretch instead.
        for _, page in ipairs(el:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                for _, card in ipairs(page:GetChildren()) do
                    for _, k in ipairs({ "Title", "Content" }) do
                        local t = card:IsA("Frame") and card:FindFirstChild("Content") and card:FindFirstChild(k)
                        if t and t:IsA("TextLabel") and t.AnchorPoint.X == 1 and t.Size.X.Scale == 0 then
                            t.AnchorPoint = Vector2.new(0, t.AnchorPoint.Y)
                            t.Position = UDim2.new(0, 12, t.Position.Y.Scale, t.Position.Y.Offset)
                            t.Size = UDim2.new(1, -24, t.Size.Y.Scale, t.Size.Y.Offset)
                        end
                    end
                end
            end
        end
        for _, tab in ipairs(tl:GetChildren()) do
            local title, img, hit = tab:FindFirstChild("Title"), tab:FindFirstChild("Image"), tab:FindFirstChild("Interact")
            if tab:IsA("Frame") and title and img and title:IsA("TextLabel") then
                title.Visible = false
                tab.Size = UDim2.new(0, w - 8, 0, w - 8)
                img.AnchorPoint, img.Position, img.Size = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 22, 0, 22)
                -- icons only (asked 2026-10-10): the open tab's icon in the accent colour and a bit
                -- bigger, the others dim — no tile, no bar. Rayfield re-tweens the tiles on every
                -- tab click and when the window opens: re-applied the moment it touches them.
                Look.styleTab(tab, pl)
                if not tab:GetAttribute("CFStyled") then
                    tab:SetAttribute("CFStyled", true)
                    local function again() if Look.sideOn then Look.styleTab(tab, pl) end end
                    tab:GetPropertyChangedSignal("BackgroundTransparency"):Connect(again)
                    img:GetPropertyChangedSignal("ImageColor3"):Connect(again)
                    if pl and not pl:GetAttribute("CFStyled") then
                        pl:SetAttribute("CFStyled", true)
                        pl:GetPropertyChangedSignal("CurrentPage"):Connect(function()
                            if not Look.sideOn then return end
                            for _, t in ipairs(tl:GetChildren()) do
                                if t:IsA("Frame") and t:GetAttribute("CFStyled") then Look.styleTab(t, pl) end
                            end
                        end)
                    end
                end
                -- the open tab's name in the title bar (icons alone don't say where you are)
                if hit and hit:IsA("GuiButton") and not tab:GetAttribute("CFNamed") then
                    tab:SetAttribute("CFNamed", true)
                    hit.MouseButton1Click:Connect(function()
                        local top = main:FindFirstChild("Topbar")
                        local t = top and top:FindFirstChild("Title")
                        if t and t:IsA("TextLabel") then t.Text = "Cometium Fusions · " .. tostring(title.Text) end
                        task.delay(0.35, function() pcall(Look.sidebar, Look) end)
                    end)
                end
            end
        end
    end)
end
function Look:set(theme, accent)
    self.theme, self.accent = theme or self.theme, accent or self.accent
    if self.pending then return end
    self.pending = true
    task.delay(0.4, function()
        self.pending = false
        -- Premium's gold theme (Premium tab) wins over the picked theme while it is on
        local th, ac = self.theme, self.accent
        if self.gold then th, ac = "Comet", "Gold" end
        local key = th .. "|" .. ac
        if key == self.applied then return end
        self.applied = key
        local theme = th == "Comet" and cometTheme(ac) or th
        pcall(function() Window.ModifyTheme(theme) end)
        if type(theme) == "string" then theme = Rayfield.Theme and Rayfield.Theme[theme] end
        pcall(repaintRayfield, theme)
    end)
end

-- Premium (2026-10-12), every second from the status loop: the gold theme while it is on and the
-- key is Premium, the Premium tab's status, and that page in gold (paragraph / section / button
-- titles, outlines) with "(Premium)" after each switch while the key isn't. Only the Premium page
-- (and its tab) is touched; every GUI write goes through ui().
function Look.premium()
    local prem = Track ~= nil and Track:isPremium()
    local gold = prem and C.GoldTheme == true
    if gold ~= (Look.gold == true) then
        Look.gold = gold
        ui(function() Look:set() end)
    end
    local text = Look.premiumInfo(prem)
    ui(function()
        if UI.PPremium and text ~= UI.premText then
            UI.premText = text
            UI.PPremium:Set({ Title = "★ PREMIUM", Content = text })
        end
        local root = UI.rayRoot()
        local main = root and root:FindFirstChild("Main")
        local tl, el = main and main:FindFirstChild("TabList"), main and main:FindFirstChild("Elements")
        local gc = Look.GOLD
        -- tabs on top (Settings › side tabs off): the Premium tab's name and crown in gold while not open
        local tab = tl and tl:FindFirstChild("Premium")
        if tab and tab:IsA("Frame") and not Look.sideOn and tab.BackgroundTransparency >= 0.5 then
            local t, img = tab:FindFirstChild("Title"), tab:FindFirstChild("Image")
            if t and t:IsA("TextLabel") and t.TextColor3 ~= gc then t.TextColor3 = gc end
            if img and img:IsA("ImageLabel") and img.ImageColor3 ~= gc then img.ImageColor3 = gc end
        end
        local page = el and el:FindFirstChild("Premium")
        if not page then return end
        for _, e in ipairs(page:GetChildren()) do
            local title = e:IsA("Frame") and e:FindFirstChild("Title")
            if title and title:IsA("TextLabel") then
                local stroke = e:FindFirstChildOfClass("UIStroke")
                if stroke and stroke.Color ~= gc then stroke.Color = gc end
                if e:FindFirstChild("Switch") then
                    local base = e:GetAttribute("CFBase")
                    if type(base) ~= "string" then base = title.Text e:SetAttribute("CFBase", base) end
                    local want = prem and base or (base .. "  (Premium)")
                    if title.Text ~= want then title.Text = want end
                elseif e:FindFirstChild("Content") or not stroke
                       or (e:FindFirstChild("Interact") and not e:FindFirstChild("InputFrame")) then
                    if title.TextColor3 ~= gc then title.TextColor3 = gc end
                end
            end
        end
    end)
end
-- The Premium tab's status line.
function Look.premiumInfo(prem)
    local p = Track and Track.premium
    local hasKey = Track ~= nil and #Track:key() >= 12
    if prem and p then
        local left = p.days and (("%d day%s left"):format(p.days, p.days == 1 and "" or "s")
            .. (p.expires_at and (" (until " .. tostring(p.expires_at):sub(1, 10) .. " UTC" .. ")") or "")) or "lifetime"
        return "✓ Active" .. (p.label and (" — " .. p.label) or "") .. " · " .. left
            .. "\nDashboard, remote control, the Halloween extras and the gold theme are unlocked."
    end
    if p and p.expired then
        return "Expired" .. (p.expires_at and (" on " .. tostring(p.expires_at):sub(1, 10) .. " UTC") or "")
            .. " — renew it to get the dashboard, remote control, the Halloween extras and the gold theme back. "
            .. "The farm and Halloween keep running."
    end
    if hasKey and p and p.invalid then
        return "This key isn't valid (unknown or revoked). The farm and Halloween stay free."
    end
    if hasKey and not p then
        return Track.premiumErr and "Comet Track isn't answering — checked again in a minute." or "Checking your key…"
    end
    return "Free — the whole farm and all of Halloween are free. Paste a Premium key below for the extras "
        .. "(Get Premium copies the link)."
end

-- UI TABS, under pcall (2026-10-13): one element Rayfield throws on (a build that behaves
-- differently on this executor) ended the whole file here — the window half-built, the boot below
-- never run, nothing farming. Now the rest of the hub runs on; the error goes to the console + log.
UI.tabsOk, UI.tabsErr = pcall(function()  -- the tab handles (TFarm, TPets…) live only while the
    -- window is built — the main chunk is at Luau's 200-local limit
------------------------------------------------------------------------------------------------
-- TAB · FARM — status + the switches you actually touch
------------------------------------------------------------------------------------------------

local TFarm = newTab("Farm", "flower-2")
UI.PNow   = TFarm:CreateParagraph({ Title = "Status", Content = "Loading…" })
-- the session's two numbers in the big title line, like Status
UI.PBucks = TFarm:CreateParagraph({ Title = "+$0 bucks this session", Content = "—" })
UI.PPots  = TFarm:CreateParagraph({ Title = "+0 potions this session", Content = "—" })
UI.PNeeds = TFarm:CreateParagraph({ Title = "Needs", Content = "—" })
TFarm:CreateParagraph({ Title = "Your farm", Content = " " })        -- pictures (Look.gallery)

-- one switch (asked 2026-10-12: "make it easier"): off = everything pauses after the step it's on.
-- No Flag, so every launch starts ON (a saved "off" would leave a farm idle by surprise).
-- S.paused: the same switch as the dashboard's Pause / Resume (Premium, Track:runCommand)
UI.TFarming = TFarm:CreateToggle({ Name = "▶ FARMING  (off = pause everything)", CurrentValue = true,
    Callback = function(v)
        S.paused = not v
        S.pausedBy = (not v) and (UI.remoteSet and "remote" or "toggle") or nil
    end })
-- the dashboard's Pause / Resume moves this switch too (called on the push thread: ui queue)
S.onPause = function(on)
    ui(function()
        UI.remoteSet = true
        pcall(function() UI.TFarming:Set(not on) end)
        UI.remoteSet = false
    end)
end
-- back to the recommended settings in one tap (twice, so it's never by accident): farm, Halloween
-- and safety ON; spending (potions, neon, release, eggs, auto buy / send, candy pets) OFF. Your
-- pet / kind / player picks stay. Through Track:apply, so the window and the Saver follow.
UI.KEEP = { Pet1 = true, Pet2 = true, FarmKinds = true, PriorityTypes = true, PotionKinds = true,
    NeonKinds = true, PenPriority = true, PenExclude = true, ReleaseKinds = true, HatchList = true,
    BuyEgg = true, ShopItem = true, ShopCategory = true, ShopSearch = true, PayTo = true, PayAmount = true,
    TradeTo = true, TradeKind = true, TrackKey = true, TrackOn = true, TrackURL = true, SupaURL = true,
    SupaKey = true, SaveSettings = true, SideTabs = true, MobileBtn = true, Theme = true, Accent = true,
    TradeOff = true }   -- the game's own account setting: false would open trade requests to everyone
UI.RECOMMENDED = { BabyFarm = true, PetFarm = true, TaskFloor = true, NoPopups = true, AntiAFK = true,
    AutoRejoin = true, AutoReconnect = true, SaveSettings = true, AutoBuyFood = true,
    HwOn = true, HwGhost = true, HwHaunt = true, HwCrypt = true, HwCat = true, HwDailies = true, HwLever = true,
    Potion = false, Neon = false, Mega = false, ReleaseAuto = false, HatchEggs = false, AutoBuyEggs = false,
    ShopAuto = false, PayAuto = false, HwPets = {}, HwPetMany = false, HwOpenBoxes = false, HwSpendEnd = false }
function UI.recommend()
    if os.clock() - (UI.recAt or -1e9) > 6 then
        UI.recAt = os.clock()
        notify("Recommended settings", "Press again to apply: farm, Halloween and safety ON; potions, neon, "
            .. "release, eggs, auto buy / send and candy pets OFF. Your pet / kind / player picks stay.")
        return
    end
    UI.recAt = nil
    local set = {}
    for k, v in pairs(UI.RECOMMENDED) do set[k] = type(v) == "table" and table.clone(v) or v end
    if Track and Track.apply then Track:apply("Recommended", set, "Recommended settings:") end
    notify("Recommended settings", "Applied — the window shows them.")
end
TFarm:CreateButton({ Name = "Recommended settings (press twice)", Callback = function() UI.recommend() end })

TFarm:CreateSection("Farm")
TFarm:CreateToggle({ Name = "Auto Farm Baby", CurrentValue = true, Flag = "BabyFarm",
    Callback = function(v) C.BabyFarm = v end })
TFarm:CreateToggle({ Name = "Auto Farm Pet", CurrentValue = true, Flag = "PetFarm",
    Callback = function(v) C.PetFarm = v end })
UI.THatch = TFarm:CreateToggle({ Name = "Hatch Eggs", CurrentValue = false,
    Flag = "HatchEggs", Callback = function(v) C.HatchEggs = v end })
TFarm:CreateToggle({ Name = "Task floor over the map (tasks done on it)", CurrentValue = true, Flag = "TaskFloor",
    Callback = function(v)
        C.TaskFloor = v
        -- own thread: apply() reads the game, which must never happen on Rayfield's thread
        if Floor and Booted.ready then task.spawn(function() Floor:apply() end) end
    end })
-- (2026-10-13) like the hub he benchmarks: wait on a small square high in the sky, so only it loads
TFarm:CreateToggle({ Name = "Wait on a small sky square (only it loads — less lag)", CurrentValue = true,
    Flag = "SkyBase", Callback = function(v) C.SkyBase = v end })
-- (sleep / bath / toilet always happen at your house — C.HomeTasks stays on — and the house
-- is set up with the free crib, bath, bowls and litter box by itself when a farm starts)
TFarm:CreateToggle({ Name = "Auto Bonus Bucks potion on the farm pet (x1.2 bucks, kept running)", CurrentValue = true,
    Flag = "BucksPotion", Callback = function(v) C.BucksPotion = v end })
TFarm:CreateToggle({ Name = "Auto Bonus Aging potion on the farm pet (grows faster, kept running)", CurrentValue = false,
    Flag = "AgingPotion", Callback = function(v) C.AgingPotion = v end })

TFarm:CreateSection("Pets")
-- 2026-10-11: a player with an active Pet Handler Pro Certificate farmed 1 pet — the old default
-- "1 pet" (saved with every config). New flag, so those saved "1 pet" are not put back: as many
-- as the game allows (2 with the certificate / Pets Plus, 1 otherwise) unless you choose 1.
TFarm:CreateDropdown({ Name = "Pets at once", Options = { "As many as the game allows", "1 pet only" },
    CurrentOption = { "As many as the game allows" }, MultipleOptions = false, Flag = "PetsOut",
    Callback = function(o)
        C.PetsOut = (type(o) == "table" and o[1]) or o or "As many as the game allows"
        C.PetCount = (C.PetsOut == "1 pet only") and "1 pet" or "2 pets"
    end })
UI.DPet1 = TFarm:CreateDropdown({ Name = "Pet 1", Options = { "Auto" }, CurrentOption = { "Auto" },
    MultipleOptions = false, Flag = "Pet1", Callback = function(o) C.Pet1 = o[1] or "Auto" end })
UI.DPet2 = TFarm:CreateDropdown({ Name = "Pet 2", Options = { "Auto" }, CurrentOption = { "Auto" },
    MultipleOptions = false, Flag = "Pet2", Callback = function(o) C.Pet2 = o[1] or "Auto" end })
-- the kinds you own, picked from a list (no typing): Auto only farms pets of these kinds
UI.DFarmKinds = TFarm:CreateDropdown({ Name = "Farm only these kinds (your pets — none = all)", Options = {},
    CurrentOption = {}, MultipleOptions = true, Flag = "FarmKinds",
    Callback = function(o) C.FarmKinds = type(o) == "table" and o or { o } end })
TFarm:CreateInput({ Name = "Search pets", CurrentValue = "", PlaceholderText = "e.g. dragon",
    RemoveTextAfterFocusLost = false, Flag = "KindSearch", Callback = function(t) refreshLists(t) end })
TFarm:CreateToggle({ Name = "Keep the same pet until it's Full Grown", CurrentValue = true, Flag = "StickyPet",
    Callback = function(v) C.StickyPet = v end })
TFarm:CreateDropdown({ Name = "When a pet is Full Grown",
    Options = { "Switch to the next pet", "Switch, same kind first", "Switch, prioritized kinds first",
                "Keep farming it (bucks)" },
    CurrentOption = { "Switch to the next pet" }, MultipleOptions = false, Flag = "WhenGrown",
    Callback = function(o) C.WhenGrown = o[1] or "Switch to the next pet" end })

TFarm:CreateSection("Buttons")
TFarm:CreateButton({ Name = "Go to the task floor", Callback = function()
    task.spawn(function() if Floor then Floor:goManual() end end)
end })
TFarm:CreateButton({ Name = "Become a Baby", Callback = function()
    task.spawn(function() if Baby then Baby:become(true) end end)
end })
TFarm:CreateButton({ Name = "Become a Parent", Callback = function()
    task.spawn(function() if Baby then Baby:become(false) end end)
end })
UI.PSession = TFarm:CreateParagraph({ Title = "Session", Content = "—" })
UI.PLog     = TFarm:CreateParagraph({ Title = "Log", Content = "—" })

------------------------------------------------------------------------------------------------
-- TAB · PREMIUM — what a Comet Track key unlocks, in gold (2026-10-12). The farm and all of
-- Halloween stay free. Look.premium (every second) writes the status, paints this page gold and
-- puts "(Premium)" after each switch while the key isn't Premium (they do nothing then).
------------------------------------------------------------------------------------------------

local TPrem = newTab("Premium", "crown")
UI.PPremium = TPrem:CreateParagraph({ Title = "★ PREMIUM", Content = "Checking your key…" })
-- the same Flag names as in Settings before (TrackKey / TrackOn / TrackURL): saved settings load
TPrem:CreateInput({ Name = "Premium key (Comet Track)", CurrentValue = "", PlaceholderText = "ct_…",
    RemoveTextAfterFocusLost = false, Flag = "TrackKey", Callback = function(t) C.TrackKey = t end })
TPrem:CreateButton({ Name = "★ Get Premium (copies the link)", Callback = function()
    local url = (Track and Track.PREMIUM_URL) or "https://comet-track.vercel.app/#premium"
    local env = (getgenv and getgenv()) or _G
    local clip = env.setclipboard or env.toclipboard
    local ok = type(clip) == "function" and pcall(clip, url)
    notify("Premium", ok and ("Link copied — open it in your browser: " .. url) or ("Open " .. url .. " in your browser"))
end })
TPrem:CreateParagraph({ Title = "What Premium gives", Content =
    "• Comet Track dashboard: every account live online — bucks, potions, pets, candy, pet pen, log\n"
    .. "• Remote control from the dashboard: pause / resume / rejoin / stop one account or all, one template for all\n"
    .. "• Halloween extras: open Poltergeist Boxes, spend it all in the event's last 12 h, Hauntlet team mode\n"
    .. "• Gold theme for this window\n"
    .. "Free, always: the whole farm and all of Halloween." })
TPrem:CreateSection("Dashboard")
TPrem:CreateToggle({ Name = "Send live stats to the Comet Track dashboard (every 10 s)", CurrentValue = true,
    Flag = "TrackOn", Callback = function(v) C.TrackOn = v end })
TPrem:CreateToggle({ Name = "Remote control from the dashboard", CurrentValue = true,
    Flag = "RemoteOn", Callback = function(v) C.RemoteOn = v end })
TPrem:CreateSection("Look")
TPrem:CreateToggle({ Name = "Gold theme", CurrentValue = false,
    Flag = "GoldTheme", Callback = function(v) C.GoldTheme = v end })
TPrem:CreateSection("Halloween extras")
TPrem:CreateToggle({ Name = "Hauntlet team mode (your accounts in the same server play together)", CurrentValue = true,
    Flag = "HwTeam", Callback = function(v) C.HwTeam = v end })
TPrem:CreateToggle({ Name = "Open Poltergeist Boxes (Caramelgeist 76 % · Bobageist 20 % · Bubblegeist 4 %)",
    CurrentValue = false, Flag = "HwOpenBoxes", Callback = function(v) C.HwOpenBoxes = v end })
TPrem:CreateToggle({ Name = "Event's last 12 h: spend ALL candy on the Halloween pets picked", CurrentValue = false,
    Flag = "HwSpendEnd", Callback = function(v) C.HwSpendEnd = v end })

------------------------------------------------------------------------------------------------
-- TAB · PETS — potions, neon, release
------------------------------------------------------------------------------------------------

local TPets = newTab("Pets", "paw-print")

TPets:CreateSection("Auto potion")
TPets:CreateToggle({ Name = "Auto use potions", CurrentValue = false, Flag = "Potion",
    Callback = function(v) C.Potion = v end })
local potionLabels = {}
for _, p in ipairs(POTIONS) do potionLabels[#potionLabels + 1] = p.label end
TPets:CreateDropdown({ Name = "Potions it may use", Options = potionLabels,
    CurrentOption = { "Age-Up Potion", "Tiny Age Potion" }, MultipleOptions = true, Flag = "PotionTypes",
    Callback = function(o) C.PotionTypes = o end })
-- who gets them: the farm pet, the kinds you pick below (the pet of those kinds closest to
-- Full Grown goes first), or the old "smart" rule
TPets:CreateDropdown({ Name = "Use potions on",
    Options = { "Farm pet", "Chosen kinds (below)", "Smart (finish neon sets, then farm pet)" },
    CurrentOption = { "Farm pet" }, MultipleOptions = false, Flag = "PotionTarget",
    Callback = function(o) C.PotionTarget = o[1] or "Farm pet" end })
UI.DPotionKinds = TPets:CreateDropdown({ Name = "Chosen kinds (none = any kind; filter with Farm › Search pets)",
    Options = {}, CurrentOption = {}, MultipleOptions = true, Flag = "PotionKinds",
    Callback = function(o) C.PotionKinds = o end })
TPets:CreateDropdown({ Name = "Only on", Options = { "All pets", "Regular pets only", "Neon pets only" },
    CurrentOption = { "All pets" }, MultipleOptions = false, Flag = "PotionOnly",
    Callback = function(o) C.PotionOnly = o[1] or "All pets" end })
UI.PPotions = TPets:CreateParagraph({ Title = "Potions", Content = "—" })

TPets:CreateSection("Pet pen")
TPets:CreateToggle({ Name = "Claim pet pen age-ups (as soon as one is ready)", CurrentValue = true,
    Flag = "PenClaim", Callback = function(v) C.PenClaim = v end })
TPets:CreateToggle({ Name = "Auto pet pen (Full Grown out, free places filled)", CurrentValue = false,
    Flag = "AutoPen", Callback = function(v) C.AutoPen = v end })
UI.DPenPriority = TPets:CreateDropdown({ Name = "Pen: put these kinds first", Options = {}, CurrentOption = {},
    MultipleOptions = true, Flag = "PenPriority", Callback = function(o) C.PenPriority = type(o) == "table" and o or { o } end })
UI.DPenExclude = TPets:CreateDropdown({ Name = "Pen: never put these kinds", Options = {}, CurrentOption = {},
    MultipleOptions = true, Flag = "PenExclude", Callback = function(o) C.PenExclude = type(o) == "table" and o or { o } end })
TPets:CreateToggle({ Name = "Pen: eggs too (they hatch in there)", CurrentValue = false,
    Flag = "PenEggs", Callback = function(v) C.PenEggs = v end })
TPets:CreateParagraph({ Title = "In the pet pen", Content = " " })    -- pictures (Look.gallery)

TPets:CreateSection("Auto Neon / Mega")
TPets:CreateToggle({ Name = "Auto Neon (4 Full Grown)", CurrentValue = false, Flag = "Neon",
    Callback = function(v) C.Neon = v end })
TPets:CreateToggle({ Name = "Auto Mega (4 Full Grown Neon)", CurrentValue = false, Flag = "Mega",
    Callback = function(v) C.Mega = v end })
UI.DNeonKinds = TPets:CreateDropdown({ Name = "Only these kinds (none = all)", Options = {},
    CurrentOption = {}, MultipleOptions = true, Flag = "NeonKinds", Callback = function(o) C.NeonKinds = o end })
UI.PNeon = TPets:CreateParagraph({ Title = "Ready to fuse", Content = "—" })

TPets:CreateSection("Auto release")
TPets:CreateToggle({ Name = "Auto release pets", CurrentValue = false, Flag = "ReleaseAuto",
    Callback = function(v) C.ReleaseAuto = v end })
TPets:CreateDropdown({ Name = "Release by", Options = { "Rarity", "Kind" }, CurrentOption = { "Rarity" },
    MultipleOptions = false, Flag = "ReleaseBy", Callback = function(o) C.ReleaseBy = o[1] or "Rarity" end })
TPets:CreateDropdown({ Name = "Rarities",
    Options = { "Common", "Uncommon", "Rare", "Ultra-Rare", "Legendary" }, CurrentOption = {},
    MultipleOptions = true, Flag = "ReleaseRarities", Callback = function(o) C.ReleaseRarities = o end })
UI.DReleaseKinds = TPets:CreateDropdown({ Name = "Kinds", Options = {},
    CurrentOption = {}, MultipleOptions = true, Flag = "ReleaseKinds", Callback = function(o) C.ReleaseKinds = o end })
TPets:CreateDropdown({ Name = "Versions", Options = { "Regular", "Neon", "Mega" }, CurrentOption = { "Regular" },
    MultipleOptions = true, Flag = "ReleaseVersions", Callback = function(o) C.ReleaseVersions = o end })
TPets:CreateDropdown({ Name = "Ages (none = any)", Options = AGE_NAME, CurrentOption = {},
    MultipleOptions = true, Flag = "ReleaseAges", Callback = function(o) C.ReleaseAges = o end })
TPets:CreateInput({ Name = "Keep at least N of each kind", CurrentValue = "0", PlaceholderText = "0",
    RemoveTextAfterFocusLost = false, Flag = "ReleaseKeep", Callback = function(t) C.ReleaseKeep = num(t) end })
TPets:CreateToggle({ Name = "Never release fly / ride pets", CurrentValue = true, Flag = "ReleaseKeepFR",
    Callback = function(v) C.ReleaseKeepFR = v end })
TPets:CreateButton({ Name = "Release now (press twice)", Callback = function()
    task.spawn(function() if Release then Release:manual() end end)
end })
UI.PRelease = TPets:CreateParagraph({ Title = "Would release", Content = "—" })

------------------------------------------------------------------------------------------------
-- TAB · SHOP
------------------------------------------------------------------------------------------------

local TShop = newTab("Shop", "shopping-cart")
local function shopRefresh() if Shop then task.spawn(function() Shop:refresh() end) end end
UI.PWallet = TShop:CreateParagraph({ Title = "Wallet", Content = "—" })

TShop:CreateSection("Buy")
UI.DShopCat = TShop:CreateDropdown({ Name = "Category", Options = { "All" }, CurrentOption = { "All" },
    MultipleOptions = false, Flag = "ShopCategory",
    Callback = function(o) C.ShopCategory = o[1] or "All" shopRefresh() end })
TShop:CreateInput({ Name = "Search", CurrentValue = "", PlaceholderText = "e.g. egg, bottle",
    RemoveTextAfterFocusLost = false, Flag = "ShopSearch", Callback = function(t) C.ShopSearch = t shopRefresh() end })
UI.DShopItem = TShop:CreateDropdown({ Name = "Item (cheapest first)", Options = {}, CurrentOption = {},
    MultipleOptions = false, Flag = "ShopItem", Callback = function(o)
        C.ShopItem = o[1]
        if Shop then task.spawn(function() Shop:details() end) end
    end })
UI.PItem = TShop:CreateParagraph({ Title = "Item", Content = "Pick an item" })
TShop:CreateSlider({ Name = "Amount", Range = { 1, 99 }, Increment = 1,
    Suffix = "x", CurrentValue = 1, Flag = "ShopAmount", Callback = function(v) C.ShopAmount = v end })
TShop:CreateButton({ Name = "Buy Amount", Callback = function()
    task.spawn(function() if Shop then Shop:buySelected() end end)
end })
TShop:CreateButton({ Name = "Buy as many as I can afford", Callback = function()
    task.spawn(function() if Shop then Shop:buySelected("max") end end)
end })
TShop:CreateButton({ Name = "Buy every item in the list (press twice)", Callback = function()
    task.spawn(function() if Shop then Shop:buyAll() end end)
end })

TShop:CreateSection("Auto buy")
TShop:CreateToggle({ Name = "Keep Amount of this item in stock", CurrentValue = false, Flag = "ShopAuto",
    Callback = function(v) C.ShopAuto = v end })
UI.DBuyEgg = TShop:CreateDropdown({ Name = "Egg to auto buy", Options = {}, CurrentOption = {},
    MultipleOptions = false, Flag = "BuyEgg", Callback = function(o) C.BuyEgg = o[1] end })
TShop:CreateToggle({ Name = "Auto buy + hatch eggs (cheapest egg if none picked above)", CurrentValue = false, Flag = "AutoBuyEggs",
    Callback = function(v) C.AutoBuyEggs = v end })
TShop:CreateInput({ Name = "Never spend below ($)", CurrentValue = "0", PlaceholderText = "0",
    RemoveTextAfterFocusLost = false, Flag = "KeepBucks", Callback = function(t) C.KeepBucks = num(t) end })

------------------------------------------------------------------------------------------------
-- TAB · TRANSFER — trading license + sending bucks
------------------------------------------------------------------------------------------------

local TRew = newTab("Rewards", "gift")
TRew:CreateSection("Lure")
TRew:CreateToggle({ Name = "Claim lure (collect what your lure caught)", CurrentValue = true, Flag = "LureClaim",
    Callback = function(v) C.LureClaim = v end })
TRew:CreateToggle({ Name = "Auto lure (bait it again with the free reusable bait)", CurrentValue = true, Flag = "AutoLure",
    Callback = function(v) C.AutoLure = v end })
TRew:CreateToggle({ Name = "Also use one-time baits (event baits — off keeps them)", CurrentValue = false,
    Flag = "LureConsumable", Callback = function(v) C.LureConsumable = v end })
TRew:CreateToggle({ Name = "Place a free Box Lure if your house has none", CurrentValue = true, Flag = "LurePlace",
    Callback = function(v) C.LurePlace = v end })
TRew:CreateButton({ Name = "Lure: collect + bait now", Callback = function()
    task.spawn(function()
        if not (Booted.ready and Farm and Farm.Lure) then return end
        local ok, s = pcall(Farm.Lure.now, Farm.Lure)
        notify("Lure", ok and s or ("couldn't: " .. tostring(s)))
    end)
end })
UI.PLure = TRew:CreateParagraph({ Title = "Lure", Content = "—" })
TRew:CreateSection("Daily rewards")
TRew:CreateToggle({ Name = "Claim daily quests (every tab, all year)", CurrentValue = true, Flag = "ClaimDailies",
    Callback = function(v) C.ClaimDailies = v end })
TRew:CreateToggle({ Name = "Claim the daily login reward (bucks + stars)", CurrentValue = true, Flag = "ClaimStars",
    Callback = function(v) C.ClaimStars = v end })
TRew:CreateToggle({ Name = "Claim achievement rewards", CurrentValue = true, Flag = "ClaimAchievements",
    Callback = function(v) C.ClaimAchievements = v end })
TRew:CreateToggle({ Name = "Take mailbox gifts (at home)", CurrentValue = true, Flag = "ClaimMail",
    Callback = function(v) C.ClaimMail = v end })

local THallo = newTab("Halloween", "moon-star")
UI.PHallo = THallo:CreateParagraph({ Title = "Candy", Content = "—" })
THallo:CreateButton({ Name = "Screen white / stuck? Press here", Callback = function()
    task.spawn(function()
        if not (Booted.ready and Hallo and Hallo.fixScreen) then return end
        local ok, fixed = pcall(Hallo.fixScreen, Hallo)
        notify("Screen", (ok and fixed) and "Fixed — the picture should come back."
            or "Nothing stuck found on this client.")
    end)
end })
-- The master switch: flipping it by hand also ticks / unticks every minigame & event below
-- (not while the saved config loads, so each one keeps its own saved state).
UI.HwSubs = {}
THallo:CreateToggle({ Name = "ALL Halloween minigames & events (master switch)", CurrentValue = true,
    Flag = "HwOn", Callback = function(v)
        local was = C.HwOn
        C.HwOn = v
        -- only a real flip by hand cascades (a config load re-sets saved values; a template sets
        -- each sub-switch itself)
        if Booted.ready and v ~= was and not (Track and Track.applying) then
            for _, t in ipairs(UI.HwSubs) do pcall(function() t:Set(v) end) end
        end
    end })
THallo:CreateSection("Minigames & events")
UI.HwSubs[#UI.HwSubs + 1] = THallo:CreateToggle({ Name = "Ghost Gallery minigame (every 20 min, up to 5000 candy)",
    CurrentValue = true, Flag = "HwGhost", Callback = function(v) C.HwGhost = v end })
UI.HwSubs[#UI.HwSubs + 1] = THallo:CreateToggle({ Name = "Hauntlet minigame (every 20 min, candy per room + bucks)",
    CurrentValue = true, Flag = "HwHaunt", Callback = function(v) C.HwHaunt = v end })
UI.HwSubs[#UI.HwSubs + 1] = THallo:CreateToggle({ Name = "Auto use keys: open crypt coffins (1000–3000 candy each)",
    CurrentValue = true, Flag = "HwCrypt", Callback = function(v) C.HwCrypt = v end })
UI.HwSubs[#UI.HwSubs + 1] = THallo:CreateToggle({ Name = "Feed the stray cat (50 candy every 10 min)",
    CurrentValue = true, Flag = "HwCat", Callback = function(v) C.HwCat = v end })
THallo:CreateSection("Crypt options")
THallo:CreateToggle({ Name = "Also open twig coffins (for the pigeon nest)", CurrentValue = false,
    Flag = "HwTwigs", Callback = function(v) C.HwTwigs = v end })
THallo:CreateToggle({ Name = "Claim the free Tomb Spider when the crypt is done", CurrentValue = true,
    Flag = "HwSpider", Callback = function(v) C.HwSpider = v end })
THallo:CreateSection("Halloween pets (candy)")
THallo:CreateToggle({ Name = "Install the Lightning Lever (puts the Skelicorn on sale)", CurrentValue = true,
    Flag = "HwLever", Callback = function(v) C.HwLever = v end })
THallo:CreateDropdown({ Name = "Buy Halloween pets", Options = {
        "Bolt (10 000)", "Jump Scare (40 000)", "Skelicorn (120 000, needs the lever)",
        "Jacobin Pigeon (4 000, needs 8 twigs)", "Poltergeist Box (13 000)" },
    CurrentOption = {}, MultipleOptions = true, Flag = "HwPets",
    Callback = function(o) C.HwPets = type(o) == "table" and o or { o } end })
THallo:CreateToggle({ Name = "Buy more than one of each", CurrentValue = false,
    Flag = "HwPetMany", Callback = function(v) C.HwPetMany = v end })
-- (Open Poltergeist Boxes and "spend it all in the last 12 h" are in the Premium tab since 2026-10-12)
THallo:CreateParagraph({ Title = "★ Premium extras", Content =
    "Open Poltergeist Boxes, spend it all in the event's last 12 h and Hauntlet team mode: Premium tab." })
THallo:CreateInput({ Name = "Keep at least (candy)", CurrentValue = "0", PlaceholderText = "0",
    RemoveTextAfterFocusLost = false, Flag = "HwKeepCandy", Callback = function(t) C.HwKeepCandy = num(t) end })
THallo:CreateParagraph({ Title = "Halloween pets", Content = " " })   -- pictures (Look.gallery)
THallo:CreateParagraph({ Title = "Tip", Content =
    "Pet needs pay 200 candy each on your OWN pet (the baby earns none), so keep Auto Farm Pet on. "
    .. "Rounds come first: a task that wouldn't finish before the next round waits. The hub goes "
    .. "to each round itself (the game's \"Teleport there now?\" invite is answered No) and the "
    .. "NICE! results screen is closed for you." })

do
    local TTp = newTab("Teleport", "map-pin")
    -- one tap = there (the game's own door trip, or an instant TP on the main map)
    local function place(tab, label, dest, spot)
        tab:CreateButton({ Name = label, Callback = function()
            task.spawn(function() if Floor and Floor.teleport then Floor.teleport(dest, spot, label) end end)
        end })
    end
    TTp:CreateToggle({ Name = "Pause the farm 3 min after a teleport (so it doesn't walk you away)",
        CurrentValue = true, Flag = "TpPause", Callback = function(v) C.TpPause = v end })
    TTp:CreateSection("Places")
    for _, p in ipairs({
        { "🏠  My house", "housing" }, { "🌳  Main map", "MainMap" }, { "🏫  School", "School" },
        { "🏥  Hospital", "Hospital" }, { "💇  Salon", "Salon" }, { "🍕  Pizza Shop", "PizzaShop" },
        { "🐱  Cat Café", "CatCafe" }, { "☕  Coffee Shop", "CoffeeShop" }, { "🍼  Nursery", "Nursery" },
        { "🐾  Pet Shop", "PetShop" }, { "🧸  Toy Shop", "ToyShop" }, { "🛒  Supermarket", "Supermarket" },
        { "🍦  Ice Cream", "IceCream" }, { "🎩  Hat Shop", "HatShop" }, { "🚗  Auto Shop", "AutoShop" },
        { "🏰  Sky Castle", "SkyCastle" },
    }) do place(TTp, p[1], p[2], nil) end
    TTp:CreateSection("Outside")
    for _, p in ipairs({
        { "🏖️  Beach", "exterior_beach" }, { "🏕️  Campsite", "exterior_camping" }, { "🌲  Park", "Park" },
        { "🏙️  Town", "Town" }, { "⛸️  Skating rink", "Skating" }, { "🔬  Science Shack", "ScienceShack" },
        { "🎡  Carnival", "exterior_carnival" }, { "🚀  Launchpad", "Launchpad" }, { "💎  Neon Cave", "NeonCave" },
    }) do place(TTp, p[1], nil, p[2]) end
    TTp:CreateSection("Halloween")
    for _, p in ipairs({
        { "🏚️  Haunted Manor (Ghost Gallery)", "HauntedManor" }, { "🏨  Haunted Hotel (Hauntlet)", "HauntedHotel" },
        { "⚰️  The Crypt", "TheCrypt" },
    }) do place(TTp, p[1], p[2], nil) end
end

local TTransfer = newTab("Transfer", "arrow-left-right")

TTransfer:CreateSection("Trading license")
TTransfer:CreateButton({ Name = "Get trading license", Callback = function()
    task.spawn(function() if License then License:get() end end)
end })
UI.PLicense = TTransfer:CreateParagraph({ Title = "License", Content = "—" })

TTransfer:CreateSection("Send bucks (mannequin)")
TTransfer:CreateInput({ Name = "Player", CurrentValue = "", PlaceholderText = "username",
    RemoveTextAfterFocusLost = false, Flag = "PayTo", Callback = function(t) C.PayTo = t end })
TTransfer:CreateInput({ Name = "Amount ($)", CurrentValue = "0", PlaceholderText = "e.g. 500",
    RemoveTextAfterFocusLost = false, Flag = "PayAmount", Callback = function(t) C.PayAmount = num(t) end })
TTransfer:CreateButton({ Name = "Send now (press twice)", Callback = function()
    task.spawn(function() if Pay then Pay:manual() end end)
end })
TTransfer:CreateToggle({ Name = "Auto send everything above Keep", CurrentValue = false,
    Flag = "PayAuto", Callback = function(v) C.PayAuto = v end })
TTransfer:CreateInput({ Name = "Keep ($)", CurrentValue = "0", PlaceholderText = "0",
    RemoveTextAfterFocusLost = false, Flag = "PayKeep", Callback = function(t) C.PayKeep = num(t) end })
UI.PPay = TTransfer:CreateParagraph({ Title = "Transfer", Content = "—" })

TTransfer:CreateSection("Receive bucks")
TTransfer:CreateButton({ Name = "Put MY mannequin on sale at $100", Callback = function()
    task.spawn(function() if Pay then Pay:sellMine() end end)
end })
TTransfer:CreateParagraph({ Title = "How", Content =
    "The sender buys the outfit on the receiver's mannequin. The game caps it at $100, so $500 = 5 buys. "
    .. "Receiver: own a Mannequin, press the button above. Both in the same server." })

TTransfer:CreateSection("Trade pets to a player")
TTransfer:CreateInput({ Name = "Player", CurrentValue = "", PlaceholderText = "username",
    RemoveTextAfterFocusLost = false, Flag = "TradeTo", Callback = function(t) C.TradeTo = t end })
UI.DTradeKind = TTransfer:CreateDropdown({ Name = "Pet", Options = {}, CurrentOption = {},
    MultipleOptions = false, Flag = "TradeKind", Callback = function(o) C.TradeKind = o[1] end })
TTransfer:CreateDropdown({ Name = "Version", Options = { "Any", "Regular", "Neon", "Mega" },
    CurrentOption = { "Any" }, MultipleOptions = false, Flag = "TradeVersion",
    Callback = function(o) C.TradeVersion = o[1] or "Any" end })
TTransfer:CreateSlider({ Name = "Pets per trade", Range = { 1, 18 }, Increment = 1, Suffix = " pets",
    CurrentValue = 1, Flag = "TradePer", Callback = function(v) C.TradePer = v end })
TTransfer:CreateInput({ Name = "How many trades", CurrentValue = "1", PlaceholderText = "1",
    RemoveTextAfterFocusLost = false, Flag = "TradeTimes", Callback = function(t) C.TradeTimes = math.max(1, num(t)) end })
TTransfer:CreateButton({ Name = "Start trading (press twice)", Callback = function()
    task.spawn(function() if Trade then Trade:manual() end end)
end })
TTransfer:CreateButton({ Name = "Stop trading", Callback = function()
    if Trade then Trade.stop = true end
end })
UI.PTrade = TTransfer:CreateParagraph({ Title = "Trades", Content = "—" })

TTransfer:CreateSection("Trade requests")
TTransfer:CreateToggle({ Name = "Trade off (nobody can send me trade requests)", CurrentValue = false,
    Flag = "TradeOff", Callback = function(v)
        local was = C.TradeOff
        C.TradeOff = v
        -- a config reload re-sets a saved false: that must not open your trade requests to everyone
        if Trade and Booted.ready and v ~= was then task.spawn(function() Trade:applyOff() end) end
    end })

------------------------------------------------------------------------------------------------
-- TAB · SETTINGS — pet picking rules, eggs, needs, other
------------------------------------------------------------------------------------------------

local TSet = newTab("Settings", "settings-2")

TSet:CreateSection("\"Auto\" pet picks")
TSet:CreateDropdown({ Name = "Order", Options = { "Youngest first", "Oldest first", "Rarest first" },
    CurrentOption = { "Youngest first" }, MultipleOptions = false, Flag = "PetOrder",
    Callback = function(o) C.PetOrder = o[1] or "Youngest first" end })
UI.DPetKind = TSet:CreateDropdown({ Name = "Only this kind", Options = { "Any" }, CurrentOption = { "Any" },
    MultipleOptions = false, Flag = "PetKind", Callback = function(o) C.PetKind = o[1] or "Any" end })
TSet:CreateDropdown({ Name = "Version", Options = { "Any pet", "Regular only", "Neon only" },
    CurrentOption = { "Any pet" }, MultipleOptions = false, Flag = "PetVersion",
    Callback = function(o) C.PetVersion = o[1] or "Any pet" end })
UI.DPriority = TSet:CreateDropdown({ Name = "Prioritized kinds", Options = {},
    CurrentOption = {}, MultipleOptions = true, Flag = "PriorityTypes", Callback = function(o) C.PriorityTypes = o end })
TSet:CreateButton({ Name = "Refresh pet + egg lists", Callback = function() refreshLists("") end })

TSet:CreateSection("Eggs")
UI.DHatchList = TSet:CreateDropdown({ Name = "Hatch these eggs (none = any)", Options = {}, CurrentOption = {},
    MultipleOptions = true, Flag = "HatchList", Callback = function(o) C.HatchList = o end })
TSet:CreateInput({ Name = "How many to hatch (0 = no limit)", CurrentValue = "0", PlaceholderText = "0",
    RemoveTextAfterFocusLost = false, Flag = "HatchCount", Callback = function(t) C.HatchCount = num(t) end })

TSet:CreateSection("Needs")
TSet:CreateDropdown({ Name = "Pet hunger / thirst", Options = { "Food items first", "Free bowls first", "Free bowls only" },
    CurrentOption = { "Food items first" }, MultipleOptions = false, Flag = "PetFood",
    Callback = function(o) C.PetFood = o[1] or "Food items first" end })
TSet:CreateToggle({ Name = "Buy the item a pet asks for (toy, food, leash, stroller…)", CurrentValue = true,
    Flag = "PrefBuy", Callback = function(v) C.PrefBuy = v end })
TSet:CreateInput({ Name = "…but only up to ($)", CurrentValue = "250", PlaceholderText = "250",
    RemoveTextAfterFocusLost = false, Flag = "PrefMax", Callback = function(t) C.PrefMax = num(t) end })
TSet:CreateToggle({ Name = "Auto buy food when out (cheapest)", CurrentValue = true, Flag = "AutoBuyFood",
    Callback = function(v) C.AutoBuyFood = v end })
TSet:CreateDropdown({ Name = "Never do these needs", Options = ORDER, CurrentOption = {}, MultipleOptions = true,
    Flag = "Skip", Callback = function(o) C.Skip = o end })
TSet:CreateSlider({ Name = "Pause between actions", Range = { 0.1, 2 }, Increment = 0.05, Suffix = "s",
    CurrentValue = 0.25, Flag = "Delay", Callback = function(v) C.Delay = v end })
TSet:CreateToggle({ Name = "Glide instead of teleporting (off = instant TP)", CurrentValue = false,
    Flag = "Glide", Callback = function(v) C.Glide = v end })
TSet:CreateSlider({ Name = "Glide speed", Range = { 60, 400 }, Increment = 10, Suffix = " studs/s",
    CurrentValue = 160, Flag = "GlideSpeed", Callback = function(v) C.GlideSpeed = v end })

TSet:CreateSection("Look")
TSet:CreateDropdown({ Name = "Theme",
    Options = { "Comet", "Default", "Ocean", "AmberGlow", "Amethyst", "Bloom", "DarkBlue", "Green", "Light", "Serenity" },
    CurrentOption = { "Comet" }, MultipleOptions = false, Flag = "Theme",
    Callback = function(o) Look:set(o[1] or "Comet", nil) end })
TSet:CreateDropdown({ Name = "Comet accent colour", Options = { "Cyan", "Pink", "Purple", "Green", "Gold", "Red" },
    CurrentOption = { "Cyan" }, MultipleOptions = false, Flag = "Accent",
    Callback = function(o) Look:set(nil, o[1] or "Cyan") end })

TSet:CreateSection("Other")
TSet:CreateToggle({ Name = "Hide popups ($10 cheques, promos, age-up banner, party invites)", CurrentValue = true,
    Flag = "NoPopups", Callback = function(v)
        C.NoPopups = v
        if Popups and Booted.ready then task.spawn(function() Popups:apply() end) end
    end })
TSet:CreateToggle({ Name = "Auto rejoin a new server when the game gets stuck (public servers)",
    CurrentValue = true, Flag = "AutoRejoin", Callback = function(v) C.AutoRejoin = v end })
TSet:CreateToggle({ Name = "Auto reconnect after a kick / disconnect screen", CurrentValue = true,
    Flag = "AutoReconnect", Callback = function(v) C.AutoReconnect = v end })
TSet:CreateToggle({ Name = "Save my settings for this account (restored at every start)", CurrentValue = true,
    Flag = "SaveSettings", Callback = function(v) C.SaveSettings = v end })
-- (the Comet Track key / live stats / local address are in the Premium tab since 2026-10-12)
TSet:CreateToggle({ Name = "Remove other players in public servers (less lag, only on your screen)",
    CurrentValue = true, Flag = "HidePlayers", Callback = function(v)
        C.HidePlayers = v
        if Crowd and Booted.ready then task.spawn(function() Crowd:tick() end) end
    end })
-- Optional FPS cap for many clients at once. "Off" never touches the cap, so a cap you set
-- elsewhere (executor, Bloxstrap) stays. Every wait and time limit in the farm is
-- clock-based, so it behaves the same at 3–5 FPS.
TSet:CreateDropdown({ Name = "Graphics (performance)", Options = { "Normal",
        "Low — no shadows, 100-stud view", "Minimum — small square view, no effects, no sound",
        "3D off — black screen + small status square" },
    CurrentOption = { "Minimum — small square view, no effects, no sound" }, MultipleOptions = false, Flag = "GfxMode",
    Callback = function(o)
        local v = tostring(type(o) == "table" and o[1] or o)
        C.GfxMode = (v:find("^Low") and "Low") or (v:find("^Min") and "Min") or (v:find("^3D off") and "3D off") or "Normal"
    end })
TSet:CreateDropdown({ Name = "FPS cap (needs setfpscap)", Options = { "Off", "3", "5", "10", "15", "30", "60" },
    CurrentOption = { "Off" }, MultipleOptions = false, Flag = "FPSCap", Callback = function(o)
        -- getgenv().CometFPS (set in the loader) wins over the saved choice
        local g = tonumber((getgenv and getgenv() or _G).CometFPS)
        local v = (g and g > 0 and g) or tonumber(o[1])
        if not v then return end
        local cap = setfpscap or (getgenv and getgenv().setfpscap)
        if cap then pcall(cap, v) else notify("FPS cap", "This executor has no setfpscap.") end
    end })
-- Show / hide the window: K always works (Rayfield's own key); pick another key here too, and
-- a small round button (on by default on phones / tablets, where there is no keyboard).
TSet:CreateKeybind({ Name = "Show / hide the window (extra key; K always works)", CurrentKeybind = "RightShift",
    HoldToInteract = false, Flag = "UIKey", Callback = function()
        pcall(function() Rayfield:SetVisibility(not Rayfield:IsVisible()) end)
    end })
UI.MobileBtn = function(on)
    ui(function()
        if not alive() then return end       -- a stopped run must never put its button back
        -- an old button wherever SESSION.parentGui may have put it (gethui / CoreGui / PlayerGui)
        for _, get in ipairs({ function() return gethui() end, function() return game:GetService("CoreGui") end,
                               function() return LP:FindFirstChildOfClass("PlayerGui") end }) do
            pcall(function()
                for _, old in ipairs(get():GetChildren()) do
                    if old.Name == "CometHubToggle" then old:Destroy() end
                end
            end)
        end
        if not on then return end
        local sg = Instance.new("ScreenGui")
        sg.Name, sg.ResetOnSpawn, sg.DisplayOrder = "CometHubToggle", false, 999
        -- a small app icon: dark rounded square, white outlined paw (drawn with frames, so it
        -- needs no image upload and stays sharp at any size)
        local b = Instance.new("TextButton")
        b.Size, b.Position = UDim2.fromOffset(52, 52), UDim2.new(0, 14, 0, 70)
        b.BackgroundColor3, b.Text, b.AutoButtonColor = Color3.fromRGB(10, 10, 22), "", true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
        local edge = Instance.new("UIStroke", b)
        edge.Color, edge.Thickness, edge.Transparency = Color3.fromRGB(120, 120, 140), 1.5, 0.3
        edge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        -- the same paw-print icon as the window's title bar (Lucide sprite from Rayfield), so it
        -- is crisp and correctly proportioned at any size
        local icon = Instance.new("ImageLabel")
        icon.BackgroundTransparency, icon.Active = 1, false
        icon.AnchorPoint, icon.Position, icon.Size = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 28, 0, 28)
        icon.Image, icon.ImageRectOffset, icon.ImageRectSize = "rbxassetid://16898613699", Vector2.new(771, 257), Vector2.new(48, 48)
        pcall(function()
            local src = UI.rayRoot().Main.Topbar.Icon     -- nil (headless / not found): kept the built-in paw
            if src.Image ~= "" then icon.Image, icon.ImageRectOffset, icon.ImageRectSize = src.Image, src.ImageRectOffset, src.ImageRectSize end
        end)
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        icon.Parent = b
        -- tap = show / hide (Activated: mouse click or finger tap); press and move > 12 px =
        -- drag it. Positions always read the same way (mouse: GetMouseLocation, finger: the
        -- touch's own position) — mixing the two spaces read the topbar inset as a "drag" and
        -- every click was ignored (reported 2026-10-10).
        local UIS = game:GetService("UserInputService")
        local function where(i)
            if i.UserInputType == Enum.UserInputType.Touch then return Vector2.new(i.Position.X, i.Position.Y) end
            return UIS:GetMouseLocation()
        end
        local held, startAt, from, moved, lastTap = false, nil, nil, false, 0
        b.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
                held, startAt, from, moved = true, where(i), b.Position, false
            end
        end)
        local cMove = UIS.InputChanged:Connect(function(i)
            if held and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
                local d = where(i) - startAt
                if d.Magnitude > 12 then moved = true end
                if moved then b.Position = UDim2.new(from.X.Scale, from.X.Offset + d.X, from.Y.Scale, from.Y.Offset + d.Y) end
            end
        end)
        local cEnd = UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
                task.defer(function() held = false end)
            end
        end)
        local function drop() cMove:Disconnect() cEnd:Disconnect() end
        sg.Destroying:Connect(drop)
        sg.AncestryChanged:Connect(function(_, p) if p == nil then drop() end end)
        b.Activated:Connect(function()
            if moved or os.clock() - lastTap < 0.35 then moved = false return end
            lastTap = os.clock()
            pcall(function() Rayfield:SetVisibility(not Rayfield:IsVisible()) end)
        end)
        b.Parent = sg
        -- gethui → CoreGui → PlayerGui. None takes it: drop the two UserInputService listeners made
        -- above — "sg.Parent = parent" throwing (no gethui, CoreGui not writable) leaked them every
        -- 3 s (the status loop asks again) and no button ever showed
        if not SESSION.parentGui(sg) then drop() pcall(function() sg:Destroy() end) return end
        UI.toggleGui = sg                     -- this run's own button (destroy removes only it)
    end)
end
TSet:CreateToggle({ Name = "Tabs down the left side (icons)", CurrentValue = true, Flag = "SideTabs",
    Callback = function(v) C.SideTabs = v if Look then Look:sidebar() end end })
TSet:CreateToggle({ Name = "Small icon button to show / hide the window", Flag = "MobileBtn",
    CurrentValue = true,
    Callback = function(v) C.MobileBtn = v UI.MobileBtn(v) end })
TSet:CreateToggle({ Name = "Anti-AFK", CurrentValue = true, Flag = "AntiAFK",
    Callback = function(v) C.AntiAFK = v if Floor then Floor:antiAfk(v) end end })
TSet:CreateButton({ Name = "Rejoin this server", Callback = function()
    if Crowd and not Crowd:public() then
        notify("Rejoin", "Private servers can't be rejoined by script — use your server link.")
        return
    end
    if Crowd then Crowd.queue() end                -- the hub runs again in there
    pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end)
end })
TSet:CreateButton({ Name = "Stop script + close UI", Callback = function()
    if _G.__CHLITE then _G.__CHLITE.destroy() end
end })
end)  -- UI TABS
if not UI.tabsOk then
    warn("[Cometium Fusions] the window couldn't be fully built: " .. tostring(UI.tabsErr) .. " — the farm runs on")
    log("window not fully built: " .. tostring(UI.tabsErr))
    if not UI.PNow and not Rayfield.headless then    -- nothing on screen at all: the small label instead
        pcall(function() Rayfield:Destroy() end)
        SESSION.uiWhy = "UI library failed to start on this executor"
        Rayfield = SESSION.headless(UI.tabsErr)
    end
end

------------------------------------------------------------------------------------------------
-- GAME LAYER — filled by boot() on a worker thread
------------------------------------------------------------------------------------------------

local G = { ready = false }

-- A game call that may load game modules the first time (UIManager's app refresh, a trip's
-- interior cleanup) runs on its own thread at the game's identity, 2. From the executor's
-- identity 8 the game's Fsys refuses them: "Cannot require a non-RobloxScript module from a
-- RobloxScript" spam at launch and on trips (reported 2026-10-10), and threads or connections
-- the call starts keep that identity. Same answer as pcall(fn, ...); 10 s at most.
function G.asGame(fn, ...)
    if not alive() then return false, "stopped" end      -- the ui queue below is gone with the run
    -- each call that never answers leaves one thread parked: more than 40 of them in 5 min = the
    -- game / server is broken — refuse for a moment (logged once) instead of piling more up
    G.stuck = G.stuck or {}
    local now = os.clock()
    while G.stuck[1] and now - G.stuck[1] > 300 do table.remove(G.stuck, 1) end
    if #G.stuck > 40 then
        if not G.saidBusy then G.saidBusy = true pcall(log, "game calls aren't answering — paused for a moment") end
        return false, "busy"
    end
    G.saidBusy = nil
    local args = table.pack(...)
    local res, late
    -- spawned from the clean Heartbeat queue, never from the caller: a thread started by one that
    -- already ran game code can't write the game's GUI (2026-10-12: the round results screen's
    -- close_display did nothing for 200 s from the status loop, and closed at once from a fresh thread)
    ui(function()
        task.spawn(function()
            pcall(function() (setthreadidentity or set_thread_identity or setidentity)(2) end)
            res = table.pack(pcall(fn, table.unpack(args, 1, args.n)))
            -- answered after all (only slow): no longer counted as stuck
            if late then local i = table.find(G.stuck, late) if i then table.remove(G.stuck, i) end end
        end)
    end)
    local t0 = os.clock()
    while not res and os.clock() - t0 < 10 do task.wait() end
    if not res then late = os.clock() table.insert(G.stuck, late) return false, "timeout" end
    return table.unpack(res, 1, res.n)
end

local function loadGame()
    local load = require(RS:WaitForChild("Fsys")).load
    G.load = load
    G.CD     = load("ClientData")
    G.IM     = load("InteriorsM")
    G.FMT    = load("FurnitureModelTracker")
    G.EP     = load("EquippedPets")
    G.IDB    = load("InventoryDB")
    G.FDB    = load("FurnitureDB")
    G.Pots   = load("PetPotionEffectsDB")
    G.Lock   = load("BackpackLockTracker")
    G.UIM    = load("UIManager")
    local okW, CWC = pcall(load, "CharWrapperClient")
    G.CWC = okW and CWC or nil
    local okE, E = pcall(load, "AdoptMeEnums/PetEntities/PetObjectCreatorType")
    G.FOOD = (okE and E and E.PetFood) or "__Enum_PetObjectCreatorType_2"
    G.TOY  = (okE and E and E.DroppableToy) or "__Enum_PetObjectCreatorType_1"
    G.AFH  = require(RS.new.modules.Ailments.Helpers.AilmentsFurnitureHelper)
    G.ADB  = require(RS.new.modules.Ailments.AilmentsDB)
    G.AC   = require(RS.new.modules.Ailments.AilmentsClient)
    G.PRC  = require(RS.new.modules.PetRecycler.PetRecyclerCalculator)
    G.HouseClient = load("HouseClient")
    G.TS = game:GetService("TweenService")
    G.PFS = game:GetService("PathfindingService")
    G.FP   = load("FurniturePlacer")
    G.DL   = load("DownloadClient")
    G.TLH  = load("TradeLicenseHelper")
    local okP, PIH = pcall(require, RS.new.modules.Ailments.Helpers.PreferenceItemHelper)
    G.PIH  = okP and PIH or nil
    local okM, RMH = pcall(load, "ResourceMultiplierHelper")
    G.RMH  = okM and RMH or nil
    -- the hotspots come from a server call (GuideArrowAPI/GetHotspotsByInterior, InvokeServer, no
    -- timeout): one that never answered held the hub on "Loading…" for good (2026-10-12, a user in
    -- the crypt). Waited 8 s at most; filled in whenever it answers
    G.Hot = { ailments = {}, items = {} }
    local hotDone = false
    task.spawn(function()
        local okR, okH, hot = pcall(function() return require(RS.new.modules.HotspotsByInterior).get_client():await() end)
        if okR and okH and type(hot) == "table" then G.Hot = hot end
        hotDone = true
    end)
    local hw = 0
    while not hotDone and hw < 8 do hw += task.wait(0.1) end
    G.API = RS:WaitForChild("API")
    G.ready = true
end

local function remote(name)
    local r = G.API and G.API:FindFirstChild(name)
    if not r then log("missing remote " .. name) end
    return r
end
local function fire(name, ...)
    local r = remote(name)
    if not r then return false end
    return pcall(r.FireServer, r, ...)
end
local function invoke(name, ...)
    local r = remote(name)
    if not r then return false end
    return pcall(r.InvokeServer, r, ...)
end

local function me()
    if not G.CD then return nil end
    local ok, all = pcall(G.CD.get_data)
    return ok and type(all) == "table" and all[LP.Name] or nil
end
local function team()
    if not G.CD then return "?" end
    local ok, t = pcall(G.CD.get, "team")
    return ok and tostring(t) or "?"
end
local function location()
    if not G.IM then return "?" end
    local ok, l = pcall(G.IM.get_current_location)
    return ok and type(l) == "table" and l.destination_id or "?"
end
local function houseOwner()
    if not G.HouseClient then return nil end
    local ok, o = pcall(G.HouseClient.get_current_house_owner)
    return ok and o or nil
end
-- nil currency = bucks ("money"); tickets and the like are their own ClientData key
local function balance(currency)
    local d = me()
    return d and tonumber(d[currency or "money"]) or 0
end
local function bucks() return balance(nil) end
local function char()
    local c = LP.Character
    return c, c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
end
local function unseat()
    local _, _, hum = char()
    if hum and hum.Sit then hum.Sit = false hum.Jump = true end
end
local function isLocked(item)
    local ok, r = pcall(G.Lock.is_locked, item)
    return ok and r == true
end

------------------------------------------------------------------------------------------------
-- PETS
------------------------------------------------------------------------------------------------

local function petInfo(e)
    local pr = e.properties or {}
    local db = G.IDB.pets[e.id]
    return {
        unique = e.unique, id = e.id, item = e,
        name = (db and db.name) or e.id,
        age = tonumber(pr.age) or 1,
        xp = tonumber(pr.xp) or 0,
        neon = pr.neon == true, mega = pr.mega_neon == true,
        fly = pr.flyable == true, ride = pr.rideable == true,
        rarity = RARITY_RANK[db and db.rarity or ""] or 0,
        egg = (db and db.is_egg) == true,     -- NOT id:find("egg"): basic_egg_2022_ant is a pet
        hatchAt = db and tonumber(db.xp_to_hatch) or nil,
        temp = (db and db.temporary) == true,              -- the tutorial Practice Dog: no age bar
        noPotion = (db and db.cannot_feed_potions) == true,
    }
end

local function allPets()
    local d, out = me(), {}
    if not d then return out end
    for _, e in pairs(d.inventory.pets or {}) do out[#out + 1] = petInfo(e) end
    return out
end

local function petByUnique(u)
    if not u then return nil end
    local d = me()
    local e = d and d.inventory.pets and d.inventory.pets[u]
    if e then return petInfo(e) end
    for _, x in pairs(d and d.inventory.pets or {}) do
        if x.unique == u then return petInfo(x) end
    end
    return nil
end

local function equippedPets()
    local d, out = me(), {}
    for _, v in pairs(d and d.equip_manager and d.equip_manager.pets or {}) do
        out[#out + 1] = type(v) == "table" and v.unique or v
    end
    return out
end

local function wrapperOf(u)
    local ok, w = pcall(G.EP.get_wrapper_from_unique, u)
    return ok and w and w.char and w or nil
end

-- How many pets the game lets you have out at once (ClientData equipped_pets_allowed).
local function maxPets()
    local ok, n = pcall(G.EP.get_max_equip_count)
    return ok and tonumber(n) or 1
end

-- Makes exactly `list` the pets you have out. The 2nd one uses the backpack's own
-- "equip as second pet" option; extras are put away first.
local function setEquipped(list)
    local want = {}
    for _, u in ipairs(list) do want[u] = true end
    local eq = equippedPets()
    local same = #eq == #list
    for _, u in ipairs(eq) do if not want[u] then same = false end end
    if same then
        local out = true
        for _, u in ipairs(list) do if not wrapperOf(u) then out = false end end
        if out then return true end
    end
    for _, u in ipairs(eq) do
        if not want[u] then invoke("ToolAPI/Unequip", u) task.wait(0.3) end
    end
    local _, hrp = char()
    for i, u in ipairs(list) do
        if not table.find(equippedPets(), u) then
            invoke("ToolAPI/Equip", u, {
                spawn_cframe = hrp and hrp.CFrame * CFrame.new(i * 3 - 4.5, 0, -4) or nil,
                equip_as_last = i > 1,
            })
            task.wait(0.4)
        end
    end
    for _ = 1, 15 do
        local out = true
        for _, u in ipairs(list) do if not wrapperOf(u) then out = false end end
        if out then return true end
        task.wait(0.2)
    end
    return wrapperOf(list[1]) ~= nil
end

------------------------------------------------------------------------------------------------
-- KIND LISTS + PET LIST — the dropdowns share one index each
------------------------------------------------------------------------------------------------

Kinds = { labelToId = {}, all = {}, ready = false }

function Kinds:build()
    local agg = {}
    for _, p in ipairs(allPets()) do
        if not p.egg then
            local a = agg[p.id]
            if not a then
                a = { id = p.id, name = p.name, n = 0 }
                agg[p.id] = a
            end
            a.n += 1
        end
    end
    local rows, seen = {}, {}
    for _, a in pairs(agg) do rows[#rows + 1] = a end
    table.sort(rows, function(x, y) if x.n ~= y.n then return x.n > y.n end return x.name < y.name end)
    local map = {}
    for _, a in ipairs(rows) do
        local label = a.name
        if seen[label] then label = a.name .. " (" .. a.id .. ")" end
        seen[label] = true
        a.label = label
        map[label] = a.id
    end
    self.all, self.labelToId, self.ready = rows, map, true
end

function Kinds:idOf(label)
    if not label or label == "Any" then return nil end
    return self.labelToId[label]
end

function Kinds:refresh(filter)
    local f = tostring(filter or ""):lower()
    local opts = {}
    for _, a in ipairs(self.all) do
        if f == "" or a.label:lower():find(f, 1, true) or a.id:lower():find(f, 1, true) then
            opts[#opts + 1] = a.label
            if #opts >= 150 then break end
        end
    end
    local withAny = { "Any" }
    for _, o in ipairs(opts) do withAny[#withAny + 1] = o end
    ui(function()
        -- each on its own: one failing Refresh used to skip every list after it
        if UI.DPetKind then pcall(UI.DPetKind.Refresh, UI.DPetKind, withAny) end
        for _, k in ipairs({ "DNeonKinds", "DPotionKinds", "DFarmKinds", "DPenPriority", "DPenExclude",
                             "DPriority", "DReleaseKinds", "DTradeKind" }) do
            local d = UI[k]
            if d then pcall(d.Refresh, d, opts) end
        end
    end)
end

-- Individual pets for the Pet 1 / Pet 2 pickers: not Full Grown first, rarest first.
PetList = { labelToUnique = {}, ready = false }

local function versionPrefix(p) return p.mega and "Mega " or (p.neon and "Neon " or "") end

function PetList:refresh(filter)
    local f = tostring(filter or ""):lower()
    local rows = {}
    for _, p in ipairs(allPets()) do
        if not p.egg and (f == "" or p.name:lower():find(f, 1, true) or p.id:lower():find(f, 1, true)) then
            rows[#rows + 1] = p
        end
    end
    table.sort(rows, function(a, b)
        local ga, gb = a.age >= 6, b.age >= 6
        if ga ~= gb then return gb end
        if a.rarity ~= b.rarity then return a.rarity > b.rarity end
        if a.name ~= b.name then return a.name < b.name end
        if a.age ~= b.age then return a.age > b.age end
        return a.unique < b.unique
    end)
    -- the [tag] is the end of the pet's unique: a saved pick still finds its pet after
    -- it ages up or you rejoin, even though the rest of the label changed
    local opts, map = { "Auto" }, {}
    for _, p in ipairs(rows) do
        local label = ("%s%s · %s [%s]"):format(versionPrefix(p), p.name,
            AGE_NAME[p.age] or tostring(p.age), p.unique:sub(-5))
        map[label] = p.unique
        opts[#opts + 1] = label
        if #opts > 150 then break end
    end
    -- keep the chosen pets findable even when a search hides them
    for _, key in ipairs({ "Pet1", "Pet2" }) do
        local cur = C[key]
        if cur ~= "Auto" and self.labelToUnique[cur] and not map[cur] then
            map[cur] = self.labelToUnique[cur]
        end
    end
    self.labelToUnique, self.ready = map, true
    ui(function()
        UI.DPet1:Refresh(opts)
        UI.DPet2:Refresh(opts)
    end)
end

function PetList:uniqueOf(label)
    if not label or label == "Auto" then return nil end
    local u = self.labelToUnique[label]
    if u then return u end
    local tag = tostring(label):match("%[(%w+)%]$")
    if not tag then return nil end
    self.missing = self.missing or {}
    if os.clock() - (self.missing[label] or -1e9) < 30 then return nil end   -- gone: rescan later
    for _, p in ipairs(allPets()) do
        if p.unique:sub(-#tag) == tag then
            self.labelToUnique[label] = p.unique
            return p.unique
        end
    end
    self.missing[label] = os.clock()
    return nil
end

------------------------------------------------------------------------------------------------
-- TASK FLOOR — gray tiles over the whole main map; the farm lives up there
------------------------------------------------------------------------------------------------

local goFloor                     -- defined with the travel helpers below

Floor = { model = nil, tiles = {}, inner = nil, innerTop = nil, lastGood = nil, caught = 0,
          conn = nil, tick = 0, travelling = false }
-- The sky square (2026-10-13, "only one small square that loads and nothing else" — how the hub he
-- benchmarks waits): 80 x 80 studs, 4600 studs over the map's centre. The farm waits and works up
-- there (play, walk, ride, food, mysteries, your house's pieces from afar); the map is far enough
-- below to stream out (less memory, less to draw). Area needs (beach / park / camping) go down to
-- the big floor over their anchor and come back up. Settings › "Wait on a small sky square".
Floor.SKY_TOP, Floor.SKY_SIZE = 4600, 80
function Floor.skyOn() return C.SkyBase ~= false and Floor.sky ~= nil and Floor.sky.Parent ~= nil end

local function grayTile(name, parent)
    local p = Instance.new("Part")
    p.Name = name
    p.Anchored, p.CanCollide, p.CanTouch, p.CastShadow = true, true, false, false
    p.Size = Vector3.new(FLOOR_TILE, 2, FLOOR_TILE)
    p.Material = Enum.Material.Plastic   -- studs only show on Plastic
    p.Color = FLOOR_BLUE
    p.TopSurface, p.BottomSurface = Enum.SurfaceType.Studs, Enum.SurfaceType.Smooth
    p.Parent = parent
    return p
end

function Floor:feetY()
    local _, hrp, hum = char()
    if not (hrp and hum) then return nil end
    return hrp.Position.Y - hum.HipHeight - hrp.Size.Y / 2
end

function Floor:build()
    if self.model and self.model.Parent then return end
    local m = Instance.new("Model")
    m.Name = "CometFloor"
    self.tiles = {}
    local half = (FLOOR_GRID - 1) / 2
    for i = 0, FLOOR_GRID - 1 do
        for j = 0, FLOOR_GRID - 1 do
            local t = grayTile("Map", m)
            t.CFrame = CFrame.new(MAP_CENTER.X + (i - half) * FLOOR_TILE, FLOOR_TOP - 1,
                MAP_CENTER.Z + (j - half) * FLOOR_TILE)            -- 2 thick: top = FLOOR_TOP
            self.tiles[#self.tiles + 1] = t
        end
    end
    self.inner = grayTile("Interior", m)
    self.inner.CFrame = CFrame.new(0, -4000, 0)                -- parked until you enter somewhere
    self.sky = grayTile("Sky", m)
    self.sky.Size = Vector3.new(Floor.SKY_SIZE, 2, Floor.SKY_SIZE)
    self.sky.CFrame = CFrame.new(MAP_CENTER.X, Floor.SKY_TOP - 1, MAP_CENTER.Z)   -- 2 thick: top = SKY_TOP
    m.Parent = Workspace
    self.model = m
end

-- Standing on the task floor right now?
function Floor:onFloor()
    local _, hrp = char()
    if not (self.model and hrp) or location() ~= "MainMap" then return false end
    local y = hrp.Position.Y
    return (y > FLOOR_TOP and y < FLOOR_TOP + 15) or self:onSky()
end
-- Standing on the sky square right now?
function Floor:onSky()
    local _, hrp = char()
    local sky = self.sky
    if not (sky and sky.Parent and hrp) then return false end
    local p, c, h = hrp.Position, sky.Position, Floor.SKY_SIZE / 2
    return math.abs(p.X - c.X) < h and math.abs(p.Z - c.Z) < h and p.Y > Floor.SKY_TOP and p.Y < Floor.SKY_TOP + 15
end
-- Where the farm waits: the sky square when it's on, else anywhere on the floor
function Floor:atBase()
    if Floor.skyOn() then return self:onSky() end
    return self:onFloor()
end

-- A safety tile under the interior you just entered (houses and shops sit far from the map).
function Floor:underInterior()
    if not self.inner then return end
    if location() == "MainMap" then
        self.inner.CFrame = CFrame.new(0, -4000, 0)
        self.innerTop = nil
        return
    end
    local _, hrp = char()
    if not hrp then return end
    local p = hrp.Position
    local best, bestD
    for _, root in ipairs({ Workspace:FindFirstChild("Interiors"), Workspace:FindFirstChild("HouseInteriors") }) do
        for _, m in ipairs(root and root:GetChildren() or {}) do
            if m:IsA("Model") then
                local ok, cf, size = pcall(m.GetBoundingBox, m)
                if ok and size.Magnitude > 1 then
                    local d = Vector3.new(cf.X - p.X, 0, cf.Z - p.Z).Magnitude
                    if not bestD or d < bestD then best, bestD = { cf = cf, size = size }, d end
                end
            end
        end
    end
    local feet = self:feetY() or p.Y
    local top, cx, cz
    if best and bestD < 1500 then
        top = math.min(best.cf.Y - best.size.Y / 2, feet) - 2
        cx, cz = best.cf.X, best.cf.Z
    else
        top, cx, cz = feet - 6, p.X, p.Z
    end
    self.inner.CFrame = CFrame.new(cx, top - 1, cz)
    self.innerTop = top
end

-- Called after every trip.
function Floor:arrived()
    self.lastGood = nil
    if self.model then self:underInterior() end
end

-- Every 0.25 s: remember where you last stood, and if you ever drop into the void
-- (off the map's edge, through a glitchy door), put you back there. No game calls here.
function Floor:step()
    if self.travelling or (G.IM and G.IM.entering) then return end
    -- a minigame moves you itself (rooms, floors, bounces, the trip back): never put a spot from
    -- before the round back (the Hauntlet has its own net)
    if Hallo and Hallo.active then self.lastGood = nil return end
    local _, hrp, hum = char()
    if not (hrp and hum) or hum.Health <= 0 then return end
    if hum.FloorMaterial ~= Enum.Material.Air and not hrp.Anchored and not hum.Sit then
        self.lastGood = hrp.CFrame
    end
    local y = hrp.Position.Y
    if (y < -40 or y < Workspace.FallenPartsDestroyHeight + 50) and hum.FloorMaterial == Enum.Material.Air then
        -- back to the last spot stood on, else the floor straight above — only when that floor is
        -- really there (an interior far away from it used to loop "fell" every 2 s in the sky)
        local spot = self.lastGood
        -- a spot from a place that's gone (a trip landed after goTo gave up on it): nothing under it
        if spot and not Workspace:Raycast(spot.Position, Vector3.new(0, -30, 0)) then spot = nil end
        if not spot and self.innerTop and self.inner then
            spot = CFrame.new(self.inner.Position.X, self.innerTop + 4, self.inner.Position.Z)
        elseif not spot and self.model then
            local half, p = FLOOR_TILE * FLOOR_GRID / 2, hrp.Position
            if math.abs(p.X - MAP_CENTER.X) < half and math.abs(p.Z - MAP_CENTER.Z) < half then
                spot = CFrame.new(p.X, FLOOR_TOP + 4, p.Z)
            end
        end
        if not spot then return end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = spot
        self.caught += 1
        if os.clock() - (self.caughtLog or 0) > 10 then self.caughtLog = os.clock() log("fell into the void — put back") end
    end
end

function Floor:apply()
    if C.TaskFloor then
        self:build()
        self:arrived()
        if not self.conn then
            self.conn = RunService.Heartbeat:Connect(function(dt)
                self.tick += dt
                if self.tick < 0.25 then return end
                self.tick = 0
                pcall(function() self:step() end)
            end)
        end
    else
        if self.conn then self.conn:Disconnect() self.conn = nil end
        if self.model then self.model:Destroy() self.model, self.inner, self.tiles = nil, nil, {} end
    end
end

function Floor:goManual()
    if not G.ready then notify("Task floor", "Still loading.") return end
    if not C.TaskFloor then notify("Task floor", "Turn \"Task floor over the map\" on first.") return end
    if Lock.held then notify("Task floor", "Waiting for the farm to finish its current step…") end
    Lock:run(function()
        notify("Task floor", goFloor() and "You're on the task floor." or "Couldn't get there — check the log.")
    end)
end

-- Anti-AFK (Settings, on by default) against Roblox's 20-minute idle kick. Adopt Me has no idle
-- check of its own (its "AFK Zone" is a separate server) and nothing in it watches VirtualUser
-- (grep 2026-10-11). Three layers, all on this client (asked 2026-10-11: "a better anti-afk"):
--   1. every handler on LocalPlayer.Idled switched off (getconnections) — and checked again
--      every 30 s, so one connected later (a respawn, Roblox's own kick timer) is caught too;
--   2. our own Idled handler clicks through VirtualUser, which resets the idle clock even where
--      the handlers can't be switched off;
--   3. a VirtualUser click every 8 min anyway: an executor without getconnections and a missed
--      Idled still never reach 20 min.
function Floor:antiAfk(on)
    self.afkOn = on
    local okV, VU = pcall(game.GetService, game, "VirtualUser")
    local function nudge()
        self.afkAt = os.clock()
        if okV and VU then pcall(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end) end
    end
    local function sweep()
        if typeof(getconnections) ~= "function" then return end
        for _, c in ipairs(getconnections(LP.Idled)) do
            local mine = false
            pcall(function() mine = self.idledFn ~= nil and c.Function == self.idledFn end)
            if not mine then pcall(function() if self.afkOn then c:Disable() else c:Enable() end end) end
        end
    end
    if not self.idledFn then
        self.idledFn = function() if self.afkOn and C.AntiAFK then nudge() end end
        track(LP.Idled:Connect(self.idledFn))
    end
    pcall(sweep)
    if on and not self.afkLoop then
        self.afkLoop, self.afkAt = true, os.clock()
        task.spawn(function()
            while alive() and self.afkOn do
                task.wait(30)
                if self.afkOn and C.AntiAFK then
                    pcall(sweep)
                    if os.clock() - (self.afkAt or 0) > 480 then nudge() end
                end
            end
            self.afkLoop = false
        end)
    end
end

------------------------------------------------------------------------------------------------
-- TRAVEL
------------------------------------------------------------------------------------------------

local travelFails, lastTrip = 0, 0

local function settle(timeout)
    local t0 = os.clock()
    while os.clock() - t0 < (timeout or 4) do
        local _, hrp, hum = char()
        if hrp and hum and not hrp.Anchored and hum.FloorMaterial ~= Enum.Material.Air then return true end
        task.wait(0.2)
    end
    return false
end

local function atDest(dest, owner)
    if location() ~= dest then return false end
    if dest ~= "housing" then return true end
    local o = houseOwner()
    return o == (owner or LP) or (o == nil and (owner or LP) == LP)
end

-- InteriorsM.enter takes a lock (a CriticalSection, upvalue of enter), sets `entering`,
-- and gives both back only at its very end ON THE CALLING THREAD. Cancel that thread
-- mid-trip and every later trip waits forever — seen live 2026-09-30 ("Travelling to
-- housing" for minutes, entering = true, 4 waiters queued). So a trip always runs on its
-- own thread, and a lock left stuck anyway (40 s+) is released the way enter would have.
local enteringSince = nil
local function unstickTravel()
    local getups = (debug and debug.getupvalues) or getupvalues      -- name differs per executor
    if type(getups) ~= "function" then
        -- this executor can't reach the lock (no debug.getupvalues): the hung house trips are still
        -- cancelled where getgc exists, and a public server is swapped for a fresh one when the lock
        -- is still held 10 s later — before, every trip waited on it for the rest of the session. Only
        -- where the hub comes back by itself in the next server (queue_on_teleport): without that, a
        -- hub that is jammed but alive (far furniture, food, no-trip jobs) beats a server with none
        pcall(Floor.killHung)
        if not S.noUpsTold then
            S.noUpsTold = true
            log("travel is stuck and this executor can't free the game's trip lock (no debug.getupvalues)")
        end
        local okQ, queued = pcall(function() return Crowd and Crowd.queue and Crowd.queue() end)
        if okQ and queued and Crowd.rejoin then
            pcall(Crowd.rejoin, Crowd, "the game's trip lock jammed (this executor can't free it)",
                function() return G.IM ~= nil and G.IM.entering == true end)
        end
        return false
    end
    pcall(Floor.killHung)                                          -- the trips hung inside it first
    local okU, ups = pcall(getups, G.IM.enter)
    if not okU or type(ups) ~= "table" then return false end
    for _, v in pairs(ups) do
        if type(v) == "table" and type(rawget(v, "queue")) == "table" and rawget(v, "running") ~= nil then
            pcall(function() v:signal() end)                       -- the trip lock
        elseif type(v) == "table" and type(rawget(v, "disable_table")) == "table" then
            pcall(function() v:enable("entering_interior") end)    -- interactions it turned off
        end
    end
    G.IM.entering = false
    log("travel was stuck — released the game's trip lock")
    -- the lock coming back again and again = the client itself is broken
    local now = os.clock()
    S.unsticks = S.unsticks or {}
    table.insert(S.unsticks, now)
    while S.unsticks[1] and now - S.unsticks[1] > 300 do table.remove(S.unsticks, 1) end
    if #S.unsticks >= 3 and Crowd and Crowd.rejoin then Crowd:rejoin("the game's trip lock jammed 3 times") end
    return true
end

local function travelIdle(maxWait)
    local t = 0
    while G.IM.entering and t < maxWait do
        -- a trip seen again after a gap is a new trip: restart its clock (a stale start from an
        -- older timed-out wait used to "unstick" a perfectly normal trip and jam InteriorsM)
        if os.clock() - (Floor.enterSeen or 0) > 1 then enteringSince = os.clock() end
        Floor.enterSeen = os.clock()
        enteringSince = enteringSince or os.clock()
        if os.clock() - enteringSince > 40 and not (Hallo and Hallo.active)
           and not (Floor.trip and os.clock() - (Floor.tripAt or 0) < 150
                    and (Floor.tripAt or 0) <= (enteringSince or 0) + 1) then   -- our own trip still running
            unstickTravel() enteringSince = nil break
        end
        t += task.wait(0.2)
    end
    if not G.IM.entering then enteringSince = nil end
end

-- InteriorsM's trip lock held 45 s straight — whoever started the trip (us, the game's invite,
-- a previous run) — is a jam. travelIdle only looked while it was waiting itself and restarted
-- its clock between two waits, so a jam left by an older trip was never freed (seen live
-- 2026-10-11 on ultra: lock running, 1 trip queued, "could not enter housing"). Every second
-- from the status loop.
function Floor.jamWatch()
    -- a minigame's own trips (into / out of a round) are the game's: slow at low FPS, and freeing
    -- their lock mid-way left the round's white fade on screen (2026-10-11) — Hallo:watch frees
    -- a round that really hangs. Two trips back to back (the place changed) are not one jam.
    if Hallo and Hallo.playing then Floor.jamSince = nil return end
    local loc = location()
    if G.IM and G.IM.entering and loc == Floor.jamLoc then
        Floor.jamSince = Floor.jamSince or os.clock()
        -- a trip parked in the game's house wait (Floor.houseReady) is never just slow, ours or not:
        -- looked for once a jam is 25 s old (one GC walk, ~0.1 s) instead of after 150 s
        if os.clock() - Floor.jamSince > 25 and Floor.jamScanned ~= Floor.jamSince then
            Floor.jamScanned = Floor.jamSince
            if Floor.killHung() > 0 then Floor.jamSince = nil Floor.jamLoc = loc return end
        end
        -- our own trip thread still inside InteriorsM.enter is slow, not jammed: 150 s for it
        local ours = Floor.trip ~= nil and os.clock() - (Floor.tripAt or 0) < 150
            and (Floor.tripAt or 0) <= (Floor.jamSince or 0) + 1      -- started before the lock was held
        if os.clock() - Floor.jamSince > (ours and 150 or ((Hallo and Hallo.active) and 120 or 45)) then
            Floor.jamSince = nil
            unstickTravel()
        end
    else
        Floor.jamSince = (G.IM and G.IM.entering) and os.clock() or nil
        Floor.jamScanned = nil
    end
    Floor.jamLoc = loc
    if not (Hallo and Hallo.playing) then pcall(Floor.fixHud) pcall(Floor.fixPets) end
end

-- Your pets follow by walking and only jump to you past ~100 studs: a 70-stud hop up to the floor
-- (or down to a seat) left them on the ground below or up on the floor (2026-10-12: "the pets
-- don't follow"). Brought the way the game's own trip end does (bring_pets_to_me): the pet put
-- next to you and marked for an immediate teleport. 0.4 s after a TP, at most once a second.
function Floor.bringPets()
    local _, hrp = char()
    if not hrp or Floor.travelling or (G.IM and G.IM.entering) or os.clock() - (Floor.bringAt or 0) < 1 then return end
    local okP, PEM = pcall(G.load, "PetEntityManager")
    local okW, CW = pcall(G.load, "CharWrapperClient")
    if not (okP and okW) then return end
    local moved = {}
    for _, w in pairs(CW.get_all_char_wrappers()) do
        local root = w.is_pet and w.controller == LP and w.char and w.char:FindFirstChild("HumanoidRootPart")
        local hum = root and w.char:FindFirstChildOfClass("Humanoid")
        if root and not root.Anchored and not (hum and hum.Sit) then        -- never one in a seat / bowl
            local d = root.Position - hrp.Position
            local e = (d.Magnitude > 35 or math.abs(d.Y) > 12) and PEM.get_pet_entity(w.char)
            if e then moved[#moved + 1] = { root = root, e = e } end
        end
    end
    if #moved == 0 then return end
    Floor.bringAt = os.clock()
    local cf = hrp.CFrame
    ui(function()
        for i, m in ipairs(moved) do
            m.root.AssemblyLinearVelocity = Vector3.zero
            m.root.CFrame = cf * CFrame.new(i * 3 - 4.5, 0, -3)
        end
    end)
    G.asGame(function() for _, m in ipairs(moved) do PEM.mark_for_immediate_teleport(m.e) end end)
end

-- A trip anchors your pets and marks them "changing interiors" until its very end (InteriorsM
-- unanchor_pets). A lost trip leaves them frozen in the air, so no pet task can run (2026-10-12 on
-- ultra: "the pet gets stuck", 220 studs over the player). Seen 2 s outside any trip = left over:
-- released the way the trip's end does, and brought to you. Every second from jamWatch.
function Floor.fixPets()
    if Floor.travelling or (G.IM and G.IM.entering) then Floor.petFrozenAt = nil Floor.anchAt = nil return end
    -- you, left anchored by a trip that was stopped before its own unanchor (killHung, a freed lock)
    local _, me = char()
    if me and me.Anchored and not C.Glide and not (Hallo and Hallo.active) then
        Floor.anchAt = Floor.anchAt or os.clock()
        if os.clock() - Floor.anchAt > 8 then Floor.anchAt = nil ui(function() me.Anchored = false end) end
    else
        Floor.anchAt = nil
    end
    local okP, PEM = pcall(G.load, "PetEntityManager")
    local okW, CW = pcall(G.load, "CharWrapperClient")
    if not (okP and okW) then return end
    local frozen = {}
    for _, w in pairs(CW.get_all_char_wrappers()) do
        local root = w.is_pet and w.controller == LP and w.char and w.char:FindFirstChild("HumanoidRootPart")
        local e = root and root.Anchored and PEM.get_pet_entity(w.char)
        if e and e.is_changing_interiors then frozen[#frozen + 1] = { root = root, e = e } end
    end
    if #frozen == 0 then Floor.petFrozenAt = nil return end
    Floor.petFrozenAt = Floor.petFrozenAt or os.clock()
    if os.clock() - Floor.petFrozenAt < 2 then return end
    Floor.petFrozenAt = nil
    local _, hrp = char()
    for _, f in ipairs(frozen) do
        ui(function()
            f.root.Anchored = false
            if hrp then f.root.CFrame = hrp.CFrame end
        end)
        G.asGame(function()
            PEM.mark_is_changing_interiors(f.e)
            PEM.mark_for_immediate_teleport(f.e)
        end)
    end
    if os.clock() - (Floor.petLogAt or 0) > 30 then
        Floor.petLogAt = os.clock()
        log(#frozen .. " pet(s) left frozen by a lost trip — released and brought back")
    end
end

-- The house trip turns the game's house editor on as it starts (DynamicLocationDB) and only the house's
-- own exit turns it off. A house trip that was lost or cancelled leaves it on outside: the candy
-- counter (AltCurrencyIndicatorApp hides while the editor is on) and the bucks top bar vanish
-- (2026-10-12 on ultra: "candy UI disappeared"). Every second from jamWatch: one store read.
function Floor.fixHud()
    if Floor.travelling or (G.IM and G.IM.entering) or location() == "housing" then return end
    local okS, mode = pcall(function() return G.load("ClientStore").store:getState().house_editor_state end)
    if not okS or mode == nil or mode == "Disabled" then return end
    if os.clock() - (Floor.hudAt or 0) < 10 then return end
    Floor.hudAt = os.clock()
    local okG = G.asGame(function()
        G.load("ClientStore").store:dispatch({ type = "set_house_edit_mode", value = "Disabled" })
        pcall(function() G.UIM.apps.HouseEditorWrapperApp:clear_drawer() end)
    end)
    if okG then log("the house editor was left on outside the house (a lost house trip) — off again, the candy counter is back") end
end

-- The game's house trip waits for the server to send the house (DynamicLocationDB: SubscribeToHouse,
-- then a frame loop until HouseInteriors.blueprint holds it) with NO time limit while the blueprint
-- stays empty. A server that never sends it (2026-10-12 on ultra) hangs that trip for good, and each
-- later house trip added one more: 21 frame loops at once, the farm stopped, and a time bomb (the house
-- arriving = 21 trips landing together, the white screen). So the house is asked for first — instant
-- when it is already there — and a trip that could only hang is never started.
-- 2026-10-13: the house only comes DURING a real house trip — a subscribe from outside fills nothing
-- on a healthy server either, so this probe blocked every trip home there and switched far use off.
-- Kept for reference, unused; Floor.houseHung is the check now.
function Floor.houseReady(owner)
    owner = owner or LP
    local bp = Workspace:FindFirstChild("HouseInteriors")
    bp = bp and bp:FindFirstChild("blueprint")
    if not bp then return true end                          -- another layout: the game decides
    local function ours() local c = bp:GetChildren()[1] return c ~= nil and c.Name == owner.Name end
    if ours() then return true end
    fire("HousingAPI/SubscribeToHouse", owner)
    local t = 0
    while not ours() and t < 12 do t += task.wait(0.1) end
    -- someone else's house in there still ends the game's wait (20 s); only an empty one hangs
    return bp:GetChildren()[1] ~= nil
end

-- Trips the game left hanging inside the house wait (above) are cancelled when the lock is freed:
-- their own watcher then ends the trip (lock back, character unanchored) instead of all of them
-- landing together whenever the house comes. Only on a jam (40 s+), so the full GC walk is rare.
-- A house trip waiting on an empty blueprint (the game's DynamicLocationDB wait, no time limit):
-- `ended` = asked after the trip gave up (then only the empty blueprint is checked)
function Floor.houseHung(ended)
    if not ended and not (G.IM and G.IM.entering) then return false end
    local bp = Workspace:FindFirstChild("HouseInteriors")
    bp = bp and bp:FindFirstChild("blueprint")
    return bp ~= nil and bp:GetChildren()[1] == nil
end

function Floor.killHung(force)
    if not getgc or (not force and os.clock() - (Floor.gcAt or -1e9) < 30) then return 0 end   -- one GC walk per 30 s
    Floor.gcAt = os.clock()
    -- a house in the blueprint ends the game's wait by itself (<= 20 s): only an empty one hangs
    local bp = Workspace:FindFirstChild("HouseInteriors")
    bp = bp and bp:FindFirstChild("blueprint")
    if bp and bp:GetChildren()[1] ~= nil then return 0 end
    local okG, all = pcall(getgc, true)
    if not okG or type(all) ~= "table" then return 0 end
    local n = 0
    for _, co in ipairs(all) do
        if type(co) == "thread" and coroutine.status(co) == "suspended" then
            local okT, tb = pcall(debug.traceback, co)
            if okT and type(tb) == "string" and tb:find("DynamicLocationDB", 1, true)
               and tb:find("enter_core_async", 1, true) and pcall(task.cancel, co) then
                n += 1
            end
        end
    end
    if n > 0 then log("cancelled " .. n .. " house trip(s) the game left hanging") end
    return n
end

-- A failed trip into a place whose model the game still holds (Workspace.Interiors) = that copy is
-- the broken one: a lost trip left its render half done, and the next render throws on whatever it
-- had taken off (Skelicorn bones, Wagon2024 parts…). Released through the game's own DownloadClient,
-- the next trip downloads it new (2026-10-12 on ultra: MainMap back in 5 s after 30 min of "could
-- not enter MainMap"). After a failure only (`force` = the 2nd try of the same trip).
function Floor.freshPlace(dest, force)
    if not (force or (Floor.failsTo and (Floor.failsTo[dest] or 0) >= 1)) then return end
    local ints = Workspace:FindFirstChild("Interiors")
    local okD, DC = pcall(G.load, "DownloadClient")
    if not (ints and okD and type(DC) == "table") then return end
    local okL, loc = pcall(G.IM.get_current_location)
    local here = okL and type(loc) == "table" and not rawget(loc, "exited") and loc.interior or nil
    for _, m in ipairs(ints:GetChildren()) do
        local n = m.Name
        if (n == dest or n:sub(1, #dest + 1) == dest .. "!") and m ~= here then
            local okC, cached = pcall(DC.is_cached, "Interiors", n)
            if okC and cached then
                G.asGame(DC.release, "Interiors", n)
                log("dropped the game's broken copy of " .. n .. " — the next trip loads it new")
            end
        end
    end
end

-- The game moves a place's occupants folder out to Workspace on arrival and back on leaving. A trip
-- lost in between strands it there, and from then on every trip to that place throws "<place> is
-- not a valid member of Folder interior_occupants" (2026-10-12 on ultra: MainMap and Neighborhood
-- both — every outdoor task and the way home failed). Put a stranded one back before the trip.
function Floor.fixOcc(dest)
    if type(dest) ~= "string" then return end
    local okL, loc = pcall(G.IM.get_current_location)
    local mine = okL and type(loc) == "table" and rawget(loc, "interior_occupants_folder") or nil
    local onMap = okL and type(loc) == "table" and loc.destination_id == "MainMap" and not rawget(loc, "exited")
    local private = Crowd and Crowd.public and not Crowd:public()
    -- the writes on the clean Heartbeat thread, waited for (<= 1 s, the trip needs them): a thread
    -- that called game modules can't make instances ("lacking capability Plugin", 2026-10-12)
    local done, late = false, false
    ui(function() if not late then pcall(Floor.fixOccNow, dest, mine, onMap, private) end done = true end)
    local t = 0
    while not done and t < 1 do t += task.wait() end
    late = true                                -- too late now: the trip may have moved the folder itself
end
function Floor.fixOccNow(dest, mine, onMap, private)
    local occ = Workspace:FindFirstChild("interior_occupants")
    if not occ then return end
    for _, f in ipairs(Workspace:GetChildren()) do
        local n = f.Name
        if (n == dest or n:sub(1, #dest + 1) == dest .. "!") and f ~= mine and f:IsA("Folder")
           and not occ:FindFirstChild(n) then
            f.Parent = occ
            log("put back " .. n .. "'s occupants folder (a lost trip left it out) — trips there work again")
        end
    end
    -- Halloween 2026: the Science Shack scene takes the Skelicorn bones off the map (parent nil) and
    -- puts them back when you leave it. A lost trip skipped that, and MainMap's render then throws on
    -- the missing bones (LightningLeverClient: "attempt to index nil with 'Parent'") — every trip to
    -- MainMap failed after it (2026-10-12 on ultra). The map model is kept between visits: put them
    -- back, only while we are not on the map (there the scene owns them).
    if dest == "MainMap" and getnilinstances and not onMap then
        for _, root in ipairs({ Workspace:FindFirstChild("Interiors") or Workspace, Workspace }) do
            for _, m in ipairs(root:GetChildren()) do
                local ped = m.Name:sub(1, 8) == "MainMap!" and m:FindFirstChild("PedestalItems")
                if ped and not ped:FindFirstChild("SkelicornUnicornBones") then
                    local back = false
                    for _, d in ipairs(getnilinstances()) do
                        if d.Name == "SkelicornUnicornBones" then
                            d.Parent, back = ped, true
                            log("put the Skelicorn bones back on " .. m.Name .. " (a lost trip left them off) — MainMap works again")
                            break
                        end
                    end
                    -- gone for good (destroyed): a public server is left for a clean one (failsTo); a
                    -- private one can't be, so an empty stand-in lets the map render (only the lever
                    -- cutscene's bone animation has nothing to move)
                    if not back and private then
                        local stand = Instance.new("Model")
                        stand.Name = "SkelicornUnicornBones"
                        stand.Parent = ped
                        log("the Skelicorn bones were destroyed by a lost trip — empty stand-in so MainMap renders (private server)")
                    end
                end
            end
        end
    end
end

-- A trip the game itself lost half way leaves its current location exited but still current (seen
-- 2026-10-12 on ultra for 87 min: the Pet Shop's own exit cleanup threw "InteriorsDB:1395: attempt
-- to call a nil value"). Every later trip re-runs that exit first, throws the same error inside
-- InteriorsM and never moves: "could not enter …" forever, nothing farms. The place is already
-- left — swap its broken exit for the cleanup steps that are left, each on its own. One table
-- read per trip; nothing changes on a healthy client.
function Floor.fixLoc()
    if not G.IM or G.IM.entering then return false end
    local ok, loc = pcall(G.IM.get_current_location)
    if not (ok and type(loc) == "table" and rawget(loc, "exited") == true and rawget(loc, "exit") == nil) then
        return false
    end
    loc.exit = function(self)
        self.exited = true
        pcall(function() G.load("ShopInteriorHelper").cleanup() end)
        pcall(function() G.load("ContentPackHelper").interior_cleanup(self.interior, self) end)
        pcall(function() self._location_maid:DoCleaning() end)
        pcall(function() self.interior_occupants_folder.Parent = Workspace.interior_occupants end)
    end
    log("the game lost its last trip half way (" .. tostring(rawget(loc, "destination_id")) .. ") — skipped its broken exit")
    return true
end

-- One trip at a time, >= 1 s apart, unseated first, the switch confirmed, one retry,
-- then a settle and the floor moved under the new place.
local function goTo(dest, owner, extra, noSettle)
    if Hallo and Hallo.inRound and Hallo:inRound() then return false end   -- never mid-round
    -- never start a trip on top of an opaque transition (the game mid-trip / mid-exit)
    local wq = 0
    while Hallo and Hallo.whiteout and Hallo.whiteout() and wq < 5 do wq += task.wait(0.25) end
    -- an earlier goTo gave up on a trip whose thread is still inside InteriorsM.enter: wait for it
    -- (30 s), never start a 2nd enter on top of it
    local wt = 0
    while Floor.trip and os.clock() - (Floor.tripAt or 0) < 150 and wt < 30 do wt += task.wait(0.25) end
    if Floor.trip and os.clock() - (Floor.tripAt or 0) < 150 then return atDest(dest, owner) end
    if atDest(dest, owner) then return true end
    travelIdle(20)
    if atDest(dest, owner) then return true end    -- the trip we waited out went there
    if G.IM.entering then return false end          -- still held: ours would only queue behind it
    local gap = 0.6 - (os.clock() - lastTrip)
    if gap > 0 then task.wait(gap) end
    local door, opts = "MainDoor", extra or {}
    if dest == "MainMap" then door = "Neighborhood!MainDoor"
    elseif dest == "housing" then opts.house_owner = owner or LP end
    -- a house the server wouldn't send twice in a row (Floor.houseHung below): not tried again for 5 min
    if dest == "housing" and opts.house_owner == LP and os.clock() < (Floor.noHouseUntil or 0) then return false end
    unseat()
    setStatus("Travelling to " .. (owner and owner ~= LP and (owner.Name .. "'s house") or dest))
    Floor.travelling = true
    local ok = false
    for attempt = 1, 2 do
        -- the 1st one landed late, or a game trip just started: no 2nd enter on top
        if attempt == 2 and (atDest(dest, owner) or G.IM.entering) then ok = atDest(dest, owner) break end
        lastTrip = os.clock()
        local done, token = false, {}
        Floor.fixLoc()                         -- a dead place left by a lost trip
        Floor.fixOcc(dest)                     -- its occupants folder left out by one
        Floor.freshPlace(dest, attempt == 2)   -- after a failure: the place's model downloaded new
        Floor.trip, Floor.tripAt = token, os.clock()
        if not G.IM.entering then Floor.jamSince = nil end   -- jamWatch times THIS trip, not the last one
        task.spawn(function()                  -- its own thread: never cancelled mid-trip
            pcall(function() (setthreadidentity or set_thread_identity or setidentity)(2) end)   -- see G.asGame
            pcall(G.IM.enter, dest, door, opts)
            done = true
            if Floor.trip == token then Floor.trip = nil end
            -- landed after goTo gave up on it: the void catcher must not keep the old place's spots
            if not Floor.travelling then pcall(Floor.arrived, Floor) end
        end)
        local t = 0
        while not done and t < 35 do
            t += task.wait()
            -- a house trip still waiting for a house the server hasn't sent after 20 s never ends by
            -- itself (Floor.houseHung): its wait is cut now, not by jamWatch later
            if dest == "housing" and t > 20 and not Floor.houseCut and Floor.houseHung() then
                Floor.houseCut = true
                local okK, nk = pcall(Floor.killHung, true)
                Floor.houseCutHit = okK and (nk or 0) > 0      -- a real hung house wait was cut
            end
        end
        Floor.houseCut = nil
        travelIdle(10)
        local w = 0
        while not atDest(dest, owner) and w < 4 do                            -- big houses register late
            local okL, l = pcall(G.IM.get_current_location)
            if okL and type(l) == "table" and rawget(l, "exited") then break end -- it died: no point waiting
            w += task.wait(0.1)
        end
        ok = atDest(dest, owner)
        if ok or attempt == 2 then break end
        -- the 1st trip still inside InteriorsM.enter (slow at low FPS, not dead): a 2nd enter now
        -- = 2 trips at once (the white screen). Wait for it; still running after = jamWatch's job
        local w2 = 0
        while not done and w2 < 40 do w2 += task.wait(0.25) end
        ok = atDest(dest, owner)
        if ok or not done then break end
        task.wait(1.5)
    end
    -- MainMap with the task floor on: straight up to it (goFloor), no waiting to land at the map's
    -- door first — that wait was the 2-3 s fall after every task (2026-10-12)
    if ok and noSettle and dest == "MainMap" and C.TaskFloor and Floor.model then
        -- goFloor's trip: put straight onto the floor above the door (it covers the whole map) —
        -- no fall from the door spawn while goFloor gets going
        local _, h, hm = char()
        if h then
            h.AssemblyLinearVelocity = Vector3.zero
            h.CFrame = CFrame.new(h.Position.X, FLOOR_TOP + (hm and hm.HipHeight or 2) + h.Size.Y / 2 + 0.1, h.Position.Z)
        end
    elseif ok then
        settle(4)
    end
    Floor.travelling = false
    if ok and dest == "housing" and (owner or LP) == LP then Floor.noHouse, Floor.noHouseUntil = 0, nil end
    local cutHit = Floor.houseCutHit
    Floor.houseCutHit = nil
    if not ok and dest == "housing" and (owner or LP) == LP and cutHit then
        -- the server never sent your house (2026-10-12 on ultra): twice = 5 min without house trips,
        -- and a public server is left for a new one
        Floor.noHouse = (Floor.noHouse or 0) + 1
        log("the server didn't send your house (" .. Floor.noHouse .. ")")
        if Floor.noHouse >= 2 then
            Floor.noHouseUntil = os.clock() + 300
            if Crowd and Crowd.rejoin then
                Crowd:rejoin("the server never sends your house", function() return (Floor.noHouse or 0) >= 2 end)
            end
        end
    end
    if ok then
        Floor:arrived()
        travelFails = 0
        if Floor.failsTo then Floor.failsTo[dest] = 0 end
    else
        log("could not enter " .. (owner and owner ~= LP and (owner.Name .. "'s house") or dest))
        -- someone else's house refusing us (locked, still loading) says nothing about this client
        if not (owner and owner ~= LP) then
            travelFails += 1
            -- one place failing every time while trips elsewhere work (they reset travelFails) = this
            -- client's copy of that place is broken (2026-10-12: MainMap) and freshPlace couldn't mend it:
            -- a new server, the last resort
            Floor.failsTo = Floor.failsTo or {}
            Floor.failsTo[dest] = (Floor.failsTo[dest] or 0) + 1
            if Floor.failsTo[dest] >= 4 and Crowd and Crowd.rejoin then
                Crowd:rejoin(dest .. " can't be entered any more", function() return (Floor.failsTo[dest] or 0) >= 4 end)
            end
            -- every 3rd failure in a row, so a hop that failed (or was skipped) gets another try
            if travelFails % 3 == 0 then
                notify("Travel is stuck", "Trips keep failing — rejoin the game if it doesn't recover.")
                if Crowd and Crowd.rejoin then
                    Crowd:rejoin(travelFails .. " trips in a row failed", function() return travelFails >= 3 end)
                end
            end
        end
    end
    return ok
end

-- Moves on the streamed main map: stream the spot in first, then an instant TP (the
-- default), or a glide when Settings › Glide is on (a ≤ 2 s tween facing the way you go).
-- The root is anchored only for the glide so physics doesn't fight the tween, and it is
-- always un-anchored again, even if the step gets cut by its watchdog mid-glide.
local function tpTo(pos)
    if Hallo and Hallo.inRound and Hallo:inRound() then return end         -- never mid-round
    unseat()                                -- a seated root gets pulled back to its seat
    local _, hrp, hum = char()
    if not hrp then return end
    -- the seat weld only drops on the next physics step: a TP before it drags you back to the seat
    local ws = 0
    while hum and hum.SeatPart and ws < 0.5 do ws += task.wait() end
    -- feet exactly on the spot (a baby, a tall avatar: not a fixed +3)
    local goal = pos + Vector3.new(0, (hum and hum.HipHeight or 2) + hrp.Size.Y / 2 + 0.1, 0)
    local dist = (hrp.Position - goal).Magnitude
    task.delay(0.4, function() pcall(Floor.bringPets) end)    -- the pets come along
    -- the task floor is ours (nothing to stream): no waiting for the map under it — that wait was
    -- spent falling at the map's door (2026-10-12: "2-3 s fall before the platform")
    local toFloor = math.abs(pos.Y - FLOOR_TOP) < 0.5 or math.abs(pos.Y - Floor.SKY_TOP) < 0.5
    if dist > 150 and toFloor and not S.streamBusy then
        S.streamBusy = true
        task.spawn(function()
            pcall(function() LP:RequestStreamAroundAsync(pos, 3) end)
            S.streamBusy, S.streamMiss = false, 0
        end)
    elseif dist > 150 and not toFloor then
        -- RequestStreamAroundAsync ignores its own timeout and can hang for minutes (seen
        -- live 2026-10-04: > 12 s, the cat / beach trip froze until the 260 s watchdog), and
        -- a hung request blocks the next ones. One request out at a time, 1.5 s wait at most;
        -- a late answer still counts (it clears the miss count whenever it comes back)
        if S.streamBusy then
            -- the last trip's request still hasn't answered: a new one would only queue behind it
            S.streamMiss = (S.streamMiss or 0) + 1
            if S.streamMiss % 6 == 0 and Crowd and Crowd.rejoin then
                Crowd:rejoin("map streaming stopped answering", function() return S.streamBusy == true end)
            end
        else
            S.streamBusy = true
            task.spawn(function()
                pcall(function() LP:RequestStreamAroundAsync(pos, 3) end)
                S.streamBusy, S.streamMiss = false, 0
            end)
            local w = 0
            while S.streamBusy and w < 1.5 do w += task.wait(0.1) end
        end
    end
    hrp.AssemblyLinearVelocity = Vector3.zero
    if not (C.Glide and G.TS and dist > 6) then
        hrp.CFrame = CFrame.new(goal)
        return
    end
    local flat = Vector3.new(goal.X - hrp.Position.X, 0, goal.Z - hrp.Position.Z)
    local cf = flat.Magnitude > 1 and CFrame.lookAt(goal, goal + flat) or CFrame.new(goal)
    local dur = math.clamp(dist / math.max(20, tonumber(C.GlideSpeed) or 160), 0.2, 2)
    local okT, tw = pcall(function()
        return G.TS:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { CFrame = cf })
    end)
    if not okT then hrp.CFrame = CFrame.new(goal) return end
    hrp.Anchored = true
    local tok = {}
    Floor.glideTok = tok
    task.delay(dur + 1, function() if Floor.glideTok == tok and hrp.Parent and hrp.Anchored then hrp.Anchored = false end end)
    tw:Play()
    local t = 0
    while t < dur + 0.3 and tw.PlaybackState == Enum.PlaybackState.Playing do t += task.wait() end
    pcall(function() tw:Cancel() end)
    hrp.CFrame = cf
    hrp.Anchored = false
    hrp.AssemblyLinearVelocity = Vector3.zero
end

local anchorCache = {}
local function anchorPos(key)
    local node = Workspace:FindFirstChild("StaticMap")
    for _, seg in ipairs(ANCHOR_PATH[key]) do node = node and node:FindFirstChild(seg) end
    if node and node:IsA("BasePart") then anchorCache[key] = node.Position end
    return anchorCache[key] or ANCHOR_FALLBACK[key]
end

-- A spot on the task floor straight above an area anchor. The default is the park, so
-- waiting there also counts for "bored".
local function floorSpot(key)
    local a = anchorPos(key or "bored")
    return Vector3.new(a.X, FLOOR_TOP, a.Z)
end

-- Onto the task floor (above `key`'s anchor). Pets left on the ground below are
-- brought back up by re-equipping them next to you.
goFloor = function(key)
    if Hallo and Hallo.inRound and Hallo:inRound() then return false end   -- never mid-round
    if not (C.TaskFloor and Floor.model) then return false end
    if location() ~= "MainMap" and not goTo("MainMap", nil, nil, true) then return false end
    local sky = key == nil and Floor.skyOn()
    local target = sky and Vector3.new(Floor.sky.Position.X, Floor.SKY_TOP, Floor.sky.Position.Z) or floorSpot(key)
    local _, hrp = char()
    if not hrp then return false end
    local p = hrp.Position
    if sky and Floor:onSky() then return true end
    if not sky and Floor:onFloor() and math.abs(p.Y - target.Y) < 15
       and Vector3.new(p.X - target.X, 0, p.Z - target.Z).Magnitude < 30 then return true end
    unseat()
    setStatus(sky and "Going up to the sky square" or "Going up to the task floor")
    tpTo(target)
    settle(2)
    local list = Farm and Farm:uniques() or {}
    local function behind()                              -- farm pets not up here with you
        local _, me2 = char()
        local out = {}
        for _, u in ipairs(list) do
            local w = wrapperOf(u)
            local root = w and (w.char.PrimaryPart or w.char:FindFirstChild("HumanoidRootPart"))
            if me2 and (not root or (root.Position - me2.Position).Magnitude > 30) then out[#out + 1] = u end
        end
        return out
    end
    -- pets usually follow on their own: wait for them (<= 0.8 s), not a flat 0.8 s
    local tw = os.clock()
    while os.clock() - tw < 0.8 and #behind() > 0 do task.wait() end
    local moved = false
    for _, u in ipairs(behind()) do
        invoke("ToolAPI/Unequip", u)
        moved = true
        task.wait(0.3)
    end
    if moved then setEquipped(list) end
    return Floor:onFloor()
end

-- Where the farm waits between jobs: the task floor, else home, else the Neighborhood.
local function goBase()
    if C.TaskFloor and Floor.model then return goFloor() end
    return goTo(C.HomeTasks and "housing" or "Neighborhood")
end

-- Play / walk / ride: anywhere on the task floor will do. goFloor() re-centred on the park spot
-- (a TP, a settle, the pets' wait) after every area hop; now only when off the floor.
function Floor.toBase()
    if C.TaskFloor and Floor.model then
        if not Floor:onFloor() then goFloor() end
    elseif C.HomeTasks then
        goTo("housing")
    end
end

------------------------------------------------------------------------------------------------
-- STEP GUARD — nothing may hang the farm
------------------------------------------------------------------------------------------------

-- Runs fn on its own thread; past `limit` seconds the thread is cancelled and the farm
-- moves on. Returns ok, result.
local function guarded(label, limit, fn, ...)
    local args = table.pack(...)
    local done, ok, res = false, false, nil
    local th = task.spawn(function()
        ok, res = pcall(fn, table.unpack(args, 1, args.n))
        done = true
    end)
    local t0 = os.clock()
    while not done and alive() and os.clock() - t0 < limit do task.wait() end   -- next frame, not the next 0.25 s
    -- script stopped / reloaded: leave the step to finish on its own (cancelling it mid-trip
    -- is what jammed InteriorsM after a reload)
    if not done and not alive() then return false, "stopped" end
    if not done then
        pcall(task.cancel, th)
        Floor.travelling = false
        unseat()
        -- a cut ride / walk must not leave the stroller or leash on (with the pet seated)
        if S.held then local h = S.held S.held = nil task.spawn(pcall, invoke, "ToolAPI/Unequip", h, {}) end
        log(label .. " took too long — skipped")
        return false, "timeout"
    end
    if not ok then log(label .. " error: " .. tostring(res)) end
    return ok, res
end

-- Waits up to `secs`, back on the next frame once ClientData's ailments_manager changed (S.needAt,
-- set by the game's own ClientData hook installed at boot): a new or cleared need is seen at
-- once instead of at the next 0.25 / 0.5 s tick.
function Floor.nap(secs)
    local t0, seen = os.clock(), S.needAt
    repeat task.wait() until os.clock() - t0 >= secs or S.needAt ~= seen
end

------------------------------------------------------------------------------------------------
-- NEEDS
------------------------------------------------------------------------------------------------

local BABY = { kind = "baby", key = "baby" }
local function petSubject(u) return { kind = "pet", key = u, unique = u } end
local function teamOf(s) return s.kind == "baby" and "Babies" or "Pets" end

local function needTable(subject)
    local d = me()
    local am = d and d.ailments_manager
    if not am then return nil end
    return subject.kind == "baby" and am.baby_ailments or (am.ailments or {})[subject.unique]
end

local function needsOf(subject)
    local out = {}
    for k in pairs(needTable(subject) or {}) do out[#out + 1] = k end
    return out
end

local function hasNeed(subject, need)
    local t = needTable(subject)
    return t ~= nil and t[need] ~= nil
end

local function subjectChar(subject)
    if subject.kind == "baby" then return LP.Character end
    local w = wrapperOf(subject.unique)
    return w and w.char
end

local function waitCleared(subjects, need, timeout)
    local t0 = os.clock()
    while alive() and os.clock() - t0 < timeout do
        local left = false
        for _, s in ipairs(subjects) do
            if hasNeed(s, need) then left = true break end
        end
        if not left then return true end
        Floor.nap(0.25)
    end
    return false
end

-- A need that failed is retried soon: after 15 s, then 30 s, then every 60 s while it keeps
-- failing (a wish that can't be done is set aside separately by Pref:park, not here).
local backoff, streak = {}, {}
local function blocked(subject, need)
    local u = backoff[subject.key .. "|" .. need]
    if u and os.clock() < u then return true end
    return Pref ~= nil and Pref.parked ~= nil and Pref:parked(subject, need)
end
local function fail(subject, need, why)
    local k = subject.key .. "|" .. need
    streak[k] = (streak[k] or 0) + 1
    local wait = ({ 15, 30, 60 })[math.min(streak[k], 3)]
    backoff[k] = os.clock() + wait
    log(("%s %s: %s (retry in %ds)"):format(subject.kind or "?", need, why or "failed", wait))
end
local function succeed(subject, need)
    local k = subject.key .. "|" .. need
    streak[k], backoff[k] = nil, nil
end

------------------------------------------------------------------------------------------------
-- FURNITURE — cribs, baths, bowls, hydrants, hospital beds
------------------------------------------------------------------------------------------------

-- `kind`: for a model that isn't placed (Home:kindInfo's download has no furniture_kind attribute)
local function behaviorsFor(model, kind)
    kind = kind or model:GetAttribute("furniture_kind")
    if not kind then return {} end
    local ok, list = pcall(G.AFH.get_behaviors_from_kind, kind, model)
    return ok and type(list) == "table" and list or {}
end

-- Same rule the game uses (AilmentsFurnitureHelper), but for babies as well as pets.
local function usableBy(model, need, teamName, kind)
    kind = kind or model:GetAttribute("furniture_kind")
    local fdb = G.FDB[kind]
    if fdb and fdb.team_whitelist and not table.find(fdb.team_whitelist, teamName) then return false end
    for _, b in ipairs(behaviorsFor(model, kind)) do
        if type(b) == "table" and type(b.ailment_to_boost) == "table"
           and b.ailment_to_boost[1] == need and not b.interaction_locking then
            if not b.team_whitelist or table.find(b.team_whitelist, teamName) then return true end
        end
    end
    return false
end

-- Nearest free seat (UseBlock) that clears `need` for this team. `skip` holds blocks
-- already given to someone else this round.
local function findFurniture(need, teamName, skip, from)
    local ok, list = pcall(G.FMT.get_furniture_models_list)
    if not ok or type(list) ~= "table" then return nil end
    local _, hrp = char()
    local o = from or (hrp and hrp.Position)              -- nearest to `from` when given
    local best, bestBlock, bestD
    for _, m in ipairs(list) do
        if m.Parent and m:GetAttribute("furniture_unique") and usableBy(m, need, teamName) then
            local ub = m:FindFirstChild("UseBlocks")
            for _, b in ipairs(ub and ub:GetChildren() or {}) do
                if b:IsA("BasePart") and not (skip and skip[b]) then
                    local d = o and (b.Position - o).Magnitude or 0
                    if not bestD or d < bestD then best, bestBlock, bestD = m, b, d end
                end
            end
        end
    end
    return best, bestBlock
end

local function needEntry(subject, need)
    local t = needTable(subject)
    return t and t[need]
end

-- Everyone in `assign` ({subject, model, block[, need]}) uses their seat at the same time —
-- each its own need when given (baby in the crib while the pet showers), else `need`.
-- Pets first, so you're still standing (pets only use furniture near their caregiver).
-- Rolling (asked 2026-10-11: "baby and pet 2-4 tasks at the same time, detection and a
-- fallback"): whoever finishes gets its next seat right away from `roll` (optional) instead
-- of waiting for the slowest one; a use that isn't counting (rate 0: never started, or thrown
-- out of the seat) is fired again, then moved to another seat, then given up; and a use waits
-- as long as its own rate says (the old flat 40 s cut slow seats at ~80 % — "couldn't clear
-- it" on sleepy / dirty / toilet). roll(busy, inUse, gaveUp) → new entries for idle subjects,
-- appended to `assign` so the caller reports them. Returns the set of subjects whose use
-- actually started.
local function useGroup(assign, need, anchor, during, roll, far)
    if os.clock() + 8 > (S.jobEnd or math.huge) - 2 then return {} end      -- no time to seat anyone
    table.sort(assign, function(a, b) return a.subject.kind == "pet" and b.subject.kind ~= "pet" end)
    local owner = location() == "housing" and (houseOwner() or LP) or nil
    if not far then
        anchor = anchor or assign[1].block.Position
        tpTo(anchor + Vector3.new(3, -2, 3))
        task.wait(0.4)
    end
    local inUse, set, gaveUp, pending = {}, {}, {}, {}
    -- per use; each also ends at its own ETA (+6 s) once it counts. Room seats in an area too:
    -- 40 s cut a bed at ~80 % and the rest cost a trip home
    local limit = roll and 120 or 65
    local side, parent = { on = false }, coroutine.running()
    local function fire(a)
        local now = os.clock()
        a.moved, a.eta = now, nil          -- firedAt only once it really fired (a pet still loading isn't a miss)
        local model = subjectChar(a.subject)
        if not model then return false end
        if a.subject.kind == "baby" then           -- off the last seat before the next one
            local _, _, hum = char()
            if hum and hum.Sit then hum.Sit = false task.wait(0.2) end
        end
        if a.far then
            -- your house's piece, used from right here (Home.far): the game seats you / the pet
            -- where you stand — no trip home
            local root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
            if not root then return false end                -- respawning / streaming: next tick
            local unique, bname = a.unique, a.blockName
            local cf = root.CFrame
            task.spawn(function()
                invoke("HousingAPI/ActivateFurniture", LP, unique, bname, { cframe = cf }, model)
            end)
            a.firedAt = now
            return true
        end
        local unique, block = a.model:GetAttribute("furniture_unique"), a.block
        task.spawn(function()
            -- yields for as long as the furniture is in use
            if owner then
                invoke("HousingAPI/ActivateFurniture", owner, unique, block.Name, { cframe = block.CFrame }, model)
            else
                invoke("HousingAPI/ActivateInteriorFurniture", unique, block.Name, { cframe = block.CFrame }, model)
            end
        end)
        a.firedAt = now
        return true
    end
    local function show()
        local names = {}
        for _, a in ipairs(pending) do names[#names + 1] = a.subject.kind .. " " .. tostring(a.need or need) end
        if #names > 1 then setStatus(("%d tasks at once: %s"):format(#names, table.concat(names, ", "))) end
    end
    for _, a in ipairs(assign) do
        inUse[a.block] = true
        if fire(a) then pending[#pending + 1] = a task.wait(a.far and 0.1 or 0.35) end
    end
    local quickAt, rollAt = 0, os.clock()
    local hardEnd = math.min(os.clock() + 150, (S.jobEnd or math.huge) - 2)
    while alive() and os.clock() < hardEnd do
        local now, still, busy = os.clock(), {}, {}
        for _, a in ipairs(pending) do
            local n = a.need or need
            local e = needEntry(a.subject, n)
            if not e then
                set[a.subject] = true                                     -- cleared
                inUse[a.block] = nil                                      -- free for the next one
            else
                local rate, keep = tonumber(e.rate) or 0, true
                if rate > 0 then
                    set[a.subject], a.ok, a.moved = true, true, now
                    if not a.eta then
                        local p = (tonumber(e.progress) or 0)
                            + rate * math.max(0, Workspace:GetServerTimeNow() - (tonumber(e.rate_timestamp) or math.huge))
                        a.eta = now + math.clamp((1 - p) / rate, 0, limit) + 6
                    end
                elseif now - a.moved > ((a.ok or a.far) and 4 or 8) then
                    -- not counting: the same seat again, then another seat, then give up
                    a.tries = (a.tries or 0) + 1
                    if a.tries == 2 and a.far then
                        a.tries = 3                                       -- far: the trip home is the fallback
                    elseif a.tries == 2 then
                        local skip = setmetatable({ [a.block] = true }, { __index = inUse })
                        local model, block = findFurniture(n, teamOf(a.subject), skip, anchor)
                        if model and (block.Position - anchor).Magnitude <= 20 then
                            a.model, a.block, inUse[block] = model, block, true
                        else
                            a.tries = 3
                        end
                    end
                    if a.tries <= 2 then
                        log(("%s %s: not counting — %s"):format(a.subject.kind, n,
                            a.tries == 1 and "using the seat again" or "trying another seat"))
                        keep = fire(a)
                    else
                        keep = false
                    end
                end
                if keep and (now - a.firedAt > limit or (a.eta and now > a.eta)) then keep = false end
                if keep then
                    still[#still + 1] = a
                    busy[a.subject.key] = true
                else
                    gaveUp[a.subject.key .. "|" .. n] = true
                end
            end
        end
        local changed = #still ~= #pending
        pending = still
        -- whoever is free takes its next seat now (no waiting for the slowest)
        -- (at once when someone frees up, else every 5 s: a roll rescans the furniture)
        if roll and (changed or now - rollAt > 5 or (S.needAt or 0) > rollAt) and now - rollAt > 1 and now + 15 < hardEnd then
            rollAt = now
            if side.on then busy[BABY.key] = true end     -- the baby may be eating: no seat for it now
            local ok, add = pcall(roll, busy, inUse, gaveUp)
            for _, a in ipairs(ok and type(add) == "table" and add or {}) do
                if fire(a) then
                    assign[#assign + 1] = a
                    pending[#pending + 1] = a
                    busy[a.subject.key], changed = true, true
                    task.wait(a.far and 0.1 or 0.35)
                end
            end
        end
        if #pending == 0 then break end
        if changed then show() end
        -- meanwhile whoever isn't seated does its quick needs (food / drink / heal items, mysteries)
        -- on their own thread: a 15 s feed no longer stops re-seating / rolling
        if during and not side.on and (now - quickAt > 2 or (now - quickAt > 0.5 and (S.needAt or 0) > quickAt)) then
            quickAt = now
            local b2 = table.clone(busy)
            side.on = true
            side.th = task.spawn(function() pcall(during, b2) side.on = false end)
            if side.on then
                task.spawn(function()
                    while side.on and coroutine.status(parent) ~= "dead" do task.wait(0.5) end
                    if side.on then pcall(task.cancel, side.th) side.on = false end
                end)
            end
        end
        Floor.nap(0.5)
    end
    do
        local w = 0
        while side.on and w < 15 do w += task.wait(0.2) end
        if side.on and side.th then pcall(task.cancel, side.th) side.on = false end
    end
    for _, a in ipairs(assign) do
        if a.subject.kind == "baby" then
            local _, _, hum = char()
            if hum then hum.Sit = false hum.Jump = true end
            break
        end
    end
    return set
end

------------------------------------------------------------------------------------------------
-- HOME — free task furniture placed in YOUR house
------------------------------------------------------------------------------------------------

Home = { placed = 0, perNeed = {} }
local HOME_CAP = 3          -- at most 3 of one piece placed per session

local function inOwnHouse()
    if location() ~= "housing" then return false end
    local o = houseOwner()
    return o == nil or o == LP
end

-- Where a new piece goes: the house editor's own floor placement, around where you stand.
function Home:placement(kind, index)
    local entry = G.FDB[kind]
    if not entry then return nil end
    local okM, model = pcall(function() return G.DL.download("Furniture", entry.model_name):Clone() end)
    if not okM or not model then return nil end
    local _, hrp = char()
    local base = hrp and hrp.Position or Vector3.zero
    local spread = Vector3.new(((index or 0) % 5) * 5, 0, math.floor((index or 0) / 5) * 5)
    local cf
    for _, off in ipairs({ Vector3.zero, Vector3.new(6, 0, 0), Vector3.new(-6, 0, 0),
                           Vector3.new(0, 0, 6), Vector3.new(0, 0, -6), Vector3.new(10, 0, 10) }) do
        local okP, res = pcall(G.FP.calculate_placement_on_floor, {
            is_first_placement = true, interval = 0.1, house = G.FP.get_house(), furniture = model,
            rotation = CFrame.new(), ray_position = base + spread + off,
        })
        if okP and res then cf = res break end
    end
    pcall(function() model:Destroy() end)
    pcall(G.DL.release, "Furniture", entry.model_name)
    return cf
end

function Home:place(need)
    local spec = HOME_KIND[need]
    if not spec or (self.perNeed[need] or 0) >= HOME_CAP then return false end
    local cf = self:placement(spec.kind, self.placed)
    if not cf then
        log("no floor space found for a " .. spec.name)
        return false
    end
    local ok, res = invoke("HousingAPI/BuyFurnitures", { { kind = spec.kind, properties = { cframe = cf } } })
    local good = ok and type(res) == "table" and res.success == true
    if good then
        self.placed += 1
        self.perNeed[need] = (self.perNeed[need] or 0) + 1
        log("placed a " .. spec.name .. " in your house")
        notify("House", "Placed a " .. spec.name .. " (free)")
        task.wait(1.5)                       -- let the new model register
    else
        log("could not place a " .. spec.name)
        self.perNeed[need] = HOME_CAP        -- don't keep trying this session
    end
    return good
end

-- One seat per subject in `list` for `need` — free pieces placed for whoever has none.
function Home:ensure(need, list)
    local spec = HOME_KIND[need]
    if not (C.HomeTasks and spec) or not inOwnHouse() then return end
    local used = {}
    for _, s in ipairs(list) do
        if not (spec.petsOnly and s.kind == "baby") then
            local _, b = findFurniture(need, teamOf(s), used)
            if not b and self:place(need) then
                _, b = findFurniture(need, teamOf(s), used)
            end
            if b then used[b] = true end
        end
    end
end

-- FAR (2026-10-11, seen in another hub and verified on Draven): the game seats you / your pet on
-- YOUR house's crib, bath, litter box or bowl wherever you stand — HousingAPI/ActivateFurniture
-- with the piece's unique and your own position. So the pieces are remembered on every visit
-- home and the next sleepy / dirty / toilet / bowl jobs need no trip home and back (~15-25 s
-- each). A use that never counts (2 jobs in a row) turns it off for 30 min: back to the trips.
Home.FAR_NEEDS = { "sleepy", "dirty", "toilet", "hungry", "thirsty" }
function Home:houseId()
    for _, h in pairs(me() and me().house_manager or {}) do
        if type(h) == "table" and h.active then return h.house_id end
    end
end
function Home:remember()
    if not inOwnHouse() then return end
    local root = Workspace:FindFirstChild("HouseInteriors")
    local ok, list = pcall(G.FMT.get_furniture_models_list)
    if not (root and ok and type(list) == "table") then return end
    local seats, n, kinds = {}, 0, self:farMem().kinds
    for _, m in ipairs(list) do
        local ub = m.Parent and m:IsDescendantOf(root) and m:GetAttribute("furniture_unique") and m:FindFirstChild("UseBlocks")
        local b = ub and ub:FindFirstChildWhichIsA("BasePart")
        if b then
            -- each kind's block + uses too: what Home:boot reads the server's list with next launch
            local kind, k = m:GetAttribute("furniture_kind"), { block = b.Name, use = {} }
            for _, need in ipairs(Home.FAR_NEEDS) do
                for _, tm in ipairs({ "Babies", "Pets" }) do
                    if usableBy(m, need, tm) then
                        seats[need] = seats[need] or { Babies = {}, Pets = {} }
                        table.insert(seats[need][tm], { unique = m:GetAttribute("furniture_unique"), block = b.Name })
                        n += 1
                        k.use[#k.use + 1] = need .. "|" .. tm
                    end
                end
            end
            if kind then kinds[kind] = k end
        end
    end
    if n > 0 then
        local first = self.far == nil
        self.far = { seats = seats, house = self:houseId(), at = os.clock() }
        self:farSave()                                   -- the next launch / rejoin starts with them
        if first then log(("house furniture remembered (%d uses) — those tasks now run without a trip home"):format(n)) end
    end
end
function Home:farReady(need, list)
    local f = self.far
    if C.FarFurniture == false or not f or location() == "housing" or os.clock() < ((self.farOff or {})[need] or 0) then return false end
    -- (a server that never sends your house: the far use seats you but never counts — farRefused turns
    -- it off for 5 min after 2 such misses; the blueprint is empty outside the house even when all is well)
    if f.house ~= self:houseId() then self.far = nil return false end
    local pool = f.seats[need]
    if not pool then return false end
    for _, s in ipairs(list or {}) do
        if #pool[teamOf(s)] > 0 then return true end
    end
    return false
end
function Home:farRefused(need)
    self.farMiss, self.farOff = self.farMiss or {}, self.farOff or {}
    self.farMiss[need] = (self.farMiss[need] or 0) + 1
    if self.farMiss[need] >= 2 then
        self.farMiss[need], self.farOff[need] = 0, os.clock() + 300
        log(("house furniture from afar didn't count for %s — going home for it again (retried in 5 min)"):format(need))
    end
end
function Home:farJob(list, need, babyBusy, during)
    local seats = self.far.seats
    local function pick(n, s, used)
        local pool = seats[n] and seats[n][teamOf(s)]
        for _, e in ipairs(pool or {}) do
            if not used["far:" .. e.unique] then
                used["far:" .. e.unique] = true
                return { subject = s, unique = e.unique, blockName = e.block, block = "far:" .. e.unique, far = true }
            end
        end
    end
    local used, busy, assign = {}, {}, {}
    for _, s in ipairs(list) do
        -- a pet wishing for one exact food / drink: a bowl can't clear it
        local _, wish = Pref:of(s, need)
        local e = hasNeed(s, need) and not (wish and (need == "hungry" or need == "thirsty")) and pick(need, s, used)
        if e then assign[#assign + 1] = e busy[s.key] = true end
    end
    if #assign == 0 then return false end
    local function others()
        local out = {}
        if C.BabyFarm and team() == "Babies" and not babyBusy then out[#out + 1] = BABY end
        for _, u in ipairs(Farm and Farm:uniques() or {}) do out[#out + 1] = petSubject(u) end
        return out
    end
    -- everyone else's home needs at the same time, and again whenever someone finishes
    local function seatFor(s, inUse, gaveUp)
        if busy[s.key] then return end
        for _, n2 in ipairs(Home.FAR_NEEDS) do
            local bowlOk = (n2 ~= "hungry" and n2 ~= "thirsty") or (s.kind == "pet" and C.PetFood ~= "Food items first")
            if bowlOk and (n2 ~= need or gaveUp ~= nil) and hasNeed(s, n2) and not table.find(C.Skip, n2)
               and not blocked(s, n2) and not (gaveUp and gaveUp[s.key .. "|" .. n2]) then
                local e = pick(n2, s, inUse)
                if e then busy[s.key] = true e.need = n2 return e end
            end
        end
    end
    for _, s in ipairs(others()) do
        local e = seatFor(s, used)
        if e then assign[#assign + 1] = e end
    end
    setStatus(("%s from where you stand — your house's furniture (%d at once)"):format(need, #assign))
    local going = useGroup(assign, need, nil, during, function(nowBusy, inUse, gaveUp)
        busy = nowBusy
        local add = {}
        for _, s in ipairs(others()) do
            local e = seatFor(s, inUse, gaveUp)
            if e then add[#add + 1] = e end
        end
        return add
    end, true)
    for _, a in ipairs(assign) do
        if a.need and a.need ~= need then
            if not hasNeed(a.subject, a.need) then
                succeed(a.subject, a.need)
                log(("%s %s done (with %s, from afar)"):format(a.subject.kind, a.need, need))
            elseif not a.ok then
                fail(a.subject, a.need, "couldn't clear it from afar")
            end
        end
    end
    -- judged on THIS need (a crib that counts for the baby says nothing about a far bath)
    local mainOk, fired = false, false
    for _, a in ipairs(assign) do
        if a.firedAt then fired = true end
        if (a.need or need) == need and (a.ok or not hasNeed(a.subject, need)) then mainOk = true end
    end
    if mainOk then self.farMiss = self.farMiss or {} self.farMiss[need] = 0 end
    return mainOk, fired
end

-- How many seats of each piece the farm can use at once.
local function seatsWanted(need)
    local pets = (Farm and Farm:count()) or 1
    return HOME_KIND[need].petsOnly and pets or pets + 1
end

function Home:setupAll()
    if not G.ready then notify("House", "Still loading.") return end
    if Lock.held then notify("House", "Waiting for the farm to finish its current step…") end
    Lock:run(function()
        if not goTo("housing") then notify("House", "Couldn't get home.") return end
        task.wait(2)
        pcall(Home.remember, Home)
        local added = {}
        for _, need in ipairs({ "hungry", "thirsty", "sleepy", "dirty", "toilet" }) do
            local have, used = 0, {}
            for _ = 1, 4 do
                local _, b = findFurniture(need, "Pets", used)
                if not b then break end
                used[b] = true
                have += 1
            end
            for _ = have + 1, seatsWanted(need) do
                if self:place(need) then added[#added + 1] = HOME_KIND[need].name else break end
            end
        end
        notify("House", #added > 0 and ("Placed: " .. table.concat(added, ", "))
            or "Your house already has everything the farm needs.")
    end)
end

-- FAR AT BOOT (2026-10-12): Home.far lived in memory only, so every relaunch / rejoin started with no
-- far seats (the first sleepy / dirty / toilet / bowl jobs went home by trip) and setupAll's trip home
-- held the farm ~8-15 s. Now kept per account + house in CometHub/AdoptMe_far_<name>.json and
-- refreshed at boot from the server's own list of your house's pieces (HousingAPI/GetFurnitureWithinHouse,
-- read-only, the house needn't be loaded): each kind's use block + needs from the file (learned at
-- home) or once from the piece's own model.
function Home:farFile() return "CometHub/AdoptMe_far_" .. LP.Name .. ".json" end
function Home:farMem()
    if self.memT then return self.memT end
    local m
    pcall(function()
        if isfile and readfile and isfile(self:farFile()) then
            m = game:GetService("HttpService"):JSONDecode(readfile(self:farFile()))
        end
    end)
    m = type(m) == "table" and m or {}
    m.kinds = type(m.kinds) == "table" and m.kinds or {}
    m.houses = type(m.houses) == "table" and m.houses or {}
    self.memT = m
    return m
end
function Home:farSave()
    local m = self:farMem()
    if self.far and self.far.house ~= nil then m.houses[tostring(self.far.house)] = self.far.seats end
    pcall(function()
        if not writefile then return end
        local js = game:GetService("HttpService"):JSONEncode(m)
        if js == self.savedJs then return end
        if makefolder and isfolder and not isfolder("CometHub") then makefolder("CometHub") end
        writefile(self:farFile(), js)
        self.savedJs = js
    end)
end
-- A kind's use block + the needs / teams it clears, for a piece known only from the server's list:
-- once from its own model (DownloadClient, as Home:placement does; 5 s at most), then from the file
function Home:kindInfo(kind)
    local kinds = self:farMem().kinds
    if kinds[kind] then return kinds[kind] end
    local entry = G.FDB[kind]
    if not (entry and entry.model_name and G.DL) then return nil end
    local model, late
    task.spawn(function()
        local okM, m = pcall(G.DL.download, "Furniture", entry.model_name)
        model = okM and typeof(m) == "Instance" and m or false
        if late and model then pcall(G.DL.release, "Furniture", entry.model_name) end   -- past the 5 s: not kept
    end)
    local w = 0
    while model == nil and w < 5 do w += task.wait(0.1) end
    if not model then late = true return nil end
    -- the game's helper must read this model, or "clears nothing" would be kept for good
    if not pcall(G.AFH.get_behaviors_from_kind, kind, model) then
        pcall(G.DL.release, "Furniture", entry.model_name)
        return nil
    end
    local ub = model:FindFirstChild("UseBlocks")
    local b = ub and ub:FindFirstChildWhichIsA("BasePart")          -- the same block remember() takes
    local k = { block = b and b.Name or nil, use = {} }
    for _, need in ipairs(b and Home.FAR_NEEDS or {}) do
        for _, tm in ipairs({ "Babies", "Pets" }) do
            if usableBy(model, need, tm, kind) then k.use[#k.use + 1] = need .. "|" .. tm end
        end
    end
    pcall(G.DL.release, "Furniture", entry.model_name)
    kinds[kind] = k
    return k
end
-- At launch, off the worker. true = the house already has every piece setupAll would place (its trip
-- home and back up is skipped)
function Home:boot()
    local id = self:houseId()
    if not id then return false end
    local mem = self:farMem()
    local saved = mem.houses[tostring(id)]
    if not self.far and type(saved) == "table" and next(saved) then          -- last session's, at once
        self.far = { seats = saved, house = id, at = os.clock(), boot = true }
    end
    local res
    task.spawn(function() res = table.pack(invoke("HousingAPI/GetFurnitureWithinHouse", id)) end)
    local w = 0
    while not res and w < 8 do w += task.wait(0.1) end                     -- InvokeServer: no timeout
    local list = res and res[1] == true and res[2]
    if type(list) ~= "table" then return false end
    local rows, prio = {}, {}
    for _, spec in pairs(HOME_KIND) do prio[spec.kind] = true end
    for _, e in pairs(list) do
        local d = type(e) == "table" and e.data
        if type(d) == "table" and d.id and d.unique then rows[#rows + 1] = d end
    end
    -- known kinds and the farm's own pieces first; unknown ones (a download each, once ever) get what
    -- is left of 20 s
    local function rank(d) return (mem.kinds[d.id] or prio[d.id]) and 0 or 1 end
    table.sort(rows, function(x, y) return rank(x) < rank(y) end)
    local seats, n, have, t0 = {}, 0, {}, os.clock()
    for _, d in ipairs(rows) do
        local k = mem.kinds[d.id] or (os.clock() - t0 < 20 and self:kindInfo(d.id))
        for _, nt in ipairs(k and k.block and k.use or {}) do
            local need, tm = string.match(nt, "^(%a+)|(%a+)$")
            if need and tm then
                seats[need] = seats[need] or { Babies = {}, Pets = {} }
                table.insert(seats[need][tm], { unique = d.unique, block = k.block })
                n += 1
                if tm == "Pets" then have[need] = (have[need] or 0) + 1 end
            end
        end
    end
    -- a visit home this session (remember: the placed models themselves) beats the list
    if n > 0 and self:houseId() == id and not (self.far and not self.far.boot) then
        self.far = { seats = seats, house = id, at = os.clock(), boot = true }
        log(("house furniture read from the server (%d uses) — sleepy / dirty / toilet / bowls from afar, no trip home"):format(n))
    end
    self:farSave()
    for _, need in ipairs({ "hungry", "thirsty", "sleepy", "dirty", "toilet" }) do
        if (have[need] or 0) < seatsWanted(need) then return false end
    end
    return true
end

local function placesFor(need)
    local out = {}
    local function add(p) if not table.find(out, p) then out[#out + 1] = p end end
    -- home first, unless the server didn't send your house (Floor.noHouse): then the seats here and on
    -- the way first, home last (bowls: the shops) — each house ask waits up to 12 s for nothing
    -- (2026-10-12 on ultra)
    if C.HomeTasks and HOME_KIND[need] and (Floor.noHouse or 0) == 0 then add("housing") end
    add(location())
    for _, p in ipairs(PLACES[need] or {}) do add(p) end
    return out
end

-- Everybody in `list` with `need` gets a seat of their own and they all go at once.
-- `onlyPlaces` limits the search (e.g. { "housing" } for the free bowls at home).
local function doFurniture(list, need, onlyPlaces, babyBusy, during)
    local function left()
        local out = {}
        for _, s in ipairs(list) do if hasNeed(s, need) then out[#out + 1] = s end end
        return out
    end
    -- your house's furniture from right where you stand (Home.far) — no trip home and back
    if (not onlyPlaces or table.find(onlyPlaces, "housing")) and Home:farReady(need, left()) then
        local okF, ran, fired = pcall(Home.farJob, Home, left(), need, babyBusy, during)
        if #left() == 0 then return true end
        if okF and fired and not ran then Home:farRefused(need) end
    end
    for _, place in ipairs(onlyPlaces or placesFor(need)) do
        if not alive() or #left() == 0 then return true end
        -- another trip + seat must still fit before the job's guard cuts it mid-trip
        if place ~= location() and os.clock() + 25 > (S.jobEnd or math.huge) then break end
        local arrived = location() ~= place
        if goTo(place) then
            if place == "housing" then
                if arrived then                                  -- let the furniture stream in (after a trip)
                    local t = 0
                    while t < 1.5 and not findFurniture(need, teamOf(left()[1] or BABY)) do t += task.wait(0.1) end
                end
                Home:ensure(need, left())
                pcall(Home.remember, Home)                       -- what the next jobs use from afar
                pcall(Farm.Lure.remember, Farm.Lure)
            end
            -- up to 3 rounds: one crib + two sleepers = the second one goes next round.
            -- A seat whose use never started is dropped; a used one is free again.
            local bad = {}
            for _ = 1, 3 do
                if os.clock() + 10 > (S.jobEnd or math.huge) then break end
                local rest = left()
                if #rest == 0 then return true end
                local assign, taken = {}, setmetatable({}, { __index = bad })
                for _, s in ipairs(rest) do
                    local model, block = findFurniture(need, teamOf(s), taken)
                    if model then
                        assign[#assign + 1] = { subject = s, model = model, block = block }
                        taken[block] = true
                    end
                end
                if #assign == 0 then break end
                -- whoever isn't busy and has another furniture need doable right here does it
                -- at the same time (baby in the crib while the pet showers / uses the box) —
                -- and again each time one of them finishes (useGroup's roll)
                local busy, extra = {}, 0
                for _, a in ipairs(assign) do busy[a.subject.key] = true end
                -- everyone is teleported to one spot (pets only use furniture near their
                -- caregiver): the first main pet seat, and extras must be within 20 studs of it
                local anchor
                for _, a in ipairs(assign) do if a.subject.kind == "pet" then anchor = a.block.Position break end end
                anchor = anchor or assign[1].block.Position
                local function seatFor(s, skip, gaveUp)
                    for _, n2 in ipairs({ "sleepy", "dirty", "toilet", "hungry", "thirsty" }) do
                        -- bowls: pets only, and only for a pet set to bowls (items are instant)
                        local bowlOk = (n2 ~= "hungry" and n2 ~= "thirsty")
                            or (s.kind == "pet" and C.PetFood ~= "Food items first")
                        if bowlOk and not busy[s.key] and (n2 ~= need or gaveUp ~= nil) and hasNeed(s, n2)
                           and not table.find(C.Skip, n2) and not blocked(s, n2) and not (gaveUp and gaveUp[s.key .. "|" .. n2]) then
                            local model, block = findFurniture(n2, teamOf(s), skip, anchor)
                            if model and (block.Position - anchor).Magnitude <= 20 then
                                busy[s.key] = true
                                return { subject = s, model = model, block = block, need = n2 }
                            end
                        end
                    end
                end
                local function others()
                    local out = {}
                    if C.BabyFarm and team() == "Babies" and not babyBusy then out[#out + 1] = BABY end
                    for _, u in ipairs(Farm and Farm:uniques() or {}) do out[#out + 1] = petSubject(u) end
                    return out
                end
                for _, s in ipairs(others()) do
                    local e = seatFor(s, taken)
                    if e then assign[#assign + 1], taken[e.block], extra = e, true, extra + 1 end
                end
                setStatus(("%s -> %s in %s (%d at once%s)"):format(need,
                    tostring(assign[1].model:GetAttribute("furniture_kind")), place, #assign,
                    extra > 0 and (", +" .. extra .. " other need") or ""))
                local function roll(nowBusy, inUse, gaveUp)
                    busy = nowBusy
                    local add = {}
                    for _, s in ipairs(others()) do
                        local skip = setmetatable({}, { __index = function(_, b) return inUse[b] or bad[b] end })
                        local e = seatFor(s, skip, gaveUp)
                        if e then inUse[e.block] = true add[#add + 1] = e end
                    end
                    return add
                end
                local going = useGroup(assign, need, anchor, during, roll)
                for _, a in ipairs(assign) do
                    if not going[a.subject] then bad[a.block] = true end
                    if a.need and a.need ~= need then
                        if not hasNeed(a.subject, a.need) then
                            succeed(a.subject, a.need)
                            log(("%s %s done (with %s)"):format(a.subject.kind, a.need, need))
                        elseif not a.ok then                    -- never counted: the usual retry wait
                            fail(a.subject, a.need, "couldn't clear it (with " .. need .. ")")
                        end                                     -- counted but cut: the next loop resumes it
                    end
                end
            end
        end
    end
    return #left() == 0
end

------------------------------------------------------------------------------------------------
-- FOOD — baby bites, pet feeding, auto-buy
------------------------------------------------------------------------------------------------

-- The game's own food rules (PetActions.can_pet_eat_food_item): who = "baby" | "pet" | "egg"
local function foodOK(e, who)
    if who == "egg" then return not e.cannot_feed_to_egg end
    if who == "pet" then return not e.cannot_feed_to_pet and not e.can_only_feed_to_egg end
    return not e.cannot_feed_to_self and not e.can_only_feed_to_egg
end

-- Baby and pets eat at the same time: an item handed to one of them is held back from
-- the others for 20 s (seen live: both grabbed the same healing apple, one feed failed).
local foodTaken = {}

-- Some needs name the exact item the pet wants — hungry / thirsty: a food, play: a toy,
-- walk: a leash, ride: a stroller or vehicle — as components.preference = {item_category,
-- item_kind} (PreferenceHelper). Only that item clears them, so it is used; bought first
-- when a shop sells it for bucks and it's under the "buy what pets ask for" cap.
Pref = {}

function Pref:of(subject, need)
    local e = needEntry(subject, need)
    local p = e and type(e.components) == "table" and e.components.preference
    if type(p) == "table" and p.item_kind then return p.item_category, p.item_kind end
    return nil
end

function Pref:matches(want, have)
    if G.PIH then
        local ok, r = pcall(G.PIH.is_correct_item, want, have)
        if ok and r ~= nil then return r == true end
    end
    return want == have
end

function Pref:owned(cat, kind)
    local d = me()
    for _, it in pairs(d and d.inventory[cat] or {}) do
        if self:matches(kind, it.kind or it.id) and not isLocked(it)
           and os.clock() - (foodTaken[it.unique] or -1e9) > 20 then
            return it
        end
    end
    return nil
end

function Pref:get(cat, kind)
    local it = self:owned(cat, kind)
    if it or not C.PrefBuy or cat == "pets" then return it end
    local e = G.IDB[cat] and G.IDB[cat][kind]
    local cost = e and tonumber(e.cost)
    -- only what a shop really sells for bucks (unpriced items are a kick)
    if not (cost and cost >= 0 and not e.currency_id and G.Hot.items and G.Hot.items[kind]) then
        log(("a pet wants %s — not sold for bucks"):format(tostring(e and e.name or kind)))
        return nil
    end
    if cost > C.PrefMax or bucks() - cost < C.KeepBucks then
        log(("a pet wants %s ($%d) — over your limit"):format(tostring(e.name or kind), cost))
        return nil
    end
    local ok, res = invoke("ShopAPI/BuyItem", cat, kind, { buy_count = 1 })
    log(("bought %s ($%d) — a pet asked for it: %s"):format(tostring(e.name or kind), cost, tostring(ok and res)))
    local tw = 0
    while tw < 1 and not self:owned(cat, kind) do tw += task.wait(0.1) end
    return self:owned(cat, kind)
end

-- A need we can't do as asked (the pet wants an item we don't have and can't buy, or one
-- a script can't drive) is set aside until the game gives a new one — keyed by the need's
-- created_timestamp — instead of being retried every 5 min forever.
-- secs: how long (default 10 min); math.huge = until the game gives a new need. Only what can
-- never work (roller skates) is set aside for good — low bucks, a price cap or a slow spawn
-- can change, so those expire.
Pref.parkedNeeds = {}
function Pref.parkKey(subject, need)
    local e = needEntry(subject, need)
    return e and e.created_timestamp and (subject.key .. "|" .. need .. "|" .. tostring(e.created_timestamp)) or nil
end
function Pref:park(subject, need, why, secs)
    local k = Pref.parkKey(subject, need)
    if k and not self:parked(subject, need) then
        secs = secs or 600
        self.parkedNeeds[k] = os.clock() + secs
        log(("%s %s: %s — set aside %s"):format(subject.kind or "pet", need, why,
            secs == math.huge and "until it changes" or ("for " .. math.floor(secs / 60) .. " min")))
    end
end
function Pref:parked(subject, need)
    local k = Pref.parkKey(subject, need)
    return k ~= nil and (self.parkedNeeds[k] or 0) > os.clock()
end

local function foodFor(need, who)
    local d = me()
    if not d then return nil end
    local best, bestCost
    for _, it in pairs(d.inventory.food or {}) do
        local e = G.IDB.food[it.id]
        if e and e.ailment_to_boost == need and foodOK(e, who) and not G.Pots[it.id] and not isLocked(it)
           and os.clock() - (foodTaken[it.unique] or -1e9) > 20 then
            -- baby: cost + bites (an item clears in entry.uses bites) — Tea $2/6 loses to Lemonade $2/5
            local c = (tonumber(e.cost) or 999) + (who == "baby" and (tonumber(e.uses) or 1) or 0)
            if not best or c < bestCost then best, bestCost = it, c end
        end
    end
    return best
end

-- Items the shop refused ("not for sale": VIP-room water, event stock…) are skipped after.
local refusedFood = {}

local function cheapestShopFood(need, who)
    local best, bestCost
    -- $0 only for sick (the Hospital's healing apple); other $0 foods are VIP-only (seen:
    -- water_vip -> "not for sale")
    local minCost = need == "sick" and 0 or 1
    for id in pairs(G.Hot.items or {}) do
        local e = G.IDB.food[id]
        if e and not refusedFood[id] and e.ailment_to_boost == need and foodOK(e, who)
           and type(e.cost) == "number" and e.cost >= minCost and not e.currency_id and not G.Pots[id] then
            local c = e.cost + (who == "baby" and (tonumber(e.uses) or 1) or 0)   -- baby: fewer bites
            if not best or c < bestCost then best, bestCost = id, c end
        end
    end
    return best
end

local buyingFood = false

local function getFood(need, who, subject)
    local function take(it)
        if it then foodTaken[it.unique] = os.clock() end
        return it
    end
    -- the exact food / drink this need asks for, when it asks for one
    local pcat, pkind = nil, nil
    if subject then pcat, pkind = Pref:of(subject, need) end
    if pkind then
        local it = Pref:get(pcat, pkind)
        if it then return take(it) end
        -- bypass: the wished food isn't owned or sold — try ordinary food ONCE for this need
        -- (it may still count); after that the need waits on the normal retry
        local key = subject and Pref.parkKey(subject, need)
        Pref.triedGeneric = Pref.triedGeneric or {}
        if not key or Pref.triedGeneric[key] then return nil end
        Pref.triedGeneric[key] = true
        log(("%s wants %s — trying ordinary %s instead"):format(subject.kind or "pet", tostring(pkind), need == "thirsty" and "drink" or "food"))
    end
    local item = foodFor(need, who)
    if item or not C.AutoBuyFood then return take(item) end
    -- one purchase at a time; whoever waited uses what the other one bought
    local t = 0
    while buyingFood and t < 10 do t += task.wait(0.2) end
    item = foodFor(need, who)
    if item then return take(item) end
    buyingFood = true
    for _ = 1, 3 do                                       -- next cheapest if one is refused
        local id = cheapestShopFood(need, who)
        if not id then break end
        local ok, res = invoke("ShopAPI/BuyItem", "food", id, { buy_count = 3 })
        log(("bought 3x %s for %s: %s"):format(id, need, tostring(ok and res)))
        if ok and (res == "success" or res == true) then break end
        refusedFood[id] = true
    end
    local tw = 0
    while tw < 1 and not foodFor(need, who) do tw += task.wait(0.1) end
    buyingFood = false
    return take(foodFor(need, who))
end

local function inInventory(cat, unique)
    local d = me()
    return d and d.inventory[cat] and d.inventory[cat][unique] ~= nil
end

-- A bite = START, a hold, END. The server adds 1/uses of the need per bite (ToolDBHelper
-- .generic_server_use_end: add_progress(ailment, 1 / entry.uses)), so one item clears it in
-- entry.uses bites. The game's own hold is the eat animation (food has no client_use_cooldown);
-- ours starts at S.biteGap = 0.6 s and grows by 0.3 s (up to 1.5) each time a pass of bites used
-- nothing up (the server ignoring too short a hold), so it settles by itself. The old
-- 0.6 + 10 x (1.2 + 0.5) made a 6-use drink ~16 s.
local function babyEat(need)
    S.biteGap = S.biteGap or 0.6
    local function usesLeft(item, uses)
        local d = me()
        local it = d and d.inventory.food and d.inventory.food[item.unique]
        if not it then return 0 end
        return tonumber(it.properties and it.properties.uses_left) or uses
    end
    for _ = 1, 4 do
        if not hasNeed(BABY, need) then return true end
        local item = getFood(need, "baby", BABY)
        if not item then
            if not C.AutoBuyFood and not S.toldNoFood then
                S.toldNoFood = true
                log(("baby %s: nothing to give and \"Auto buy food when out\" is off (Settings) — turn it on"):format(need))
                notify("Out of food", "The baby needs food / drink and \"Auto buy food when out\" is off (Settings).")
            end
            return false
        end
        local e = G.IDB.food[item.id]
        local uses = math.max(1, tonumber(e and e.uses) or 1)
        setStatus("Baby " .. need .. ": " .. item.id)
        invoke("ToolAPI/Equip", item.unique, {})
        task.wait(0.15)
        for _ = 1, 3 do                                          -- a pass = the bites still missing
            local u0 = usesLeft(item, uses)
            if u0 <= 0 then break end                            -- used up: the next item
            local p0 = Pref.progress(BABY, need)
            local bites = math.min(u0, math.max(1, math.ceil((1 - p0) * uses - 0.01)))
            local clears = p0 + bites / uses >= 0.99
            for _ = 1, bites do
                invoke("ToolAPI/ServerUseTool", item.unique, "START")
                task.wait(S.biteGap)
                invoke("ToolAPI/ServerUseTool", item.unique, "END")
            end
            -- ClientData shows the bites a frame or two after END answers: wait for that (<= 1 s)
            local t0 = os.clock()
            while os.clock() - t0 < 1 and hasNeed(BABY, need) and (clears or usesLeft(item, uses) > u0 - bites) do
                Floor.nap(0.1)
            end
            if not hasNeed(BABY, need) then
                if inInventory("food", item.unique) then task.spawn(invoke, "ToolAPI/Unequip", item.unique) end
                return true
            end
            if usesLeft(item, uses) >= u0 and S.biteGap < 1.5 then
                S.biteGap += 0.3
                log(("baby %s: the bites didn't count — %.1f s per bite from now on"):format(need, S.biteGap))
            end
        end
    end
    return not hasNeed(BABY, need)
end

local function petRoot(u)
    local w = wrapperOf(u)
    return w and (w.char.PrimaryPart or w.char:FindFirstChild("HumanoidRootPart"))
end

-- Mirrors PetActions.feed_pet: the server spawns the food object and the pet eats it.
-- Spawns the food / potion in front of the pet and has it consumed right away: the server
-- answers with the object's StreamingId, its model (attribute StreamingId) is in the
-- workspace ~50 ms later, and PetAPI/ConsumeFoodObject(model, pet) eats it at once —
-- verified 2026-10-08: 0.3 s instead of the 4.2 s walk-and-eat animation. If the model
-- isn't found the pet still eats it by itself (the old way).
local function feedPet(u, item)
    -- the server refuses a pet object sent < 1 s after the previous one was eaten (potions, seen
    -- live): every feed / potion 1 s apart
    local gap = 1 - (os.clock() - (S.feedAt or -1e9))
    if gap > 0 then task.wait(gap) end
    local root = petRoot(u)
    -- the food model is caught as it arrives (a full Workspace scan ×10 stuttered low-FPS clients)
    local seen = {}
    local conn = Workspace.DescendantAdded:Connect(function(m) if m:IsA("Model") then seen[#seen + 1] = m end end)
    task.delay(5, function() pcall(function() conn:Disconnect() end) end)   -- a cancelled feed can't leak it
    local ok, obj = invoke("PetObjectAPI/CreatePetObject", G.FOOD, {
        unique_id = item.unique,
        pet_unique = u,
        spawn_cframe = root and root.CFrame * CFrame.new(0, 0, -2) or nil,
        additional_consume_uniques = {},
    })
    if not (ok and obj ~= nil) then conn:Disconnect() return false end
    if type(obj) == "string" then
        for _ = 1, 10 do
            for _, m in ipairs(seen) do
                if m.Parent and m:GetAttribute("StreamingId") == obj then
                    conn:Disconnect()
                    S.feedAt = os.clock()
                    fire("PetAPI/ConsumeFoodObject", m, u)
                    return true
                end
            end
            task.wait(0.1)
        end
    end
    conn:Disconnect()
    S.feedAt = os.clock()
    return true
end

-- True once `item` has left the inventory (eaten / drunk), within `secs`.
local function consumed(item, secs)
    local t0 = os.clock()
    while os.clock() - t0 < (secs or 8) do
        local d = me()
        local still = false
        for _, it in pairs(d and d.inventory.food or {}) do
            if it.unique == item.unique then still = true break end
        end
        if not still then return true end
        task.wait(0.2)
    end
    return false
end

-- The pet has to be out: a farm pet brings the whole farm set, anything else goes out alone.
local function ensureOut(u)
    if wrapperOf(u) and table.find(equippedPets(), u) then return true end
    -- (2026-10-11) a pet that isn't a farm pet (a potion target…) joins in a free slot or takes
    -- only the LAST farm slot, so pet 1 keeps its task; the answer is about THIS pet
    if Farm and not Farm:has(u) and maxPets() > 1 then
        local farm, list = Farm:uniques(), {}
        for i = 1, math.min(#farm, maxPets() - 1) do list[#list + 1] = farm[i] end
        list[#list + 1] = u
        setEquipped(list)
        return wrapperOf(u) ~= nil
    end
    if Farm and Farm:has(u) then return setEquipped(Farm:uniques()) end
    return setEquipped({ u })
end

local function feedWithItem(s, need)
    local p = petByUnique(s.unique)
    local item = getFood(need, (p and p.egg) and "egg" or "pet", s)
    if not item or not ensureOut(s.unique) then return false end
    setStatus("Pet " .. need .. ": " .. item.id)
    -- refused (too soon after another feed / potion): once more 1 s later with the same item,
    -- not a bowl trip home
    local fed = feedPet(s.unique, item)
    if not fed then task.wait(1) fed = feedPet(s.unique, item) end
    return fed and waitCleared({ s }, need, 8)
end

-- Items (and the free bowls at home first, if chosen). Sick = the free healing apple.
-- Whatever is left goes to public bowls / the Hospital from doJob.
-- babyBusy: the baby is eating on another thread right now (together()), so the bowl trip
-- must not also give it a crib / bath as an extra.
local function petsEat(pets, need, babyBusy)
    if need ~= "sick" and C.HomeTasks and C.PetFood ~= "Food items first" then
        doFurniture(pets, need, { "housing" }, babyBusy)
    end
    if need == "sick" or C.PetFood ~= "Free bowls only" then
        for _, s in ipairs(pets) do
            if hasNeed(s, need) then feedWithItem(s, need) end
        end
    end
end

-- Runs a and b at the same time (either may be nil) and returns when both are done.
-- `a` runs on its own thread, tied to the caller: guarded() only cancels the job's thread,
-- so a watcher stops the bites when the job dies, and they stop at 40 s anyway — otherwise
-- an orphaned babyEat kept equipping food and swapped out the next job's stroller / leash.
local function together(a, b)
    local done = a == nil
    local parent = coroutine.running()
    local th = a and task.spawn(function() pcall(a) done = true end)
    if th and not done then
        task.spawn(function()
            while not done and coroutine.status(parent) ~= "dead" do task.wait(0.5) end
            if not done then pcall(task.cancel, th) end
        end)
    end
    if b then pcall(b) end
    local t0 = os.clock()
    while not done and os.clock() - t0 < 40 do task.wait() end
    if not done and th then pcall(task.cancel, th) done = true end
end

------------------------------------------------------------------------------------------------
-- MYSTERY — pick the easiest of the three needs the game offers
------------------------------------------------------------------------------------------------

-- prefer (optional set of needs): an option doable right where we are wins — at the campsite
-- "camping" or "sleepy" (the bags), in the school "school" / a bed… (asked 2026-10-11: two
-- tasks at once); otherwise the easiest by RANK.
local function doMystery(subject, prefer)
    if not ensureOut(subject.unique) then return false end
    local w = wrapperOf(subject.unique)
    -- game code that loads modules on first use: at the game's identity (G.asGame), or on
    -- some executors it fails at once and mystery was "couldn't clear it" every minute.
    -- (2026-10-12) one hop for the three calls: each G.asGame waits 1-2 frames (0.4-0.7 s at
    -- 3-5 FPS) and has its own 10 s timeout — three of them made a mystery ~2 s on ultra
    local okL, m, action, slots = G.asGame(function()
        local list = G.AC.get_ailments_for_pet(w)
        local mm = type(list) == "table" and list.mystery
        if not mm then return nil end
        local act = mm.action or G.ADB.mystery.create_action(mm)
        if not act then return mm end
        return mm, act, act:_get_ailment_slots(w)
    end)
    if not (okL and m) then return not hasNeed(subject, "mystery") end
    if not action then return false end
    if type(slots) ~= "table" then return false end
    -- outside an area: an option doable without a trip wins (on the floor play / walk over a
    -- crib at home — unless the house works from afar), then the easiest by RANK
    if not prefer and Farm and Farm.isHere then
        prefer = {}
        local loc = location()
        for _, kind in pairs(slots) do
            local okH, here = pcall(Farm.isHere, kind, { subject }, loc)
            if okH and here then prefer[kind] = true end
        end
    end
    -- (2026-10-12) the FASTEST option, not the job order: by RANK a walk / ride (33 s) beat pet_me
    -- (4.5 s) and a bed (16-41 s) beat play (6 s). Seconds measured on ultra / Draven. The seats
    -- keep RANK's order (bed, bath, box): a bath is home-only, so on a server that never sends the
    -- house it can't be done while a bed can (the MainMap bags). An option this pet just failed
    -- (its retry wait) comes after the others doable here
    local SECS = { hungry = 2, thirsty = 2.1, sick = 2.2, pet_me = 5, play = 6, sleepy = 20, dirty = 21,
                   toilet = 22, walk = 33, ride = 35 }
    local bestI, bestR
    for i, kind in pairs(slots) do
        if not UNSUPPORTED[kind] and not table.find(C.Skip, kind) then
            local r = (SECS[kind] or 50 + (RANK[kind] or 500)) - ((prefer and prefer[kind]) and 1000 or 0)
                + (blocked(subject, kind) and 500 or 0)
            if not bestR or r < bestR then bestI, bestR = i, r end
        end
    end
    bestI = bestI or next(slots)     -- all three unworkable: still pick, so the slot moves on
    if not bestI then return false end
    local key = (action.options and action.options.ailment_key) or m.ailment_key or "mystery"
    fire("AilmentsAPI/ChooseMysteryAilment", subject.unique, key, bestI, slots[bestI])
    log("mystery -> " .. tostring(slots[bestI]))
    waitCleared({ subject }, "mystery", 2)
    return not hasNeed(subject, "mystery")
end

------------------------------------------------------------------------------------------------
-- PET PLAY + WALK
------------------------------------------------------------------------------------------------

local function toyForPlay()
    local d = me()
    local entry = G.ADB.play
    local fc = entry and entry.filter_callback
    for _, it in pairs(d and d.inventory.toys or {}) do
        local e = G.IDB.toys[it.id]
        if e and not isLocked(it) then
            local okF, pass = true, true
            if fc then okF, pass = pcall(fc, e) end
            if okF and pass then return it end
        end
    end
    return nil
end

-- stay = true: play right where you are (used while waiting in an area).
local function petPlay(subject, stay)
    -- the exact toy this pet asks for ("catch the ball with …"), else any throwable toy
    local pcat, pkind = Pref:of(subject, "play")
    local toy = (pkind and Pref:get(pcat or "toys", pkind)) or toyForPlay()
    if not toy then return false end
    if not stay then Floor.toBase() end                      -- anywhere on the floor will do
    if not ensureOut(subject.unique) then return false end
    -- the toy stays in your hand between throws: equipped once (re-equipping before every throw
    -- cost a round trip + 0.4 s each)
    local function holding()
        local d = me()
        for _, v in pairs(d and d.equip_manager and d.equip_manager.toys or {}) do
            if type(v) == "table" and v.unique == toy.unique then return true end
        end
        return false
    end
    for _ = 1, 6 do
        if not hasNeed(subject, "play") then break end
        local _, hrp = char()
        if not holding() then
            invoke("ToolAPI/Equip", toy.unique, {})
            task.wait(0.2)
        end
        local p0 = Pref.progress(subject, "play")
        -- (2026-10-13) the game counts 1/3 of play when the pet GRABS the toy (PetObjectHelper): dropped
        -- 2 studs from the pet (on your side of it) it grabs it at once instead of running 6 studs past
        -- you every throw. A close throw that doesn't count in 3 s = back to the old spot for this pet.
        local spot = hrp and hrp.CFrame * CFrame.new(0, 1, -6) or nil       -- short: house walls
        local pw = wrapperOf(subject.unique)
        local pr = pw and pw.char and (pw.char.PrimaryPart or pw.char:FindFirstChild("HumanoidRootPart"))
        local close = false
        if hrp and pr and not (Floor.playFar or {})[subject.unique] then
            local d = hrp.Position - pr.Position
            if d.Magnitude < 20 and d.Magnitude > 0.5 then
                spot, close = CFrame.new(pr.Position + d.Unit * 2 + Vector3.new(0, 1, 0)), true
            end
        end
        invoke("PetObjectAPI/CreatePetObject", G.TOY, {
            unique_id = toy.unique,
            pet_unique = subject.unique,
            spawn_cframe = spot,
        })
        -- the next throw as soon as this fetch counted (it waited a flat 7 s per throw)
        local t0 = os.clock()
        while os.clock() - t0 < (close and 3 or 7) and hasNeed(subject, "play") and Pref.progress(subject, "play") < p0 + 0.02 do
            Floor.nap(0.1)
        end
        if close and hasNeed(subject, "play") and Pref.progress(subject, "play") < p0 + 0.02 then
            Floor.playFar = Floor.playFar or {}
            Floor.playFar[subject.unique] = true                             -- this pet: the old spot
        end
        -- reported 2026-10-11: "it throws but didn't take it again" — the pet holding the toy
        -- (and you the tool) froze every later throw. The game's own fetch drops it only when
        -- the pet reaches you; do it ourselves before the next throw
        local w = wrapperOf(subject.unique)
        if w and w.char then fire("PetObjectAPI/DropPetObject", w.char) end
        if not hasNeed(subject, "play") then break end         -- done: no pause before the unequip
        task.wait(0.2)
    end
    task.spawn(invoke, "ToolAPI/Unequip", toy.unique)          -- sent now, not waited for
    if Pref.progress(subject, "play") >= 0.99 then waitCleared({ subject }, "play", 1) end
    return not hasNeed(subject, "play")
end

local function anyNeed(list, need)
    for _, s in ipairs(list) do if hasNeed(s, need) then return true end end
    return false
end

-- Strolls back and forth around where you stand until `stillNeeded()` is false.
-- progressOf (optional): returns the need's progress; if it hasn't moved for 15 s the walk
-- stops early (the ride / walk isn't counting — wrong item, nothing seated). Ride progress
-- comes in steps with rate 0 (seen live), so the rate can't tell; the progress value can.
local function moveUntil(stillNeeded, seconds, radius, progressOf, during)
    local _, hrp, hum = char()
    if not (hrp and hum) then return false end
    local origin, t0, ang = hrp.Position, os.clock(), 0
    local lastP, movedAt = progressOf and progressOf() or 0, os.clock()
    local side, parent, sideAt = { on = false }, coroutine.running(), 0
    radius = radius or 16
    -- a smooth loop with the next point always ahead: walk / ride only count while moving, and
    -- the old back-and-forth legs stood still ~0.6 s at each end (another hub's ride: ~31 s).
    -- Quick needs run on their own thread (a 15 s feed used to stop the walk), joined at the end.
    while alive() and os.clock() - t0 < seconds do
        if not stillNeeded() then break end
        if progressOf then
            local p = progressOf()
            if p > lastP + 0.001 then lastP, movedAt = p, os.clock()
            elseif os.clock() - movedAt > 15 then break end
        end
        ang += 0.55
        hum:MoveTo(origin + Vector3.new(math.cos(ang) * radius, 0, math.sin(ang) * radius))
        if during and not side.on and (os.clock() - sideAt > 2 or (os.clock() - sideAt > 0.5 and (S.needAt or 0) > sideAt)) then
            sideAt, side.on = os.clock(), true
            side.th = task.spawn(function() pcall(during) side.on = false end)
            if side.on then
                task.spawn(function()
                    while side.on and coroutine.status(parent) ~= "dead" do task.wait(0.5) end
                    if side.on then pcall(task.cancel, side.th) side.on = false end
                end)
            end
        end
        task.wait(0.5)
    end
    local w = 0
    while side.on and w < 15 do w += task.wait(0.2) end
    if side.on and side.th then pcall(task.cancel, side.th) side.on = false end
    return not stillNeeded()
end

-- Progress of a moving need right now (1 when gone = done), for moveUntil's stall check.
function Pref.progress(subject, need)
    local e = needEntry(subject, need)
    if not e then return 1 end
    local p, rate, ts = tonumber(e.progress) or 0, tonumber(e.rate) or 0, tonumber(e.rate_timestamp) or -1
    if rate > 0 and ts > 0 then p += rate * math.max(0, Workspace:GetServerTimeNow() - ts) end
    return p
end

-- One walk clears it for every pet that's out.
local function petWalk(pets, during)
    Floor.toBase()
    for _, s in ipairs(pets) do ensureOut(s.unique) end      -- goFloor may have re-equipped
    -- a pet may ask for a specific leash ("Can we use …?"): hold it while walking
    local leash
    for _, s in ipairs(pets) do
        local pcat, pkind = Pref:of(s, "walk")
        leash = leash or (pkind and Pref:get(pcat or "toys", pkind))
    end
    if leash then invoke("ToolAPI/Equip", leash.unique, {}) S.held = leash.unique task.wait(0.5) end
    setStatus("Walking " .. #pets .. " pet(s)" .. (leash and (" on " .. tostring(leash.id)) or ""))
    local ok = moveUntil(function() return anyNeed(pets, "walk") end, 90, nil, function()
        local sum = 0              -- each pet capped at 1 (= done): the total only ever goes up
        for _, p in ipairs(pets) do sum += math.min(1, Pref.progress(p, "walk")) end
        return sum
    end, during and function() during(leash and { [BABY.key] = true } or {}) end)
    if leash then invoke("ToolAPI/Unequip", leash.unique, {}) S.held = nil end
    return ok
end

-- Ride = ~60 s of moving with the pet in a stroller or a vehicle (the ailment's own action is
-- "pick a stroller or vehicle"; a pet may name the exact one it wants).
--   Stroller (verified, even as a baby): ToolAPI/Equip(stroller) puts the StrollerTool on
--   you, its seat is tagged "StrollerSeat", AdoptAPI/UseStroller(owner, petModel, seat)
--   sits the pet in it, and walking moved ride 0 -> 13 % in ~8 s.
--   Vehicle (verified): ToolAPI/Equip(vehicle) spawns it (ClientData "vehicle"),
--   VehicleAPI/SitInVehicle(character, seat) seats you at the VehicleSeat and the pet in a
--   Seat. Adopt Me ignores VehicleSeat throttle from scripts, so the vehicle is moved in a
--   slow circle with PivotTo (you and the pet stay seated and move with it).
-- Carrying the pet (AdoptAPI/HoldBaby) does NOT count for pets, and holding one while in
-- an area stopped the area's progress for baby and pet alike (salon stuck at 39 %).
local function firstItem(cat, prefer)
    local d, pick = me(), nil
    for _, it in pairs(d and d.inventory[cat] or {}) do
        if not isLocked(it) then
            pick = pick or it
            if it.id == prefer then return it end
        end
    end
    return pick
end

local function strollerSeats()
    local out = {}
    for _, s in ipairs(CollectionService:GetTagged("StrollerSeat")) do
        if LP.Character and s:IsDescendantOf(LP.Character) then out[#out + 1] = s end
    end
    return out
end

-- Returns true when the pet was really put in the stroller (so a miss can be told apart from
-- a ride that never started: no seat in time, pet not out or left behind).
local function strollerRide(s, st, walkers, during)
    -- the pet must be out and next to you, or UseStroller has nothing to seat
    local w = wrapperOf(s.unique)
    local root = w and (w.char.PrimaryPart or w.char:FindFirstChild("HumanoidRootPart"))
    local _, hrp0 = char()
    if hrp0 and (not root or (root.Position - hrp0.Position).Magnitude > 25) then
        invoke("ToolAPI/Unequip", s.unique)
        task.wait(0.3)
        ensureOut(s.unique)
        task.wait(0.8)
        w = wrapperOf(s.unique)
    end
    invoke("ToolAPI/Equip", st.unique, {})
    S.held = st.unique
    local seats, t = {}, 0
    while #seats == 0 and t < 4 do
        seats = strollerSeats()
        if #seats == 0 then t += task.wait(0.3) end
    end
    local ran = false
    if #seats > 0 and w then
        -- seated = the pet's model is right at the seat (UseStroller welds it there)
        local function seated()
            local wr = wrapperOf(s.unique)
            local r = wr and wr.char and (wr.char.PrimaryPart or wr.char:FindFirstChild("HumanoidRootPart"))
            local seat = strollerSeats()[1]
            return r ~= nil and seat ~= nil and (r.Position - seat.Position).Magnitude < 6
        end
        local function sit()
            local wr = wrapperOf(s.unique)
            local seat = strollerSeats()[1]
            if not (wr and wr.char and seat) then return false end
            local ok, res = invoke("AdoptAPI/UseStroller", LP, wr.char, seat)
            local t1 = 0
            while not seated() and t1 < 2 do t1 += task.wait(0.2) end
            return ok and res ~= false and seated()
        end
        ran = sit() or sit()               -- one quick second try before walking for nothing
        setStatus("Stroller ride (" .. tostring(st.id) .. ")")
        -- ~35-60 s from 0 % (verified 2026-10-11: 0 -> done in ~33 s); stops early if the ride
        -- stops counting. A pet that needs a walk just follows: walking around with the stroller
        -- clears its walk too (asked 2026-10-11: two tasks at once), so it keeps going until both
        -- are done. Reported 2026-10-11 "ride task don't work": a pet that slipped out of the
        -- stroller (or was never seated) used to end the ride after 15 s of no progress — now
        -- it's put back in and the ride goes on (2 more tries).
        walkers = walkers or {}
        local t0 = os.clock()
        for try = 1, 3 do
            if try > 1 then
                if not (alive() and hasNeed(s, "ride") and os.clock() - t0 < 80) then break end
                log(("ride: the pet wasn't riding — putting it back in the stroller (try %d)"):format(try))
                if not wrapperOf(s.unique) then ensureOut(s.unique) task.wait(0.8) end
                if #strollerSeats() == 0 then invoke("ToolAPI/Equip", st.unique, {}) task.wait(0.8) end
                if not seated() then ran = sit() or ran end
            end
            moveUntil(function() return hasNeed(s, "ride") or anyNeed(walkers, "walk") end,
                math.max(10, 90 - (os.clock() - t0)), nil, function()
                local sum = math.min(1, Pref.progress(s, "ride"))
                for _, p in ipairs(walkers) do sum += math.min(1, Pref.progress(p, "walk")) end
                return sum
            end, during and function() during({ [BABY.key] = true, [s.key] = true }) end)
            if not hasNeed(s, "ride") then break end
        end
    else
        log(("ride: %s"):format(#seats == 0 and "the stroller's seat never showed up" or "the pet isn't out"))
    end
    invoke("ToolAPI/Unequip", st.unique, {})
    S.held = nil
    return ran
end

local function vehicleRide(s, item, during)
    invoke("ToolAPI/Equip", item.unique, {})
    S.held = item.unique
    local v, t = nil, 0
    while t < 4 do
        v = G.CD.get("vehicle")
        if typeof(v) == "Instance" and v.Parent then break end
        v = nil
        t += task.wait(0.3)
    end
    local w = wrapperOf(s.unique)
    local driver = v and v:FindFirstChildWhichIsA("VehicleSeat", true)
    local seat
    for _, d in ipairs(v and v:GetDescendants() or {}) do
        if d:IsA("Seat") then seat = d break end
    end
    if driver and w then
        invoke("VehicleAPI/SitInVehicle", LP.Character, driver)
        if seat then invoke("VehicleAPI/SitInVehicle", w.char, seat) end
        setStatus("Vehicle ride (" .. tostring(item.id) .. ")")
        local cf0, a, t0 = v:GetPivot(), 0, os.clock()
        local lastP, movedAt, quickAt = Pref.progress(s, "ride"), os.clock(), os.clock()
        while alive() and hasNeed(s, "ride") and os.clock() - t0 < 90 and v.Parent do
            -- you and this pet are seated: the others do their quick needs meanwhile
            if during and os.clock() - quickAt > 2 then
                local d0 = os.clock()
                pcall(during, { [BABY.key] = true, [s.key] = true })
                quickAt = os.clock()
                movedAt += quickAt - d0                 -- time on quick needs is not a stall
            end
            a += 0.25
            v:PivotTo(cf0 * CFrame.new(math.sin(a) * 12, 0, math.cos(a) * 12 - 12))
            local p = Pref.progress(s, "ride")
            if p > lastP + 0.001 then lastP, movedAt = p, os.clock()
            elseif os.clock() - movedAt > 15 then break end      -- not counting: don't burn 90 s
            task.wait(0.25)
        end
    end
    unseat()
    task.wait(0.3)
    invoke("ToolAPI/Unequip", item.unique, {})
    S.held = nil
    return driver ~= nil and w ~= nil           -- a seatless vehicle still counts as having run
end

-- Each pet rides in what it asked for, else any stroller, else a vehicle. Only the item a
-- pet names clears its wish, so a wish we can't do is set aside (Pref:park) instead of
-- failing every 5 min: an item we don't have and can't buy, roller skates (verified
-- 2026-10-04: they sit YOU on their own VehicleSeat, there is no seat for the pet, and
-- neither PivotTo, holding the pet nor Humanoid:Move made ride progress), or a ride that
-- didn't move the progress at all.
local function petRide(pets, walkers, during)
    Floor.toBase()
    ensureOut(pets[1].unique)
    for _, s in ipairs(pets) do
        if alive() and hasNeed(s, "ride") then
            local cat, kind = Pref:of(s, "ride")
            local item
            local bypass = false
            if kind then
                local e = G.IDB[cat] and G.IDB[cat][kind]
                local label = tostring(e and e.name or kind)
                if not (cat == "transport" and e and e.is_roller_skates) then item = Pref:get(cat, kind) end
                if not item then
                    -- bypass: the wished item can't be used (roller skates carry no pet, or it isn't
                    -- owned / sold) — ride in a stroller you own anyway; the progress check below
                    -- tells whether the game counts it, and only then is the need set aside
                    cat, item = "strollers", firstItem("strollers", "stroller-default")
                    bypass = item ~= nil
                    if bypass then log(("ride: the pet wants %s — trying %s instead"):format(label, tostring(item.id))) end
                    if not item then Pref:park(s, "ride", "wants " .. label .. " (no stroller to try instead)", 300) end
                end
            else
                cat, item = "strollers", firstItem("strollers", "stroller-default")
                if not item then
                    for _, it in pairs(me() and me().inventory.transport or {}) do
                        local e = G.IDB.transport[it.id]
                        if e and not e.is_roller_skates and not isLocked(it) then cat, item = "transport", it break end
                    end
                end
                if not item then log("ride: no stroller or vehicle in your backpack") break end
            end
            if item then
                local before = Pref.progress(s, "ride")
                local ran
                if cat == "transport" then ran = vehicleRide(s, item, during) else ran = strollerRide(s, item, walkers, during) end
                local after = needEntry(s, "ride")
                -- set aside only a ride that really ran and didn't count (a wish, or a vehicle);
                -- one that never started, or a plain stroller miss, gets the normal backoff
                if after and ran and (kind or cat == "transport") and Pref.progress(s, "ride") <= before + 0.001 then
                    Pref:park(s, "ride", "riding " .. tostring(item.id) .. " didn't count", bypass and 600 or 1200)
                elseif bypass and ran then
                    log("ride: the stroller counted even though the pet wished for something else")
                end
            end
        end
    end
    return not anyNeed(pets, "ride")
end

-- Pet me: firing the petting remotes by hand is ignored by the server (tried twice), so the
-- game's own petting screen does it: FocusPetApp:capture_focus(pet) opens it (and tells the
-- server), petting_handler:start_petting("pet_me") counts petting while the "hand" moves
-- over the pet, and after 3 s the client sends the real completion. The hand is ours: the
-- handler's get_position is swapped for a small circle at screen centre and
-- is_holding_pet_button set. Verified 2026-09-30: pet_me cleared in 4.5 s. The timing is
-- the handler's own (tick-based), so it works at 3–5 FPS too.
local function petMe(subject)
    if not ensureOut(subject.unique) then return false end
    local w = wrapperOf(subject.unique)
    local FPA = G.UIM and G.UIM.apps.FocusPetApp
    local ph = FPA and FPA.petting_handler
    if not (w and ph) then return false end
    setStatus("Petting the pet")
    -- a minigame's results screen left open blocks the petting screen
    if Popups and Popups.clearBlockers then
        local blocked = false
        pcall(function()
            for _, n in ipairs({ "MinigameRewardsApp", "MinigameNewsPaperApp", "JackboxRewardApp" }) do
                local okC, closed = pcall(G.UIM.is_closed, { n })
                if okC and closed == false then blocked = true end
            end
        end)
        if blocked then pcall(function() Popups:clearBlockers(true) end) task.wait(0.4) end   -- only when one was up
    end
    -- the petting screen is a UI app: opened at the game's identity (G.asGame), or on some
    -- executors UIManager can't load its parts and pet_me failed in under a second
    -- restore first: a capture_focus that errored or timed out after moving the camera used to
    -- leave it on the pet for good (over the gray floor = a "white screen")
    local restored = false
    local function restore()
        if restored then return end
        restored = true
        ph.is_holding_pet_button = false
        rawset(ph, "get_position", nil)
        G.asGame(function() FPA:release_focus() end)
        G.asGame(G.UIM.set_app_visibility, "FocusPetApp", false)
        local cam = Workspace.CurrentCamera
        local _, _, hum = char()
        if cam and hum and cam.CameraType == Enum.CameraType.Scriptable then
            cam.CameraType, cam.CameraSubject = Enum.CameraType.Custom, hum
        end
    end
    task.delay(20, restore)                  -- even if this step gets cut short
    if not G.asGame(function() FPA:capture_focus(w) end) then restore() return false end
    task.wait(0.8)
    local centre, i = Workspace.CurrentCamera.ViewportSize * 0.5, 0
    rawset(ph, "get_position", function()
        i += 1
        return centre + Vector2.new(math.sin(i) * 12, math.cos(i) * 12)
    end)
    ph.is_holding_pet_button = true
    task.spawn(function() G.asGame(function() ph:start_petting("pet_me") end) end)
    waitCleared({ subject }, "pet_me", 10)
    task.wait(0.3)
    restore()
    return not hasNeed(subject, "pet_me")
end

------------------------------------------------------------------------------------------------
-- SIDE JOBS — everything that needs no trip, done while a timed area counts down
------------------------------------------------------------------------------------------------

local function farmPets()
    local out = {}
    if C.PetFarm or Eggs:hatching() then
        for _, u in ipairs(Farm:uniques()) do out[#out + 1] = petSubject(u) end
    end
    return out
end

-- tried (per area visit): a side need that didn't clear isn't tried again on every 1 s tick
-- (that burned food and kept the area's checks waiting) — the main job still gets it after,
-- with its bowls / Hospital fallback. away(): stop the batch as soon as we left the place.
-- busy: subjects seated / in a stroller / holding something right now (left alone); quick:
-- only the instant ones (food, drink, heal items, mysteries) — what runs while another task
-- (a walk, a ride, a seat) is going on.
local function sideJobs(except, tried, away, busy, quick)
    tried = tried or {}
    local function want(s, n)
        return n ~= except and not (busy and busy[s.key]) and hasNeed(s, n) and not table.find(C.Skip, n)
            and not blocked(s, n) and not tried[s.key .. "|" .. n] and not (away and away())
    end
    local function did(s, n)
        if not hasNeed(s, n) then
            succeed(s, n)
            log(("%s %s done (while waiting)"):format(s.kind, n))
        else
            tried[s.key .. "|" .. n] = true
        end
    end
    if C.BabyFarm and team() == "Babies" then
        for _, n in ipairs({ "hungry", "thirsty", "sick" }) do
            if want(BABY, n) then babyEat(n) did(BABY, n) end
        end
    end
    for _, s in ipairs(farmPets()) do
        if want(s, "mystery") then
            -- in an area: an option done right here (the area itself, or a seat it has) wins
            local a, prefer = AREA[except], nil
            if a then
                prefer = { [except] = true }
                for n in pairs(a.room or {}) do prefer[n] = true end
            end
            doMystery(s, prefer)
            did(s, "mystery")
        end
        for _, n in ipairs({ "hungry", "thirsty", "sick" }) do
            if want(s, n) and (n == "sick" or C.PetFood ~= "Free bowls only") then
                feedWithItem(s, n)
                did(s, n)
            end
        end
        if not quick then
            if want(s, "play") then petPlay(s, true) did(s, "play") end
            if want(s, "pet_me") then petMe(s) did(s, "pet_me") end       -- 4.5 s, no moving
        end
    end
    if quick then return end
    -- outdoor areas (beach / park / camp) count by position, so a short walk around the spot
    -- clears walk for every pet at the same time
    local a = AREA[except]
    if a and a.anchor then
        local walkers = {}
        for _, s in ipairs(farmPets()) do
            local _, wish = Pref:of(s, "walk")          -- a leash wish: only petWalk (holding it) clears it
            if want(s, "walk") and not wish and wrapperOf(s.unique) then walkers[#walkers + 1] = s end
        end
        if #walkers > 0 then
            local _, hrp = char()
            local origin = hrp and hrp.Position
            -- stops after 15 s without progress (sum: one pet finishing never looks like a stall)
            -- quick needs (food, drink, heal, mysteries) on their own thread meanwhile, like petWalk:
            -- a hungry baby waited out the whole walk (up to 45 s) before (2026-10-12)
            moveUntil(function() return anyNeed(walkers, "walk") end, 45, 10, function()
                local sum = 0
                for _, p in ipairs(walkers) do sum += math.min(1, Pref.progress(p, "walk")) end
                return sum
            end, function() sideJobs(except, tried, away, nil, true) end)
            for _, s in ipairs(walkers) do did(s, "walk") end
            local _, hrp2, hum = char()                                     -- back to the spot
            if origin and hum then hum:MoveTo(origin) end
        end
    end
end

------------------------------------------------------------------------------------------------
-- AREAS — one trip clears the need for the baby AND every farm pet together
------------------------------------------------------------------------------------------------

local function doArea(need, subjects)
    local a = AREA[need]
    if a.anchor and C.TaskFloor and Floor.model then
        if not goFloor(a.anchor) then return false end       -- the floor above it counts
    else
        if not goTo(a.dest) then return false end
        if a.anchor then tpTo(anchorPos(a.anchor)) end
    end
    setStatus(("%s at %s (≈50 s, %d at once) + small tasks meanwhile"):format(need, a.anchor or a.dest, #subjects))
    -- the area counts down on its own: meanwhile eat, drink, heal, pick mysteries and play
    -- right here. Stand still otherwise: carrying / strolling during an area stopped its
    -- progress for baby and pet (seen live), so walk and ride wait until it's done.
    -- The game's area timer sometimes stops counting mid-way (seen at the Pizza Shop: 24 %
    -- after 70 s, then fine on a retry), so: keep going while progress moves, and if it
    -- stalls 15 s, step out and back in to restart it. Up to 150 s in all.
    local function progress()
        local best, now = 0, Workspace:GetServerTimeNow()
        for _, s in ipairs(subjects) do
            local e = needEntry(s, need)
            if e then
                local p = tonumber(e.progress) or 0
                local rate, ts = tonumber(e.rate) or 0, tonumber(e.rate_timestamp) or -1
                if rate > 0 and ts > 0 then p += rate * math.max(0, now - ts) end
                best = math.max(best, p)
            end
        end
        return best
    end
    local t0, lastP, movedAt, restarts = os.clock(), -1, os.clock(), 0
    local tried = {}
    local function away() return not a.anchor and location() ~= a.dest and not G.IM.entering end
    -- At the same time (asked 2026-10-11: "camping and sleeping at once, school…"): whoever
    -- needs a seat the area has (a.room) uses it here instead of a trip home afterwards — the
    -- campsite's sleeping bags, the beds / bowls inside School, Salon, Cat Café, Pizza Shop.
    -- Only seats that keep the area counting: in the same building, or within 100 studs of the
    -- campsite origin. Everyone at once, one seat each; a seat that didn't clear its need isn't
    -- tried again this visit (the usual job does it after). Food: items first (sideJobs); a
    -- seat here only when items didn't work, or for a pet set to "Free bowls only".
    local origin = a.anchor == "camp" and anchorPos("camp") or nil
    local function roomJobs()
        if not a.room or (a.anchor and not origin) or away() then return end
        if os.clock() + 45 > (S.jobEnd or math.huge) then return end          -- no time for a seat
        local _, hrp = char()
        if not hrp then return end
        local subs = {}
        if C.BabyFarm and team() == "Babies" then subs[#subs + 1] = BABY end
        for _, s in ipairs(farmPets()) do subs[#subs + 1] = s end
        local assign, taken = {}, {}
        for _, s in ipairs(subs) do
            for _, n in ipairs({ "sleepy", "hungry", "thirsty" }) do
                local key = "room|" .. s.key .. "|" .. n
                local food = n == "hungry" or n == "thirsty"
                local foodOk = not food or tried[s.key .. "|" .. n]
                    or (s.kind == "pet" and C.PetFood == "Free bowls only")
                if a.room[n] and n ~= need and foodOk and not tried[key] and hasNeed(s, n)
                   and not table.find(C.Skip, n) and not blocked(s, n) then
                    local model, block = findFurniture(n, teamOf(s), taken, origin or hrp.Position)
                    local inside = block and (origin and (block.Position - origin).Magnitude < 100
                        or (not origin and location() == a.dest and (block.Position - hrp.Position).Magnitude < 400))
                    if model and inside then
                        assign[#assign + 1] = { subject = s, model = model, block = block, need = n, key = key }
                        taken[block] = true
                        break                                                -- one seat each
                    end
                end
            end
        end
        if #assign == 0 then return end
        -- pets only use furniture near their caregiver: everyone within 20 studs of one spot
        local anchor
        for _, x in ipairs(assign) do if x.subject.kind == "pet" then anchor = x.block.Position break end end
        anchor = anchor or assign[1].block.Position
        local near, names = {}, {}
        for _, x in ipairs(assign) do
            if (x.block.Position - anchor).Magnitude <= 20 then
                near[#near + 1] = x
                names[#names + 1] = x.subject.kind .. " " .. x.need
            end
        end
        setStatus(("%s + %s at once (%s)"):format(need, table.concat(names, ", "), a.anchor or a.dest))
        if origin then
            -- from the floor above, down to the bags; a pet left up there is brought along
            tpTo(anchor + Vector3.new(3, -2, 3))
            settle(1.5)
            local _, me2 = char()
            for _, x in ipairs(near) do
                local w = x.subject.kind ~= "baby" and wrapperOf(x.subject.unique)
                local root = w and (w.char.PrimaryPart or w.char:FindFirstChild("HumanoidRootPart"))
                if x.subject.kind ~= "baby" and me2 and (not root or (root.Position - me2.Position).Magnitude > 30) then
                    invoke("ToolAPI/Unequip", x.subject.unique)
                    task.wait(0.3)
                    ensureOut(x.subject.unique)
                end
            end
        end
        useGroup(near, nil, anchor, function(busy) sideJobs(need, tried, away, busy, true) end)
        for _, x in ipairs(near) do
            tried[x.key] = true
            if not hasNeed(x.subject, x.need) then
                succeed(x.subject, x.need)
                log(("%s %s done (during %s)"):format(x.subject.kind, x.need, need))
            end
        end
    end
    while alive() and os.clock() - t0 < 150 do
        -- someone who got this same need after we came (or sat on a retry wait) counts here
        -- already: wait for it too, not a new trip and a whole new countdown later
        if os.clock() - t0 < 100 then
            local all = farmPets()
            if C.BabyFarm and team() == "Babies" then all[#all + 1] = BABY end
            for _, s in ipairs(all) do
                local known = false
                for _, x in ipairs(subjects) do if x.key == s.key then known = true break end end
                if not known and hasNeed(s, need) and not table.find(C.Skip, need) then
                    subjects[#subjects + 1] = s
                    log(("%s %s: joined the one running at %s"):format(s.kind, need, a.anchor or a.dest))
                end
            end
        end
        if not anyNeed(subjects, need) then break end
        sideJobs(need, tried, away)
        roomJobs()
        -- ended up outside the building (a door touched, a glitch): straight back in
        if away() then
            log(("left the %s by accident — going back in"):format(a.dest))
            goTo(a.dest)
            movedAt = os.clock()
        end
        local p = progress()
        if p > lastP + 0.002 then lastP, movedAt = p, os.clock() end
        -- the area may have finished during a long side job (a walk + its quick thread): progress()
        -- then reads 0, which is no stall — no stepping out and back in for nothing (2026-10-12)
        if os.clock() - movedAt > 15 and restarts < 3 and anyNeed(subjects, need) then
            restarts += 1
            log(("%s stalled at %d%% — stepping out and back in"):format(need, math.floor(p * 100)))
            if a.anchor and C.TaskFloor and Floor.model and restarts == 1 then
                -- the floor above didn't count this time: stand on the ground at the spot
                -- itself (always counts), with the pets brought along
                tpTo(anchorPos(a.anchor))
                settle(2)
                local _, me2 = char()
                for _, s in ipairs(subjects) do
                    local w = s.kind ~= "baby" and wrapperOf(s.unique)
                    local root = w and (w.char.PrimaryPart or w.char:FindFirstChild("HumanoidRootPart"))
                    if s.kind ~= "baby" and me2 and (not root or (root.Position - me2.Position).Magnitude > 30) then
                        invoke("ToolAPI/Unequip", s.unique)      -- left behind: back out next to you
                        task.wait(0.3)
                        ensureOut(s.unique)
                    end
                end
            elseif a.anchor and C.TaskFloor and Floor.model then
                goTo("Neighborhood")
                goTo("MainMap")
                tpTo(anchorPos(a.anchor))
            else
                goTo(a.dest == "MainMap" and "Neighborhood" or "MainMap")
                goTo(a.dest)
                if a.anchor then tpTo(anchorPos(a.anchor)) end
            end
            movedAt = os.clock()
        end
        -- a new need (hungry, a mystery…) is picked up within 0.25 s, not at the end of the 1 s tick;
        -- never a tick under 0.25 s, so a burst of ClientData updates can't spin the loop (2026-10-12)
        local t1, seen = os.clock(), S.needAt
        while os.clock() - t1 < 1 and anyNeed(subjects, need) and (S.needAt == seen or os.clock() - t1 < 0.25) do
            Floor.nap(S.needAt == seen and 0.25 or 0.25 - (os.clock() - t1))
        end
    end
    if anyNeed(subjects, need) then
        log(("%s didn't finish at %s (%d%% after %ds, %d restart(s))"):format(need, a.anchor or a.dest,
            math.floor(progress() * 100), math.floor(os.clock() - t0), restarts))
    end
    return not anyNeed(subjects, need)
end

------------------------------------------------------------------------------------------------
-- BABY
------------------------------------------------------------------------------------------------

Baby = {}

function Baby:become(wantBaby)
    if not G.ready then notify("Loading", "Game data isn't ready yet.") return false end
    local target = wantBaby and "Babies" or "Parents"
    if team() == target then notify("Form", "Already " .. target) return true end
    local ok, res = invoke("TeamAPI/ChooseTeam", target, { dont_respawn = true, source_for_logging = "avatar_editor" })
    task.wait(1.5)
    local now = team()
    log(("team -> %s (%s)"):format(now, tostring(ok and res)))
    notify("Form", now == target and ("You are now " .. target) or ("Refused: " .. tostring(res)))
    return now == target
end

------------------------------------------------------------------------------------------------
-- SHOP — the live catalogue is whatever HotspotsByInterior says a shop sells
------------------------------------------------------------------------------------------------

Shop = { rows = {}, byId = {}, shown = {}, byLabel = {}, confirmAt = 0, autoAt = 0 }

local function currencyName(cur)
    if not cur then return "$" end
    if tostring(cur):find("ticket") then return "tickets" end
    return tostring(cur)
end

local function priceText(r)
    if (tonumber(r.cost) or 0) == 0 then return "free" end    -- priced $0 by the game, e.g. healing apple
    if not r.currency then return "$" .. tostring(r.cost) end
    return tostring(r.cost) .. " " .. currencyName(r.currency)
end

local CAT_LABEL = { food = "Food", toys = "Toys", pets = "Eggs", gifts = "Gifts", strollers = "Strollers",
                    transport = "Vehicles", pet_accessories = "Pet wear", roleplay = "Roleplay",
                    stickers = "Stickers" }
local function catLabel(cat) return CAT_LABEL[cat] or cat end

-- Only what the server sells for bucks / tickets. A shop also DISPLAYS items with no price
-- (Robux pets, signs): buying one of those is a server kick — seen live 2026-09-30, "Vanilla
-- Penguin" (no cost field, shown as "free") -> kicked 0.5 s later. Pets: eggs only.
local function sellable(cat, e)
    if type(e.cost) ~= "number" or e.cost < 0 then return false end
    if cat == "pets" and not e.is_egg then return false end
    return true
end

function Shop:build()
    local rows, cats, byId = {}, {}, {}
    for id, shops in pairs(G.Hot.items or {}) do
        for cat, t in pairs(G.IDB) do
            local e = type(t) == "table" and t[id]
            if type(e) == "table" then
                if sellable(cat, e) then
                    local r = { id = id, cat = cat, name = e.name or id, cost = e.cost,
                                currency = e.currency_id, shop = next(shops) or "?",
                                egg = cat == "pets" and e.is_egg == true }
                    rows[#rows + 1] = r
                    byId[id] = r
                    cats[cat] = true
                end
                break
            end
        end
    end
    local catList = { "All" }
    for c in pairs(cats) do catList[#catList + 1] = catLabel(c) end
    table.sort(catList)
    self.rows, self.byId = rows, byId
    ui(function() UI.DShopCat:Refresh(catList) end)
    self:refresh()
end

function Shop:refresh()
    if not G.ready then return end
    local f = tostring(C.ShopSearch or ""):lower()
    local list = {}
    for _, r in ipairs(self.rows) do
        if (C.ShopCategory == "All" or catLabel(r.cat) == C.ShopCategory or r.cat == C.ShopCategory)
           and (f == "" or r.name:lower():find(f, 1, true) or r.id:lower():find(f, 1, true))
           and (not C.ShopAffordable or self:affordable(r, 0) > 0) then
            list[#list + 1] = r
        end
    end
    table.sort(list, function(a, b)
        if C.ShopSort == "Name A-Z" then return a.name < b.name end
        local ca, cb = tonumber(a.cost) or 0, tonumber(b.cost) or 0
        if ca ~= cb then
            if C.ShopSort == "Most expensive first" then return ca > cb end
            return ca < cb
        end
        return a.name < b.name
    end)
    local labels, map = {}, {}
    for _, r in ipairs(list) do
        local label = ("%s — %s"):format(r.name, priceText(r))
        if map[label] then label = label .. " (" .. r.id .. ")" end
        labels[#labels + 1] = label
        map[label] = r
    end
    self.shown, self.byLabel = list, map
    ui(function() UI.DShopItem:Refresh(labels) end)
    self:details()
end

function Shop:details()
    if not G.ready then return end
    local r = C.ShopItem and self.byLabel[C.ShopItem]
    local text
    if not r then
        text = "Pick an item"
    else
        local e = G.IDB[r.cat] and G.IDB[r.cat][r.id]
        local extra = ""
        if e and e.ailment_to_boost then extra = " · clears " .. tostring(e.ailment_to_boost) end
        if r.egg and e then extra = (" · hatches after %s xp"):format(tostring(e.xp_to_hatch)) end
        text = ("%s — %s\n%s · sold at %s · you own %d · you can buy %d now%s"):format(
            r.name, priceText(r), catLabel(r.cat), tostring(r.shop), self:owned(r), self:affordable(r, 0), extra)
    end
    ui(function() UI.PItem:Set({ Title = "Selected item", Content = text }) end)
end

function Shop:owned(r)
    local d, n = me(), 0
    for _, it in pairs(d and d.inventory[r.cat] or {}) do
        if it.id == r.id then n += 1 end
    end
    return n
end

-- How many of `r` can be bought right now: money (minus a bucks reserve), the game's
-- per-item purchase limit, and the 99-per-purchase cap.
function Shop:affordable(r, reserve)
    local cap = 99
    local okL, plm = pcall(G.CD.get, "purchase_limit_manager")
    local lim = okL and plm and plm.purchase_limits and plm.purchase_limits[r.id]
    if lim then cap = math.min(cap, (tonumber(lim.max_purchases) or 0) - (tonumber(lim.purchases) or 0)) end
    local cost = tonumber(r.cost)
    if not cost or cost <= 0 then return math.max(0, cap) end
    local spendable = balance(r.currency) - (r.currency and 0 or (reserve or 0))
    return math.clamp(math.floor(spendable / cost), 0, math.max(0, cap))
end

function Shop:buy(r, n)
    -- second guard: never ask the server for something it doesn't sell (kick)
    local e = G.IDB[r.cat] and G.IDB[r.cat][r.id]
    if not (e and sellable(r.cat, e)) then
        log("refused to buy " .. tostring(r.id) .. " — not sold for bucks")
        return false, "not for sale"
    end
    n = math.clamp(math.floor(tonumber(n) or 1), 1, 99)
    local before = balance(r.currency)
    local ok, res = invoke("ShopAPI/BuyItem", r.cat, r.id, { buy_count = n })
    task.wait(0.4)
    local spent = before - balance(r.currency)
    local good = ok and (res == "success" or res == true)
    if good then S.bought += n end
    log(("buy %dx %s: %s (-%d %s)"):format(n, r.id, tostring(ok and res or "error"), spent, currencyName(r.currency)))
    return good, res
end

-- n = number, "max" (everything you can afford, 99 per purchase) or nil (the Amount slider).
function Shop:buySelected(n)
    if not G.ready then notify("Shop", "Still loading.") return end
    local r = C.ShopItem and self.byLabel[C.ShopItem]
    if not r then notify("Shop", "Pick an item first.") return end
    local count = n == "max" and self:affordable(r, C.KeepBucks) or (tonumber(n) or C.ShopAmount)
    if count < 1 then notify("Shop", "You can't afford " .. r.name .. " right now.") return end
    local good, res = self:buy(r, count)
    notify("Shop", good and ("Bought %dx %s"):format(count, r.name) or ("Refused: " .. tostring(res)))
    self:details()
end

function Shop:buyAll()
    if not G.ready then notify("Shop", "Still loading.") return end
    if os.clock() - self.confirmAt > 6 then
        self.confirmAt = os.clock()
        notify("Confirm", ("Press again within 6 s to buy %dx of all %d listed items.")
            :format(C.ShopAmount, #self.shown))
        return
    end
    self.confirmAt = 0
    local okN, badN = 0, 0
    for _, r in ipairs(self.shown) do
        if not alive() then break end
        if self:buy(r, C.ShopAmount) then okN += 1 else badN += 1 end
        task.wait(0.25)
    end
    notify("Shop", ("Done: %d bought, %d refused."):format(okN, badN))
    self:refresh()
end

------------------------------------------------------------------------------------------------
-- EGGS — hatch list, egg picker, auto-buy with first call on the bucks
------------------------------------------------------------------------------------------------

Eggs = { hatchLabelToId = {}, buyLabelToId = {}, ready = false, warned = false }

function Eggs:build()
    local ids, owned = {}, {}
    for _, p in ipairs(allPets()) do
        if p.egg then
            ids[p.id] = true
            owned[p.id] = (owned[p.id] or 0) + 1
        end
    end
    for id, r in pairs(Shop.byId) do
        if r.egg then ids[id] = true end
    end
    local hatchLabels, hatchMap, seen, sorted = {}, {}, {}, {}
    for id in pairs(ids) do sorted[#sorted + 1] = id end
    table.sort(sorted, function(a, b) return (owned[a] or 0) > (owned[b] or 0) end)
    for _, id in ipairs(sorted) do
        local db = G.IDB.pets[id]
        local label = (db and db.name) or id
        if seen[label] then label = label .. " (" .. id .. ")" end
        seen[label] = true
        hatchLabels[#hatchLabels + 1] = label
        hatchMap[label] = id
    end
    local buyLabels, buyMap, sold = {}, {}, {}
    for _, r in pairs(Shop.byId) do if r.egg then sold[#sold + 1] = r end end
    table.sort(sold, function(a, b) return (tonumber(a.cost) or 0) < (tonumber(b.cost) or 0) end)
    for _, r in ipairs(sold) do
        local label = ("%s — %s"):format(r.name, priceText(r))
        buyLabels[#buyLabels + 1] = label
        buyMap[label] = r.id
    end
    self.hatchLabelToId, self.buyLabelToId, self.ready = hatchMap, buyMap, true
    ui(function()
        UI.DHatchList:Refresh(hatchLabels)
        UI.DBuyEgg:Refresh(buyLabels)
    end)
end

-- The egg to auto buy; nothing picked = the cheapest egg the shops sell for bucks (before,
-- "Auto buy" with no egg picked silently did nothing).
function Eggs:buyId()
    local id = self.buyLabelToId[C.BuyEgg or ""]
    if id then return id end
    local best, bestCost
    for bid, r in pairs(Shop.byId or {}) do
        local c = tonumber(r.cost)
        if r.egg and not r.currency and c and (not bestCost or c < bestCost) then best, bestCost = bid, c end
    end
    return best
end

-- Egg kinds the farm may hatch; nil = any egg. The egg you auto-buy always counts.
function Eggs:allowed()
    if #C.HatchList == 0 then return nil end
    local set = {}
    for _, label in ipairs(C.HatchList) do
        local id = self.hatchLabelToId[label]
        if id then set[id] = true end
    end
    -- the auto-bought egg counts only when auto buy is on (buyId falls back to the cheapest
    -- egg since v3.3, so this used to add Cracked Eggs to every hatch list)
    local b = C.AutoBuyEggs and self:buyId()
    if b then set[b] = true end
    return set
end

function Eggs:done()
    return C.HatchCount > 0 and S.hatched >= C.HatchCount
end

-- Auto buy eggs means hatching them too (buying eggs nobody hatches did nothing visible).
function Eggs:hatching() return (C.HatchEggs or C.AutoBuyEggs) and not self:done() end

function Eggs:ok(p)
    if not (p and p.egg) then return false end
    local allow = self:allowed()
    return allow == nil or allow[p.id] == true
end

function Eggs:tick()
    if not C.AutoBuyEggs or self:done() then return end
    local id = self:buyId()
    local r = id and Shop.byId[id]
    if not r then return end
    for _, p in ipairs(allPets()) do
        if self:ok(p) then return end          -- still something to hatch
    end
    local n = Shop:affordable(r, C.KeepBucks)
    if n < 1 then
        if not self.warned then
            log("can't afford " .. r.name)
            notify("Eggs", "Not enough to buy " .. r.name)
            self.warned = true
        end
        return
    end
    self.warned = false
    local want = C.HatchCount > 0 and (C.HatchCount - S.hatched) or 3
    n = math.min(n, math.max(1, want), 99)
    setStatus(("Buying %dx %s"):format(n, r.name))
    if Shop:buy(r, n) then
        S.eggsBought += n
        notify("Egg bought", ("%dx %s"):format(n, r.name))
    end
end

function Shop:autoTick()
    if not C.ShopAuto or os.clock() - self.autoAt < 6 then return end
    self.autoAt = os.clock()
    local r = C.ShopItem and self.byLabel[C.ShopItem]
    if not r then return end
    local reserve = C.KeepBucks
    if C.AutoBuyEggs and not Eggs:done() then
        local e = Eggs:buyId() and self.byId[Eggs:buyId()]
        if e and not e.currency then reserve += tonumber(e.cost) or 0 end
    end
    local n = self:affordable(r, reserve)
    if not C.ShopMax then n = math.min(n, C.ShopAmount - self:owned(r)) end
    if n < 1 then return end
    if self:buy(r, n) then notify("Auto buy", ("%dx %s"):format(n, r.name)) end
end

------------------------------------------------------------------------------------------------
-- PET FARM — up to 2 slots; a slot is a pet you chose or "Auto" (rules / eggs)
------------------------------------------------------------------------------------------------

Farm = { slots = {}, wasEgg = {}, readySince = {}, lastKind = {}, lastMark = 0, known = nil, warned = {} }

local function keepGrown() return C.WhenGrown == "Keep farming it (bucks)" end

function Farm:count()
    if C.PetCount ~= "2 pets" then return 1 end
    return math.clamp(maxPets(), 1, 2)
end

function Farm:uniques()
    local out = {}
    for i = 1, 2 do if self.slots[i] then out[#out + 1] = self.slots[i] end end
    return out
end

-- The 2nd pet needs the game's permission (equipped_pets_allowed, from an ACTIVE Pet Handler
-- Pro Certificate / Pets Plus) and the setting; say once which one is missing (2026-10-11:
-- "I have the certificate and it won't equip 2 pets")
function Farm:twoPetsHint()
    if self.hinted then return end
    local want = C.PetCount == "2 pets"
    local can = maxPets() >= 2
    local cert = false
    for _, it in pairs(me() and me().inventory.gifts or {}) do
        if tostring(it.id):find("2x_pet_certificate", 1, true) then cert = true end
    end
    local sub = me() and me().subscription_manager
    local state = type(sub) == "table" and type(sub.equip_2x_pets) == "table" and tostring(sub.equip_2x_pets.state) or nil
    local msg
    if want and not can and state and state ~= "NeverSubscribed" and not cert then
        msg = "Pet Handler Pro Certificate: " .. state .. " (not active) — the game allows 1 pet out."
    elseif want and not can and cert then
        msg = "A Pet Handler Pro Certificate is in your backpack but not used: use it in the game (Backpack › Gifts) to unlock 2 pets."
    elseif can and not want then
        msg = "This account can have 2 pets out: set \"Pets at once\" to \"As many as the game allows\" (Farm tab)."
    end
    if msg then self.hinted = true log(msg) notify("2 pets", msg) end
end

function Farm:has(u)
    return u ~= nil and (self.slots[1] == u or self.slots[2] == u)
end

-- Session age-up counter for the dashboard: called for the farm pets every second, before a
-- slot changes pet, and around every age potion — one place, so nothing is counted twice
-- and a pet's first age-up isn't lost to a slot switch.
function Farm:seeAge(u)
    S.ageSeen = S.ageSeen or {}
    local p = petByUnique(u)
    if not p or p.egg then return end
    local was = S.ageSeen[u]
    if was and p.age > was then
        S.ageUps += p.age - was
        if p.age >= 6 then S.grown += 1 end
        if Farm.Pen and Farm.Pen.note then Farm.Pen.note(p.name, was, p.age, "farm") end
    end
    S.ageSeen[u] = p.age
end

-- The "Auto" rules for a pet (eggs while hatching).
-- petRules: judge by the pet rules even while hatching (the no-egg-left fallback below).
function Farm:valid(p, petRules)
    if not p then return false end
    if Eggs:hatching() and not petRules then return Eggs:ok(p) end
    if not C.PetFarm or p.egg or p.temp then return false end
    if p.age >= 6 and not keepGrown() then return false end
    local kid = Kinds:idOf(C.PetKind)
    if kid and p.id ~= kid then return false end
    -- Farm tab › "Farm only these kinds" (labels from your own pets; none ticked = every kind)
    if type(C.FarmKinds) == "table" and #C.FarmKinds > 0 then
        local okKind = false
        for _, label in ipairs(C.FarmKinds) do
            if Kinds:idOf(label) == p.id or label == p.id then okKind = true break end
        end
        if not okKind then return false end
    end
    if C.PetVersion == "Regular only" and (p.neon or p.mega) then return false end
    if C.PetVersion == "Neon only" and not p.neon then return false end
    return true
end

function Farm:rank(p, i)
    if C.WhenGrown == "Switch, prioritized kinds first" and #C.PriorityTypes > 0 then
        for n, label in ipairs(C.PriorityTypes) do
            if Kinds:idOf(label) == p.id then return n end
        end
        return 1000
    end
    if C.WhenGrown == "Switch, same kind first" and self.lastKind[i] and p.id == self.lastKind[i] then return 0 end
    return 1
end

-- The pet each slot farms, remembered per account: in getgenv (survives a reload, any
-- executor) and in a small file when the executor has writefile (survives a rejoin).
function Farm:memFile() return "CometHub/AdoptMe_farm_" .. LP.Name .. ".json" end

function Farm:memory()
    if self.mem then return self.mem end
    local mem
    pcall(function() mem = getgenv().__CometFarmPets and getgenv().__CometFarmPets[LP.Name] end)
    if type(mem) ~= "table" then
        pcall(function()
            if isfile and readfile and isfile(self:memFile()) then
                mem = game:GetService("HttpService"):JSONDecode(readfile(self:memFile()))
            end
        end)
    end
    self.mem = type(mem) == "table" and mem or {}
    return self.mem
end

function Farm:remember(i, u)
    local mem = self:memory()
    if mem[tostring(i)] == u then return end
    mem[tostring(i)] = u
    pcall(function()
        local g = getgenv()
        g.__CometFarmPets = g.__CometFarmPets or {}
        g.__CometFarmPets[LP.Name] = mem
    end)
    pcall(function()
        if not writefile then return end
        if makefolder and isfolder and not isfolder("CometHub") then makefolder("CometHub") end
        writefile(self:memFile(), game:GetService("HttpService"):JSONEncode(mem))
    end)
end

function Farm:pickFor(i, blockedSet)
    -- a pet you picked by hand, while it still has growing to do
    local u = PetList:uniqueOf(C["Pet" .. i])
    if u and C.PetFarm then
        local p = petByUnique(u)
        if p and not blockedSet[u] and not p.egg and (p.age < 6 or keepGrown()) then return p end
        if p and not self.warned[u] then
            self.warned[u] = true
            notify("Pet " .. i, p.name .. (blockedSet[u] and " is in the pet pen or used by the other slot"
                or " is Full Grown") .. " — the slot goes back to Auto")
        end
    end
    local cur = self.slots[i] and petByUnique(self.slots[i])
    -- fresh start (reload, rejoin, farm toggled off and on): carry on with the pet this slot
    -- was farming, else the pet you already have out — never a new one while it's growing
    if not cur and C.StickyPet then
        local mu = self:memory()[tostring(i)]
        local mp = mu and petByUnique(mu)
        if mp and not blockedSet[mu] and self:valid(mp) then cur = mp end
        if not cur then
            for _, eu in ipairs(equippedPets()) do
                local ep = petByUnique(eu)
                if ep and not blockedSet[eu] and self:valid(ep) then cur = ep break end
            end
        end
    end
    if cur and not blockedSet[cur.unique] and PetList:uniqueOf(C["Pet" .. i]) ~= cur.unique and self:valid(cur) then
        return cur
    end
    if cur and not cur.egg then self.lastKind[i] = cur.id end
    local pool = {}
    for _, p in ipairs(allPets()) do
        if not blockedSet[p.unique] and self:valid(p) then pool[#pool + 1] = p end
    end
    -- hatching with no allowed egg owned (all hatched, can't afford one): farm a pet
    -- meanwhile instead of stopping — no needs done means no bucks for the next egg either.
    -- The pet is swapped for an egg on the next ensure after Eggs:tick buys one.
    if not pool[1] and Eggs:hatching() and C.PetFarm then
        if cur and not cur.egg and not blockedSet[cur.unique] and self:valid(cur, true) then return cur end
        for _, p in ipairs(allPets()) do
            if not blockedSet[p.unique] and self:valid(p, true) then pool[#pool + 1] = p end
        end
    end
    local order = C.PetOrder
    table.sort(pool, function(a, b)
        local ra, rb = self:rank(a, i), self:rank(b, i)
        if ra ~= rb then return ra < rb end
        if a.egg and b.egg and a.xp ~= b.xp then return a.xp > b.xp end   -- closest to hatching
        if order == "Rarest first" and a.rarity ~= b.rarity then return a.rarity > b.rarity end
        if a.age ~= b.age then
            if order == "Oldest first" then return a.age > b.age end
            return a.age < b.age
        end
        return a.unique < b.unique
    end)
    return pool[1]
end

-- A farmed egg turned into a pet (or vanished): count it. If it is ready but the hatch
-- animation never confirmed (window hidden…), confirm it ourselves.
function Farm:checkHatch()
    for i = 1, 2 do
        local u = self.slots[i]
        if u and self.wasEgg[i] then
            local cur = petByUnique(u)
            if cur and cur.egg then
                if cur.hatchAt and cur.xp >= cur.hatchAt then
                    self.readySince[i] = self.readySince[i] or os.clock()
                    if os.clock() - self.readySince[i] > 8 and os.clock() - self.lastMark > 15 then
                        self.lastMark = os.clock()
                        local _, hrp = char()
                        fire("PetAPI/MarkHatched", cur.unique, hrp and hrp.CFrame * CFrame.new(0, 0, -4) or CFrame.new())
                        log("egg ready — confirmed the hatch")
                    end
                end
            else
                self.wasEgg[i], self.readySince[i], self.slots[i] = false, nil, nil
                S.hatched += 1
                -- the hatched pet gets a NEW unique: name it by diffing the snapshot
                local name
                for _, q in ipairs(self.known and allPets() or {}) do
                    if not self.known[q.unique] and not q.egg then name = q.name break end
                end
                name = name or "a pet"
                log("egg hatched: " .. name)
                notify("Egg hatched!", name)
                self.known = nil
                if Eggs:done() then
                    ui(function() UI.THatch:Set(false) end)
                    C.HatchEggs = false
                    notify("Hatching done", ("%d eggs hatched."):format(S.hatched))
                end
            end
        end
    end
end

function Farm:ensure()
    self:checkHatch()
    for _, u in ipairs(self:uniques()) do self:seeAge(u) end     -- before any slot changes pet
    local n = self:count()
    local reserved = {}
    for i = 1, n do
        local u = PetList:uniqueOf(C["Pet" .. i])
        if u then reserved[u] = i end
    end
    local taken, list, anyEgg = {}, {}, false
    -- pets sitting in the pet pen are never farmed: equipping one either fails (a dead slot
    -- StickyPet would keep forever) or pulls it out of your pen
    local d = me()
    local pen = d and d.idle_progression_manager and d.idle_progression_manager.active_pets or {}
    for i = 1, n do
        local blockedSet = {}
        for u, j in pairs(reserved) do if j ~= i then blockedSet[u] = true end end
        for u in pairs(taken) do blockedSet[u] = true end
        for u in pairs(pen) do blockedSet[u] = true end
        local p = self:pickFor(i, blockedSet)
        if p then
            if p.unique ~= self.slots[i] then
                self.readySince[i] = nil
                log(("pet %d: %s%s (%s)"):format(i, versionPrefix(p), p.name,
                    p.egg and "egg" or (AGE_NAME[p.age] or p.age)))
            end
            self.slots[i], self.wasEgg[i] = p.unique, p.egg
            self:remember(i, p.unique)
            taken[p.unique] = true
            list[#list + 1] = p.unique
            anyEgg = anyEgg or p.egg
        else
            if self.slots[i] then log(("pet %d: nothing left to farm with these settings"):format(i)) end
            self.slots[i], self.wasEgg[i] = nil, false
        end
    end
    for i = n + 1, 2 do self.slots[i], self.wasEgg[i] = nil, false end
    if anyEgg and not self.known then
        self.known = {}
        for _, q in ipairs(allPets()) do self.known[q.unique] = true end
    elseif not anyEgg then
        self.known = nil
    end
    if #list > 0 then setEquipped(list) end
end

local function farming() return C.PetFarm or Eggs:hatching() end

------------------------------------------------------------------------------------------------
-- JOBS — needs grouped so everyone with the same need is done in one go
------------------------------------------------------------------------------------------------

local function subjects()
    local list = {}
    if C.BabyFarm and team() == "Babies" then list[#list + 1] = BABY end
    if farming() then
        for _, u in ipairs(Farm:uniques()) do list[#list + 1] = petSubject(u) end
    end
    return list
end

local function workable(s, need)
    return RANK[need] and not table.find(C.Skip, need) and not blocked(s, need) and not UNSUPPORTED[need]
end

-- Can this job start without a trip?
local function isHere(need, list, loc)
    local onFloor = C.TaskFloor and Floor:onFloor()
    local a = AREA[need]
    if a then
        if a.anchor then return onFloor end                  -- a short hop along the floor
        return loc == a.dest
    end
    if need == "mystery" or need == "pet_me" then return true end
    local allBaby = true
    for _, s in ipairs(list) do if s.kind ~= "baby" then allBaby = false end end
    if (need == "hungry" or need == "thirsty") and (allBaby or C.PetFood == "Food items first") then
        return true                                          -- eaten right where you stand
    end
    if need == "sick" then return C.AutoBuyFood end         -- the free healing apple
    if need == "play" or need == "walk" or need == "ride" then
        if C.TaskFloor then return onFloor end
        return not C.HomeTasks or loc == "housing"
    end
    if need == "hungry" or need == "thirsty" then
        return not C.HomeTasks or loc == "housing"
    end
    if C.HomeTasks and HOME_KIND[need] then return loc == "housing" or Home:farReady(need, list) end
    return findFurniture(need, teamOf(list[1])) ~= nil
end

Farm.isHere = isHere

local function collectJobs()
    local byNeed, order = {}, {}
    for _, s in ipairs(subjects()) do
        for _, need in ipairs(needsOf(s)) do
            if workable(s, need) then
                if not byNeed[need] then byNeed[need] = {} order[#order + 1] = need end
                table.insert(byNeed[need], s)
            end
        end
    end
    local loc, jobs = location(), {}
    for _, need in ipairs(order) do
        local list = byNeed[need]
        jobs[#jobs + 1] = { need = need, subjects = list, here = isHere(need, list, loc) and 0 or 1 }
    end
    -- Timed areas first: their ~50 s countdown is when every quick need (eat, drink, heal,
    -- play, mystery, walk, ride) gets done too — and sleep / bowls where the area has them, so
    -- of two areas the one covering more of the other needs goes first (sleep at school instead
    -- of a trip home after). Then whatever needs no trip, then the rest.
    local cover = {}
    for _, j in ipairs(jobs) do
        local room, n = AREA[j.need] and AREA[j.need].room, 0
        for _, j2 in ipairs(room and jobs or {}) do
            if j2 ~= j and room[j2.need] then n += #j2.subjects end
        end
        cover[j] = n
    end
    -- a ride goes just before a walk when both are pending: the walk rides along (strollerRide)
    local hasWalk = false
    for _, j in ipairs(jobs) do if j.need == "walk" then hasWalk = true end end
    local function rank(j)
        if j.need == "ride" and hasWalk then return math.min(RANK.ride, RANK.walk - 0.5) end
        return RANK[j.need]
    end
    -- away from where the farm waits (home for a bed, an area just done), what needs no trip goes
    -- BEFORE an area trip — done after, it cost a trip back here. At the base areas stay first.
    local onBase = (C.TaskFloor and Floor.model) and Floor:onFloor()
        or (not (C.TaskFloor and Floor.model) and loc == (C.HomeTasks and "housing" or "Neighborhood"))
    local class = {}
    for _, j in ipairs(jobs) do
        class[j] = AREA[j.need] and 1 or ((not onBase and j.here == 0) and 0 or 2)
    end
    table.sort(jobs, function(x, y)
        if class[x] ~= class[y] then return class[x] < class[y] end
        if cover[x] ~= cover[y] then return cover[x] > cover[y] end
        if x.here ~= y.here then return x.here < y.here end
        return rank(x) < rank(y)
    end)
    return jobs
end

local function doJob(job)
    local need, list = job.need, job.subjects
    local babies, pets = {}, {}
    for _, s in ipairs(list) do
        if s.kind == "baby" then babies[#babies + 1] = s else pets[#pets + 1] = s end
    end
    -- Two tasks at once (asked 2026-10-11): while this job walks, rides or sits, everyone else
    -- does their instant needs (food, drink, heal items, mysteries) — sideJobs' quick mode,
    -- leaving alone whoever is seated / in the stroller / when the baby holds a leash.
    for _, s in ipairs(pets) do
        if not wrapperOf(s.unique) then ensureOut(s.unique) break end
    end
    local quickTried = {}
    local function during(busy) sideJobs(need, quickTried, nil, busy, true) end
    -- (2026-10-12) a food / mystery job of one side only: the OTHER side's instant needs (the
    -- baby's drink while the pets eat, the pets' mystery / drink while the baby eats) run
    -- alongside instead of as the next jobs — a burst after a round was 3 jobs in a row
    local petsBusy = {}
    for _, u in ipairs(Farm:uniques()) do petsBusy[u] = true end
    local function babySide() during(petsBusy) end
    local function petSide() during({ [BABY.key] = true }) end
    if AREA[need] then
        doArea(need, list)
    elseif need == "hungry" or need == "thirsty" or need == "sick" then
        -- baby bites and pet feeding at the same time; babyBusy whenever the baby may be eating on
        -- the other thread (no crib / bath extra for it on a bowl trip home meanwhile)
        local babyEats = babies[1] ~= nil or (C.BabyFarm and (hasNeed(BABY, "hungry")
            or hasNeed(BABY, "thirsty") or hasNeed(BABY, "sick")))
        together(babies[1] and function() babyEat(need) end or babySide,
                 pets[1] and function() petsEat(pets, need, babyEats) end or petSide)
        local rest = {}
        for _, s in ipairs(list) do
            -- a pet wishing for one exact drink / food can't be cleared by a bowl: no tour
            local _, wish = Pref:of(s, need)
            if hasNeed(s, need) and (need == "sick" or (s.kind == "pet" and not wish)) then rest[#rest + 1] = s end
        end
        if #rest > 0 then doFurniture(rest, need, nil, nil, during) end    -- public bowls / the Hospital
    elseif need == "mystery" then
        -- both pets at once + the baby's quick needs alongside (2026-10-12): each mystery is 3 game
        -- calls (a frame or two each at 3-5 FPS) + the server's answer, ~1.5-3 s the 2nd pet waited
        together(babySide, function()
            together(pets[2] and function() doMystery(pets[2]) end or nil,
                     pets[1] and function() doMystery(pets[1]) end or nil)
        end)
    elseif need == "play" then
        for _, s in ipairs(pets) do petPlay(s) end
    elseif need == "walk" then
        if pets[1] then petWalk(pets, during) end
    elseif need == "ride" then
        -- farm pets that need a walk (and don't wish for a leash) come along on the ride
        local walkers = {}
        for _, s in ipairs(farmPets()) do
            local _, wish = Pref:of(s, "walk")
            local riding = false
            for _, p in ipairs(pets) do if p.key == s.key then riding = true end end
            if not riding and not wish and hasNeed(s, "walk") and not blocked(s, "walk")
               and not table.find(C.Skip, "walk") then
                walkers[#walkers + 1] = s
            end
        end
        if pets[1] then petRide(pets, walkers, during) end
        for _, s in ipairs(walkers) do
            if not hasNeed(s, "walk") then succeed(s, "walk") log(("pet walk done (with ride)")) end
        end
    elseif need == "pet_me" then
        for _, s in ipairs(pets) do petMe(s) end
    else
        doFurniture(list, need, nil, nil, during)
    end
end

local function runJob(job, cap)
    -- areas: up to 150 s + a restart trip; a ride is ~60 s of moving per pet, a walk ~60 s
    -- furniture: a trip + rolling seats (useGroup stops itself at 150 s); play: one pet after the other
    local limit = AREA[job.need] and 210 or (job.need == "ride" and 40 + 95 * #job.subjects)
        or (job.need == "walk" and 130) or (HOME_KIND[job.need] and 170)
        or (job.need == "play" and math.max(100, 30 + 55 * #job.subjects)) or 100
    if cap and cap < limit then limit = math.max(20, cap) end   -- the next Ghost Gallery round
    S.jobEnd = os.clock() + limit
    guarded(job.need, limit, doJob, job)
    S.jobEnd = nil
    for _, s in ipairs(job.subjects) do
        if hasNeed(s, job.need) then
            fail(s, job.need, "couldn't clear it")
        else
            succeed(s, job.need)
            log(("%s %s done"):format(s.kind, job.need))
        end
    end
end

------------------------------------------------------------------------------------------------
-- POTIONS — smart targets, the game's own validate() on every use
------------------------------------------------------------------------------------------------

Potion = { at = 0, fedAt = {} }

local function potionVersionOK(p)
    if C.PotionOnly == "Regular pets only" then return not p.neon and not p.mega end
    if C.PotionOnly == "Neon pets only" then return p.neon end
    return true
end

function Potion:owned()
    local d, first, n = me(), {}, {}
    for _, it in pairs(d and d.inventory.food or {}) do
        if not isLocked(it) then
            n[it.id] = (n[it.id] or 0) + 1
            first[it.id] = first[it.id] or it
        end
    end
    return first, n
end

-- The potion counter everywhere (session box, Kaitun board, Comet Track): Age-Up Potions
-- only (he asked for that 2026-10-09), locked ones included. Other kinds: Track:snap.
function Potion:total()
    local d, n = me(), 0
    for _, it in pairs(d and d.inventory.food or {}) do
        if it.id == "pet_age_potion" then n += 1 end
    end
    return n
end

-- true / false, or nil when the boost timer can't be read (helper missing after an update):
-- then a 900 s timer per pet stands in, so a stack of potions isn't fed one per tick.
local function boostRunning(p, flag)
    if not G.RMH then return nil end
    local ok, m = pcall(G.RMH.get_timed_multiplier_for_pet, p.item, flag)
    m = ok and tonumber(m)
    if not m then return nil end
    return m > 1
end

-- Why a potion can't go to `p` right now (nil = it can). Shared by the chosen-pet rule and
-- the "nothing done" messages, so the log says exactly what blocks it.
function Potion:unfit(def, p)
    if not p then return "the pet isn't in your inventory any more" end
    if def.kind == "egg" then return (not p.egg) and "it's not an egg" or nil end
    if p.egg then return "it's still an egg" end
    if p.noPotion then return "this pet can't drink potions (" .. tostring(p.name) .. ")" end
    if isLocked(p.item) then return "it's locked in the backpack" end
    if not potionVersionOK(p) then return "\"Only on\" (" .. tostring(C.PotionOnly) .. ") rules it out" end
    if def.kind == "age" then
        if p.age >= 6 then return "it's already Full Grown" end
        if def.rareOnly and p.rarity < 4 then return "the Super potion needs Ultra-Rare or better" end
    elseif def.kind == "boost" then
        if def.flag == "aging" and p.age >= 6 then return "it's already Full Grown" end
    elseif def.kind == "fly" and p.fly then return "it can already fly"
    elseif def.kind == "ride" and p.ride then return "it can already be ridden" end
    return nil
end

-- Is this timed boost already running on p (a 900 s timer stands in when it can't be read)?
function Potion:boostOn(p, def)
    local running = boostRunning(p, def.flag)
    if running == nil then running = os.clock() - (self.fedAt[p.unique .. "|" .. def.flag] or -1e9) < 900 end
    return running
end

-- Age potions: the chosen kinds, or the farm pets, or (old "smart" rule) the pet that
-- completes a neon / mega set first.
function Potion:ageTarget(def)
    local all = allPets()
    local function eligible(p)
        return not p.egg and p.age < 6 and not isLocked(p.item) and potionVersionOK(p)
           and (not def.rareOnly or p.rarity >= 4)
    end
    if C.PotionTarget == "Smart (finish neon sets, then farm pet)" then
        local grown = {}
        for _, p in ipairs(all) do
            if not p.egg and p.age >= 6 and not p.mega then
                local k = p.id .. (p.neon and "|n" or "|r")
                grown[k] = (grown[k] or 0) + 1
            end
        end
        local best
        for _, p in ipairs(all) do
            if eligible(p) and (grown[p.id .. (p.neon and "|n" or "|r")] or 0) >= 3 then
                if not best or p.age > best.age or (p.age == best.age and p.xp > best.xp) then best = p end
            end
        end
        if best then return best, "finishes a neon set" end
    end
    for _, u in ipairs(Farm:uniques()) do
        local p = petByUnique(u)
        if p and eligible(p) then return p, "farm pet" end
    end
    return nil
end

function Potion:targetFor(def)
    -- "Chosen kinds": among the pets of those kinds (any kind when the list is empty), the one
    -- closest to Full Grown first, so potions finish a pet instead of spreading. The Bonus
    -- Bucks / Aging switches of the Farm tab keep going to the farm pet (the farm's own boosts).
    if C.PotionTarget == "Chosen kinds (below)" and not (def.kind == "boost" and not C.Potion) then
        local want, named = {}, 0
        for _, label in ipairs(C.PotionKinds) do
            named += 1
            local id = Kinds:idOf(label)
            if id then want[id] = true end
        end
        if named > 0 and next(want) == nil then return nil, nil, "none of the chosen kinds is a pet you own" end
        local best, reasons, seen = nil, {}, 0
        for _, p in ipairs(allPets()) do
            if named == 0 or want[p.id] then
                seen += 1
                local why = self:unfit(def, p)
                    or (def.kind == "boost" and self:boostOn(p, def) and "that boost is still running")
                    or (blocked({ key = p.unique }, "potion:" .. def.id) and "refused a moment ago, retrying later")
                if why then reasons[why] = (reasons[why] or 0) + 1
                elseif not best or p.age > best.age or (p.age == best.age and (p.xp or 0) > (best.xp or 0)) then best = p end
            end
        end
        if best then return best, "chosen kind" end
        if seen == 0 then return nil, nil, "no pet of the chosen kinds in your inventory" end
        local parts = {}
        for why, n in pairs(reasons) do parts[#parts + 1] = n .. " × " .. why end
        table.sort(parts)
        return nil, nil, ("all %d pets of the chosen kinds are done or unfit: %s"):format(seen, table.concat(parts, ", "))
    end
    if def.kind == "age" then
        local p, why = self:ageTarget(def)
        if p then return p, why end
        -- say why nothing happens (the usual one: the farm pet is an egg or Full Grown)
        local fu = Farm:uniques()[1]
        local fp = fu and petByUnique(fu)
        return nil, nil, fp and ("farm pet " .. fp.name .. ": " .. tostring(self:unfit(def, fp)))
            or "no farm pet out (turn on Auto Farm Pet, or pick kinds under \"Use potions on\")"
    end
    if def.kind == "boost" then
        if not farming() then return nil, nil, "no farm running" end
        -- Bucks and Aging can run together (verified 2026-10-04: Aging accepted while Bucks ran;
        -- a refusal came from the pet being in the shower). Bucks comes first in POTIONS.
        for _, u in ipairs(Farm:uniques()) do
            local p = petByUnique(u)
            local running = p and boostRunning(p, def.flag)
            if running == nil and p then                              -- unreadable: 900 s timer
                if not self.warned then
                    self.warned = true
                    log("potion: can't read boost timers — feeding on a 900 s timer instead")
                end
                running = os.clock() - (self.fedAt[p.unique .. "|" .. def.flag] or -1e9) < 900
            end
            if p and not p.egg and potionVersionOK(p) and not running
               and (def.flag ~= "aging" or p.age < 6) then
                return p, "farm pet"
            end
        end
        return nil
    end
    if def.kind == "egg" then
        if not Eggs:hatching() then return nil end
        for _, u in ipairs(Farm:uniques()) do
            local p = petByUnique(u)
            if p and p.egg and not (p.hatchAt and p.xp >= p.hatchAt) then return p, "farmed egg" end
        end
        return nil
    end
    -- fly / ride: the rarest pet that doesn't have it yet
    local best
    for _, p in ipairs(allPets()) do
        local has = (def.kind == "fly" and p.fly) or (def.kind == "ride" and p.ride)
        if not p.egg and not has and not isLocked(p.item) and potionVersionOK(p) then
            if not best or p.rarity > best.rarity
               or (p.rarity == best.rarity and (p.mega and 2 or p.neon and 1 or 0) > (best.mega and 2 or best.neon and 1 or 0))
               or (p.rarity == best.rarity and p.neon == best.neon and p.mega == best.mega and p.age > best.age) then
                best = p
            end
        end
    end
    return best, "rarest without it"
end

function Potion:give(def, item, pet, why)
    if not ensureOut(pet.unique) then
        fail({ kind = "potion", key = pet.unique }, "potion:" .. def.id,
            pet.name .. " couldn't be equipped (in the pet pen? locked?)")
        return false
    end
    local w = wrapperOf(pet.unique)
    local eff = G.Pots[item.id]
    if eff and type(eff.validate) == "function" then
        local okV, can, msg = pcall(eff.validate, w, pet.item)
        if okV and can == false then
            fail({ kind = "potion", key = pet.unique }, "potion:" .. def.id, tostring(msg))
            return false
        end
    end
    setStatus(("%s -> %s (%s)"):format(def.label, pet.name, why or ""))
    local before = pet.age
    if def.kind == "age" then Farm:seeAge(pet.unique) end           -- starting age for the counter
    local t0 = os.clock()
    local fed = feedPet(pet.unique, item)
    if not fed then
        -- the server refuses a potion sent right after the previous one was drunk (seen
        -- live: every 2nd one at 0.3 s); a second try 1 s later goes through
        task.wait(1)
        fed = feedPet(pet.unique, item)
    end
    if not fed then
        fail({ kind = "potion", key = pet.unique }, "potion:" .. def.id, "server refused " .. item.id)
        return false
    end
    -- one at a time: the next potion only once this one is really drunk (it used to count
    -- the spawn as used and pile a new potion on the ground every tick)
    if not consumed(item, 8) then
        fail({ kind = "potion", key = pet.unique }, "potion:" .. def.id, pet.name .. " didn't drink it (left on the ground)")
        return false
    end
    local after = petByUnique(pet.unique)
    S.potions += 1
    if def.kind == "age" then Farm:seeAge(pet.unique) end
    if def.kind == "boost" then self.fedAt[pet.unique .. "|" .. def.flag] = os.clock() end
    local aged = def.kind == "age" and after and after.age > before
    local msg = ("%s -> %s (%s, %.1f s)"):format(def.label, pet.name,
        aged and ((AGE_NAME[before] or before) .. " -> " .. (AGE_NAME[after.age] or after.age))
            or (after and (AGE_NAME[after.age] or tostring(after.age)) or "?"),
        os.clock() - t0)
    log("potion " .. msg .. " (" .. tostring(why) .. ")")
    if aged then notify("Age up!", pet.name .. " is now " .. (AGE_NAME[after.age] or after.age)) end
    return true
end

-- The Farm tab's two boost switches work on their own, without "Auto use potions": they keep
-- a Bonus Bucks / Bonus Aging potion running on the farm pet (fed only when its boost isn't
-- running — re-feeding a running one just wastes it).
function Potion:tick()
    if not (C.Potion or C.BucksPotion or C.AgingPotion) or os.clock() - self.at < 1 then return end
    self.at = os.clock()
    local first = self:owned()
    local given = 0
    for _, def in ipairs(POTIONS) do
        local item = first[def.id]
        local wanted = (C.Potion and table.find(C.PotionTypes, def.label))
            or (C.BucksPotion and def.id == "pet_bonus_bucks_potion")
            or (C.AgingPotion and def.id == "pet_bonus_aging_potion")
        if item and wanted then
            local pet, why, none = self:targetFor(def)
            if pet and not blocked({ key = pet.unique }, "potion:" .. def.id) then
                -- one potion after another (each confirmed drunk), up to 5 per pass
                while pet and given < 5 and self:give(def, item, pet, why) do
                    given += 1
                    task.wait(1)                    -- the server refuses one sent any sooner
                    first = self:owned()
                    item = first[def.id]
                    if not item then break end
                    pet, why = self:targetFor(def)
                    if pet and blocked({ key = pet.unique }, "potion:" .. def.id) then pet = nil end
                end
                if given > 0 then return end
            elseif not pet and none then
                -- once per reason, so "auto potion does nothing" always has a line in the log
                self.noneWhy = self.noneWhy or {}
                if self.noneWhy[def.id] ~= none then
                    self.noneWhy[def.id] = none
                    log(("potion %s not used — %s"):format(def.label, none))
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------
-- NEON / MEGA
------------------------------------------------------------------------------------------------

Neon = {}

function Neon:groups()
    local kinds = {}
    for _, label in ipairs(C.NeonKinds) do
        local id = Kinds:idOf(label)
        if id then kinds[id] = true end
    end
    local anyKind = next(kinds) == nil
    local g = {}
    for _, p in ipairs(allPets()) do
        if not p.egg and p.age >= 6 and not p.mega and not Farm:has(p.unique)
           and not isLocked(p.item) and (anyKind or kinds[p.id]) then
            local ver = p.neon and "neon" or "regular"
            if (ver == "regular" and C.Neon) or (ver == "neon" and C.Mega) then
                local k = p.id .. "|" .. ver
                g[k] = g[k] or {}
                table.insert(g[k], p)
            end
        end
    end
    return g
end

function Neon:ready()
    local out = {}
    for k, list in pairs(self:groups()) do
        if #list >= 4 then out[#out + 1] = ("%s %s x%d"):format(list[1].name, k:match("|(.+)$"), #list) end
    end
    table.sort(out)
    return out
end

function Neon:fuse(list)
    local uniques = { list[1].unique, list[2].unique, list[3].unique, list[4].unique }
    local eq = equippedPets()
    for _, u in ipairs(uniques) do
        if table.find(eq, u) then fire("ToolAPI/UnequipAll") task.wait(0.8) break end
    end
    local ok, newU, kind = invoke("PetAPI/DoNeonFusion", uniques)
    if not (ok and newU) and goTo("Cave") then       -- the fusion normally happens in the Neon Cave
        ok, newU, kind = invoke("PetAPI/DoNeonFusion", uniques)
    end
    return ok and newU ~= nil, kind
end

function Neon:tick()
    -- every 5 s, not every worker loop: groups() builds a record per pet (2 000+ on big accounts)
    if not (C.Neon or C.Mega) or os.clock() - (self.at or 0) < 5 then return end
    self.at = os.clock()
    for k, list in pairs(self:groups()) do
        if #list >= 4 and not blocked({ key = k }, "fuse") then
            local mega = list[1].neon
            setStatus(("Fusing 4 %s into %s"):format(list[1].name, mega and "Mega" or "Neon"))
            local ok, kind = self:fuse(list)
            if ok then
                if mega then S.megas += 1 else S.neons += 1 end
                log(("%s made: %s"):format(mega and "MEGA" or "NEON", tostring(kind or list[1].id)))
                notify(mega and "Mega Neon!" or "Neon!", list[1].name)
            else
                fail({ key = k }, "fuse", "fusion refused for " .. list[1].name)
            end
            return   -- inventory changed, regroup next tick
        end
    end
end

------------------------------------------------------------------------------------------------
-- AUTO RELEASE — the Pet Recycler NPC (furniture kind pet_recycler) in the Nursery
------------------------------------------------------------------------------------------------

Release = { confirmAt = 0, lastAt = 0, previewAt = 0, preview = "—" }

local RARITY_LABEL = { common = "Common", uncommon = "Uncommon", rare = "Rare",
                       ultra_rare = "Ultra-Rare", legendary = "Legendary" }
local VRANK = { Regular = 1, Neon = 2, Mega = 3 }
local BATCH = 25

local function versionOf(p) return p.mega and "Mega" or (p.neon and "Neon" or "Regular") end

function Release:protected()
    local d, set = me(), {}
    for _, u in ipairs(equippedPets()) do set[u] = true end
    for _, u in ipairs(Farm:uniques()) do set[u] = true end
    for _, key in ipairs({ "Pet1", "Pet2" }) do
        local u = PetList:uniqueOf(C[key])
        if u then set[u] = true end
    end
    local pen = d and d.idle_progression_manager and d.idle_progression_manager.active_pets
    for u in pairs(pen or {}) do set[u] = true end                  -- keyed BY unique
    local prm = d and d.pet_recycler_manager
    for u in pairs(prm and prm.uniques or {}) do set[u] = true end  -- already pending
    return set
end

function Release:matches(p, protected, kinds)
    local db = G.IDB.pets[p.item.kind or p.id]
    if not db or db.is_egg or db.temporary or db.disallow_recycling then return false end
    local pr = p.item.properties or {}
    if pr.temporary or protected[p.unique] or isLocked(p.item) then return false end
    if C.ReleaseKeepFR and (pr.flyable or pr.rideable) then return false end
    if not table.find(C.ReleaseVersions, versionOf(p)) then return false end
    if #C.ReleaseAges > 0 and not table.find(C.ReleaseAges, AGE_NAME[p.age] or "") then return false end
    if C.ReleaseBy == "Kind" then return kinds[p.id] == true end
    return table.find(C.ReleaseRarities, RARITY_LABEL[db.rarity] or tostring(db.rarity)) ~= nil
end

function Release:candidates()
    if C.ReleaseBy == "Kind" and #C.ReleaseKinds == 0 then return {} end
    if C.ReleaseBy ~= "Kind" and #C.ReleaseRarities == 0 then return {} end
    local kinds = {}
    for _, label in ipairs(C.ReleaseKinds) do
        local id = Kinds:idOf(label)
        if id then kinds[id] = true end
    end
    local protected = self:protected()
    local all = allPets()
    local keep = {}
    if C.ReleaseKeep > 0 then
        local byKind = {}
        for _, p in ipairs(all) do
            if not p.egg then
                byKind[p.id] = byKind[p.id] or {}
                table.insert(byKind[p.id], p)
            end
        end
        for _, list in pairs(byKind) do
            table.sort(list, function(a, b)
                local va, vb = VRANK[versionOf(a)], VRANK[versionOf(b)]
                if va ~= vb then return va > vb end
                return a.age > b.age
            end)
            for i = 1, math.min(C.ReleaseKeep, #list) do keep[list[i].unique] = true end
        end
    end
    local out = {}
    for _, p in ipairs(all) do
        if not keep[p.unique] and self:matches(p, protected, kinds) then out[#out + 1] = p end
    end
    return out
end

function Release:value(p)
    local ok, v = pcall(G.PRC.get_pet_value, p.item)
    return ok and tonumber(v) or 0
end

function Release:summary(list)
    local tickets, byName = 0, {}
    for _, p in ipairs(list) do
        tickets += math.floor(self:value(p))       -- %d in the preview rejects fractions
        byName[p.name] = (byName[p.name] or 0) + 1
    end
    local rows = {}
    for name, n in pairs(byName) do rows[#rows + 1] = { name = name, n = n } end
    table.sort(rows, function(a, b) return a.n > b.n end)
    local top = {}
    for i = 1, math.min(5, #rows) do top[i] = ("%s x%d"):format(rows[i].name, rows[i].n) end
    return tickets, top
end

function Release:recycler()
    local ok, list = pcall(G.FMT.get_furniture_models_list)
    for _, m in ipairs(ok and list or {}) do
        if m.Parent and m:GetAttribute("furniture_kind") == "pet_recycler" then
            local ub = m:FindFirstChild("UseBlocks")
            local block = ub and ub:FindFirstChild("UseBlock")
            if block then return m, block end
        end
    end
    return nil
end

function Release:run(list)
    if #list == 0 then return 0 end
    if not goTo("Nursery") then return 0 end
    local model, block = self:recycler()
    if not model then
        task.wait(2)
        model, block = self:recycler()
    end
    if not model then log("pet recycler not found in the Nursery") return 0 end
    local set, batch = {}, {}
    for i = 1, math.min(#list, BATCH) do
        set[list[i].unique] = true
        batch[#batch + 1] = list[i]
    end
    local tickets = self:summary(batch)
    setStatus(("Releasing %d pets (~%d tickets)"):format(#batch, tickets))
    tpTo(block.Position + Vector3.new(3, -2, 3))
    task.wait(0.4)
    task.spawn(function()
        invoke("HousingAPI/ActivateInteriorFurniture", model:GetAttribute("furniture_unique"),
            block.Name, { uniques = set }, LP.Character)
    end)
    local gone, t0 = 0, os.clock()
    while os.clock() - t0 < 15 do
        gone = 0
        for _, p in ipairs(batch) do
            if not petByUnique(p.unique) then gone += 1 end
        end
        if gone == #batch then break end
        task.wait(0.5)
    end
    unseat()
    S.released = (S.released or 0) + gone
    log(("released %d/%d pets (~%d tickets on the way)"):format(gone, #batch, tickets))
    if gone > 0 then
        notify("Pets released", ("%d pets — ~%d tickets arrive in about a minute"):format(gone, tickets))
    else
        fail({ kind = "release", key = "recycler" }, "release", "the recycler took nothing")
    end
    return gone
end

function Release:collect()
    if os.clock() - (self.collectAt or 0) < 10 then return end
    self.collectAt = os.clock()
    local d = me()
    local saved = d and d.pet_recycler_manager and tonumber(d.pet_recycler_manager.saved_tickets) or 0
    if saved <= 0 then return end
    local ok, res = invoke("PetRecyclerAPI/TicketsCollected")
    if ok and res then
        S.tickets = (S.tickets or 0) + saved
        log(("collected %d recycler tickets"):format(saved))
        notify("Tickets collected", ("+%d recycler tickets"):format(saved))
    end
end

function Release:tick()
    if not C.ReleaseAuto or os.clock() - self.lastAt < 20 then return end
    if blocked({ key = "recycler" }, "release") then return end
    self.lastAt = os.clock()
    local list = self:candidates()
    if #list > 0 then self:run(list) end
end

function Release:manual()
    if not G.ready then notify("Release", "Still loading.") return end
    local list = self:candidates()
    if #list == 0 then notify("Release", "Nothing matches your filters.") return end
    if os.clock() - self.confirmAt > 6 then
        self.confirmAt = os.clock()
        local tickets = self:summary(list)
        notify("Confirm release", ("Press again within 6 s to release %d pets (~%d tickets). "
            .. "This cannot be undone."):format(#list, tickets))
        return
    end
    self.confirmAt = 0
    if Lock.held then notify("Release", "Waiting for the farm to finish its current step…") end
    Lock:run(function()
        while alive() and #list > 0 do
            local ok, n = guarded("release", 60, function() return self:run(list) end)
            if not ok or (n or 0) == 0 then break end
            list = self:candidates()
        end
    end)
end

function Release:refreshPreview()
    if os.clock() - self.previewAt < 10 then return self.preview end
    self.previewAt = os.clock()
    local list = self:candidates()
    if #list == 0 then
        self.preview = "nothing with these filters"
    else
        local tickets, top = self:summary(list)
        self.preview = ("%d pets -> ~%d tickets\n%s"):format(#list, tickets, table.concat(top, ", "))
    end
    return self.preview
end

------------------------------------------------------------------------------------------------
-- TRADING LICENSE — the Safety Hub quiz, answered from the quiz's own data
------------------------------------------------------------------------------------------------

License = { running = false }

function License:has()
    local ok, r = pcall(G.TLH.player_has_trade_license)
    return ok and r == true
end

function License:get()
    if not G.ready then notify("License", "Still loading.") return end
    if self:has() then notify("License", "You already have a trading license.") return end
    if self.running then return end
    self.running = true
    if Lock.held then notify("License", "Waiting for the farm to finish its current step…") end
    Lock:run(function()
        guarded("license", 120, function()
            local rep = G.API:FindFirstChild("TradeAPI/QuizAnswerReported")
            local last
            local conn = rep and rep.OnClientEvent:Connect(function(correct, finished)
                last = { correct = correct, finished = finished }
            end)
            for _ = 1, 3 do
                if self:has() then break end
                if not goTo("TradeLicenseZone") then notify("License", "Couldn't reach the license room.") break end
                task.wait(1.5)
                fire("TradeAPI/BeginQuiz")
                local w = 0
                while not G.CD.get("trade_license_quiz_manager") and w < 8 do w += task.wait(0.25) end
                local done = false
                for _ = 1, 12 do
                    local qm = G.CD.get("trade_license_quiz_manager")
                    local q = qm and qm.quiz and qm.quiz[qm.question_index]
                    if not q then break end
                    setStatus(("License quiz: question %d/%d"):format(qm.question_index, #qm.quiz))
                    last = nil
                    task.wait(1)
                    fire("TradeAPI/AnswerQuizQuestion", q.answer)
                    local t = 0
                    while not last and t < 8 do t += task.wait(0.2) end
                    if not (last and last.correct) then break end
                    if last.finished then done = true break end
                end
                if done then
                    local t = 0
                    while not self:has() and t < 8 do t += task.wait(0.5) end
                    break
                end
            end
            if conn then conn:Disconnect() end
        end)
        if self:has() then
            log("trading license obtained")
            notify("Trading license", "Done — you can trade now.")
        else
            notify("Trading license", "Didn't get it this time — check the log.")
        end
        goBase()
    end)
    self.running = false
end

------------------------------------------------------------------------------------------------
-- PAY — send bucks by buying a player's mannequin outfit (the game caps it at $100)
------------------------------------------------------------------------------------------------

Pay = { confirmAt = 0, autoAt = 0, last = "—" }

local function findPlayer(name)
    name = tostring(name or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == name or p.DisplayName:lower() == name then return p end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then return p end
    end
    return nil
end

-- Mannequins loaded right now that belong to `owner`, best price first.
function Pay:mannequins(owner)
    local out = {}
    for _, fm in ipairs(CollectionService:GetTagged("FurnitureMannequin")) do
        local m = fm:FindFirstChild("Mannequin")
        local o = m and m:FindFirstChild("Owner")
        if m and o and o.Value == owner then
            out[#out + 1] = {
                id = fm:GetAttribute("furniture_unique"), model = fm,
                version = m:GetAttribute("outfit_version"),
                price = tonumber(m:GetAttribute("price")) or 0,
                forSale = m:GetAttribute("for_sale") == true,
            }
        end
    end
    table.sort(out, function(a, b) return a.price > b.price end)
    return out
end

-- The copy you get from a buy blocks buying the same version again: remove it.
function Pay:dropCopy(version)
    local ok, list = pcall(G.CD.get, "outfits")
    for _, o in pairs(ok and list or {}) do
        if type(o) == "table" and o.source_outfit_version == version then
            fire("AvatarAPI/DeleteOutfit", "player", o.name, nil)
            task.wait(0.5)
            return true
        end
    end
    return false
end

-- Pays `owner` up to `amount` bucks. Returns what was spent and why it stopped.
function Pay:send(owner, amount)
    if owner == LP then return 0, "you can't pay yourself" end
    if not goTo("housing", owner) then return 0, "couldn't enter " .. owner.Name .. "'s house" end
    local m, t = nil, 0
    while t < 10 do
        for _, x in ipairs(self:mannequins(owner)) do
            if x.forSale and x.price > 0 then m = x break end
        end
        if m then break end
        t += task.wait(0.5)
    end
    if not m then return 0, owner.Name .. " has no mannequin on sale" end
    local spent, why = 0, "done"
    while alive() and spent + m.price <= amount do
        if bucks() < m.price then why = "out of bucks" break end
        self:dropCopy(m.version)
        setStatus(("Paying %s: $%d / $%d"):format(owner.Name, spent, amount))
        local before = bucks()
        local ok, res = invoke("AvatarAPI/BuyMannequinOutfit", owner, m.id, m.version, m.price)
        task.wait(0.8)
        local paid = before - bucks()
        if not (ok and res) or paid <= 0 then why = "the buy was refused (" .. tostring(ok and res) .. ")" break end
        spent += paid
        S.paid += paid
        self:dropCopy(m.version)
        -- the owner may have changed the outfit or price meanwhile
        local fresh = self:mannequins(owner)
        for _, x in ipairs(fresh) do if x.id == m.id then m = x end end
        if not m.forSale or m.price <= 0 then why = "their mannequin went off sale" break end
        task.wait(0.4)
    end
    if spent + m.price > amount and why == "done" and spent < amount then
        why = ("the rest ($%d) is under one buy ($%d)"):format(amount - spent, m.price)
    end
    return spent, why
end

function Pay:run(amount)
    local owner = findPlayer(C.PayTo)
    if not owner then notify("Pay", "\"" .. tostring(C.PayTo) .. "\" isn't in this server.") return end
    local spent, why = 0, "?"
    guarded("pay", 180, function() spent, why = self:send(owner, amount) end)
    self.last = ("Paid %s $%d — %s"):format(owner.Name, spent, why)
    log(self.last)
    notify("Pay", self.last)
end

function Pay:manual()
    if not G.ready then notify("Pay", "Still loading.") return end
    if C.PayAmount <= 0 then notify("Pay", "Set an amount first.") return end
    local owner = findPlayer(C.PayTo)
    if not owner then notify("Pay", "\"" .. tostring(C.PayTo) .. "\" isn't in this server.") return end
    if os.clock() - self.confirmAt > 6 then
        self.confirmAt = os.clock()
        notify("Confirm payment", ("Press again within 6 s to send up to $%d to %s."):format(C.PayAmount, owner.Name))
        return
    end
    self.confirmAt = 0
    if Lock.held then notify("Pay", "Waiting for the farm to finish its current step…") end
    Lock:run(function()
        self:run(C.PayAmount)
        goBase()
    end)
end

-- Worker hook: auto pay everything above "Keep for myself", checked every minute.
function Pay:tick()
    if not C.PayAuto or os.clock() - self.autoAt < 60 then return end
    self.autoAt = os.clock()
    local spare = bucks() - C.PayKeep
    if spare < 100 or not findPlayer(C.PayTo) then return end
    self:run(spare)
end

-- Receiving account: every mannequin in YOUR house goes on sale at $100.
function Pay:sellMine()
    if not G.ready then notify("Pay", "Still loading.") return end
    Lock:run(function()
        if not goTo("housing") then notify("Pay", "Couldn't get home.") return end
        task.wait(2)
        local list = self:mannequins(LP)
        if #list == 0 then
            notify("Pay", "No mannequin in your house. Buy one ($750, furniture \"Mannequin\") and place it.")
            return
        end
        local n = 0
        for _, m in ipairs(list) do
            local ub = m.model:FindFirstChild("UseBlocks")
            local block
            for _, b in ipairs(ub and ub:GetChildren() or {}) do
                if b:IsA("BasePart") then block = b break end
            end
            if block and m.id then
                tpTo(block.Position + Vector3.new(3, -2, 3))
                task.wait(0.4)
                invoke("HousingAPI/ActivateFurniture", LP, m.id, block.Name, { set_price = true, price = 100 }, LP.Character)
                task.wait(1.5)
                local fresh = self:mannequins(LP)
                for _, x in ipairs(fresh) do
                    if x.id == m.id and x.forSale and x.price == 100 then n += 1 end
                end
            end
        end
        notify("Pay", n > 0 and ("%d mannequin(s) on sale at $100 — others can pay you now."):format(n)
            or "The game didn't accept the price (outfits with exclusive items can't be sold).")
    end)
end

------------------------------------------------------------------------------------------------
-- TRADE — send pets to a player: N pets per trade, M trades
--
--   TradeAPI/SendTradeRequest(player) → the partner accepts → TradeApp's local state
--   ({current_stage, sender, recipient, sender_offer, recipient_offer}) appears →
--   AddItemToOffer(unique) per pet (18 slots max, SharedConstants.max_trade_offer_slots) →
--   AcceptNegotiation, then ConfirmTrade. Each stage has a lock countdown and pressing during
--   it restarts it (verified on house trades): so wait the lock out, refresh the lock UI, and
--   press every 4 s; the state going away = the trade ended. Our own negotiated/confirmed
--   flags are set optimistically by the client, so they're never trusted.
------------------------------------------------------------------------------------------------

Trade = { running = false, stop = false, confirmAt = 0, last = "—", pets = 0, trades = 0 }
local TRADE_SLOTS = 18

function Trade:app() return G.UIM and G.UIM.apps.TradeApp end

function Trade:state()
    local TA = self:app()
    if not TA then return nil end
    local ok, st = pcall(function() return TA:_get_local_trade_state() end)
    return ok and type(st) == "table" and st or nil
end

-- Pets of the chosen kind you can give: never locked, out, farmed, picked, in the pen or
-- pending release. Youngest first, so the grown ones stay.
function Trade:candidates()
    local kid = Kinds:idOf(C.TradeKind)
    if not kid then return {} end
    local protected = Release:protected()
    local out = {}
    for _, p in ipairs(allPets()) do
        if p.id == kid and not p.egg and not protected[p.unique] and not isLocked(p.item)
           and (C.TradeVersion == "Any" or versionOf(p) == C.TradeVersion) then
            out[#out + 1] = p
        end
    end
    table.sort(out, function(a, b)
        if a.age ~= b.age then return a.age < b.age end
        return a.unique < b.unique
    end)
    return out
end

-- One trade with `partner` giving `batch`. Returns how many pets actually left you.
function Trade:once(partner, batch)
    if self:state() then fire("TradeAPI/DeclineTrade") task.wait(1) end     -- an old one open
    fire("TradeAPI/SendTradeRequest", partner)
    setStatus(("Trade: waiting for %s to accept"):format(partner.Name))
    local t0 = os.clock()
    while not self:state() and os.clock() - t0 < 30 and not self.stop do task.wait(0.5) end
    if not self:state() then return 0, partner.Name .. " didn't accept the trade" end
    setStatus(("Trade: adding %d pet(s)"):format(#batch))
    for _, p in ipairs(batch) do
        if self.stop or not self:state() then break end
        fire("TradeAPI/AddItemToOffer", p.unique)
        task.wait(0.35)
    end
    task.wait(5.5)                                   -- sit out the negotiation lock first
    local t1 = os.clock()
    while self:state() and not self.stop and os.clock() - t1 < 120 do
        local st = self:state()
        local TA = self:app()
        G.asGame(function() TA:_refresh_lock_related_ui() end)
        if st.current_stage == "confirmation" then
            setStatus("Trade: confirming")
            fire("TradeAPI/ConfirmTrade")
        else
            setStatus("Trade: accepting (waiting for " .. partner.Name .. ")")
            fire("TradeAPI/AcceptNegotiation")
        end
        task.wait(4)
    end
    if self:state() then
        fire("TradeAPI/DeclineTrade")
        return 0, self.stop and "stopped" or "the trade didn't finish in 2 min"
    end
    task.wait(1.5)
    local gone = 0
    for _, p in ipairs(batch) do if not petByUnique(p.unique) then gone += 1 end end
    return gone, gone > 0 and "done" or "the trade was cancelled"
end

function Trade:run()
    local partner = findPlayer(C.TradeTo)
    if not partner or partner == LP then return "\"" .. tostring(C.TradeTo) .. "\" isn't in this server" end
    if not License:has() then return "you need a trading license first (button above)" end
    local per = math.clamp(math.floor(C.TradePer or 1), 1, TRADE_SLOTS)
    local why = "done"
    for n = 1, math.max(1, C.TradeTimes or 1) do
        if self.stop then why = "stopped" break end
        local list = self:candidates()
        if #list == 0 then why = "no more matching pets" break end
        local batch = {}
        for i = 1, math.min(per, #list) do batch[i] = list[i] end
        local gone, res = self:once(partner, batch)
        self.pets += gone
        if gone > 0 then self.trades += 1 end
        self.last = ("Trade %d/%d with %s: %d pet(s) — %s"):format(n, C.TradeTimes, partner.Name, gone, res)
        log(self.last)
        if gone == 0 then why = res break end
        task.wait(3)
    end
    return why
end

function Trade:manual()
    if not G.ready then notify("Trade", "Still loading.") return end
    if self.running then notify("Trade", "Already trading — press Stop first.") return end
    local partner = findPlayer(C.TradeTo)
    if not partner then notify("Trade", "\"" .. tostring(C.TradeTo) .. "\" isn't in this server.") return end
    local have = #self:candidates()
    if have == 0 then notify("Trade", "No matching pet to give (pick a pet and version).") return end
    local total = math.min(have, (C.TradePer or 1) * (C.TradeTimes or 1))
    if os.clock() - self.confirmAt > 6 then
        self.confirmAt = os.clock()
        notify("Confirm trade", ("Press again within 6 s to give %s up to %d x %s in %d trade(s). This can't be undone.")
            :format(partner.Name, total, tostring(C.TradeKind), C.TradeTimes))
        return
    end
    self.confirmAt, self.running, self.stop = 0, true, false
    if Lock.held then notify("Trade", "Waiting for the farm to finish its current step…") end
    Lock:run(function()
        local why = "?"
        guarded("trade", 60 + 150 * math.max(1, C.TradeTimes or 1), function() why = self:run() end)
        notify("Trade", ("Gave %d pet(s) in %d trade(s) — %s"):format(self.pets, self.trades, tostring(why)))
    end)
    self.running = false
end

-- Trade off: the game's own setting, SettingsAPI/SetSetting("trade_requests", index) —
-- 1 Everyone, 2 Friends, 3 No One (SettingsDB dropdown values are indexes).
function Trade:applyOff()
    fire("SettingsAPI/SetSetting", "trade_requests", C.TradeOff and 3 or 1)
    log("trade requests: " .. (C.TradeOff and "nobody" or "everyone"))
end

------------------------------------------------------------------------------------------------
-- POPUPS — the $10 playtime cheque, promo windows, the age-up banner, party prompts
--
--   The cheque (PlaytimePayoutsApp) is what CASH OUT does: PayAPI/Collect, and with "do not
--   show again" ticked PayAPI/DisablePopups — after which the game banks every payout by
--   itself (PlaytimePayoutsClientService). Verified: +$10, window gone.
------------------------------------------------------------------------------------------------

Popups = { patched = false }
local PROMO_APPS = { "EventPopupApp", "MerchPopUpApp", "NewSpotlightApp", "SubscriptionsPopUpApp",
                     "ExperimentalNewsApp", "PartyInvitationApp", "StickerRewardsApp",
                     "LikesRewardApp", "StarRewardsApp" }

local function appOpen(name)
    local ok, closed = pcall(G.UIM.is_closed, { name })
    return ok and closed == false
end

-- The minigame invite ("Ghost Gallery is starting soon! Teleport there now?") comes from
-- MinigameJoinPopups through DialogApp:queue_with_override, which returns (promise, resolver);
-- "Yes" makes the game itself enter_smooth to the join zone. Answered without showing it.
Popups.INVITE = "is starting soon! Teleport there now?"
-- empty (2026-10-12): the game may keep the hint's handle to close it, and our nil return could break
-- its queue client — the queue hint is only a small banner
Popups.HINT_WORDS = {}

-- Prompts answered "no" for you: adoption parties, "add as friend" after a trade. The
-- minigame invite is answered by Hallo:inviteAnswer (Yes when the hub plays that round).
function Popups:patch(on)
    local DA = G.UIM and G.UIM.apps.DialogApp
    if not DA then return end
    if on and not self.patched then
        local orig, origQ = DA.dialog, DA.queue_with_override
        self.own, self.ownQ = rawget(DA, "dialog"), rawget(DA, "queue_with_override")
        DA.dialog = function(this, opts, ...)
            if not alive() then return orig(this, opts, ...) end
            if C.NoPopups and type(opts) == "table" then
                local text = tostring(opts.text or ""):lower()
                -- Halloween: "ARE YOU AFRAID OF SPIDERS?" at spawn (SpawnSequenceHelper: a return of 1
                -- turns arachnophobia mode on) — 2 keeps the game's default and marks it seen
                if opts.dialog_type == "ArachnophobiaModeDialog" then return 2 end
                if text:find("adoption party", 1, true) or opts.dialog_type == "FriendAfterTradeDialog"
                   or (text:find("you caught a", 1, true) and text:find("throw a party", 1, true)) then
                    return opts.left or "No"
                end
            end
            return orig(this, opts, ...)
        end
        -- minigame hints ("You are in the queue for the Ghost Gallery Minigame.") are dropped
        local HA = G.UIM.apps.HintApp
        if HA and HA.hint then
            local origH = HA.hint
            self.ownH = rawget(HA, "hint")
            HA.hint = function(this, opts, ...)
                if alive() and C.NoPopups and type(opts) == "table" then
                    local text = tostring(opts.text or ""):lower()
                    for _, word in ipairs(Popups.HINT_WORDS) do
                        if text:find(word, 1, true) then return end
                    end
                end
                return origH(this, opts, ...)
            end
        end
        DA.queue_with_override = function(this, opts, ...)
            if alive() and type(opts) == "table" and tostring(opts.text or ""):find(Popups.INVITE, 1, true) then
                local okA, answer = pcall(function() return Hallo:inviteAnswer(opts.text) end)
                local okP, Promise = pcall(G.load, "package:Promise")
                if not (okA and answer) and C.NoPopups then okA, answer = true, "No" end   -- not a round we play
                if okA and answer and okP and Promise then
                    return Promise.resolve(answer, false), function() end
                end
            end
            return origQ(this, opts, ...)
        end
        self.patched = true
    elseif not on and self.patched then
        rawset(DA, "dialog", self.own)
        rawset(DA, "queue_with_override", self.ownQ)
        local HA = G.UIM.apps.HintApp
        if HA then rawset(HA, "hint", self.ownH) end
        self.patched = false
    end
end

function Popups:apply()
    if C.NoPopups then
        fire("PayAPI/Collect")              -- bank a cheque already waiting
        fire("PayAPI/DisablePopups")        -- and let the game bank the next ones silently
    end
    self:patch(true)                        -- each hook checks its own option when it fires
    self:tick()
end

-- Screens that stop FocusPetApp from opening (its can_display() is false while they're up),
-- so pet_me fails after a minigame. The results screen is closed the way its NICE! button
-- does (close_display), once its button takes a press (2.5 s) — never hidden: a hidden app
-- answers nothing the game may wait on. The others only once no round is running.
Popups.BLOCKERS = { "MinigameNewsPaperApp", "JackboxRewardApp" }
function Popups:clearBlockers(force)
    if not G.UIM then return end
    local RA = G.UIM.apps.MinigameRewardsApp
    if RA and appOpen("MinigameRewardsApp") then
        self.rewardsAt = self.rewardsAt or os.clock()
        -- its close is the one display() handed it (the round's exit waits on it): only once set
        local ready = type(rawget(RA, "close_display_function")) == "function"
        if ready and (force or os.clock() - self.rewardsAt > 2.5) and os.clock() - (self.rewardsTry or 0) > 2 then
            self.rewardsTry = os.clock()
            G.asGame(function() RA:close_display() end)
        end
        -- never ready for a whole minute, no round on: hidden once (a hide skips that close, so not
        -- while a round may still wait on it)
        if not ready and os.clock() - self.rewardsAt > 60 and not (Hallo and Hallo.active) and not self.rewardsHid then
            self.rewardsHid = true
            G.asGame(G.UIM.set_app_visibility, "MinigameRewardsApp", false)
        end
    else
        self.rewardsAt, self.rewardsHid = nil, nil
    end
    if Hallo and Hallo.active then return end
    self.blockAt = self.blockAt or {}
    for _, name in ipairs(Popups.BLOCKERS) do
        local app = G.UIM.apps[name]
        if app and appOpen(name) then
            self.blockAt[name] = self.blockAt[name] or os.clock()
            local held = os.clock() - self.blockAt[name]
            if type(app.close_display) == "function" then
                if force or held > 2.5 then Popups.close(name, function() app:close_display() end) end
            elseif held > 15 then
                Popups.close(name, function() G.UIM.set_app_visibility(name, false) end)
            end
        else
            self.blockAt[name] = nil
        end
    end
end

-- Every second from the status loop.
-- A close on its own thread, at most 3 tries per 30 s: an app that won't close used to hold the
-- status loop for up to 10 s every second (G.asGame), for hours.
function Popups.close(name, fn)
    Popups.asks = Popups.asks or {}
    local a = Popups.asks[name] or { n = 0, at = 0 }
    Popups.asks[name] = a
    if a.busy and os.clock() - (a.busyAt or 0) < 300 then return end
    if os.clock() < (a.waitUntil or 0) then return end
    if a.n >= 3 and os.clock() - a.at < 30 then return end
    if os.clock() - a.at >= 30 then a.n = 0 end
    a.n, a.at, a.busy, a.busyAt = a.n + 1, os.clock(), true, os.clock()
    task.spawn(function()
        local _, err = G.asGame(fn)
        -- a close that never answered: its thread is parked — that app again in 10 min, not every 10 s
        if err == "timeout" then a.waitUntil = os.clock() + 600 return end
        a.busy = false
    end)
end
-- The game's full-screen celebration screens — a pet aging up in the pen, a new pet, an
-- achievement — blur everything and take the camera and the controls until their button is
-- pressed: on a farm nobody watches, that's forever (2026-10-12: "after a while the screen goes
-- white"). Closed the way their own button does, 4 s after they open.
Popups.SCREENS = { "PetLevelUpApp", "PetDiscoveryApp", "AchievementsApp" }

function Popups:tick()
    if not G.UIM then return end
    if not self.patched then pcall(self.patch, self, true) end      -- DialogApp loads late on some joins
    if C.NoPopups or (C.HwOn and (C.HwGhost or C.HwHaunt)) then pcall(self.clearBlockers, self) end
    -- the join screen (NewsApp) showing again after boot (a rejoin, an autoexec): Play, never a hide —
    -- the spawn sequence waits on its button
    local news = G.UIM.apps.NewsApp
    if news and news.cont and news.instance and news.instance.Enabled and appOpen("NewsApp") then
        Popups.close("NewsApp", function() news.cont.continue() end)
    end
    self.screenAt = self.screenAt or {}
    for _, name in ipairs(Popups.SCREENS) do
        if appOpen(name) then
            self.screenAt[name] = self.screenAt[name] or os.clock()
            if os.clock() - self.screenAt[name] > 4 then
                Popups.close(name, function() G.UIM.set_app_visibility(name, false) end)
            end
        else
            self.screenAt[name] = nil
            -- seen closed: the next one (several pen pets aging up at once) gets its own tries
            local a = Popups.asks and Popups.asks[name]
            if a and not a.busy then Popups.asks[name] = nil end
        end
    end
    if not C.NoPopups then return end
    if appOpen("PlaytimePayoutsApp") then
        Popups.close("PlaytimePayoutsApp", function()
            G.UIM.set_app_visibility("PlaytimePayoutsApp", false)
            fire("PayAPI/Collect")
            fire("PayAPI/DisablePopups")
        end)
    end
    for _, name in ipairs(PROMO_APPS) do
        if appOpen(name) then Popups.close(name, function() G.UIM.set_app_visibility(name, false) end) end
    end
    -- the big "Pre-Teen" / "Full Grown" banner is a SurfaceGui on a Part in PlayerGui
    local part = LP.PlayerGui:FindFirstChild("Part")
    local sg = part and part:FindFirstChildWhichIsA("SurfaceGui")
    if sg and sg.Enabled and sg:FindFirstChild("AgeBar", true) then sg.Enabled = false end
end

------------------------------------------------------------------------------------------------
-- HALLOWEEN 2026 — candy: Ghost Gallery minigame, crypt keys, stray cat, dailies
--
--   Read from the live client (2026-10-04, ContentPacks.Halloween2026 + the replicated
--   GhostClustersMinigameServer). Currency = ClientData candy_2026 (daily cap 250 000).
--   · Pet needs on your OWN equipped pet pay 200 candy each — the normal farm does that.
--   · Ghost Gallery ("ghost_clusters"): a public round every 600 s at
--     ClientData ghost_clusters_cycle_timestamp. Stand in the ring
--     Interiors.HauntedManor.GhostClustersMinigameJoinZone.Collider before it starts and the
--     game queues + joins you itself (verified: join_accepted → join_minigame → enter_game).
--     In the round: MinigameAPI/MessageServer(inst.minigame_id, "start_contribute",
--     {ghost_id, use_token}) resent every 0.4 s (the server drops you after 2 s), one ghost at
--     a time, server checks FLAT distance only (Small 28.6, Medium 35.1, anything 84.5 once
--     the boss is out). Verified: nearest ghost first, walking → score 100 100 = +5000 candy
--     (the cap) + a crypt key for the boss. Leaving early forfeits everything; the game takes
--     you back to the manor at the end.
--   · Crypt: one rusty key per coffin; CryptClient.unlock_padlock_async(floor, slot) inside
--     "TheCrypt" (no distance check), 1000/2000/3000 candy coffins, a ladder per floor, the
--     server re-equips the next key itself. Verified: +1000 per candy coffin. The Tomb Spider
--     (floor 5) resets the run — only claimed once every candy coffin is open.
--   · Stray cat: one food per 600 s cycle, StrayCatNet.GiftFood {unique} within 20 studs of
--     Interiors["MainMap!Halloween"].Event.Halloween.StrayCat.Position. Verified: +50 candy.
--   · Dailies: DailiesNetService.try_to_claim_daily_rewards("halloween_2026") → a key per
--     finished daily (verified); try_to_claim_tab_reward after 3 → a 4th key.
--   Not touched: the Candy Corn Pile (needs a Robux gamepass, its ring opens a purchase).
------------------------------------------------------------------------------------------------

-- Teleport tab: any place in one tap. dest = an interior (the game's own door trip), spot =
-- a TeleportLocations marker on the main map (instant TP). Holds the lock like any manual
-- button, never during a minigame round, and pauses the farm for 3 min (Teleport tab toggle)
-- so the next task doesn't walk you straight back.
function Floor.teleport(dest, spot, label)
    if Hallo:inRound() then notify("Teleport", "Not during a minigame round.") return end
    Lock:run(function()
        setStatus("Teleport: " .. tostring(label))
        S.tpPauseUntil = C.TpPause and (os.clock() + 180) or nil
        local ok = true
        if dest then ok = goTo(dest) end
        if ok and spot then
            if location() ~= "MainMap" then ok = goTo("MainMap") end
            local tl = Workspace:FindFirstChild("StaticMap") and Workspace.StaticMap:FindFirstChild("TeleportLocations")
            local p = tl and tl:FindFirstChild(spot)
            if ok and p then tpTo(p.Position) elseif ok then ok = false end
        end
        log(("teleport to %s: %s"):format((tostring(label):gsub("^%S+%s+", "")), ok and "done" or "failed"))
        if not ok then notify("Teleport", "Couldn't get there — try again in a moment.") end
    end)
end

Hallo = { busy = false, dailyAt = 0, catAt = 0, cryptAt = 0, last = "—", rounds = 0,
          roundCandy = 0, keysUsed = 0, catFeeds = 0, cryptSkip = {} }
Hallo.KEY = "halloween_2026_rusty_key"
-- Seconds before a round we head for its queue ring. Was 45 (the game's own invite time): one
-- slow trip and the round was gone (reported 2026-10-10 "doesn't join sometimes"); 75 leaves
-- room for a 2nd trip and a 2nd try at the ring.
Hallo.LEAD = 75

function Hallo:mods()
    -- kept once the minigame manager is in; else tried again at most once a minute (a first
    -- load that failed used to leave the watchdog off for the whole session)
    if self.M and (self.M.MCM or os.clock() - (self.modsAt or 0) < 60) then return self.M end
    self.modsAt = os.clock()
    local M = {}
    local function try(name, fn) local ok, v = pcall(fn) if ok then M[name] = v end end
    try("MCM", function() return G.load("MinigameClientManager") end)
    try("CTM", function() return G.load("ClientToolManager") end)
    try("Daily", function() return require(RS.new.modules.Dailies.DailiesNetService) end)
    local okB, base = pcall(function() return RS.SharedModules.ContentPacks.Halloween2026.Game end)
    if okB and base then
        try("Crypt", function() return require(base.TheCrypt.CryptClient) end)
        try("CatNet", function() return require(base.StrayCat.StrayCatNet) end)
        try("CatC", function() return require(base.StrayCat.StrayCatConstants) end)
        try("GhostR", function() return require(base.GhostClusters.GhostClustersGhostRenderer) end)
        try("PropR", function() return require(base.GhostClusters.GhostClustersPropRenderer) end)
    end
    self.M = M
    return M
end

-- Event window from SharedConstants.festival_event.
function Hallo:live()
    local ok, SC = pcall(require, RS.ClientDB.SharedConstants)
    local fe = ok and SC and SC.festival_event
    local now = Workspace:GetServerTimeNow()
    if type(fe) ~= "table" then return true end
    return now >= (tonumber(fe.start_time) or 0) and now < (tonumber(fe.finish_time) or math.huge)
end

function Hallo:candy() return balance("candy_2026") end

-- How many pets you own (a count — allPets() builds a record per pet, 2 000+ on big accounts).
function Farm.petCount()
    local d, n = me(), 0
    for _ in pairs(d and d.inventory.pets or {}) do n += 1 end
    return n
end

-- Session maps that only ever grew (food held back, retry waits, parked wishes, pen refusals,
-- missing picks, age-ups seen): trimmed every 10 min.
function Farm.prune()
    if os.clock() - (Farm.prunedAt or 0) < 600 then return end
    Farm.prunedAt = os.clock()
    local now = os.clock()
    for k, t in pairs(foodTaken) do if now - t > 60 then foodTaken[k] = nil end end
    for k, t in pairs(backoff) do if t < now - 600 then backoff[k], streak[k] = nil, nil end end
    if type(Pref.parkedNeeds) == "table" then
        for k, t in pairs(Pref.parkedNeeds) do if type(t) == "number" and t < now then Pref.parkedNeeds[k] = nil end end
    end
    if now - (Pref.triedAt or 0) > 3600 then Pref.triedGeneric, Pref.triedAt = {}, now end
    if Farm.Pen and type(Farm.Pen.refused) == "table" then
        for k, t in pairs(Farm.Pen.refused) do if type(t) == "number" and now - t > 600 then Farm.Pen.refused[k] = nil end end
    end
    if type(PetList) == "table" and type(PetList.missing) == "table" then
        for k, t in pairs(PetList.missing) do if type(t) == "number" and now - t > 60 then PetList.missing[k] = nil end end
    end
    for u in pairs(S.ageSeen or {}) do if not Farm:has(u) then S.ageSeen[u] = nil end end
end

-- Seconds until the event ends (SharedConstants.festival_event.finish_time; math.huge = unknown).
function Hallo:endsIn()
    local ok, SC = pcall(require, RS.ClientDB.SharedConstants)
    local fe = ok and SC and SC.festival_event
    local fin = type(fe) == "table" and tonumber(fe.finish_time)
    return fin and (fin - Workspace:GetServerTimeNow()) or math.huge
end

function Hallo:keys()
    local d, n, first = me(), 0, nil
    for _, it in pairs(d and d.inventory.toys or {}) do
        if (it.id or it.kind) == Hallo.KEY then n += 1 first = first or it end
    end
    return n, first
end

-- Next Ghost Gallery start (server time) and seconds to it.
function Hallo:nextRound()
    local ok, v = pcall(G.CD.get, "ghost_clusters_cycle_timestamp")
    local T = ok and type(v) == "table" and tonumber(v.timestamp) or nil
    return T, T and (T - Workspace:GetServerTimeNow()) or math.huge
end

-- Next Hauntlet start (ClientData hauntlet_cycle_timestamp; 1200 s cycle, 600 s off the
-- Ghost Gallery — read live 2026-10-09).
function Hallo:nextHaunt()
    local ok, v = pcall(G.CD.get, "hauntlet_cycle_timestamp")
    local T = ok and type(v) == "table" and tonumber(v.timestamp) or nil
    return T, T and (T - Workspace:GetServerTimeNow()) or math.huge
end

function Hallo:plays() return C.HwOn and C.HwGhost and self:live() and os.clock() >= (self.capUntil or 0) end

-- True while the game has us inside a Ghost Gallery / Hauntlet round: no trips then (a teleport
-- inside a round is what the game punishes, and a cut round step must not send us home).
function Hallo:inRound()
    local M = self.M
    if not (M and M.MCM) then return false end
    for _, id in ipairs({ "ghost_clusters", "hauntlet" }) do
        local ok, mg = pcall(M.MCM.get, id)
        local inst = ok and mg and mg.instanced_minigame
        if inst and inst.is_participating then return true end
    end
    return false
end

-- A server call that may never answer: at most `secs` seconds, then (false, "timeout").
function Hallo.call(secs, fn, ...)
    local args = table.pack(...)
    local done, ok, res = false, false, nil
    task.spawn(function()
        ok, res = pcall(fn, table.unpack(args, 1, args.n))
        done = true
    end)
    local w = 0
    while not done and w < secs do w += task.wait(0.2) end
    if not done then return false, "timeout" end
    return ok, res
end

-- WHITE SCREEN (reported 2026-10-11: "the screen goes white and stays; Reset asks 'Do you want
-- to exit this game?' and Exit does nothing"). Read in the game: entering a round, the
-- minigame client fades PlayerGui.TransitionsApp.Whiteout to opaque WHITE, switches team, makes
-- its own InteriorsM trip and fades back only after that trip returns. A trip that never
-- returns (a 2nd trip at once, the trip lock freed under it, no character) leaves the screen
-- white with the client "participating"; the server's leave_game is queued behind that dead
-- step in the instance's interior_promise_queue, so Exit (AttemptJoin false) can't land.
-- Hallo:watch (every second, the jamWatch thread) frees such a round the game's own way.

-- The transition screen is opaque (white, or the black of a cutscene).
function Hallo.whiteout()
    local pg = LP:FindFirstChild("PlayerGui")
    local tr = pg and pg:FindFirstChild("TransitionsApp")
    local w = tr and tr:FindFirstChild("Whiteout")
    return w ~= nil and w.Visible and w.BackgroundTransparency < 0.05 and not (tr:IsA("LayerCollector") and not tr.Enabled)
end

-- A camera left away from you for 15 s (a pet_me focus, a closed screen that didn't give it
-- back) with no round, no trip and no fade: back behind your character.
function Hallo.camWatch()
    local cam = Workspace.CurrentCamera
    local _, hrp, hum = char()
    -- an app that owns the camera right now (petting, a celebration screen not closed yet)
    local appCam = appOpen("FocusPetApp")
    for _, name in ipairs(Popups and Popups.SCREENS or {}) do if appOpen(name) then appCam = true end end
    local off = cam and hrp and hum and not Hallo.active and not Hallo.whiteout()
        and not (G.IM and G.IM.entering)
        and ((cam.CameraType == Enum.CameraType.Scriptable and not appCam)
            or ((cam.CameraType ~= Enum.CameraType.Custom or cam.CameraSubject ~= hum)
                and (cam.CFrame.Position - hrp.Position).Magnitude > 150))
    if not off then Hallo.camAt = nil return end
    Hallo.camAt = Hallo.camAt or os.clock()
    if os.clock() - Hallo.camAt < 15 then return end
    Hallo.camAt = nil
    local FPA = G.UIM and G.UIM.apps.FocusPetApp
    if FPA then G.asGame(function() FPA:release_focus() end) end
    cam.CameraType, cam.CameraSubject = Enum.CameraType.Custom, hum
    log("the camera was left away from you — put back behind the character")
end

-- The game's own fade back (TransitionsApp:transition), its lock cleared first.
function Hallo.fadeBack(why)
    local T = G.UIM and G.UIM.apps.TransitionsApp
    if not T then return end
    log("the screen was left on a transition (" .. tostring(why) .. ") — faded back")
    G.asGame(function()
        pcall(T.force_unlock, T)
        local ok = pcall(T.transition, T, { start_transparency = 0, end_transparency = 1, length = 0.4, yields = false })
        if not ok then pcall(T.sudden_fill_off, T) end
    end)
end

-- Out of a round the client can't leave: the dead step dropped (PromiseQueue:cancel), then the
-- instance's own leave_game_msg — exactly what the server's "leave_game" runs: exit sequence,
-- team back, pets back, fade back. The trip lock is freed first (the way out is a trip too).
function Hallo:freeRound(mg, why, noUnstick)
    if self.fixing then return false end
    self.fixing, self.fixingAt = true, os.clock()
    local q = rawget(mg, "interior_promise_queue")
    log(("%s: stuck in its round (%s) — leaving it the game's way [trip=%s char=%s team=%s]"):format(
        tostring(rawget(mg, "minigame_id") or "minigame"), tostring(why), tostring(G.IM and G.IM.entering),
        tostring(LP.Character ~= nil), tostring(team())))
    -- no character: the game's trip waits for one (it respawns only from Reset, which a
    -- "participating" client swallows). Spawned FIRST, the way the game's Reset does — if the
    -- round then gets in by itself, nothing else is touched
    if not LP.Character then
        invoke("TeamAPI/Spawn")
        log("respawned the character")
        local w = 0
        while w < 20 and not (LP.Character and not (G.IM and G.IM.entering)) do w += task.wait(0.5) end
        local h0 = type(q) == "table" and rawget(q, "current_promise")
        local okS, st = false, nil
        if h0 then okS, st = pcall(function() return h0:getStatus() end) end
        if not (okS and st == "Started") then self.fixing = false return true end
    end
    -- the trip lock only when it has really been held a long time (a live trip is not ours to free)
    if not noUnstick and G.IM and G.IM.entering and self.enterSince and os.clock() - self.enterSince > 60 then pcall(unstickTravel) end
    G.asGame(function()
        if type(q) == "table" and type(q.cancel) == "function" then q:cancel() end
        if rawget(mg, "is_participating") and type(mg.leave_game_msg) == "function" then mg:leave_game_msg({}) end
    end)
    local w = 0
    while w < 20 and (Hallo.whiteout() or (G.IM and G.IM.entering)) do w += task.wait(0.5) end
    if Hallo.whiteout() and not (G.IM and G.IM.entering) then Hallo.fadeBack("after leaving the round") end
    -- still "participating" (the leave errored): cleared the way the scaler's own leave does,
    -- so the game's Reset works again and the farm isn't held by it
    if rawget(mg, "is_participating") == true then
        rawset(mg, "is_participating", false)
        local okSc, sc = pcall(function() return self.M.MCM.get(rawget(mg, "static_minigame_id") or "") end)
        if okSc and type(sc) == "table" and rawget(sc, "is_participating") == true then rawset(sc, "is_participating", false) end
        log("cleared the finished round on this client")
    end
    task.wait(2)
    self.fixing = false
    return true
end

-- Every second: Hallo.active (queued for / in / leaving a round — the void catcher, the trip
-- lock watcher, the popup closer and the player hider keep off), Hallo.playing (in a round),
-- and the stuck-round watchdog: a participating minigame whose queue step hasn't moved for
-- 45 s on a white screen it never got past (150 s otherwise) is freed; a transition screen
-- left opaque 20 s with no round and no trip is faded back.
function Hallo:watch()
    local M = self.M
    if self.fixing and os.clock() - (self.fixingAt or 0) > 90 then self.fixing = false end
    if not (M and M.MCM) then
        -- the minigame modules load with the first Halloween step; with Halloween off, 30 s in,
        -- then once a minute until they're there
        self.watchFrom = self.watchFrom or os.clock()
        if os.clock() - self.watchFrom > 30 and os.clock() - (self.modsAt or -1e9) > 60 then
            G.asGame(function() Hallo:mods() end)
        end
        self.active, self.playing = false, false
        -- a screen left opaque needs no module to be faded back
        if Hallo.whiteout() and not (G.IM and G.IM.entering) then
            self.whiteAt = self.whiteAt or os.clock()
            if os.clock() - self.whiteAt > 20 then self.whiteAt = nil Hallo.fadeBack("no round, no trip") end
        else
            self.whiteAt = nil
        end
        return
    end
    local okA, all = pcall(M.MCM.get_all)
    local active, playing, now = false, false, os.clock()
    local white = Hallo.whiteout()
    self.heads = self.heads or {}
    if G.IM and G.IM.entering then self.enterSince = self.enterSince or now else self.enterSince = nil end
    for id, mg in pairs(okA and type(all) == "table" and all or {}) do
        if type(mg) == "table" then
            local part = rawget(mg, "is_participating") == true
            if part or rawget(mg, "instanced_minigame") ~= nil then active = true end
            if part then playing = true end
            -- a round instance still held long after its end (2 min past end_time, or 30 min):
            -- left the game's way, then dropped — it kept every trip refused and the farm waiting
            local inst = rawget(mg, "instanced_minigame")
            self.instSeen = self.instSeen or {}
            if type(inst) == "table" then
                local seen = self.instSeen[id]
                if not seen or seen.inst ~= inst then seen = { inst = inst, at = now } self.instSeen[id] = seen end
                -- counted only while the client is quiet (no fade, no trip): a slow but healthy exit at
                -- low FPS is never cut; end_time is the Ghost Gallery's (the Hauntlet's isn't its end)
                local quiet = not white and not (G.IM and G.IM.entering)
                seen.quietAt = quiet and (seen.quietAt or now) or nil
                local endT = id == "ghost_clusters" and tonumber(rawget(inst, "end_time")) or nil
                local stale = seen.quietAt and now - seen.quietAt > 30
                    and ((endT and Workspace:GetServerTimeNow() > endT + 120) or now - seen.at > 1800)
                if stale and not self.fixing and not Hallo.busy then
                    self.instSeen[id] = nil
                    task.spawn(function()
                        pcall(self.freeRound, self, inst, "the round ended long ago", true)
                        if rawget(mg, "instanced_minigame") == inst then rawset(mg, "instanced_minigame", nil) end
                    end)
                end
            else
                self.instSeen[id] = nil
            end
            local q = rawget(mg, "interior_promise_queue")
            local head = type(q) == "table" and rawget(q, "current_promise")
            local okS, st = false, nil
            if head then okS, st = pcall(function() return head:getStatus() end) end
            if part and rawget(mg, "instanced_minigame") == nil and okS and st == "Started" then
                local rec = self.heads[id]
                if not rec or rec.head ~= head then rec = { head = head, at = now } self.heads[id] = rec end
                local neverIn = rawget(mg, "ingame_app_controller") == nil
                local limit = (white and neverIn) and 45 or 150
                -- a trip still running with a character is slow (3 FPS), not dead
                if G.IM and G.IM.entering and LP.Character then limit = 180 end
                if now - rec.at > limit and not self.fixing then
                    self.heads[id] = nil
                    local why = (white and neverIn) and "white screen, never got in" or "its queue stopped moving"
                    task.spawn(function() pcall(self.freeRound, self, mg, why) end)
                end
            elseif part and rawget(mg, "instanced_minigame") == nil then
                -- participating, no round and no queue moving (a leave that errored, a cancelled
                -- queue): nothing else frees it and the farm waits 900 s. 300 s: a real queue starts
                -- well before that (seen: 75 s)
                local rec = self.heads[id]
                if not rec or rec.head ~= "none" then rec = { head = "none", at = now } self.heads[id] = rec end
                if now - rec.at > 300 and not self.fixing and not Hallo.busy and not (G.IM and G.IM.entering) then
                    self.heads[id] = nil
                    task.spawn(function() pcall(self.freeRound, self, mg, "participating, nothing running") end)
                end
            else
                self.heads[id] = nil
            end
        end
    end
    self.active, self.playing = active, playing
    if white and not playing and not (G.IM and G.IM.entering) and not self.fixing then
        self.whiteAt = self.whiteAt or now
        if now - self.whiteAt > (active and 60 or 20) then self.whiteAt = nil Hallo.fadeBack("no round, no trip") end
    else
        self.whiteAt = nil
    end
end

-- The Fix button (Halloween tab): whatever holds the screen, the game's own ways out.
function Hallo:fixScreen()
    pcall(self.mods, self)
    local fixed = false
    local M = self.M
    local okA, all = false, nil
    if M and M.MCM then okA, all = pcall(M.MCM.get_all) end
    for _, mg in pairs(okA and type(all) == "table" and all or {}) do
        if type(mg) == "table" and rawget(mg, "is_participating") == true and rawget(mg, "instanced_minigame") == nil
           and (Hallo.whiteout() or not self.busy) then
            fixed = self:freeRound(mg, "the Fix button") or fixed
        end
    end
    if not fixed then
        if G.IM and G.IM.entering and self.enterSince and os.clock() - self.enterSince > 30 then
            pcall(unstickTravel) fixed = true
        end
        if Hallo.whiteout() then Hallo.fadeBack("the Fix button") fixed = true end
        if not LP.Character then invoke("TeamAPI/Spawn") fixed = true end
    end
    -- the game's celebration screens (pet aged up, new pet, achievement) hold the camera too
    for _, name in ipairs(Popups and Popups.SCREENS or {}) do
        local okO, closed = pcall(G.UIM.is_closed, { name })
        if okO and closed == false then G.asGame(G.UIM.set_app_visibility, name, false) fixed = true end
    end
    pcall(function()
        local cam = Workspace.CurrentCamera
        local _, _, hum = char()
        if cam and hum and (cam.CameraType ~= Enum.CameraType.Custom or cam.CameraSubject ~= hum) then
            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum
            fixed = true
        end
    end)
    return fixed
end

-- Until the minigame client has finished ITS exit (results, fade, trip back): nobody
-- participating, no round instance left, no trip, no opaque fade. False after `secs`.
function Hallo.waitExit(id, secs)
    local w = 0
    while w < secs do
        local busy = (G.IM and G.IM.entering) or Hallo.whiteout()
        local MCM = Hallo.M and Hallo.M.MCM
        if MCM and not busy then
            local okA, all = pcall(MCM.get_all)
            for _, mg in pairs(okA and type(all) == "table" and all or {}) do
                if type(mg) == "table" and rawget(mg, "is_participating") == true then busy = true end
            end
            local okG, sc = pcall(MCM.get, id)
            if okG and type(sc) == "table" and sc.instanced_minigame then busy = true end
        end
        if not busy then return true end
        w += task.wait(0.5)
    end
    return false
end
function Hallo:playsH() return C.HwOn and C.HwHaunt and self:live() end

-- Seconds to the next round of any minigame we play (math.huge = none).
function Hallo:nextEvent()
    local left = math.huge
    local function use(v) if v >= -1 then left = math.min(left, v) end end   -- a past start: stale data
    if self:plays() then use(select(2, self:nextRound())) end
    if self:playsH() then use(select(2, self:nextHaunt())) end
    return left
end

-- True when a round we will play starts within `secs` (+ the Hallo.LEAD s we need to queue).
function Hallo:roundSoon(secs)
    return self:nextEvent() < (secs or 0) + Hallo.LEAD
end

-- Seconds any step may still take before we must leave to queue (math.huge = no round).
function Hallo:budget()
    local left = self:nextEvent()
    return left == math.huge and math.huge or left - Hallo.LEAD - 10
end

-- The game's own "<minigame> is starting soon! Teleport there now?" invite (45 s before the
-- round): always "No" for a round we play (nil = shown as usual for one we don't). Hallo:join
-- goes to the queue ring by itself at T-75; "Yes" made the game run ITS trip (enter_smooth: a
-- white fade, then InteriorsM.enter) next to ours, and two trips at once jam InteriorsM — a
-- jammed trip under that fade was the white screen that never went away (2026-10-11).
function Hallo:inviteAnswer(text)
    text = tostring(text)
    local ghost = C.HwOn and C.HwGhost and Hallo:live() and text:find("Ghost Gallery", 1, true)
    local haunt = Hallo:playsH() and text:lower():find("hauntlet", 1, true)
    if not (ghost or haunt) then return nil end
    return "No"
end

------------------------------------------------------------------------------------------------
-- Dailies → keys
------------------------------------------------------------------------------------------------

function Hallo:dailies()
    -- the daily quests are claimed by Farm.Claims (every tab, Halloween or not): nothing left here
    if Farm and Farm.Claims then return end
    if not C.HwDailies or os.clock() - self.dailyAt < 45 then return end
    self.dailyAt = os.clock()
    local M = self:mods()
    local d = me()
    local tabs = d and d.dailies_manager and d.dailies_manager.serialized_tabs
    if not (type(tabs) == "table" and M.Daily) then return end
    local before = self:keys()
    -- every tab the game shows (halloween_2026 = crypt keys; vanilla, 2d_tuesdays, admin_abuse…
    -- have their own rewards); "alerts" is the lure's, left alone
    self.tabAt = self.tabAt or {}
    for name, tab in pairs(tabs) do
        if type(tab) == "table" and name ~= "alerts" and name ~= "tutorial" then
            local any = false
            for _, v in pairs(tab.active_dailies or {}) do
                local st = type(v) == "table" and v.state
                if st and (tonumber(st.steps_completed) or 0) >= (tonumber(st.steps_to_complete) or math.huge) then any = true end
            end
            if any then Hallo.call(10, M.Daily.try_to_claim_daily_rewards, name) task.wait(1.2) end
            local fresh = (me().dailies_manager.serialized_tabs or {})[name] or tab
            if (tonumber(fresh.total_dailies_completed_today) or 0) >= 3 and not fresh.reward_claimed
               and os.clock() > (self.tabAt[name] or 0) then
                self.tabAt[name] = os.clock() + 600                 -- a refused claim isn't retried every 45 s
                Hallo.call(10, M.Daily.try_to_claim_tab_reward, name)
                if name ~= "halloween_2026" then log("Dailies: claimed the " .. name .. " tab reward") end
                task.wait(1.2)
            end
        end
    end
    local after = self:keys()
    if after > before then log(("Halloween: +%d crypt key(s) from dailies"):format(after - before)) end
end

------------------------------------------------------------------------------------------------
-- Crypt — keys into candy
------------------------------------------------------------------------------------------------

-- Unopened coffins worth a key now: candy first (biggest first), twigs if wanted (and still
-- grantable: max_collectable is a lifetime cap counted in reward_counts), then the current
-- floor's ladder once its candy is gone. Second value: the current floor.
function Hallo:cryptTargets()
    local cm = me() and me().halloween_2026_crypt_manager
    if type(cm) ~= "table" or type(cm.floors) ~= "table" then return {}, 0 end
    local opened = {}
    for _, k in pairs(cm.opened or {}) do opened[tonumber(k)] = true end
    local counts = type(cm.reward_counts) == "table" and cm.reward_counts or {}
    -- the Jacobin Pigeon picked in the shop list = its 8 twigs are wanted too
    local wantTwigs = C.HwTwigs
    for _, o in ipairs(C.HwPets or {}) do
        if tostring(o):find("Jacobin Pigeon", 1, true) == 1 then wantTwigs = true end
    end
    local f = #cm.floors
    if (self.cryptFloors or 0) > f then self.cryptSkip = {} end   -- spider claimed: new run
    self.cryptFloors = f
    local list, ladder, candyLeftOnTop = {}, nil, false
    for fl = 1, f do
        local floor = cm.floors[fl]
        local rewards = floor and floor.rewards or {}
        for slot, id in pairs(floor and floor.coffins or {}) do
            slot = tonumber(slot)
            local key = slot and fl * 16 + slot
            if slot and not opened[key] and not self.cryptSkip[key] then
                if id == "ladder" then
                    if fl == f then ladder = { floor = fl, slot = slot, value = -1 } end
                else
                    local r = rewards[id] or {}
                    local twig = tostring(r.kind or id):find("twig") ~= nil
                    local cap = tonumber(r.max_collectable)
                    local capped = cap ~= nil and (tonumber(counts[id]) or 0) >= cap
                    -- the Lightning Lever (puts the Skelicorn on sale) before any candy
                    local lever = tostring(r.kind or id):find("lightning_lever") ~= nil
                    if not capped and (not twig or wantTwigs) then
                        list[#list + 1] = { floor = fl, slot = slot, value = twig and 1
                            or (lever and C.HwLever and 9999) or (tonumber(r.amount) or 0), lever = lever }
                        if fl == f and not twig then candyLeftOnTop = true end
                    end
                end
            end
        end
    end
    table.sort(list, function(a, b) return a.value > b.value end)
    if ladder and not candyLeftOnTop then list[#list + 1] = ladder end
    return list, f
end

function Hallo:crypt()
    if not C.HwCrypt or os.clock() - self.cryptAt < 20 then return end
    self.cryptAt = os.clock()
    local M = self:mods()
    if not M.Crypt or self:budget() < 40 then return end
    local n = self:keys()
    local cm = me() and me().halloween_2026_crypt_manager
    local finalRoom = type(cm) == "table" and type(cm.floors) == "table" and cm.floors[5] ~= nil
    local targets = self:cryptTargets()
    -- the free Tomb Spider ends the run: only once every coffin we want on floors 1-4 is open
    local spider = finalRoom and C.HwSpider and #targets == 0
    if not spider and (n == 0 or #targets == 0) then return end
    self.busy = true
    setStatus("Halloween: opening crypt coffins")
    local tf0 = travelFails
    if not goTo("TheCrypt") then
        -- the crypt not letting us in (seen 2026-10-11 on 2 alts, again every 20 s) made three
        -- failed trips = a server hop for an optional step: leave it alone for 10 min instead
        self.busy = false
        self.cryptAt = os.clock() + 600
        travelFails = tf0
        if Floor.failsTo then Floor.failsTo.TheCrypt = 0 end
        log("Halloween: the crypt didn't let us in — trying again in 10 min")
        return
    end
    task.wait(1)
    for _ = 1, 30 do
        if not alive() or self:budget() < 15 then break end
        cm = me().halloween_2026_crypt_manager
        targets = self:cryptTargets()
        if C.HwSpider and type(cm) == "table" and cm.floors and cm.floors[5] and #targets == 0 then
            local ok, res = Hallo.call(10, M.Crypt.claim_tomb_spider_async)
            local claimed = ok and type(res) == "table" and res.ok
            log("Halloween: tomb spider " .. tostring(claimed and "claimed — new crypt run"
                or (ok and type(res) == "table" and res.reason or res)))
            if not claimed then self.cryptAt = os.clock() + 300 break end
            task.wait(1.5)
            self.cryptSkip = {}                       -- new run: new coffins in the same slots
            targets = self:cryptTargets()
        end
        local keys, key = self:keys()
        local t = targets[1]
        if keys == 0 or not t then break end
        if M.CTM and not M.CTM.is_kind_equipped({ category = "toys", kind = Hallo.KEY }) then
            pcall(M.CTM.equip, key)
            task.wait(0.6)
        end
        local ok, res = Hallo.call(10, M.Crypt.unlock_padlock_async, t.floor, t.slot)
        if ok and type(res) == "table" and res.ok then
            self.keysUsed += 1
            log(("Halloween: coffin %d-%d opened (%s)"):format(t.floor, t.slot,
                t.lever and "lightning lever" or t.value > 1 and (t.value .. " candy") or (t.value == -1 and "ladder" or t.value == 1 and "twig" or "an item")))
        else
            local why = ok and type(res) == "table" and tostring(res.reason) or tostring(res)
            log("Halloween: coffin refused — " .. why)
            if why == "reward_unavailable" or why == "already_opened" then
                self.cryptSkip[t.floor * 16 + t.slot] = true      -- don't pick it again
            elseif why ~= "no_key_equipped" then
                self.cryptAt = os.clock() + 300               -- unknown refusal: not every 20 s
                break
            end
        end
        task.wait(0.35)
    end
    if self:budget() > 45 then goBase() end           -- near a round, ghostRound goes from here
    self.busy = false
end

------------------------------------------------------------------------------------------------
-- Stray cat — one cheap food per 600 s cycle
------------------------------------------------------------------------------------------------

-- A cheap cat food you own (≤ $15, never event or limited food), else buy the cheapest
-- priced drink / snack the shops sell and use that.
function Hallo:catFood()
    local M = self:mods()
    local function scan()
        local d, best, bestCost = me(), nil, nil
        for _, it in pairs(d and d.inventory.food or {}) do
            local kind = it.id or it.kind
            local e = G.IDB.food[kind]
            local okC, isFood = pcall(M.CatC.is_cat_food, kind)
            if e and okC and isFood and not e.currency_id and kind ~= "halloween_2026_polymorphing_cat_food"
               and not isLocked(it) and not G.Pots[kind] and os.clock() - (foodTaken[it.unique] or -1e9) > 20 then
                local c = tonumber(e.cost) or 999
                if c <= 15 and (not best or c < bestCost) then best, bestCost = it, c end
            end
        end
        return best
    end
    local food = scan()
    if food or not C.AutoBuyFood then return food end
    for _, need in ipairs({ "thirsty", "hungry" }) do
        local id = cheapestShopFood(need, "pet")
        local e = id and G.IDB.food[id]
        if e and (tonumber(e.cost) or 999) <= 15 then
            local ok, res = invoke("ShopAPI/BuyItem", "food", id, { buy_count = 3 })
            if ok and (res == "success" or res == true) then task.wait(1) return scan() end
            refusedFood[id] = true
        end
    end
    return nil
end

function Hallo:cat()
    if not C.HwCat or os.clock() - self.catAt < 30 then return end
    self.catAt = os.clock()
    local M = self:mods()
    if not (M.CatNet and M.CatC) or self:budget() < 30 then return end
    local okC, cycle = pcall(M.CatC.current_cycle_number)
    local cat = me() and me().halloween_2026_stray_cat_manager
    if not okC or type(cat) ~= "table" or cat.last_fed_cycle == cycle then return end
    local food = self:catFood()
    if not food then self.catAt = os.clock() + 120 return end
    self.busy = true
    setStatus("Halloween: feeding the stray cat")
    if location() ~= "MainMap" then goTo("MainMap") end
    local function findMark()
        local map = Workspace.Interiors:FindFirstChild("MainMap!Halloween")
        local ev = map and map:FindFirstChild("Event")
        local hw = ev and ev:FindFirstChild("Halloween")
        local sc = hw and hw:FindFirstChild("StrayCat")
        return sc and sc:FindFirstChild("Position")
    end
    -- the cat's marker streams out when you're far away: go where it was and it comes back
    local mark = findMark()
    if not mark and self.catPos then tpTo(self.catPos + Vector3.new(0, 0, 3)) end
    for _ = 1, 16 do
        mark = mark or findMark()
        if mark then break end
        task.wait(0.5)
    end
    if mark then
        self.catPos = mark.Position
        local ok, res
        for try = 1, 2 do                                 -- "too_far": the server hadn't seen the tp yet
            tpTo(mark.Position + Vector3.new(0, 0, 3))
            task.wait(try == 1 and 1.2 or 2.5)
            -- the server call can hang with no answer: give it 8 s, never the whole 260 s step
            local done = false
            task.spawn(function()
                local a, b = pcall(M.CatNet.GiftFood.invoke_server_async, M.CatNet.GiftFood, { unique = food.unique })
                ok, res, done = a, b, true
            end)
            local w = 0
            while not done and w < 8 do w += task.wait(0.2) end
            if not done then ok, res = true, { reason = "no answer from the server" } end
            if not (ok and type(res) == "table" and res.reason == "too_far") then break end
        end
        if ok and type(res) == "table" and res.ok then
            self.catFeeds += 1
            log(("Halloween: fed the stray cat (+%s candy)"):format(tostring(res.amount)))
        else
            log("Halloween: cat refused — " .. tostring(ok and type(res) == "table" and res.reason or res))
            self.catAt = os.clock() + 120                      -- don't walk back every 30 s
        end
    else
        log("Halloween: stray cat not found on the map")
        self.catAt = os.clock() + 120
    end
    self.busy = false
    if C.TaskFloor and Floor.model and self:budget() > 20 then goFloor() end   -- don't idle by the cat
end

------------------------------------------------------------------------------------------------
-- Ghost Gallery round
------------------------------------------------------------------------------------------------

function Hallo.flat(a, b) return Vector3.new(a.X - b.X, 0, a.Z - b.Z).Magnitude end

-- Range the server accepts (flat) and where we like to stand (outside tornado reach).
Hallo.RANGE = { Small = 28.6, Medium = 35.1, Large = 84.5 }
Hallo.STAND = { Small = 22, Medium = 28, Large = 60 }
Hallo.SIDES = { 0, 70, -70, 140, -140 }

-- Ghosts we may vacuum now. Position = the visual model's pivot (what the verified
-- 100 100-score run used); the renderer's gameplay CFrame only as a fallback.
function Hallo:ghosts()
    local out, bossOut, shieldUp = {}, false, false
    local vis = Workspace:FindFirstChild("GhostClustersVisuals")
    local M = self:mods()
    for _, g in ipairs(vis and vis:GetChildren() or {}) do
        if g:GetAttribute("GhostClustersSize") == "Large" then
            bossOut = true
            if g:GetAttribute("GhostClustersShielded") then shieldUp = true end
        end
    end
    for _, g in ipairs(vis and vis:GetChildren() or {}) do
        local id = g:GetAttribute("GhostClustersId")
        local size = g:GetAttribute("GhostClustersSize")
        if id and not g:GetAttribute("GhostClustersOrbiting")
           and not (size == "Large" and g:GetAttribute("GhostClustersShielded")) then
            local okP, pivot = pcall(g.GetPivot, g)
            local pos = okP and pivot.Position or nil
            if not pos and M.GhostR then
                local okR, cf = pcall(M.GhostR.get_gameplay_cframe, id)
                if okR and typeof(cf) == "CFrame" then pos = cf.Position end
            end
            if pos then
                out[#out + 1] = { id = id, size = size, pos = pos,
                                  mass = tonumber(g:GetAttribute("GhostClustersCombineMass")) or 1,
                                  shield = g:GetAttribute("GhostClustersIsShield") == true }
            end
        end
    end
    return out, bossOut, shieldUp
end

-- Nearest first (no walking = no idle drain time); shield ghosts first while the boss is
-- shielded, the boss itself once it can be drained; mass only breaks near-ties.
function Hallo:pickGhost(list, hrp, bossOut, shieldUp)
    local best, bestScore
    local skip, now = self.skip or {}, os.clock()
    for _, g in ipairs(list) do
        local d = Hallo.flat(g.pos, hrp.Position)
        local range = bossOut and Hallo.RANGE.Large or (Hallo.RANGE[g.size] or 28.6)
        local s = -d
        if d <= range then s += 100 end
        if shieldUp and g.shield then s += 400 end
        if bossOut and not shieldUp and g.size == "Large" then s += 300 end
        s += g.mass * 2
        if (skip[g.id] or 0) > now and d > range then s -= 1000 end   -- couldn't reach it just now
        if not bestScore or s > bestScore then best, bestScore = g, s end
    end
    return best
end

-- Walking in the round (never a teleport — MovementLeakyBucket): a straight MoveTo while
-- we keep moving; stuck for 0.8 s (stairs, rails, a wall between — seen live 2026-10-04:
-- 8 s pinned with the target 67 studs away) → jump and ask PathfindingService for a way
-- round, then follow its waypoints. Returns how long we've been stuck on this goal.
-- key = the target (ghost id / prop): a new target starts fresh, the same target drifting
-- keeps its stuck clock. Only real movement resets the clock, so "stuck 5 s" can fire.
function Hallo:walkTo(hum, hrp, goal, key)
    local now, nav = os.clock(), self.nav
    goal = Vector3.new(goal.X, hrp.Position.Y, goal.Z)
    if not nav or nav.key ~= key then
        nav = { key = key, goal = goal, last = hrp.Position, movedAt = now, gen = 0 }
        self.nav = nav
    elseif Hallo.flat(nav.goal, goal) > 8 then                    -- drifted: drop the stale route
        nav.goal, nav.wp, nav.gen = goal, nil, nav.gen + 1
    end
    if hum.Sit or hum.PlatformStand then
        hum.Sit, hum.PlatformStand = false, false
        nav.movedAt = now
    end
    if Hallo.flat(hrp.Position, nav.last) > 1.5 then nav.last, nav.movedAt = hrp.Position, now end
    local wp = nav.wp and nav.wp[nav.i]
    if wp and Hallo.flat(wp.Position, hrp.Position) < 3.5 then
        nav.i += 1
        wp = nav.wp[nav.i]
    end
    if wp then
        if wp.Action == Enum.PathWaypointAction.Jump then hum.Jump = true end
        hum:MoveTo(wp.Position)
        if now - math.max(nav.movedAt, nav.wpAt or 0) > 2.5 then nav.wp = nil end   -- route didn't help
        return now - nav.movedAt
    end
    nav.wp = nil
    if now - nav.movedAt > 0.8 then
        hum.Jump = true
        if G.PFS and not nav.computing and now - (nav.pathAt or 0) > 1.5 then
            nav.computing, nav.pathAt = true, now
            local from, gen = hrp.Position, nav.gen
            task.spawn(function()
                local okP, path = pcall(function()
                    local p = G.PFS:CreatePath({ AgentRadius = 2.5, AgentHeight = 5, AgentCanJump = true, WaypointSpacing = 6 })
                    p:ComputeAsync(from, goal)
                    return p
                end)
                if okP and path and path.Status == Enum.PathStatus.Success and self.nav == nav and nav.gen == gen then
                    nav.wp, nav.i, nav.wpAt = path:GetWaypoints(), 2, os.clock()   -- movedAt untouched
                end
                nav.computing = false
            end)
        end
    end
    hum:MoveTo(goal)
    return now - nav.movedAt
end

-- Into a round's queue ring, trying again until the start: a trip that failed, a ring still
-- streaming in or a queue that didn't take us each used to cost the whole round. Returns the
-- ring's collider once the game has us queued, nil when the start went by.
function Hallo:join(id, interior, zoneName, spotName, T, label)
    local M = self:mods()
    local function left() return T - Workspace:GetServerTimeNow() end
    local tl = Workspace:FindFirstChild("StaticMap") and Workspace.StaticMap:FindFirstChild("TeleportLocations")
    local spot = tl and tl:FindFirstChild(spotName)
    -- we answered Yes to the invite: the game is taking us there, don't start a 2nd trip
    if os.clock() - (self.inviteAt or -1e9) < 20 then
        local w = 0
        repeat w += task.wait(0.25)
        until (not G.IM.entering and (location() == interior or w > 12)) or w > 40
    end
    local tries = 0
    while alive() and left() > 1 do
        tries += 1
        if location() ~= interior then
            setStatus(("Halloween: going to the %s queue (starts in %ds)"):format(label, math.max(0, math.floor(left()))))
            if G.IM.entering then
                local w = 0
                while G.IM.entering and w < 15 do w += task.wait(0.25) end
            end
            if location() ~= interior then goTo(interior, nil, spot and { spawn_cframe = spot.CFrame } or nil) end
        end
        local zone
        for _ = 1, 16 do
            local room = Workspace:FindFirstChild("Interiors") and Workspace.Interiors:FindFirstChild(interior)
            zone = room and room:FindFirstChild(zoneName)
            if zone or left() <= 1 then break end
            task.wait(0.5)
        end
        local col = zone and (zone:FindFirstChild("Collider", true) or (zone:IsA("BasePart") and zone)
            or zone:FindFirstChildWhichIsA("BasePart", true))
        if col then
            -- stand in the ring (again every 2 s: a respawn or a shove puts us out of it)
            local mg, t0, placed = nil, os.clock(), -1e9
            repeat
                local _, hrp = char()
                if hrp and os.clock() - placed > 2 then
                    placed = os.clock()
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.CFrame = CFrame.new(col.Position + Vector3.new(0, 3, 0))
                end
                task.wait(0.2)
                mg = M.MCM.get(id)
            until (mg and mg.is_queued) or os.clock() - t0 > 8 or left() <= 1 or not alive()
            if mg and mg.is_queued then
                if tries > 1 then log(("%s: queued on try %d"):format(label, tries)) end
                return col
            end
            log(label .. ": not in the queue yet — trying again")
        elseif location() == interior then
            log(label .. ": queue ring not found — trying again")
        end
        task.wait(0.5)
    end
    log(label .. ": missed the start (" .. tries .. " tries)")
    return nil
end

-- The status line in minigames counts down live (it used to freeze on the number it had when a
-- wait began — asked 2026-10-11: "timer don't break"). Only written when the text changes.
function Hallo.say(text)
    if text ~= S.status then Hallo.said = text setStatus(text) end
end

-- The wait in the queue ring (~60 s a round, 6 rounds an hour): food / drink / heal items and
-- mysteries meanwhile — nothing that moves us, and never in the last 30 s before the start.
function Hallo:queueTasks(tl)
    if tl < 30 or os.clock() - (self.qAt or 0) < 4 then return end
    self.qAt = os.clock()
    if os.clock() - (self.qReset or 0) > 120 then self.qTried, self.qReset = {}, os.clock() end
    guarded("queue tasks", math.min(15, tl - 15), sideJobs, nil, self.qTried, nil, nil, true)
end

function Hallo:ghostRound()
    local M = self:mods()
    if not (M.MCM and self:live()) then return end
    local T, left = self:nextRound()
    if not T or left > Hallo.LEAD or left < -1 then return end
    self.busy = true
    local startCandy = self:candy()
    setStatus(("Halloween: queueing for Ghost Gallery (starts in %ds)"):format(math.max(0, math.floor(left))))
    -- 1) the manor, right at the queue ring (the game's own return call), retried until the start
    local col = self:join("ghost_clusters", "HauntedManor", "GhostClustersMinigameJoinZone", "ghost_clusters", T, "Ghost Gallery")
    if not col then self.busy = false return end
    local _, hrp, hum = char()
    local mg
    setStatus(("Halloween: in the Ghost Gallery queue (starts in %ds)"):format(
        math.max(0, math.floor(T - Workspace:GetServerTimeNow()))))
    -- 2) the game joins us at T and moves us in; the round times arrive with enter_game
    local inst
    -- 2026-10-12: past T+30 only while the game is still taking us in (participating / its trip
    -- running — a 3-5 FPS client can be that slow): giving up there could leave us in a round we
    -- don't play, with a farm trip started on top of the game's own
    while alive() and Workspace:GetServerTimeNow() < T + (((type(mg) == "table" and rawget(mg, "is_participating") == true)
        or (G.IM and G.IM.entering)) and 90 or 30) do
        mg = M.MCM.get("ghost_clusters")
        inst = mg and mg.instanced_minigame
        if inst and inst.is_participating and tonumber(inst.intermission_end_time) then break end
        local tl = T - Workspace:GetServerTimeNow()
        Hallo.say(tl > 0 and ("Halloween: in the Ghost Gallery queue — starts in %ds"):format(math.ceil(tl))
            or "Halloween: Ghost Gallery — joining the round…")
        Hallo:queueTasks(tl)
        if not inst then                                   -- stay in the ring until we're in
            _, hrp = char()
            if hrp and col.Parent and Hallo.flat(hrp.Position, col.Position) > 10
               and Workspace:GetServerTimeNow() < T - 1 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(col.Position + Vector3.new(0, 3, 0))
            end
        end
        task.wait(0.25)
    end
    if not (inst and inst.is_participating and tonumber(inst.intermission_end_time)) then
        log("Halloween: wasn't let into the round")
        self.busy = false
        return
    end
    local mid = inst.minigame_id
    local remote = G.API:FindFirstChild("MinigameAPI/MessageServer")
    local retarget
    local conn = G.API["MinigameAPI/MessageClient"].OnClientEvent:Connect(function(_, msg, a)
        if msg == "ghost_clusters_retarget" then retarget = a end
    end)
    -- a round cut short (guard, error) left its listener live on every minigame message: the
    -- next round drops it
    if Hallo.roundConn and Hallo.roundConn ~= conn then pcall(function() Hallo.roundConn:Disconnect() end) end
    Hallo.roundConn = conn
    while alive() and Workspace:GetServerTimeNow() < tonumber(inst.intermission_end_time) do
        Hallo.say(("Halloween: Ghost Gallery — starts in %ds"):format(
            math.max(0, math.ceil(tonumber(inst.intermission_end_time) - Workspace:GetServerTimeNow()))))
        task.wait(0.25)
    end
    -- 3) play: one ghost at a time, 0.4 s keepalive, walk into range (no teleports in here)
    local HS = game:GetService("HttpService")
    local target, token, sentAt, propAt = nil, nil, 0, 0
    self.nav, self.skip, self.side, self.propU, self.propTok = nil, {}, nil, nil, nil
    while alive() do
        mg = M.MCM.get("ghost_clusters")
        if not (mg and mg.instanced_minigame) then break end
        local now = Workspace:GetServerTimeNow()
        -- over at end_time: walking / un-seating the character after it fights the game's exit
        if now > (tonumber(inst.end_time) or now + 999) + 1 then break end
        _, hrp, hum = char()
        if hrp and hum then
            local list, bossOut, shieldUp = self:ghosts()
            if retarget then target, token, retarget = retarget, token or HS:GenerateGUID(false), nil end
            local cur
            for _, g in ipairs(list) do if g.id == target then cur = g end end
            -- drop a target we can't reach while a nearer one sits in range
            if cur and Hallo.flat(cur.pos, hrp.Position) > (bossOut and Hallo.RANGE.Large or (Hallo.RANGE[cur.size] or 28.6)) + 15 then
                cur = nil
            end
            if not cur then
                cur = self:pickGhost(list, hrp, bossOut, shieldUp)
                if cur and cur.id ~= target then target, token = cur.id, HS:GenerateGUID(false) end
            end
            if cur then
                local range = bossOut and Hallo.RANGE.Large or (Hallo.RANGE[cur.size] or 28.6)
                local stand = bossOut and Hallo.STAND.Large or (Hallo.STAND[cur.size] or 22)
                local d = Hallo.flat(cur.pos, hrp.Position)
                if d > range - 3 then
                    -- pinned against a wall (reported 2026-10-10, fixed with Ethan's review): the stand
                    -- point is FROZEN per ghost + side (a goal sliding with us threw every detour route
                    -- away); the side only changes after 2.5 s with no progress and no route running;
                    -- a turned point is stopped 3 studs short of any wall; and "stuck" means no
                    -- progress toward the ghost for 6 s — sliding along a wall doesn't count
                    local side = self.side
                    if not side or side.id ~= cur.id then
                        side = { id = cur.id, i = 1, at = os.clock(), best = d, prog = os.clock() }
                        self.side = side
                    end
                    if d < side.best - 1.5 then side.best, side.prog = d, os.clock() end
                    local nav = self.nav
                    local routing = nav and nav.key == cur.id and (nav.wp or nav.computing)
                    if not routing and os.clock() - side.prog > 2.5 and os.clock() - side.at > 2.5 then
                        side.i = side.i % #Hallo.SIDES + 1
                        side.at, side.goal = os.clock(), nil
                    end
                    if not side.goal or Hallo.flat(side.gpos, cur.pos) > 8 then
                        local dir = Vector3.new(hrp.Position.X - cur.pos.X, 0, hrp.Position.Z - cur.pos.Z)
                        dir = dir.Magnitude > 0.1 and dir.Unit or Vector3.new(1, 0, 0)
                        local turn = Hallo.SIDES[side.i]
                        if turn ~= 0 then dir = CFrame.Angles(0, math.rad(turn), 0):VectorToWorldSpace(dir) end
                        local from = Vector3.new(cur.pos.X, hrp.Position.Y, cur.pos.Z)
                        local dist = stand
                        local params = RaycastParams.new()
                        local skipList = { LP.Character }
                        local vis = Workspace:FindFirstChild("GhostClustersVisuals")
                        if vis then skipList[#skipList + 1] = vis end
                        params.FilterDescendantsInstances = skipList
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        local okR, hit = pcall(Workspace.Raycast, Workspace, from, dir * stand, params)
                        if okR and hit then dist = math.max(4, hit.Distance - 3) end
                        side.goal, side.gpos = from + dir * dist, cur.pos
                    end
                    self:walkTo(hum, hrp, side.goal, cur.id)
                    if os.clock() - side.prog > 6 then               -- no way round: another ghost
                        self.skip = self.skip or {}
                        self.skip[cur.id] = os.clock() + 8
                        target, self.nav, self.side = nil, nil, nil
                    end
                else
                    if self.nav then hum:MoveTo(hrp.Position) end    -- don't walk back out of range
                    self.nav = nil
                end
                if os.clock() - sentAt >= 0.4 and remote then
                    sentAt = os.clock()
                    remote:FireServer(mid, "start_contribute", { ghost_id = cur.id, use_token = token })
                end
                local endT = tonumber(inst.end_time)
                Hallo.say(("Halloween: Ghost Gallery — %s ghost, score %s%s"):format(tostring(cur.size),
                    tostring(mg.instanced_minigame and mg.instanced_minigame._score or "?"),
                    endT and (" · %ds left"):format(math.max(0, math.ceil(endT - Workspace:GetServerTimeNow()))) or ""))
            elseif not bossOut and M.PropR and os.clock() - propAt >= 0.4 then
                -- nothing to vacuum: shake the nearest haunted prop so it lets its ghosts out
                propAt = os.clock()
                local okT, props = pcall(M.PropR.get_targets, true)
                local best, bd
                for _, p in ipairs(okT and type(props) == "table" and props or {}) do
                    local blk = p.model and (p.model:FindFirstChild("PlacementBlock") or p.model.PrimaryPart)
                    if blk then
                        local dd = Hallo.flat(blk.Position, hrp.Position)
                        if not bd or dd < bd then best, bd = { unique = p.unique, pos = blk.Position }, dd end
                    end
                end
                if best then
                    if bd > 20 then
                        local away = Vector3.new(hrp.Position.X - best.pos.X, 0, hrp.Position.Z - best.pos.Z)
                        away = away.Magnitude > 0.1 and away.Unit or Vector3.new(1, 0, 0)
                        self:walkTo(hum, hrp, best.pos + away * 12, "prop:" .. tostring(best.unique))
                    end
                    if best.unique ~= self.propU then                -- one token per prop, like ghosts
                        self.propU, self.propTok = best.unique, HS:GenerateGUID(false)
                    end
                    if remote then
                        remote:FireServer(mid, "start_prop_contribute", { unique = best.unique, use_token = self.propTok })
                    end
                    setStatus("Halloween: Ghost Gallery — waking a haunted prop")
                end
            end
        end
        task.wait(0.1)
    end
    conn:Disconnect()
    -- 4) the game shows the results and takes us back to the manor: wait for ITS exit to end (a
    -- trip / equip of ours in the middle of it was one way to the white screen, 2026-10-11)
    do
        local _, h2, m2 = char()
        if h2 and m2 then pcall(function() m2:MoveTo(h2.Position) end) end
    end
    if not Hallo.waitExit("ghost_clusters", 45) then log("Ghost Gallery: the game is slow to take us out — watching it") end
    task.wait(1)
    -- no ClientData at either end (Hallo:candy() = 0) must not read as "paid 0" / a huge gain
    local endCandy = me() and self:candy() or nil
    local got = (endCandy and startCandy > 0) and (endCandy - startCandy) or 0
    -- the daily candy cap (AltCurrencyData candy_2026: 250 000): a round that scored but paid 0
    -- would cost ~4 min every 20 for nothing — the Ghost Gallery waits 3 h (the Hauntlet still pays bucks)
    local score = tonumber(inst and inst._score) or 0
    if endCandy and startCandy > 0 and got <= 0 and score >= 4000 then
        self.capUntil = os.clock() + 3 * 3600
        log(("Halloween: daily candy cap reached (score %d, +0 candy) — Ghost Gallery paused 3 h"):format(score))
    end
    self.rounds += 1
    self.roundCandy += math.max(0, got)
    self.last = ("Ghost Gallery round %d: +%d candy"):format(self.rounds, got)
    log("Halloween: " .. self.last)
    self.busy = false
end

------------------------------------------------------------------------------------------------
-- Hauntlet round (Halloween 2026, part 2)
--
--   Read from the live client 2026-10-09 (HauntletMinigameServer / HauntletFloor are
--   replicated). Queue = HauntedHotel.HauntletMinigameJoinZone, a round every 1200 s at
--   ClientData hauntlet_cycle_timestamp. 5 floors x 10 rooms: rooms 1-9 = 3 doors (4 on floor
--   5), room 10 = a nexus (2 doors = next area + a special item), floor 4's = the final nexus.
--   MinigameAPI/MessageServer(mid, "try_pick_door", i) / (mid, "try_use_item", kind); the
--   server answers on MessageClient(mid, msg, …): started_room(room, end_time, players,
--   nexus_items), picked_door(ok), doors_opened(ghosts per door, damage by user id, items
--   gained), used_item(kind, ok), revealed_ghost(i), gained_items(list), kicked_from_game(why).
--   No position check. Ghosts are hidden: the room's ghost count is
--   (room > 1) + (room-in-floor >= (1 - floor/5)*10) + (floor == 5), spread over the doors by
--   each kind's ghost_weight — so the lowest weight is the safest door. One ghost = 1 health;
--   at 0 the run ends. Reward: (rooms + 1) x candy_per_room, bucks every 10 rooms, rusty keys.
--   Items: cell_phone reveals one haunted door (refused — and kept — when no door has a ghost),
--   key = -1 grey lock on every door, gold_key = every lock off, rainbow_wand = every ghost
--   gone, ghost_potion = +1 temporary health (this room), red_potion = full health,
--   gold_potion = +1 max health.
------------------------------------------------------------------------------------------------

Haunt = { rounds = 0, candy = 0, best = 0, last = "—" }
-- next areas, best first: their own door kind comes twice as often there (tuned on 50 000
-- simulated runs of the real room generator: copycat / carnival floors go furthest)
-- carnival LAST (2026-10-11): its Bouncy (clown) Doors fling you off the map — a death
Haunt.AREA = { copycat = 0, spider = 2, laboratory = 3, hallway = 5, mechanical = 6, nightmare = 9, carnival = 10 }
Haunt.SPECIAL = { rainbow_wand = 3, red_potion = 2, gold_key = 1.5 }
-- what a door with no ghost pays out (its drop table), in "health points" of value
Haunt.DROPVAL = { shadow = 0.8, nightmare = 0.8, rotten = 0.5, electric = 0.6, security = 0.6,
                  wooden = 0.3, locked = 0.15, gold_locked = 1.5 }
Haunt.DANGER = 0.08          -- chance to die in this room above which items are spent

function Haunt:db()
    if self.D then return self.D end
    local base = RS.SharedModules.ContentPacks.Halloween2026.Game.Hauntlet
    local okD, D = pcall(require, base.HauntletDoorDB)
    self.D = okD and D or {}
    return self.D
end

-- Ghosts the server puts in room k (1-based over the whole run).
function Haunt.ghostsIn(k)
    local f = math.min(5, math.floor((k - 1) / 10) + 1)
    local n = k - (f - 1) * 10
    local g = (k > 1) and 1 or 0
    if (1 - f / 5) * 10 <= n then g += 1 end
    if f == 5 then g += 1 end
    return g
end

-- Where the ghosts can be: dist[i][g + 1] = chance door i hides exactly g ghosts. The server
-- draws G ghosts WITH replacement by ghost_weight (2 behind one door seen live); a copycat
-- hides another door's weight (75 ≈ the average). A phone reveal (one haunted door, chosen
-- evenly among the haunted ones) is folded in exactly — G ≤ 3 and ≤ 4 doors = ≤ 64 cases.
function Haunt:posterior(doors, G, revealed, cleared)
    local D = self:db()
    local n = #doors
    local w, tot = {}, 0
    for i, d in ipairs(doors) do
        local e = D[d.kind] or {}
        w[i] = d.kind == "copycat" and 75 or (tonumber(e.ghost_weight) or 75)
        tot += w[i]
    end
    local dist = {}
    for i = 1, n do dist[i] = table.create(G + 1, 0) end
    if cleared or G == 0 or tot == 0 then
        for i = 1, n do dist[i] = { 1 } end
        return dist, 0
    end
    local vec, Z = table.create(n, 0), 0
    local function rec(g, pr)
        if g == G then
            local like = pr
            if revealed then
                local haunted = 0
                for i = 1, n do if vec[i] > 0 then haunted += 1 end end
                like = vec[revealed] > 0 and like / haunted or 0
            end
            if like > 0 then
                Z += like
                for i = 1, n do dist[i][vec[i] + 1] += like end
            end
            return
        end
        for i = 1, n do
            if w[i] > 0 then
                vec[i] += 1
                rec(g + 1, pr * w[i] / tot)
                vec[i] -= 1
            end
        end
    end
    rec(0, 1)
    if Z > 0 then for i = 1, n do for g = 1, G + 1 do dist[i][g] /= Z end end end
    return dist, G
end

-- Each door's cost for someone with hp health (+temp) and inventory inv (nil = a teammate:
-- only doors without locks). Returns the doors that can be picked, cheapest first, each with
-- pd = chance to die behind it.
function Haunt:costs(room, dist, G, hp, inv)
    local doors, out = room.doors or {}, {}
    local items = 0
    for _, c in pairs(inv or {}) do items += c end
    local function dmgOf(i)                 -- damage distribution behind door i
        local d = doors[i]
        local extra = d.enter_effect == "player_take_damage" and (tonumber(d.enter_effect_value) or 1) or 0
        local dd = {}
        for g, pr in ipairs(dist[i]) do dd[g - 1 + extra] = (dd[g - 1 + extra] or 0) + pr end
        return dd
    end
    for i, d in ipairs(doors) do
        local ok, cost = true, 0
        local grey, gold = tonumber(d.grey_locks) or 0, tonumber(d.gold_locks) or 0
        if gold > 0 then
            if inv and (inv.gold_key or 0) > 0 then cost += 0.4 else ok = false end
        elseif grey > 0 then
            if inv and (inv.key or 0) >= grey then cost += 0.15 * grey
            elseif inv and (inv.gold_key or 0) > 0 then cost += 0.4
            else ok = false end
        end
        local dd
        if d.enter_effect == "player_bounce" then        -- lands on one of the other doors
            dd = {}
            local others = #doors - 1
            for j = 1, #doors do
                if j ~= i then
                    for dmg, pr in pairs(dmgOf(j)) do dd[dmg] = (dd[dmg] or 0) + pr / others end
                end
            end
            cost += 0.1
        else
            if d.enter_effect == "player_take_damage" and hp <= (tonumber(d.enter_effect_value) or 1) then ok = false end
            if d.enter_effect == "player_lose_item" and items > 0 then cost += 0.25 end
            if d.enter_effect == "transform" then cost += 0.1 end
            dd = dmgOf(i)
        end
        local pd, ed = 0, 0
        for dmg, pr in pairs(dd) do
            ed += pr * dmg
            if dmg >= hp then pd += pr end
        end
        -- the Bouncy Door's fling often lands you off the map (reported 2026-10-11): a last resort
        if d.enter_effect == "player_bounce" then pd, cost = math.max(pd, 0.5), cost + 1 end
        cost += pd * 20 + ed - (dist[i][1] or 0) * (Haunt.DROPVAL[d.kind] or 0)
        if ok then out[#out + 1] = { i = i, cost = cost, pd = pd, d = d } end
    end
    table.sort(out, function(a, b) return a.cost < b.cost end)
    return out
end

-- Our own accounts in this round: every hub writes a heartbeat in the executor workspace
-- (shared by all clients of the executor on this PC); a fresh one = one of ours.
function Haunt:beat()
    pcall(function()
        if isfolder and makefolder and not isfolder("CometHaunt") then makefolder("CometHaunt") end
        writefile("CometHaunt/" .. LP.UserId .. ".txt", tostring(os.time()))
    end)
end
function Haunt:ours(roster)
    -- team mode is Premium (2026-10-12; C.HwTeam, on): free = every account plays its round alone
    if not (Track and Track:isPremium() and C.HwTeam ~= false) then return { tostring(LP.UserId) } end
    local mine, n = {}, 0
    local okL = pcall(function()
        for _, path in ipairs(listfiles("CometHaunt")) do
            local id = tostring(path):match("(%d+)%.txt$")
            local okR, t = pcall(readfile, path)
            if id and okR and os.time() - (tonumber(t) or 0) < 90 then mine[id] = true end
        end
    end)
    local out = {}
    for id in pairs(roster or {}) do
        id = tostring(id)
        -- no workspace functions: treat everyone in the round as a teammate
        if id == tostring(LP.UserId) or mine[id] or not okL then out[#out + 1] = id end
    end
    table.sort(out, function(a, b) return tonumber(a) < tonumber(b) end)
    return out
end

function Haunt:round()
    local M = Hallo:mods()
    if not (M.MCM and Hallo:live()) then return end
    local T, left = Hallo:nextHaunt()
    if not T or left > Hallo.LEAD or left < -1 then return end
    Hallo.busy = true
    local startCandy, startBucks = Hallo:candy(), bucks()
    setStatus(("Halloween: queueing for the Hauntlet (starts in %ds)"):format(math.max(0, math.floor(left))))
    local col = Hallo:join("hauntlet", "HauntedHotel", "HauntletMinigameJoinZone", "hauntlet", T, "Hauntlet")
    if not col then Hallo.busy = false return end
    local _, hrp = char()
    local mg
    setStatus(("Halloween: in the Hauntlet queue (starts in %ds)"):format(
        math.max(0, math.floor(T - Workspace:GetServerTimeNow()))))
    local inst
    -- past T+30 only while the game is still taking us in (see ghostRound)
    while alive() and Workspace:GetServerTimeNow() < T + (((type(mg) == "table" and rawget(mg, "is_participating") == true)
        or (G.IM and G.IM.entering)) and 90 or 30) do
        mg = M.MCM.get("hauntlet")
        inst = mg and mg.instanced_minigame
        if inst and inst.is_participating then break end
        local tl = T - Workspace:GetServerTimeNow()
        Hallo.say(tl > 0 and ("Halloween: in the Hauntlet queue — starts in %ds"):format(math.ceil(tl))
            or "Halloween: Hauntlet — joining the round…")
        Hallo:queueTasks(tl)
        if not inst then
            _, hrp = char()
            if hrp and col.Parent and Hallo.flat(hrp.Position, col.Position) > 10
               and Workspace:GetServerTimeNow() < T - 1 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(col.Position + Vector3.new(0, 3, 0))
            end
        end
        task.wait(0.25)
    end
    if not (inst and inst.is_participating) then
        log("Hauntlet: wasn't let into the round")
        Hallo.busy = false
        return
    end
    local mid = inst.minigame_id
    local remote = G.API:FindFirstChild("MinigameAPI/MessageServer")
    local uid = tostring(LP.UserId)
    -- our run: health / items from the game's own copy, then kept up to date from the messages.
    -- Every runner's health is tracked too (the server broadcasts damage, heals and temp
    -- health for all): a teammate about to die makes us spend our rainbow wand for the room.
    local st = { health = 3, max = 3, temp = 0, inv = {}, k = 0, room = nil, ghosts = 0,
                 revealed = nil, noGhosts = false, used = nil, picked = nil, over = nil, gotItems = 0,
                 roster = {}, hp = {} }
    local function syncFromGame()
        for who, r in pairs(type(inst.runners) == "table" and inst.runners or {}) do
            local id = typeof(who) == "Instance" and tostring(who.UserId) or tostring(who)
            if type(r) == "table" then
                st.hp[id] = { health = tonumber(r.health) or 3, max = tonumber(r.max_health) or 3,
                              temp = tonumber(r.temp_health) or 0 }
                if id == uid then
                    st.health = st.hp[id].health
                    st.max = st.hp[id].max
                    st.temp = st.hp[id].temp
                    if type(r.inventory) == "table" then
                        st.inv = {}
                        for kk, n in pairs(r.inventory) do st.inv[kk] = tonumber(n) or 0 end
                    end
                end
            end
        end
    end
    local function hpOf(id)
        id = tostring(id)
        st.hp[id] = st.hp[id] or { health = 3, max = 3, temp = 0 }
        return st.hp[id]
    end
    local function hurt(id, n)
        local h = hpOf(id)
        for _ = 1, n do if h.temp > 0 then h.temp -= 1 else h.health -= 1 end end
        if id == uid then st.health, st.temp = h.health, h.temp end
    end
    local function addItems(list)
        for _, it in ipairs(type(list) == "table" and list or {}) do
            st.inv[it] = (st.inv[it] or 0) + 1
            st.gotItems += 1
        end
    end
    local conn = G.API["MinigameAPI/MessageClient"].OnClientEvent:Connect(function(id, msg, a, b, c, d)
        if id ~= mid then return end
        if msg == "started_room" then
            st.k += 1
            st.room, st.nexusItems = a, d
            st.endAt = tonumber(b)                -- the room's end (server time): pick before it
            st.roster = type(c) == "table" and c or { [uid] = true }
            st.ghosts = Haunt.ghostsIn(st.k)
            st.revealed, st.noGhosts, st.temp = nil, false, 0
            for _, h in pairs(st.hp) do h.temp = 0 end
            st.at = os.clock()
            st.newRoom = true          -- solo, picked_door → doors_opened → started_room come at once
        elseif msg == "picked_door" then
            st.picked = a == true
        elseif msg == "used_item" then
            st.used = { kind = a, ok = b == true }
            if b == true and st.inv[a] then st.inv[a] = math.max(0, st.inv[a] - 1) end
        elseif msg == "revealed_ghost" then
            st.revealed = tonumber(a)
        elseif msg == "ghosts_dispelled" then
            st.noGhosts = true                                -- anyone's wand: the room is clean
        elseif msg == "grey_locks_removed" and st.room and type(a) == "table" then
            for _, i in ipairs(a) do
                local dd = st.room.doors and st.room.doors[tonumber(i)]
                if dd then dd.grey_locks = math.max(0, (tonumber(dd.grey_locks) or 0) - 1) end
            end
        elseif msg == "all_locks_removed" and st.room and type(a) == "table" then
            for _, i in ipairs(a) do
                local dd = st.room.doors and st.room.doors[tonumber(i)]
                if dd then dd.grey_locks, dd.gold_locks = 0, 0 end
            end
        elseif msg == "gained_items" then
            addItems(a)
        elseif msg == "doors_opened" then
            for who, dmg in pairs(type(b) == "table" and b or {}) do hurt(tostring(who), tonumber(dmg) or 0) end
            addItems(c)
        elseif msg == "door_effect_triggered" then
            if c == "player_take_damage" then hurt(tostring(a), tonumber(d) or 0) end
            if tostring(a) == uid and c == "player_lose_item" and type(d) == "table" then
                for _, it in ipairs(d) do if st.inv[it] then st.inv[it] = math.max(0, st.inv[it] - 1) end end
            end
        elseif msg == "max_health_gained" then
            local h = hpOf(a)
            h.max += tonumber(b) or 1
            h.health += tonumber(b) or 1
            if tostring(a) == uid then st.max, st.health = h.max, h.health end
        elseif msg == "health_restored" then
            local h = hpOf(a)
            h.health = h.max
            if tostring(a) == uid then st.health = h.health end
        elseif msg == "temp_health_gained" then
            local h = hpOf(a)
            h.temp += tonumber(b) or 1
            if tostring(a) == uid then st.temp = h.temp end
        elseif msg == "kicked_from_game" then
            st.over = tostring(a)
        end
    end)
    -- a round cut short (guard, error) left its listener live on every minigame message: the
    -- next round drops it
    if Hallo.roundConn and Hallo.roundConn ~= conn then pcall(function() Hallo.roundConn:Disconnect() end) end
    Hallo.roundConn = conn
    local function send(...) if remote then pcall(remote.FireServer, remote, mid, ...) end end
    -- The room's timer (read 2026-10-11 in HauntletFloor): whoever hasn't picked a door when it
    -- ends is marked "out_of_time" — out of the run. Every wait below is cut by it.
    local function tleft() return st.endAt and (st.endAt - Workspace:GetServerTimeNow()) or 30 end
    -- use an item and wait for the answer (true = used). vital = it saves the run (potion, wand,
    -- the chosen door's keys): still tried under 3 s; anything else waits for a calmer room
    local function use(kind, vital)
        if (st.inv[kind] or 0) <= 0 or tleft() < (vital and 1.5 or 3) then return false end
        st.used = nil
        send("try_use_item", kind)
        local w, cap = 0, math.min(2.5, math.max(0.3, tleft() - 1.2))
        while not st.used and w < cap and not st.over do w += task.wait(0.1) end
        return st.used ~= nil and st.used.kind == kind and st.used.ok
    end
    -- sleep until `t` seconds after the room started (team rounds take turns with items),
    -- never into the last 3 s of the room's timer
    local function untilT(t, k0)
        while alive() and not st.over and st.k == k0 and os.clock() - st.at < t and tleft() > 3 do task.wait(0.05) end
        return st.k == k0 and not st.over
    end
    local function pickDoor(i, k0)
        st.picked = nil
        -- what the game's own door circle sets first: its picked_door / doors_opened handlers
        -- read it, and left nil they errored every room (HauntletMinigameClient:596) and left
        -- each room's circles and handlers running
        pcall(function() inst.selected_door_index = i end)
        -- the net below only watches the 10 s after a Bouncy (clown) Door: every other drop is the
        -- game moving us (a new floor is a fall too — seen 2026-10-11, the net fired on rooms 22-27)
        local dd = st.room and type(st.room.doors) == "table" and st.room.doors[i]
        st.bounceAt = (type(dd) == "table" and dd.enter_effect == "player_bounce") and os.clock() or nil
        send("try_pick_door", i)
        local w = 0
        while st.picked == nil and st.k == k0 and w < 3 and not st.over do w += task.wait(0.1) end
        return st.picked or st.k ~= k0
    end
    syncFromGame()
    Haunt:beat()
    setStatus("Halloween: Hauntlet — waiting for the first room")
    local tEnd = os.clock() + 780
    while alive() and not st.over and os.clock() < tEnd do
        mg = M.MCM.get("hauntlet")
        if not (mg and mg.instanced_minigame) then break end
        -- the net: only a Bouncy Door fling gone wrong (the 10 s after picking one, dropping fast,
        -- near where you last stood, no trip, twice a room at most) — never one of the game's own
        -- moves (next room or floor, the trip back), which it used to pull you out of (2026-10-11)
        local _, hf, hh = char()
        if hf and hh and hh.FloorMaterial ~= Enum.Material.Air and not hf.Anchored then st.safe = hf.CFrame end
        if hf and st.safe and st.bounceAt and os.clock() - st.bounceAt < 10
           and not (G.IM and G.IM.entering) and (st.caught or 0) < 2
           and hf.Position.Y < st.safe.Position.Y - 35 and hf.AssemblyLinearVelocity.Y < -40
           and Hallo.flat(hf.Position, st.safe.Position) < 150 then
            st.caught = (st.caught or 0) + 1
            hf.AssemblyLinearVelocity = Vector3.zero
            hf.CFrame = st.safe
            log("Hauntlet: thrown off the map — put back in the room")
        end
        if st.newRoom and st.room then
            st.newRoom = false
            local room, k0 = st.room, st.k
            Haunt:beat()
            local team = Haunt:ours(st.roster)               -- our accounts in this round, sorted
            local rank, multi = 1, false
            for i, id in ipairs(team) do if id == uid then rank = i end end
            local others = 0
            for _ in pairs(st.roster) do others += 1 end
            multi = others > 1
            task.wait(0.3)                                    -- let the game's own room code start
            st.caught = 0

            if room.kind == "default" then
                local G = st.ghosts
                -- health first: +1 max is always good; a full heal once down to 1
                if (st.inv.gold_potion or 0) > 0 then use("gold_potion") end
                if (st.inv.red_potion or 0) > 0 and st.health <= math.min(1, st.max - 1) then use("red_potion") end
                -- 1) one phone for the whole room: we take turns (a refused phone isn't spent —
                -- it is refused once a door is already revealed)
                if G > 0 and (st.inv.cell_phone or 0) > 0 then
                    if multi then untilT(0.3 + (rank - 1) * 0.35, k0) end
                    if not st.revealed and st.k == k0 then use("cell_phone") end
                end
                if multi then untilT(0.5 + #team * 0.35, k0) end
                -- 2) the rainbow wand when anyone of ours would likely die here
                local dist = self:posterior(room.doors or {}, G, st.revealed, st.noGhosts)
                local function dangerOf(id)
                    local h = hpOf(id)
                    if h.health <= 0 then return 0 end
                    local list = self:costs(room, dist, G, h.health + h.temp, id == uid and st.inv or nil)
                    return list[1] and list[1].pd or 1
                end
                if G > 0 and not st.noGhosts and (st.inv.rainbow_wand or 0) > 0 then
                    if multi then untilT(1.6 + (rank - 1) * 0.3, k0) end
                    local need = false
                    for _, id in ipairs(team) do if dangerOf(id) > Haunt.DANGER then need = true end end
                    if need and not st.noGhosts and st.k == k0 and use("rainbow_wand", true) then st.noGhosts = true end
                end
                if multi then untilT(1.9 + #team * 0.3, k0) end
                if st.k == k0 and not st.over then
                -- 3) our own spare heart, then the door
                dist = self:posterior(room.doors or {}, G, st.revealed, st.noGhosts)
                local list = self:costs(room, dist, G, st.health + st.temp, st.inv)
                for _ = 1, 2 do
                    if not (list[1] and list[1].pd > Haunt.DANGER) then break end
                    if (st.inv.ghost_potion or 0) > 0 and use("ghost_potion", true) then
                    elseif (st.inv.red_potion or 0) > 0 and st.health < st.max and use("red_potion", true) then
                    else break end
                    list = self:costs(room, dist, G, st.health + st.temp, st.inv)
                end
                local done = false
                for _, cand in ipairs(list) do
                    local d = cand.d
                    local gold, grey = tonumber(d.gold_locks) or 0, tonumber(d.grey_locks) or 0
                    -- locks are the room's: the broadcast updates them for everyone
                    if gold > 0 or (grey > 0 and (st.inv.key or 0) < grey) then
                        if use("gold_key", true) then d.grey_locks, d.gold_locks = 0, 0 end
                    else
                        for _ = 1, grey do if use("key", true) then task.wait(0.15) end end
                    end
                    if pickDoor(cand.i, k0) then
                        done = true
                        st.lastPick = { k = k0, i = cand.i, kind = tostring(d.kind), pd = cand.pd }
                        Hallo.say(("Halloween: Hauntlet — room %d, door %d (%s), health %d+%d, death risk %d%%%s · %ds left")
                            :format(k0, cand.i, tostring(d.kind), st.health, st.temp, math.floor(cand.pd * 100 + 0.5),
                                multi and (" · team of " .. #team) or "", math.max(0, math.floor(tleft()))))
                        break
                    end
                end
                if not done and st.k == k0 and not st.over then
                    -- nothing we wanted could be taken: any door beats the timer running out
                    -- ("out_of_time" ends the run, a ghost only costs 1 health)
                    for i = 1, #(room.doors or {}) do
                        if pickDoor(i, k0) then
                            done = true
                            log(("Hauntlet: room %d — took door %d so the timer doesn't run out"):format(k0, i))
                            break
                        end
                    end
                end
                if not done then log(("Hauntlet: no door could be picked in room %d"):format(k0)) end
                end
            else
                -- nexus: the best next area. Our accounts must all take the same door (each door
                -- is its own floor), so in a team the special item each sees doesn't count.
                local best, bs
                for i, d in ipairs(room.doors or {}) do
                    local s = Haunt.AREA[d.area_kind] or 5
                    local it = type(st.nexusItems) == "table" and st.nexusItems[i]
                    if #team <= 1 then s -= (Haunt.SPECIAL[it] or 0) end
                    if not bs or s < bs then best, bs = i, s end
                end
                pickDoor(best or 1, k0)
                setStatus(("Halloween: Hauntlet — room %d (next floor: %s)"):format(k0,
                    tostring(best and room.doors[best] and room.doors[best].area_kind or "?")))
            end
        end
        task.wait(0.05)
    end
    conn:Disconnect()
    -- the game shows the results (an ending cutscene ~27 s) and takes us back to the hotel: wait
    -- for ITS exit to end before the farm moves again
    if not Hallo.waitExit("hauntlet", 60) then log("Hauntlet: the game is slow to take us out — watching it") end
    task.wait(1)
    local got, gotB = Hallo:candy() - startCandy, bucks() - startBucks
    -- 3+ rooms and 0 candy = the daily cap (the Hauntlet pays rooms x 420 otherwise): the Ghost
    -- Gallery (candy only) waits 3 h, also on accounts that never saw it pay 0 there
    if me() and startCandy > 0 and got <= 0 and st.k >= 3 then
        Hallo.capUntil = os.clock() + 3 * 3600
        log(("Halloween: the Hauntlet paid 0 candy for %d rooms — daily candy cap, Ghost Gallery paused 3 h"):format(st.k))
    end
    self.rounds += 1
    self.candy += math.max(0, got)
    self.best = math.max(self.best, st.k)
    self.last = ("Hauntlet round %d: room %d (%s), +%d candy%s"):format(self.rounds, st.k,
        tostring(st.over or "ended"), got, gotB > 0 and (" +$" .. gotB) or "")
    Hallo.last = self.last
    -- how the run ended: health, items still in hand, the last door and the risk we read for it
    -- ("dies at 0 health" — with items left = a policy question; without = the luck of the draw)
    local rest, lp = {}, st.lastPick
    for kk, n in pairs(st.inv) do if n > 0 then rest[#rest + 1] = kk .. " x" .. n end end
    log("Halloween: " .. self.last .. (" · health %d/%d · items left: %s%s"):format(st.health, st.max,
        #rest > 0 and table.concat(rest, ", ") or "none",
        lp and (" · last door %d (%s, death risk %d%%) in room %d"):format(lp.i, lp.kind,
            math.floor(lp.pd * 100 + 0.5), lp.k) or ""))
    Hallo.busy = false
end

------------------------------------------------------------------------------------------------
-- Lightning Lever → Skelicorn, and the Halloween pets bought with candy
--
--   The lever is a crypt coffin reward (toys halloween_2026_lightning_lever, one per account).
--   Halloween2026/LightningLeverDeliver (needs the lever equipped) → state "deactivated", then
--   Halloween2026/LightningLeverActivate → "activated" = the Skelicorn is for sale
--   (ForSaleCallbacks). No distance check on either. Pets: ShopAPI/BuyItem("pets", kind,
--   {buy_count = 1}) paid in candy_2026 — Bolt (Hotel), Jump Scare (Manor), Skelicorn (after
--   the lever), Jacobin Pigeon (after 8 twigs in the nest).
------------------------------------------------------------------------------------------------

-- gate(data) = on sale for this account (ClientData, both fields seen live): a refused buy no
-- longer holds every other purchase back 5 min
Haunt.PETS = {
    { label = "Bolt", kind = "halloween_2026_bolt" },
    { label = "Jump Scare", kind = "halloween_2026_jump_scare" },
    { label = "Skelicorn", kind = "halloween_2026_skelicorn", gate = function(d)
        local lm = d.halloween_2026_lightning_lever_manager
        return type(lm) == "table" and lm.lever_state == "activated"
    end },
    { label = "Jacobin Pigeon", kind = "halloween_2026_jacobean_pigeon", gate = function(d)
        local nm = d.halloween_2026_jacobean_pigeon_nest_manager
        return type(nm) == "table" and (tonumber(nm.twigs_contributed) or 0) >= 8
    end },
    -- a gacha (LootBoxRewards: Caramelgeist 76 % / Bobageist 20 % / Bubblegeist 4 %), opened by
    -- Haunt:openBoxes only with "Open Poltergeist Boxes" on
    { label = "Poltergeist Box", kind = "halloween_2026_poltergeist_box", cat = "gifts", box = true },
}

function Haunt:lever()
    if not C.HwLever or os.clock() - (self.leverAt or -1e9) < 60 then return end
    self.leverAt = os.clock()
    local lm = me() and me().halloween_2026_lightning_lever_manager
    local state = type(lm) == "table" and lm.lever_state or nil
    if state == nil or state == "activated" then return end
    local okN, Net = pcall(require, RS.SharedModules.ContentPacks.Halloween2026.Game.LightningLever.LightningLeverNet)
    if not okN then return end
    if state == "default" then
        local item
        for _, it in pairs(me().inventory.toys or {}) do
            if (it.id or it.kind) == "halloween_2026_lightning_lever" then item = it break end
        end
        if not item then return end                       -- still in the crypt
        local M = Hallo:mods()
        if M.CTM then pcall(M.CTM.equip, item) task.wait(0.8) end
        local done, ok, res = false, false, nil
        task.spawn(function()
            ok, res = pcall(Net.DeliverLever.invoke_server_async, Net.DeliverLever)
            done = true
        end)
        local w = 0
        while not done and w < 10 do w += task.wait(0.2) end
        log("Halloween: lightning lever delivered — " .. tostring(ok and type(res) == "table"
            and (res.ok and "ok" or res.reason) or res))
        task.wait(1.5)
    end
    lm = me().halloween_2026_lightning_lever_manager
    if type(lm) == "table" and lm.lever_state == "deactivated" then
        pcall(Net.ActivateLever.fire_server, Net.ActivateLever)
        task.wait(1.5)
        lm = me().halloween_2026_lightning_lever_manager
        log("Halloween: lightning lever " .. tostring(type(lm) == "table" and lm.lever_state))
    end
end

function Haunt:ownedPet(kind)
    for _, p in pairs(me() and me().inventory.pets or {}) do
        if (p.id or p.kind) == kind then return true end
    end
    return false
end

function Haunt:buyPets()
    if os.clock() - (self.petAt or -1e9) < 30 then return end
    self.petAt = os.clock()
    local d = me()
    if not d or #(C.HwPets or {}) == 0 then return end
    self.noSale = self.noSale or {}
    -- the event's last 12 h (opt-in "spend it all", Premium): "keep at least" and "one of each" stop holding
    local last = C.HwSpendEnd and Track:isPremium() and Hallo:endsIn() < 12 * 3600
    local keep = last and 0 or (C.HwKeepCandy or 0)
    local list, missing, missingCan = {}, false, false
    for _, p in ipairs(Haunt.PETS) do
        local picked = false
        for _, o in ipairs(C.HwPets) do if tostring(o):find(p.label, 1, true) == 1 then picked = true end end
        local cat = p.cat or "pets"
        local e = picked and G.IDB[cat] and G.IDB[cat][p.kind]
        local cost = e and e.currency_id == "candy_2026" and tonumber(e.cost)
        local onSale = cost and os.clock() >= (self.noSale[p.kind] or 0) and (not p.gate or p.gate(d))
        -- a picked pet you don't own counts as missing even while it isn't on sale yet (the lever,
        -- a refusal window): its candy is kept for it, not spent on copies / boxes
        if cost and not p.box and not self:ownedPet(p.kind)
           and not (p.kind == "halloween_2026_jacobean_pigeon" and not onSale and not C.HwTwigs) then
            missing = true
            if Hallo:candy() >= cost then missingCan = true end
        end
        if p.gate and cost and not p.gate(d) and p.kind == "halloween_2026_jacobean_pigeon" and not self.nestSaid then
            self.nestSaid = true
            local bag, nm = 0, d.halloween_2026_jacobean_pigeon_nest_manager
            for _, t in pairs(d.inventory.toys or {}) do if (t.id or t.kind) == "halloween_2026_twig" then bag += 1 end end
            log(("Jacobin Pigeon: %d twig(s) in your bag, %s in the nest (8 needed) — put them in the pigeon nest yourself"):format(
                bag, tostring(type(nm) == "table" and nm.twigs_contributed or "?")))
        end
        if onSale then
            local held = 0
            if p.box then
                for _, it in pairs(d.inventory.gifts or {}) do if (it.id or it.kind) == p.kind then held += 1 end end
            end
            local have = (not p.box) and self:ownedPet(p.kind)
            list[#list + 1] = { p = p, cat = cat, cost = cost, again = p.box or have, held = held }
        end
    end
    -- dearest first. A 2nd copy or a box only once every picked pet you still miss is bought:
    -- "buy more than one" on a cheap pet used to eat, every 30 s, the candy a dear one needed
    table.sort(list, function(a, b) return a.cost > b.cost end)
    for _, it in ipairs(list) do
        local repeatOk = C.HwPetMany or last or (it.p.box and ((C.HwOpenBoxes and Track:isPremium()) or it.held == 0))
        local blocked = (last and missingCan) or (not last and missing)
        if (not it.again or (repeatOk and not blocked)) and Hallo:candy() - it.cost >= keep then
            local before = Hallo:candy()
            local ok, res = invoke("ShopAPI/BuyItem", it.cat, it.p.kind, { buy_count = 1 })
            task.wait(1)
            local spent = before - Hallo:candy()
            log(("Halloween: buy %s (%d candy): %s%s"):format(it.p.label, it.cost, tostring(ok and res or "error"),
                spent > 0 and (" (-" .. spent .. ")") or ""))
            if spent <= 0 then self.noSale[it.p.kind] = os.clock() + 300 end   -- refused: this one, 5 min
        end
    end
end

-- The Poltergeist Boxes you hold, opened one per pass (opt-in, Premium: irreversible). The game's own way
-- (GenericBoxTool): the box in hand, then LootBoxAPI/ExchangeItemForReward(kind, unique) — the
-- LootBoxRewards key is the item kind; the answer is a list, [1] = { kind, unique } (how the
-- game's other boxes read it), nil when refused. Never in the last 30 s before a round.
function Haunt:openBoxes()
    if not (C.HwOpenBoxes and Track:isPremium()) or os.clock() - (self.boxAt or -1e9) < 20 or Hallo:budget() < 30 then return end
    self.boxAt = os.clock()
    local d = me()
    for _, it in pairs(d and d.inventory.gifts or {}) do
        if (it.id or it.kind) == "halloween_2026_poltergeist_box" and not isLocked(it) then
            local M = Hallo:mods()
            if M.CTM then pcall(M.CTM.equip, it) task.wait(0.8) end
            local ok, res = Hallo.call(10, function()
                local r = G.API:FindFirstChild("LootBoxAPI/ExchangeItemForReward")
                return r and r:InvokeServer("halloween_2026_poltergeist_box", it.unique)
            end)
            local got = ok and type(res) == "table" and type(res[1]) == "table" and res[1] or nil
            local e = got and G.IDB.pets[got.kind]
            if got then
                self.boxes = (self.boxes or 0) + 1
                log("Halloween: opened a Poltergeist Box — " .. tostring(e and e.name or got.kind))
            else
                self.boxAt = os.clock() + 600                  -- refused / no answer: not every 20 s
                log("Halloween: Poltergeist Box not opened (" .. tostring(res) .. ")")
            end
            return
        end
    end
end

-- Worker hook: the rounds first (they can't wait), then dailies, keys, cat, lever, pets.
function Hallo:tick()
    if not (C.HwOn and self:live()) then return end
    if C.HwGhost and os.clock() >= (self.capUntil or 0) then
        local _, left = self:nextRound()
        if left <= Hallo.LEAD and left >= -1 then self:ghostRound() return end
    end
    if C.HwHaunt then
        local _, left = self:nextHaunt()
        if left <= Hallo.LEAD and left >= -1 then Haunt:round() return end
    end
    -- each on its own: one that keeps throwing (me() nil mid-teleport…) used to skip the rest
    pcall(self.dailies, self)
    -- (2026-10-13, "don't break the tasks after the Halloween event") the needs that piled up during
    -- a round come FIRST: the optional chores (the crypt run = 2 trips, the cat, the lever, candy buys,
    -- boxes) wait for a loop with nothing to do — the crypt trip right after a round was where tasks
    -- broke. Never starved: 15 min at most; a cat whose 10-min cycle (50 candy) would end, or a round
    -- start, before the farm is free is fed anyway.
    local okJ, jobs = pcall(collectJobs)
    if okJ and type(jobs) == "table" and jobs[1] ~= nil and os.clock() - (self.choresAt or 0) < 900 then
        if self:catDue() then pcall(self.cat, self) end
        return
    end
    self.choresAt = os.clock()
    pcall(self.crypt, self)
    pcall(self.cat, self)
    pcall(Haunt.lever, Haunt)
    pcall(Haunt.buyPets, Haunt)
    pcall(Haunt.openBoxes, Haunt)
end

-- The stray cat not fed this cycle, and its cycle ends within 150 s or after the next queue starts.
-- A cycle = 600 s of server time (checked 2026-10-13: current_cycle_number = floor(GetServerTimeNow / 600)).
function Hallo:catDue()
    if not C.HwCat then return false end
    local M = self:mods()
    local okC, cyc = pcall(function() return M.CatC.current_cycle_number() end)
    local cat = me() and me().halloween_2026_stray_cat_manager
    if not (okC and type(cyc) == "number") or type(cat) ~= "table" or cat.last_fed_cycle == cyc then return false end
    local endsIn = (cyc + 1) * 600 - Workspace:GetServerTimeNow()
    return endsIn < 150 or self:budget() < endsIn
end

------------------------------------------------------------------------------------------------
-- PET PEN — claims its XP, keeps it full, logs every age-up (asked 2026-10-11)
--
--   IdleProgressionAPI, read live 2026-10-11: 4 places (CloudValues idle_progression
--   maxTotalPets) + 1 with the "pet_pen_extra_slot" gamepass. A pet in the pen earns 200 XP/h,
--   +600/h while you're online; a Full Grown earns nothing (maxAgePetsEarnXP false). A claim —
--   CommitAllProgression(true), what the game's own level-up screen sends — moves each pet by at
--   most ONE age and drops the XP past it, so it is claimed as soon as a pet can age
--   (age_up_pending) instead of piling up, and every 20 min anyway for the pen's bucks.
--   AddPet(unique) / RemovePet(unique) fill and empty a place.
--   Settings: PenClaim (on by default), AutoPen (Full Grown out, free places filled: PenPriority
--   kinds first, then the rarest and the closest to Full Grown; never PenExclude kinds, the
--   farm's pets, pets out with you or locked ones; eggs only with PenEggs). Every age-up — pen
--   or farm — goes to the board's age-up feed (stats.feed) and the log.
------------------------------------------------------------------------------------------------

do
    local Pen = { at = 0, claimAt = 0, feed = {}, cap = 4, claims = 0, refused = {} }
    Farm.Pen = Pen

    -- a line in the board's age-up feed, newest first (a / b: ages 1-6, 0 = egg)
    function Pen.note(name, from, to, src)
        table.insert(Pen.feed, 1, { t = os.time(), n = tostring(name), a = from, b = to, s = src })
        while #Pen.feed > 25 do table.remove(Pen.feed) end
    end

    function Pen:manager()
        local d = me()
        return d and d.idle_progression_manager
    end

    function Pen:active()
        local ipm = self:manager()
        return ipm and type(ipm.active_pets) == "table" and ipm.active_pets or {}
    end

    -- places: the cloud value + every extra-slot gamepass you own (game code: at its identity)
    function Pen:capacity()
        if os.clock() - (self.capAt or -1e9) < 300 then return self.cap end
        self.capAt = os.clock()
        local ok, n = G.asGame(function()
            local CV = G.load("CloudValues")
            local base = tonumber(CV:getValue("idle_progression", "maxTotalPets")) or 4
            local ids = CV:getValue("idle_progression", "extraSlotGamepassIds")
            local okG, GH = pcall(G.load, "ClientGamepassHelper")
            local extra = 0
            for _, id in ipairs(type(ids) == "table" and ids or {}) do
                if okG and GH.owns_gamepass(id) then extra += 1 end
            end
            return base + extra
        end)
        if ok and tonumber(n) then self.cap = tonumber(n) end
        return self.cap
    end

    local function listed(list, p)
        for i, label in ipairs(type(list) == "table" and list or {}) do
            if Kinds:idOf(label) == p.id or label == p.id or label == p.name then return i end
        end
        return nil
    end

    -- who may go in, best first: PenPriority order, pets before eggs, rarest, closest to grown
    function Pen:candidates(active)
        local out, busy = {}, {}
        for _, u in ipairs(Farm:uniques()) do busy[u] = true end
        for _, u in ipairs(equippedPets()) do busy[u] = true end
        for _, key in ipairs({ "Pet1", "Pet2" }) do                  -- your Pet 1 / Pet 2 picks too
            local okU, pu = pcall(function() return PetList:uniqueOf(C[key]) end)
            if okU and pu then busy[pu] = true end
        end
        for _, p in ipairs(allPets()) do
            if not active[p.unique] and not busy[p.unique] and not p.temp and (p.egg or p.age < 6)
               and (not p.egg or C.PenEggs) and not isLocked(p.item) and not listed(C.PenExclude, p)
               and os.clock() - (self.refused[p.unique] or -1e9) > 600 then
                out[#out + 1] = p
            end
        end
        table.sort(out, function(a, b)
            local pa, pb = listed(C.PenPriority, a) or 1000, listed(C.PenPriority, b) or 1000
            if pa ~= pb then return pa < pb end
            if a.egg ~= b.egg then return not a.egg end
            if a.rarity ~= b.rarity then return a.rarity > b.rarity end
            if a.age ~= b.age then return a.age > b.age end
            return tostring(a.unique) < tostring(b.unique)
        end)
        return out
    end

    -- ages before the claim, compared after: every step goes to the feed, the log and the
    -- session's age-up count (pen pets aren't farm pets: nothing counted twice)
    function Pen:claim()
        local before = {}
        for u in pairs(self:active()) do before[u] = petByUnique(u) end
        fire("IdleProgressionAPI/CommitAllProgression", true)
        self.claimAt, self.claims = os.clock(), self.claims + 1
        task.wait(2)
        local ups = 0
        for u, was in pairs(before) do
            local p = petByUnique(u)
            if p and not p.egg and not was.egg and p.age > was.age then
                ups += 1
                Pen.note(p.name, was.age, p.age, "pen")
                log(("pet pen: %s %s → %s"):format(p.name, AGE_NAME[was.age] or "?", AGE_NAME[p.age] or "?"))
                S.ageUps += p.age - was.age
                if p.age >= 6 then S.grown += 1 end
            elseif was.egg and (not p or not p.egg) then
                ups += 1
                Pen.note(was.name, 0, 1, "pen")
                log("pet pen: " .. was.name .. " hatched")
            end
        end
        return ups
    end

    -- Full Grown pets out (they earn nothing there), the free places filled
    function Pen:fill()
        local n = 0
        for u in pairs(self:active()) do
            local p = petByUnique(u)
            if p and not p.egg and p.age >= 6 then
                fire("IdleProgressionAPI/RemovePet", u)
                log("pet pen: " .. p.name .. " is Full Grown — taken out")
                task.wait(0.6)
            else
                n += 1
            end
        end
        local cap = self:capacity()
        if n >= cap then return end
        for _, p in ipairs(self:candidates(self:active())) do
            if n >= cap or not alive() then break end
            fire("IdleProgressionAPI/AddPet", p.unique)
            local t = 0
            while not self:active()[p.unique] and t < 3 do t += task.wait(0.25) end
            if self:active()[p.unique] then
                n += 1
                log(("pet pen: %s put in (%s)"):format(p.name, p.egg and "egg" or (AGE_NAME[p.age] or "?")))
            else
                self.refused[p.unique] = os.clock()            -- not taken: leave it 10 min
            end
        end
    end

    -- every 30 s from the worker
    function Pen:tick()
        if not (C.PenClaim or C.AutoPen) or os.clock() - self.at < 30 then return end
        self.at = os.clock()
        local ipm = self:manager()
        if not ipm then return end
        local pend = ipm.age_up_pending
        if C.PenClaim and next(self:active()) and (pend == true or (type(pend) == "table" and next(pend) ~= nil)
            or os.clock() - self.claimAt > 1200) then
            self:claim()
        end
        if C.AutoPen then self:fill() end
    end

    -- each pen pet's way to its next age (committed xp + what the pen earned since, through the
    -- game's own calculator) for the board's progress bars
    function Pen:details()
        local ipm = self:manager()
        local active = ipm and type(ipm.active_pets) == "table" and ipm.active_pets or {}
        if not next(active) then return {} end
        if not self.calc then
            local okC, Calc = pcall(require, RS.new.modules.IdleProgression.IdleProgressionCalculator)
            local okD, PDB = pcall(G.load, "PetProgressionDB")
            self.calc = { okC and Calc or nil, okD and PDB or nil }
        end
        local Calc, PDB = self.calc[1], self.calc[2]
        local now, out = Workspace:GetServerTimeNow(), {}
        for u, meta in pairs(active) do
            local p = petByUnique(u)
            if p then
                local row = { n = p.name, id = p.id, a = p.egg and 0 or p.age, x = p.xp }
                if p.neon then row.neon = true end
                if p.mega then row.mega = true end
                if Calc and type(meta) == "table" then
                    local ok, got = G.asGame(Calc.get_xp, now, meta, ipm.online_periods or {}, ipm.last_login or now)
                    if ok and tonumber(got) then row.x = math.floor(p.xp + tonumber(got)) end
                end
                if p.egg then
                    row.need = p.hatchAt
                elseif p.age < 6 and PDB then
                    local ok, per = G.asGame(PDB.get_xp_per_age, G.IDB.pets[p.id])
                    if ok and type(per) == "table" then row.need = tonumber(per[p.age]) end
                end
                out[#out + 1] = row
            end
        end
        table.sort(out, function(x, y) return x.n < y.n end)
        return out
    end
end

------------------------------------------------------------------------------------------------
-- COMET TRACK — live stats, inventory and remote templates (D:\Jeux\CometTrack)
--
--   Online (https://comet-track.vercel.app, Supabase): one board per KEY. The board is PREMIUM
--   (2026-10-12): the owner issues the keys (lifetime or N days) and the hub is given one:
--     getgenv().CometTrackKey = "ct_…"   before loading (Lite or Kaitun), or
--     Lite Premium tab › "Premium key (Comet Track)", or Kaitun CONFIG TrackKey.
--   getgenv().CometDashboard = true / false in the loader turns sending on / off for that run.
--   No key, an unknown / revoked or an expired key = free: nothing is sent online (the farm and
--   all of Halloween stay free). Every 10 s one rpc/ct_push(key, row): stats (currencies,
--   potions by kind, pets, pet pen, gains); every 60 s also the inventory (pets by kind with
--   ages / neon / mega / pen, other categories counted) and the settings (what this hub can
--   set); every 5 min a history point. The answer is the template this account follows; one
--   that changed since the last answer is applied (Lite: through the Rayfield flags, so the
--   window and the saved config follow; Kaitun: the switches, then the derived labels again).
--   Its answer also carries the dashboard's buttons for this account (Track:runCommand).
--   Local mode (no SupaURL): one POST to C.TrackURL every 10 s (CometTrack/start.bat).
--   Only executor HTTP calls (request / http_request / syn.request); nothing touches the game.
--   A dead address fails quietly and is retried.
------------------------------------------------------------------------------------------------

Track = { base = nil, sent = 0, fails = 0, last = "—", tplStamp = nil }
-- which build sent the stats (the board's stats.build): bump on every upload
Track.BUILD = "2026-10-13.6"
-- never set from a template: the connection itself, and the Kaitun's derived labels
Track.NO_TEMPLATE = { TrackOn = true, TrackURL = true, SupaURL = true, SupaKey = true, TrackKey = true,
    PetCount = true, HomeTasks = true }   -- HomeTasks: sleep / bath / toilet always go home   -- PetCount: the Lite's old "1 pet" default, replaced by PetsOut (2026-10-11)
-- the Kaitun computes these labels from its true / false switches: set the switches instead
if _G.CometKaitunState == S then
    for _, k in ipairs({ "PetCount", "WhenGrown", "PetOrder", "PetVersion", "PetFood", "PotionOnly",
                         "PotionTarget", "ReleaseBy", "TradeVersion", "ShopSort" }) do
        Track.NO_TEMPLATE[k] = true
    end
end
Track.NAMES = { PetKind = true, TradeKind = true, NeonKinds = true, PriorityTypes = true, ReleaseKinds = true,
    PenPriority = true, PenExclude = true,
    PotionKinds = true, Pet1 = true, Pet2 = true, HatchList = true, BuyEgg = true, ShopItem = true, FarmKinds = true }

function Track:req()
    return (syn and syn.request) or (http and http.request) or http_request or request
end

-- The board key: getgenv().CometTrackKey wins (set in the loader), else the saved setting.
function Track:key()
    local g = (getgenv and getgenv() or _G).CometTrackKey
    local k = tostring((type(g) == "string" and g ~= "" and g) or C.TrackKey or "")
    k = k:gsub("^%s+", ""):gsub("%s+$", "")
    return k
end

function Track:supa()
    return tostring(C.SupaURL or "") ~= "" and tostring(C.SupaKey or "") ~= "" and #self:key() >= 12
end

-- PREMIUM (2026-10-12) — what a Comet Track key unlocks. The farm and all of Halloween stay
-- free; a valid, unexpired key (rpc/ct_check) adds the dashboard (telemetry), remote control
-- from it (pause / resume / rejoin / stop), the Halloween extras (open Poltergeist Boxes, spend
-- it all in the last 12 h, Hauntlet team mode) and the Lite's gold theme. Asked at start, every
-- 10 min and as soon as the key changes (Track:start); no answer keeps what was known, so a
-- network blip never takes Premium away.
Track.PREMIUM_URL = "https://comet-track.vercel.app/#premium"

function Track:isPremium() return Track.premium ~= nil and Track.premium.ok == true end

function Track:checkPremium()
    local key = self:key()
    self.premiumKey = key
    if #key < 12 or tostring(C.SupaURL or "") == "" or tostring(C.SupaKey or "") == "" then
        self.premium, self.premiumErr, self.premiumNext = { ok = false, at = os.clock() }, nil, os.clock() + 600
        if S.paused and S.pausedBy == "remote" then
            S.paused, S.pausedBy = false, nil
            if type(S.onPause) == "function" then pcall(S.onPause, false) end
            log("Comet Track: no key any more — the dashboard's pause is lifted")
        end
        return
    end
    local body = self:enc({ p_key = key })
    local res = body and self:rest("POST", "rpc/ct_check", body)
    local code = res and tonumber(res.StatusCode) or 0
    local HS = game:GetService("HttpService")
    local okD, t = pcall(HS.JSONDecode, HS, tostring(res and res.Body or ""))
    if self:key() ~= key then return end                -- changed meanwhile: the next pass asks again
    if not (code >= 200 and code < 300 and okD and type(t) == "table") then
        self.premiumErr, self.premiumNext = true, os.clock() + 60
        return
    end
    local was = self.premium
    -- an old ct_check (no "premium" field) that says ok = true: that key is lifetime
    local p = { ok = t.ok == true and t.premium ~= false, label = type(t.label) == "string" and t.label or nil,
        expires_at = type(t.expires_at) == "string" and t.expires_at or nil,
        days = tonumber(t.days_left) and math.max(0, math.floor(tonumber(t.days_left))) or nil,
        expired = t.expired == true, at = os.clock() }
    p.invalid = not p.ok and not p.expired
    self.premium, self.premiumErr, self.premiumNext = p, nil, os.clock() + 600
    if p.ok then self.lostTold = nil end
    if not was or was.ok ~= p.ok or (was.expired == true) ~= p.expired then
        if p.ok then
            log("Comet Track: " .. self:premiumText() .. (p.label and (" — " .. p.label) or ""))
        else
            self:lost(p.expired and "expired" or "invalid")
        end
    end
end

-- The key stopped working (ct_check says so, or ct_push answered "premium expired" / "invalid
-- key"): the dashboard, remote control and the extras stop at once — the farm goes on. Told
-- once; asked again in 10 min (a renewed key comes back by itself) or when the key changes.
function Track:lost(kind)
    local p = self.premium or {}
    p.ok, p.at = false, os.clock()
    if kind == "expired" then p.expired = true else p.invalid = true end
    self.premium, self.premiumNext = p, os.clock() + 600
    -- the dashboard's pause can't be lifted from the dashboard any more: lifted now (the farm is free)
    if S.paused and S.pausedBy == "remote" then
        S.paused, S.pausedBy = false, nil
        if type(S.onPause) == "function" then pcall(S.onPause, false) end
        log("Comet Track: the dashboard's pause is lifted — Premium is off, the free farm goes on")
    end
    if self.lostTold then return end
    self.lostTold = true
    local msg = kind == "expired"
        and ("Premium expired%s — the dashboard, remote control and the Halloween extras are off (the farm "
            .. "and Halloween go on). Renew: %s"):format(p.expires_at and (" on " .. tostring(p.expires_at):sub(1, 10) .. " UTC") or "",
            Track.PREMIUM_URL)
        or "this key isn't valid (unknown or revoked) — free: nothing is sent online"
    log("Comet Track: " .. msg)
    notify("Premium", msg)
end

-- One line for the windows: "PREMIUM ✓ (lifetime)", "PREMIUM ✓ (12 days)", "PREMIUM expired…", "FREE".
function Track:premiumText()
    local p = self.premium
    if p == nil then
        if #self:key() < 12 then return "FREE" end
        return self.premiumErr and "PREMIUM ? (Comet Track not answering)" or "PREMIUM · checking…"
    end
    if p.ok then
        return "PREMIUM ✓ (" .. (p.days and (p.days .. (p.days == 1 and " day" or " days")) or "lifetime") .. ")"
    end
    if p.expired then
        return "PREMIUM expired" .. (p.expires_at and (" on " .. tostring(p.expires_at):sub(1, 10) .. " UTC") or "")
    end
    return p.invalid and "FREE (key not valid)" or "FREE"
end

-- A dashboard button for this account (Premium, Remote control on): pause / resume the farm (the
-- same switch as the Lite's ▶ FARMING: S.paused), rejoin this server, or stop the hub. Runs on
-- the push thread: GUI only through ui().
function Track:runCommand(c)
    if type(c) ~= "table" then return end
    local cmd, id = tostring(c.cmd or ""), tostring(c.id or "")
    self.cmdSeen = self.cmdSeen or {}
    if id ~= "" then
        if self.cmdSeen[id] then return end
        self.cmdSeen[id] = true
    end
    if cmd ~= "resume" and (not self:isPremium() or C.RemoteOn == false) then   -- resuming is always safe
        log(("Comet Track: dashboard \"%s\" ignored — %s"):format(cmd,
            self:isPremium() and "Remote control is off" or "remote control is Premium"))
        return
    end
    if cmd == "pause" then
        S.paused, S.pausedBy = true, "remote"
        log("Comet Track: paused from the dashboard")
        if type(S.onPause) == "function" then pcall(S.onPause, true) end
    elseif cmd == "resume" then
        S.paused, S.pausedBy = false, nil
        log("Comet Track: resumed from the dashboard")
        if type(S.onPause) == "function" then pcall(S.onPause, false) end
    elseif cmd == "rejoin" then
        if Crowd and not Crowd:public() then
            log("Comet Track: dashboard rejoin refused — private server (rejoin it by hand)")
            notify("Rejoin", "Private server: rejoin this account by hand")
            return
        end
        log("Comet Track: rejoin this server (from the dashboard)")
        task.spawn(function()
            -- never in the middle of a round, its queue or its way out: 5 min at most
            local w = 0
            while alive() and w < 300 and (Hallo.busy or Hallo.playing or Hallo.active) do w += task.wait(2) end
            if alive() and Crowd then pcall(Crowd.hop, Crowd, "remote: rejoin from the dashboard", true) end
        end)
    elseif cmd == "stop" then
        log("Comet Track: stopped from the dashboard")
        local h = SESSION.handle
        if type(h) == "table" and type(h.destroy) == "function" then ui(function() pcall(h.destroy) end) end
    else
        log("Comet Track: unknown dashboard command \"" .. cmd .. "\"")
    end
end

-- Supabase REST call → response table or nil
function Track:rest(method, path, body, prefer)
    local req = self:req()
    if type(req) ~= "function" then return nil end
    local key = tostring(C.SupaKey)
    local h = { ["Content-Type"] = "application/json", apikey = key, Authorization = "Bearer " .. key }
    if prefer then h.Prefer = prefer end
    local ok, res = pcall(req, { Url = tostring(C.SupaURL):gsub("/+$", "") .. "/rest/v1/" .. path,
        Method = method, Headers = h, Body = body })
    return ok and type(res) == "table" and res or nil
end

function Track:enc(t)
    local HS = game:GetService("HttpService")
    local ok, s = pcall(HS.JSONEncode, HS, t)
    return ok and s or nil
end

function Track:snap()
    local d = me()
    local now = { bucks = bucks(), potions = Potion:total(), pets = Farm.petCount(), candy = balance("candy_2026") }
    if not self.base then self.base = now end
    -- potions by kind (Age-Up, Tiny Age, Bonus Bucks…)
    local pots = {}
    for _, it in pairs(d and d.inventory.food or {}) do
        if G.Pots[it.id] then
            local e = G.IDB.food[it.id]
            local name = e and e.name or it.id
            pots[name] = (pots[name] or 0) + 1
        end
    end
    -- pets: totals, and the pet pen (idle_progression_manager.active_pets, keyed by unique)
    local pen = d and d.idle_progression_manager or {}
    local inPen = {}
    for u in pairs(type(pen.active_pets) == "table" and pen.active_pets or {}) do inPen[u] = true end
    local pc = { total = 0, eggs = 0, neon = 0, mega = 0, fg = 0 }
    local penNames = {}
    for _, p in ipairs(allPets()) do
        if p.egg then pc.eggs += 1 else pc.total += 1 end
        if p.mega then pc.mega += 1 elseif p.neon then pc.neon += 1 end
        if p.age >= 6 and not p.egg then pc.fg += 1 end
        if inPen[p.unique] then penNames[#penNames + 1] = p.name .. " (" .. (AGE_NAME[p.age] or "?") .. ")" end
    end
    local pet, petIds = nil, {}
    for _, u in pairs(Farm and Farm.slots or {}) do
        local p = petByUnique(u)
        if p then
            pet = (pet and (pet .. ", ") or "") .. p.name .. " (" .. (AGE_NAME[p.age] or ("age " .. p.age)) .. ")"
            petIds[#petIds + 1] = p.id
        end
    end
    local log3 = {}
    for i = 1, math.min(3, #S.log) do log3[i] = S.log[i] end
    local function pair(k) return { start = self.base[k], now = now[k] } end
    return {
        acc = LP.Name, uid = LP.UserId, runId = self.runId, exec = self.execName, build = Track.BUILD,
        hub = (_G.CometKaitunState == S) and "Kaitun" or "Lite",
        job = game.JobId, place = game.PlaceId, status = S.status,
        remote = Track:isPremium() and C.RemoteOn ~= false,
        vip = (Crowd and Crowd.public and not Crowd:public()) and true or false,
        up = math.floor(os.clock() - S.start), fps = self.fps,
        bucks = pair("bucks"), potions = pair("potions"), pets = pair("pets"),
        -- candy earned and spent apart: a 120k pet bought used to show as "-120 000 candy"
        candy = { start = (S.candyTally and S.candyTally.start) or self.base.candy, now = now.candy,
                  gain = S.candyTally and S.candyTally.gain, spent = S.candyTally and S.candyTally.lost },
        mem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb()),
        white = Hallo.whiteout(), playing = Hallo.playing == true,
        currency = { bucks = now.bucks, candy = now.candy, tickets = balance("pet_recycler_tickets_2026"),
                     stars = balance("stars") },
        potionKinds = pots, petCount = pc,
        pen = { n = #penNames, pets = penNames, ageUpPending = pen.age_up_pending == true,
                cap = Farm.Pen and Farm.Pen.cap or nil, list = Farm.Pen and Farm.Pen:details() or nil,
                auto = C.AutoPen == true, claim = C.PenClaim == true, claims = Farm.Pen and Farm.Pen.claims or 0 },
        feed = Farm.Pen and Farm.Pen.feed or nil,
        ageUps = S.ageUps or 0, grown = S.grown or 0, pet = pet, petIds = petIds,
        ghost = { rounds = Hallo.rounds or 0, candy = Hallo.roundCandy or 0 },
        haunt = { rounds = Haunt.rounds or 0, candy = Haunt.candy or 0, best = Haunt.best or 0 },
        template = self.tplName, log = log3, online = d ~= nil,
    }
end

-- Every pet kind with ages / neon / mega / pen, and every other category counted.
function Track:inventory()
    local d = me()
    if not d then return nil end
    local pen = {}
    local ipm = d.idle_progression_manager
    for u in pairs(ipm and type(ipm.active_pets) == "table" and ipm.active_pets or {}) do pen[u] = true end
    local byKind = {}
    for _, e in pairs(d.inventory.pets or {}) do
        local db = G.IDB.pets[e.id]
        local pr = e.properties or {}
        local a = byKind[e.id]
        if not a then
            a = { id = e.id, name = db and db.name or e.id, rarity = db and db.rarity or "?",
                  egg = (db and db.is_egg) == true, n = 0, neon = 0, mega = 0, fg = 0, pen = 0,
                  ages = { 0, 0, 0, 0, 0, 0 } }
            byKind[e.id] = a
        end
        a.n += 1
        local age = math.clamp(math.floor(tonumber(pr.age) or 1), 1, 6)
        a.ages[age] += 1
        if pr.mega_neon then a.mega += 1 elseif pr.neon then a.neon += 1 end
        if age == 6 then a.fg += 1 end
        if pen[e.unique] then a.pen += 1 end
    end
    local pets = {}
    for _, a in pairs(byKind) do pets[#pets + 1] = a end
    table.sort(pets, function(x, y) return x.n > y.n end)
    local items = {}
    for cat, t in pairs(d.inventory) do
        if cat ~= "pets" and type(t) == "table" then
            local c = {}
            for _, it in pairs(t) do
                local id = it.id or it.kind
                if id then c[id] = (c[id] or 0) + 1 end
            end
            local arr = {}
            for id, n in pairs(c) do
                local e = G.IDB[cat] and G.IDB[cat][id]
                arr[#arr + 1] = { id = id, name = e and e.name or id, n = n,
                                  potion = (cat == "food" and G.Pots[id]) and true or nil }
            end
            table.sort(arr, function(x, y) return x.n > y.n end)
            items[cat] = arr
        end
    end
    return { pets = pets, items = items, at = os.time() }
end

-- What this hub can be told to change: plain values and lists of names.
-- How each setting looks on the site's template editor: its name in the hub window, and the
-- choices it takes (dropdown options = the kinds you own, potion / egg / shop lists…), so
-- nothing has to be typed there. Lite: read off the Rayfield elements. Kaitun: kind lists
-- from your pets, fixed lists from its CONFIG vocabulary.
function Track:meta()
    local out = {}
    -- the Lite's own window only: in the Kaitun "Rayfield" is a GLOBAL, so another hub's library
    -- left in the executor's shared env was read here (and in apply, its switches flipped)
    local flags = _G.CometKaitunState ~= S and type(Rayfield) == "table" and Rayfield.Flags
    if flags then
        for k, f in pairs(flags) do
            if type(f) == "table" and C[k] ~= nil and not self.NO_TEMPLATE[k] then
                local m = { name = f.Name }
                if type(f.Options) == "table" then
                    m.kind = f.MultipleOptions and "multi" or "one"
                    local o = {}
                    for i, x in ipairs(f.Options) do if i > 300 then break end o[i] = tostring(x) end
                    m.options = o
                elseif type(f.Range) == "table" then
                    m.kind, m.min, m.max, m.step = "range", f.Range[1], f.Range[2], f.Increment
                end
                out[k] = m
            end
        end
    else
        local kinds = {}
        for i, a in ipairs(Kinds and Kinds.all or {}) do
            if i > 300 then break end
            kinds[#kinds + 1] = a.label
        end
        for k in pairs(self.NAMES) do
            if C[k] ~= nil and (k:find("Kind") or k == "PriorityTypes" or k == "PenPriority" or k == "PenExclude") then
                out[k] = { kind = type(C[k]) == "table" and "multi" or "one", options = kinds }
            end
        end
        if type(K) == "table" and type(K.VOCAB) == "table" then
            for k, v in pairs(K.VOCAB) do
                if C[k] ~= nil and type(v) == "table" then
                    out[k] = { kind = type(C[k]) == "table" and "multi" or "one", options = v }
                end
            end
        end
    end
    return out
end

-- The executor this account runs on (the board shows it).
function Track:executor()
    local ok, a, b = pcall(function() return (identifyexecutor or getexecutorname)() end)
    if ok and a then return tostring(a) .. (b and (" " .. tostring(b)) or "") end
    return "?"
end

function Track:settings()
    local out = {}
    for k, v in pairs(C) do
        if type(k) == "string" and not self.NO_TEMPLATE[k] then
            local t = type(v)
            if t == "boolean" or t == "number" or t == "string" then
                out[k] = v
            elseif t == "table" and #v <= 80 then
                local list, ok = {}, true
                for i, x in ipairs(v) do if type(x) == "string" then list[i] = x else ok = false end end
                if ok and next(v) == nil or (ok and #list == #v) then out[k] = list end
            end
        end
    end
    return out
end

function Track.same(a, b)
    if type(a) ~= type(b) then return false end
    if type(a) ~= "table" then return a == b end
    if #a ~= #b then return false end
    for i = 1, #a do if a[i] ~= b[i] then return false end end
    return true
end

-- Apply a template's overrides that differ from what we run now.
function Track:apply(name, set, why)
    local changed, names = {}, false
    local flags = _G.CometKaitunState ~= S and type(Rayfield) == "table" and Rayfield.Flags   -- see Track:meta
    self.applying = true            -- master switches don't cascade over the values being set
    for k, v in pairs(type(set) == "table" and set or {}) do
        local cur = C[k]
        if not self.NO_TEMPLATE[k] and cur ~= nil and type(cur) == type(v) and not self.same(cur, v) then
            local f = flags and flags[k]
            if f and type(f.Set) == "function" then
                local arg = v
                if f.Type == "Dropdown" and type(v) ~= "table" then arg = { v } end
                if f.Type == "Input" then arg = tostring(v) end
                ui(function() Track.applying = true pcall(f.Set, f, arg) Track.applying = false end)
            end
            if type(v) == "table" then
                local copy = {}
                for i, x in ipairs(v) do copy[i] = x end
                C[k] = copy
            else
                C[k] = v
            end
            changed[#changed + 1] = k
            if self.NAMES[k] then names = true end
        end
    end
    self.applying = false
    if #changed == 0 then return end
    if K and type(K) == "table" and type(K.derive) == "function" then
        pcall(K.derive)
        if names and type(K.resolve) == "function" then pcall(K.resolve, false) end
    end
    log((why or ("Comet Track: template \"%s\""):format(name)) .. " set " .. table.concat(changed, ", "))
end

-- The answer (local board or ct_push) names the template this account follows: apply it
-- when it changed since the last answer. ct_push also hands over the dashboard's buttons for
-- this account (undelivered, last 10 min, oldest first): run first.
function Track:takeTemplate(body)
    local HS = game:GetService("HttpService")
    local okD, t = pcall(HS.JSONDecode, HS, tostring(body or ""))
    if not (okD and type(t) == "table") then return end
    if type(t.commands) == "table" then
        for _, c in ipairs(t.commands) do pcall(self.runCommand, self, c) end
    end
    if not t.template then return end
    local stamp = tostring(t.template) .. "@" .. tostring(t.updated_at)
    self.tplName = t.template
    if stamp ~= self.tplStamp then
        self.tplStamp = stamp
        pcall(self.apply, self, t.template, t.settings)
    end
end

function Track:pushSupa(tick)
    local s = self:snap()
    local row = { acc = s.acc, uid = s.uid, hub = s.hub, run_id = s.runId, stats = s }
    if tick % 6 == 0 then
        row.inventory = self:inventory()
        row.settings = self:settings()
        row.settings.__meta = self:meta()
    end
    local body = self:enc({ p_key = self:key(), p_row = row, p_snapshot = tick % 30 == 0 })
    if not body then return false end
    local res = self:rest("POST", "rpc/ct_push", body)
    local code = res and tonumber(res.StatusCode) or 0
    if code >= 200 and code < 300 then
        self:takeTemplate(res.Body)
        return true
    end
    self.why = res and tostring(res.Body):sub(1, 120) or "no answer"
    -- the key ran out / was revoked since the last check: nothing more is sent (told once)
    local said = res and tostring(res.Body) or ""
    if said:find("premium expired", 1, true) then self:lost("expired")
    elseif said:find("invalid key", 1, true) then self:lost("invalid") end
    return false
end

-- Local board (CometTrack/start.bat): the same row as Supabase; the answer carries the
-- template this account follows, applied like the online one.
function Track:pushLocal(tick)
    local req = self:req()
    local s = self:snap()
    local row = { acc = s.acc, uid = s.uid, hub = s.hub, run_id = s.runId, stats = s }
    if tick % 6 == 0 then
        row.inventory = self:inventory()
        row.settings = self:settings()
        row.settings.__meta = self:meta()
    end
    local body = self:enc(row)
    if not (body and type(req) == "function") then return false end
    local ok, res = pcall(req, { Url = C.TrackURL, Method = "POST",
        Headers = { ["Content-Type"] = "application/json" }, Body = body })
    local code = ok and type(res) == "table" and tonumber(res.StatusCode) or 0
    if code >= 200 and code < 300 then self:takeTemplate(res.Body) end
    return code >= 200 and code < 300
end

-- Every 10 s, telemetry on or off: CometHub/last_<account>.txt = what this client was doing
-- (memory, a white screen, a round, the status, the log) — after a client dies, it says why.
function Track:crumb()
    if not (writefile and isfolder and makefolder) then return end
    pcall(function()
        if not isfolder("CometHub") then makefolder("CometHub") end
        local mem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb())
        writefile("CometHub/last_" .. LP.Name .. ".txt", ("%s up=%ds mem=%dMB candy=%d white=%s playing=%s cam=%s status=%s\n%s")
            :format(os.date("%Y-%m-%d %H:%M:%S"), math.floor(os.clock() - S.start), mem, Hallo:candy(),
                tostring(Hallo.whiteout()), tostring(Hallo.playing), tostring(Workspace.CurrentCamera and Workspace.CurrentCamera.CameraType.Name),
                tostring(S.status), table.concat(S.log, "\n")))
    end)
end

function Track:push(tick)
    -- getgenv().CometDashboard (set in the loader) wins over the live-stats toggle (Premium tab / TrackOn)
    local dash = (getgenv and getgenv() or _G).CometDashboard
    if dash == false or (dash ~= true and not C.TrackOn) then return end
    if type(self:req()) ~= "function" then
        if not self.warned then self.warned = true log("Comet Track: this executor has no HTTP request function") end
        return
    end
    if tostring(C.SupaURL or "") ~= "" and #self:key() < 12 and not self.noKeyTold then
        self.noKeyTold = true
        log("Comet Track: no Premium key — the farm and Halloween are free; the online dashboard is Premium ("
            .. Track.PREMIUM_URL .. ")")
    end
    local good
    if self:supa() then
        -- the dashboard is Premium: nothing goes online without a valid, unexpired key (the
        -- first ct_check answer may still be on its way — at start, after a new key: 10 s at most)
        local t0 = os.clock()
        while self.premium == nil and self.checkingAt and os.clock() - t0 < 10 and alive() do task.wait(0.25) end
        if not self:isPremium() then return end
        good = self:pushSupa(tick)
    elseif tostring(C.SupaURL or "") == "" and tostring(C.TrackURL or "") ~= "" then
        good = self:pushLocal(tick)                  -- your own board on this PC (start.bat, SupaURL = "")
    else
        return
    end
    if good then
        self.sent += 1
        if self.fails >= 3 then log("Comet Track: connected again") end
        self.fails, self.last = 0, os.date("%H:%M:%S")
    else
        self.fails += 1
        if self.fails == 3 then
            log("Comet Track: no answer (" .. (self:supa() and ("Supabase: " .. tostring(self.why)) or tostring(C.TrackURL)) .. ")")
        end
    end
end

function Track:start()
    if self.started then return end
    self.started = true
    self.runId = game:GetService("HttpService"):GenerateGUID(false)
    self.execName = self:executor()
    local RunS = game:GetService("RunService")
    task.spawn(function()
        local tick = 0
        while alive() do
            -- frames in one second = the real FPS (the client may be capped at 3)
            local t0, n = os.clock(), 0
            while os.clock() - t0 < 1 and alive() do RunS.Heartbeat:Wait() n += 1 end
            self.fps = math.floor(n / math.max(0.001, os.clock() - t0) + 0.5)
            -- a client the server dropped (kicked, "joined from another device", lost
            -- connection) keeps running scripts with frozen data: one last row says so, then
            -- nothing more — the board shows it offline instead of live with stale numbers
            local nc = game:FindFirstChildOfClass("NetworkClient")
            if nc and not nc:FindFirstChildOfClass("ClientReplicator") then
                if not self.saidGone then
                    self.saidGone = true
                    local okM, m = pcall(function() return game:GetService("GuiService"):GetErrorMessage() end)
                    S.status = "Disconnected" .. ((okM and m and m ~= "") and (": " .. m) or "")
                    pcall(self.push, self, tick)
                end
            else
                self.saidGone = false
                pcall(self.crumb, self)
                -- Premium: asked at start, every 10 min and as soon as the key changes (its own
                -- thread: an HTTP call may hang); a new key forgets the old one's answer at once
                local key = self:key()
                if key ~= self.premiumKey then
                    self.premium, self.premiumNext, self.premiumKey = nil, 0, key
                    self.lostTold, self.noKeyTold = nil, nil
                end
                if os.clock() >= (self.premiumNext or 0) and not (self.checkingAt and os.clock() - self.checkingAt < 30) then
                    local at = os.clock()
                    self.checkingAt = at
                    task.spawn(function()
                        pcall(self.checkPremium, self)
                        if self.checkingAt == at then self.checkingAt = nil end
                    end)
                end
                -- one request that never answers used to stop reporting for the whole session (and
                -- read as a crash on the board): sent on its own thread, a new one 30 s later anyway
                if not (self.inflightAt and os.clock() - self.inflightAt < 30) then
                    local stamp = os.clock()
                    self.inflightAt = stamp
                    task.spawn(function()
                        pcall(self.push, self, tick)
                        if self.inflightAt == stamp then self.inflightAt = nil end
                    end)
                end
            end
            tick += 1
            local w = 0
            while w < 9 and alive() do w += task.wait(1) end
        end
    end)
end


------------------------------------------------------------------------------------------------
-- SAVER — your settings, per account, even when Rayfield's own save doesn't work
--
--   Settings › "Save my settings" (on by default): every 5 s, when something changed, every
--   plain setting goes to CometHub/AdoptMe_settings_<account>.json; at start they are put back
--   through the Rayfield flags (the window shows them). Then a loader's
--   getgenv().CometConfig = { BabyFarm = true, ... } is applied on top, and a Comet Track
--   template on top of that. The Kaitun keeps its CONFIG table: nothing here runs there.
------------------------------------------------------------------------------------------------

Saver = { last = nil }

function Saver:off() return _G.CometKaitunState == S or not (writefile and readfile and isfile) end
function Saver:file() return "CometHub/AdoptMe_settings_" .. LP.Name .. ".json" end

function Saver:save()
    if self:off() then return end
    local t = C.SaveSettings and Track:settings() or { SaveSettings = false }
    if C.SaveSettings then t.TrackKey = C.TrackKey end
    local body = Track:enc(t)
    if not body or body == self.last then return end
    local ok = pcall(function()
        if isfolder and makefolder and not isfolder("CometHub") then makefolder("CometHub") end
        writefile(self:file(), body)
    end)
    if ok then self.last = body end
end

function Saver:load()
    if not self:off() then
        local okR, body = pcall(function() return isfile(self:file()) and readfile(self:file()) or nil end)
        local HS = game:GetService("HttpService")
        local okD, t = pcall(HS.JSONDecode, HS, tostring(body or ""))
        if okR and body and okD and type(t) == "table" then
            Track:apply("saved", t.SaveSettings == false and { SaveSettings = false } or t, "Saved settings:")
            if type(t.TrackKey) == "string" and t.TrackKey ~= "" and tostring(C.TrackKey or "") == "" then
                C.TrackKey = t.TrackKey
                local f = type(Rayfield) == "table" and Rayfield.Flags and Rayfield.Flags.TrackKey
                if f and f.Set then pcall(f.Set, f, t.TrackKey) end
            end
            self.last = body
        end
    end
    local g = (getgenv and getgenv() or _G).CometConfig
    if type(g) == "table" then Track:apply("loader", g, "Loader CometConfig:") end
end

function Saver:start()
    task.delay(5, function()                  -- after Rayfield's own load (it runs at +4 s)
        pcall(self.load, self)
        while alive() do
            task.wait(5)
            pcall(self.save, self)
        end
    end)
end
------------------------------------------------------------------------------------------------
-- LURE — collect what your lure caught and bait it again (asked 2026-10-12).
--   Read in the game (LureUseHelper, HouseInterior.Furniture): a lure is a house furniture piece
--   (Box Lure lures_2023_normal_lure: free, 1 per house; Cozy Home Lure = a Robux gamepass, never
--   bought). No lure remote: everything is HousingAPI/ActivateFurniture(LP, unique, "UseBlock",
--   data, character) — data = { bait_unique } to bait, false to collect (what a tap sends).
--   State: ClientData lures_2023_lure_manager.lures_map[*] = { lure_kind, bait_kind,
--   lure_start_timestamp, finished, reward = { category, kind } }, readable anywhere; the time
--   is IDB.food[bait_kind].lure_time (Ice Soup / Campfire Cookie: infinite, 4 h). The piece's
--   unique is only seen while at home: remembered then, used from anywhere after (like the far
--   crib — not verified for the lure: 2 uses that change nothing = at home only for 30 min).
--   NEVER a bait over a running lure; one-time baits only with "Also use one-time baits".
------------------------------------------------------------------------------------------------
do
    local Lure = { at = 0, claims = 0, baits = 0, misses = 0, farOff = 0, homeAt = -1e9, said = {}, last = "—", offUntil = {} }
    Farm.Lure = Lure
    Lure.KINDS = { lures_2023_normal_lure = "Box Lure", lures_2023_cozy_home_lure = "Cozy Home Lure" }

    function Lure:entry(kind)
        local m = me() and me().lures_2023_lure_manager
        local map = type(m) == "table" and m.lures_map
        for _, v in pairs(type(map) == "table" and map or {}) do
            if type(v) == "table" and v.lure_kind == kind then return v end
        end
    end
    function Lure:left(e)
        local b = e and G.IDB.food[e.bait_kind]
        local t, s = b and tonumber(b.lure_time), e and tonumber(e.lure_start_timestamp)
        return (t and s) and (s + t - Workspace:GetServerTimeNow()) or nil
    end
    function Lure:say(key, msg) if not self.said[key] then self.said[key] = true log(msg) end end

    -- at home: every lure piece of this house (unique + use block); a free Box Lure placed if none
    function Lure:remember()
        if not inOwnHouse() then return end
        local root = Workspace:FindFirstChild("HouseInteriors")
        local ok, list = pcall(G.FMT.get_furniture_models_list)
        if not (root and ok and type(list) == "table") then return end
        local pieces, n = {}, 0
        for _, m in ipairs(list) do
            local k = m:GetAttribute("furniture_kind")
            if Lure.KINDS[k] and m:IsDescendantOf(root) then
                local ub = m:FindFirstChild("UseBlocks")
                local b = ub and (ub:FindFirstChild("UseBlock") or ub:FindFirstChildWhichIsA("BasePart"))
                if b then pieces[k] = { unique = m:GetAttribute("furniture_unique"), block = b.Name } n += 1 end
            end
        end
        if n == 0 and C.LurePlace ~= false and (C.AutoLure or C.LureClaim) and not self.placeTried then
            self.placeTried = true                                 -- once a session
            local cf = Home:placement("lures_2023_normal_lure", 7)
            local okB, res = false, nil
            if cf then okB, res = invoke("HousingAPI/BuyFurnitures", { { kind = "lures_2023_normal_lure", properties = { cframe = cf } } }) end
            if okB and type(res) == "table" and res.success == true then
                log("Lure: placed a free Box Lure in your house")
                task.wait(1.5)
                return self:remember()
            end
            self:say("place", "Lure: couldn't place a Box Lure (no floor space?)")
        end
        local first = self.far == nil
        self.far = { pieces = pieces, house = Home:houseId() }
        pcall(function() local g = getgenv() g.CometLure = g.CometLure or {} g.CometLure[LP.Name] = self.far end)
        if first then log(n > 0 and ("Lure: %d lure(s) in your house"):format(n) or "Lure: no lure in this house") end
    end
    function Lure:known()
        if not self.far then pcall(function() self.far = (getgenv().CometLure or {})[LP.Name] end) end
        local f = self.far
        if f and f.house ~= Home:houseId() then self.far, f = nil, nil end      -- another house is active
        return f
    end

    -- infinite baits first (they come back), one-time ones only with C.LureConsumable; never locked
    function Lure:bait()
        local best
        for u, it in pairs(me() and me().inventory and me().inventory.food or {}) do
            local e = G.IDB.food[it.id or it.kind]
            if e and e.is_lure_bait and not isLocked(it) and (e.is_infinite_bait or C.LureConsumable) then
                local score = (e.is_infinite_bait and 0 or 1e6) + (tonumber(e.lure_time) or 1e5)
                if not best or score < best.score then best = { unique = it.unique or u, name = e.name or it.id, score = score } end
            end
        end
        return best
    end

    -- one furniture use (it may yield: own thread + deadline); true once ClientData changed
    function Lure:use(piece, data, changed)
        local c = LP.Character
        if not (c and c.Parent) then return false end
        task.spawn(function() invoke("HousingAPI/ActivateFurniture", LP, piece.unique, piece.block, data, c) end)
        local t0 = os.clock()
        while os.clock() - t0 < 5 do
            if changed() then return true end
            task.wait(0.25)
        end
        return changed()
    end
    function Lure.rewardName(r)
        if type(r) ~= "table" then return "a reward" end
        if r.category == "currency" and r.kind == "money" then return (r.amount and (tostring(r.amount) .. " ") or "") .. "bucks" end
        local e = G.IDB[r.category] and G.IDB[r.category][r.kind]
        return (e and e.name or tostring(r.kind)) .. (r.category == "pets" and " (pet)" or "")
    end
    function Lure:due(kind)
        if os.clock() < (self.offUntil[kind] or 0) then return false end
        local e = self:entry(kind)
        if e then return C.LureClaim ~= false and (e.finished == true or (self:left(e) or 1) <= -10) end
        return C.AutoLure ~= false and self:bait() ~= nil
    end
    -- from afar it isn't verified: 2 uses in a row that change nothing = at home only for 30 min
    function Lure:miss(far, kind)
        self.misses += 1
        if self.misses < 2 then return end
        self.misses = 0
        if far then
            self.farOff = os.clock() + 1800
            log("Lure: using it from afar didn't work — done at home for 30 min")
        else
            -- refused at home too (pet inventory full, a bait it won't take…): left alone 2 h
            self.offUntil[kind or "?"] = os.clock() + 7200
            log("Lure: the game refuses it even at home — left alone for 2 h")
        end
    end

    -- the worker's extras (every 20 s at most)
    function Lure:tick(force)
        if not (C.AutoLure or C.LureClaim) then return end
        if not force and os.clock() < self.at then return end
        self.at = os.clock() + 20
        local home = inOwnHouse()
        if home then self:remember() end
        local f = self:known()
        if not f then
            -- never seen this house's lure yet: one trip home every 20 min at most
            if os.clock() - self.homeAt > 1200 and Hallo:budget() > 60 then
                self.homeAt = os.clock()
                if goTo("housing") then task.wait(1.5) return self:tick(true) end
            end
            return
        end
        local far = not inOwnHouse()
        if far and os.clock() < self.farOff then
            for kind in pairs(f.pieces) do
                if self:due(kind) and os.clock() - self.homeAt > 600 and Hallo:budget() > 60 then
                    self.homeAt = os.clock()
                    if goTo("housing") then task.wait(1.5) return self:tick(true) end
                    return
                end
            end
            return
        end
        for kind, piece in pairs(f.pieces) do
            if os.clock() < (self.offUntil[kind] or 0) then continue end
            local e = self:entry(kind)
            -- 1) Collect Reward (false = what a tap sends while a lure is there; harmless while it runs)
            if e and C.LureClaim ~= false and (e.finished or (self:left(e) or 1) <= -10) then
                local was = e
                if self:use(piece, false, function() return self:entry(kind) == nil end) then
                    self.claims, self.misses = self.claims + 1, 0
                    self.last = "collected " .. Lure.rewardName(was.reward)
                    log(("Lure: collected %s from your %s"):format(Lure.rewardName(was.reward), Lure.KINDS[kind]))
                    task.wait(1.5)
                elseif was.finished then
                    self:miss(far, kind)
                end
                e = self:entry(kind)
            end
            -- 2) Place Bait — ONLY when no lure is running in this piece
            if not e and C.AutoLure ~= false and C.AutoLure then
                local b = self:bait()
                if not b then
                    self:say("nobait", "Lure: no lure bait in your backpack (Ice Soup / Campfire Cookie are reusable)")
                else
                    self.said.nobait = nil
                    if self:use(piece, { bait_unique = b.unique }, function() return self:entry(kind) ~= nil end) then
                        self.baits, self.misses = self.baits + 1, 0
                        self.last = "baited with " .. tostring(b.name)
                        log(("Lure: %s baited with %s (ready in %d min)"):format(Lure.KINDS[kind], tostring(b.name),
                            math.floor((self:left(self:entry(kind)) or 0) / 60)))
                    else
                        self:miss(far, kind)
                    end
                end
            end
        end
    end

    -- the Rewards tab button: home if this house's lure was never seen, then collect + bait now
    function Lure:now()
        Lock:run(function()
            if not inOwnHouse() and not self:known() then goTo("housing") task.wait(2) end
            self:tick(true)
        end)
        return self:status()
    end

    function Lure:status()
        local parts = {}
        for _, v in pairs((me() and me().lures_2023_lure_manager or {}).lures_map or {}) do
            if type(v) == "table" then
                local left = self:left(v)
                parts[#parts + 1] = v.finished and "reward waiting"
                    or (left and left > 0 and ("%dh%02dm left"):format(math.floor(left / 3600), math.floor(left % 3600 / 60)))
                    or "almost ready"
            end
        end
        if #parts == 0 then
            local f = self:known()
            parts[1] = f == nil and "not seen yet (it's found on a visit home)" or (next(f.pieces) and "empty" or "no lure in this house")
        end
        return ("%s · collected %d · baited %d · last: %s"):format(table.concat(parts, ", "), self.claims, self.baits, self.last)
    end
end

------------------------------------------------------------------------------------------------
-- DAILY CLAIMS — on their own, not only during Halloween (asked 2026-10-12: "claim daily quest").
--   Daily quests: every dailies tab (vanilla, halloween_2026, 2d_tuesdays, admin_abuse…) except
--   "alerts" (notifications only) — DailiesNetService.try_to_claim_daily_rewards / _tab_reward.
--   Daily login reward (bucks + stars): StarRewardsNet.Claim — only while star_rewards_manager
--   .claimed == false, the one moment the game itself sends it. Achievements: completed and not
--   yet claimed → AchievementsAPI/ClaimReward(kind). Mailbox gifts at home: ClaimAllDeliveries.
--   Nothing here ever spends (no star / battle-pass purchase, no gamepass).
------------------------------------------------------------------------------------------------
do
    local Claims = { dayAt = 0, tabAt = {}, starAt = 0, achAt = 0, mailAt = 0, M = {} }
    Farm.Claims = Claims
    function Claims:mod(n)
        if self.M[n] == nil or (self.M[n] == false and os.clock() - (self.modAt or 0) > 60) then
            self.modAt = os.clock()
            local ok, v = G.asGame(function()
                if n == "Daily" then return require(RS.new.modules.Dailies.DailiesNetService) end
                if n == "Star" then return require(RS.new.modules.StarRewards.StarRewardsNet) end
                if n == "Ach" then return require(RS.new.modules.Achievements.AchievementsDB) end
            end)
            self.M[n] = ok and type(v) == "table" and v or false
        end
        return self.M[n] or nil
    end

    function Claims:dailies()
        if C.ClaimDailies == false or os.clock() - self.dayAt < 45 then return end
        self.dayAt = os.clock()
        local d, Daily = me(), self:mod("Daily")
        local tabs = d and d.dailies_manager and d.dailies_manager.serialized_tabs
        if type(tabs) ~= "table" or not Daily then return end
        local keys0 = Hallo:keys()
        for name, tab in pairs(tabs) do
            if type(tab) == "table" and name ~= "alerts" and name ~= "tutorial" then
                local any = false
                for _, v in pairs(tab.active_dailies or {}) do
                    local st = type(v) == "table" and v.state
                    if st and (tonumber(st.steps_completed) or 0) >= (tonumber(st.steps_to_complete) or math.huge) then any = true end
                end
                if any then Hallo.call(10, Daily.try_to_claim_daily_rewards, name) task.wait(1.2) end
                local fresh = ((me().dailies_manager or {}).serialized_tabs or {})[name] or tab
                if (tonumber(fresh.total_dailies_completed_today) or 0) >= 3 and not fresh.reward_claimed
                   and os.clock() > (self.tabAt[name] or 0) then
                    self.tabAt[name] = os.clock() + 600                 -- a refused claim isn't retried every 45 s
                    Hallo.call(10, Daily.try_to_claim_tab_reward, name)
                    log("Dailies: claimed the " .. name .. " tab reward")
                    task.wait(1.2)
                end
            end
        end
        local keys1 = Hallo:keys()
        if keys1 > keys0 then log(("Halloween: +%d crypt key(s) from dailies"):format(keys1 - keys0)) end
    end

    function Claims:stars()
        local s = me() and me().star_rewards_manager
        if C.ClaimStars == false or type(s) ~= "table" or s.claimed ~= false or os.clock() < self.starAt then return end
        self.starTries = self.starTries or 0
        if self.starTries >= 3 then return end
        self.starAt = os.clock() + 30
        local Star = self:mod("Star")
        if not (Star and Star.Claim) then return end
        local before = tonumber(me().stars) or 0
        G.asGame(function() Star.Claim:fire_server() end)
        task.wait(2)
        local d = me()
        local s2 = d and d.star_rewards_manager
        if (type(s2) == "table" and s2.claimed ~= false) or (tonumber(d and d.stars) or 0) > before then
            self.starTries = 0
            log(("Daily login reward claimed (stars %d → %d, streak %s)"):format(before, tonumber(d and d.stars) or before,
                tostring(d and d.daily_login_manager and d.daily_login_manager.streak or "?")))
        else
            self.starTries += 1
            self.starAt = os.clock() + 600 * 2 ^ self.starTries
            if self.starTries >= 3 then log("Daily login reward: the game didn't take the claim — left alone this session") end
        end
    end

    function Claims:achievements()
        if C.ClaimAchievements == false or os.clock() < self.achAt then return end
        self.achAt = os.clock() + 120
        local am, DB = me() and me().achievements_manager, self:mod("Ach")
        if type(am) ~= "table" or not (DB and type(DB.entries) == "table") then return end
        self.tried = self.tried or {}
        local sent = {}
        for kind, e in pairs(DB.entries) do
            if type(e) == "table" and e.reward and (am.completed or {})[kind] and not (am.claimed_rewards or {})[kind]
               and os.clock() - (self.tried[kind] or -1e9) > 3600 then
                self.tried[kind] = os.clock()
                fire("AchievementsAPI/ClaimReward", kind)
                sent[#sent + 1] = kind
                task.wait(0.6)
                if #sent >= 5 then break end
            end
        end
        if #sent == 0 then return end
        task.wait(2)
        local got, am2 = 0, me() and me().achievements_manager
        for _, kind in ipairs(sent) do
            if type(am2) == "table" and (am2.claimed_rewards or {})[kind] then got += 1 end
        end
        if got > 0 then log(("Achievements: claimed %d reward(s)"):format(got)) end
    end

    function Claims:mail()
        local mb = me() and me().mailbox_manager
        if C.ClaimMail == false or not (type(mb) == "table" and type(mb.deliveries) == "table" and next(mb.deliveries)) then return end
        if not inOwnHouse() or os.clock() < self.mailAt then return end
        self.mailAt = os.clock() + 600
        local n = 0
        for _ in pairs(mb.deliveries) do n += 1 end
        fire("HousingAPI/ClaimAllDeliveries")
        task.wait(2)
        local mb2 = me() and me().mailbox_manager
        local left = 0
        for _ in pairs(type(mb2) == "table" and type(mb2.deliveries) == "table" and mb2.deliveries or {}) do left += 1 end
        if left < n then log(("Mailbox: took %d gift(s)"):format(n - left)) end
    end

    function Claims:tick()
        pcall(self.dailies, self)
        pcall(self.stars, self)
        pcall(self.achievements, self)
        pcall(self.mail, self)
    end
end

------------------------------------------------------------------------------------------------
-- GRAPHICS — Normal / Low / 3D off (asked 2026-10-12: "better performance: no shadows, no 3D,
-- quality at 100 studs or just a small square").
--   Low     lowest quality level, no shadows / bloom / sun rays / depth of field, no particles,
--           trails, beams, fire or smoke, no grass, still water, and the world past ~100 studs in
--           a DARK fog (the old light fog read as a white screen). Re-applied every 5 s: the game
--           changes its lighting itself (day / night, events).
--   3D off  Low + no 3D drawing at all, behind a black screen with one small square (status,
--           uptime) — never a blank white world: if the black screen is gone, 3D comes back.
-- Lite: Settings › Graphics. Kaitun: LowGraphics = true is "Low" (its own board is the 3D off).
-- Everything is put back on Normal and when the hub stops.
------------------------------------------------------------------------------------------------
do
    local Gfx = { mode = "Normal", off = setmetatable({}, { __mode = "k" }) }
    Floor.Gfx = Gfx
    local Lighting = game:GetService("Lighting")
    local FX = { ParticleEmitter = true, Trail = true, Beam = true, Fire = true, Smoke = true, Sparkles = true,
                 PointLight = true, SpotLight = true, SurfaceLight = true, Highlight = true }

    function Gfx:save()
        if self.orig then return end
        local t = Workspace.Terrain
        local o = { shadows = Lighting.GlobalShadows, fogS = Lighting.FogStart, fogE = Lighting.FogEnd,
                    fogC = Lighting.FogColor, wave = t.WaterWaveSize, post = {} }
        pcall(function() o.deco = t.Decoration end)               -- hidden on some clients
        pcall(function() o.q = settings().Rendering.QualityLevel end)
        pcall(function() o.mesh = settings().Rendering.MeshPartDetailLevel end)
        self.orig = o
    end

    function Gfx:low()
        -- Minimum (2026-10-13, "only one small square and nothing else"): the world past ~40 studs in the
        -- dark, the lowest mesh detail, no blur / colour grading / stars, and no sound (Gfx:sounds)
        local min = self.mode == "Min"
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        if min then pcall(function() settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01 end) end
        if Lighting.GlobalShadows then Lighting.GlobalShadows = false end
        local dark = Color3.fromRGB(12, 12, 16)
        local fs, fe = (min and 8 or 60), (min and 40 or 100)
        if Lighting.FogEnd ~= fe or Lighting.FogStart ~= fs then Lighting.FogStart, Lighting.FogEnd = fs, fe end
        if Lighting.FogColor ~= dark then Lighting.FogColor = dark end
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("Atmosphere") then
                -- an Atmosphere overrides the fog: darkened in place (never taken out — the game
                -- drives it itself: house ambiance, day / night), its own values kept to put back
                self.atmos = self.atmos or {}
                if not self.atmos[e] then
                    self.atmos[e] = { Density = e.Density, Offset = e.Offset, Color = e.Color, Decay = e.Decay,
                                      Glare = e.Glare, Haze = e.Haze }
                end
                pcall(function()
                    if e.Density < 0.6 then e.Density = 0.6 end
                    e.Offset, e.Color, e.Decay, e.Glare, e.Haze = 0, dark, dark, 0, 0
                end)
            elseif (e:IsA("BloomEffect") or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect")
                    or (min and (e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect")))) and e.Enabled then
                self.orig.post[e] = true
                e.Enabled = false
            elseif min and e:IsA("Sky") then
                self.sky = self.sky or {}
                if not self.sky[e] then self.sky[e] = { CelestialBodiesShown = e.CelestialBodiesShown, StarCount = e.StarCount } end
                pcall(function()
                    if e.CelestialBodiesShown then e.CelestialBodiesShown = false end
                    if e.StarCount ~= 0 then e.StarCount = 0 end
                end)
            end
        end
        local t = Workspace.Terrain
        pcall(function() if t.Decoration then t.Decoration = false end end)
        pcall(function() if t.WaterWaveSize ~= 0 then t.WaterWaveSize = 0 end end)
        if self.mode ~= "Low" then self:sounds(false) end         -- Minimum / 3D off: silent (re-checked every 5 s)
    end

    -- The game's sounds: its SoundGroups (Music, SoundEffects) to 0 and any sound outside a group muted
    -- where it plays (Workspace, SoundService, your PlayerGui); everything put back on Normal / at stop.
    function Gfx:sounds(on)
        local SS = game:GetService("SoundService")
        if on then
            for _, c in ipairs(self.sndConn or {}) do pcall(function() c:Disconnect() end) end
            for g, v in pairs(self.sndGroups or {}) do pcall(function() g.Volume = v end) end
            for s, v in pairs(self.sndOne or {}) do pcall(function() if s.Volume == 0 then s.Volume = v end end) end
            self.sndConn, self.sndGroups, self.sndOne = nil, nil, nil
            return
        end
        self.sndGroups = self.sndGroups or setmetatable({}, { __mode = "k" })
        self.sndOne = self.sndOne or setmetatable({}, { __mode = "k" })
        for _, g in ipairs(SS:GetDescendants()) do
            if g:IsA("SoundGroup") and g.Volume ~= 0 then
                if self.sndGroups[g] == nil then self.sndGroups[g] = g.Volume end
                g.Volume = 0
            end
        end
        local one = self.sndOne
        local function mute(s)
            if s:IsA("Sound") and not s.SoundGroup and s.Volume ~= 0 then
                if one[s] == nil then one[s] = s.Volume end
                s.Volume = 0
            end
        end
        for s in pairs(one) do pcall(mute, s) end                     -- the game turned one back up
        if self.sndConn then return end
        self.sndConn = {}
        for _, root in ipairs({ Workspace, SS, LP:FindFirstChildOfClass("PlayerGui") }) do
            if root then
                for _, d in ipairs(root:GetDescendants()) do if d:IsA("Sound") then pcall(mute, d) end end
                self.sndConn[#self.sndConn + 1] = root.DescendantAdded:Connect(function(d)
                    if d:IsA("Sound") then task.defer(function() pcall(mute, d) end) end
                end)
            end
        end
    end

    Gfx.hooked = setmetatable({}, { __mode = "k" })
    function Gfx.quiet(d)
        if d.ClassName == "Explosion" then if d.Visible then d.Visible = false end return end   -- short-lived: not put back
        if not FX[d.ClassName] then return end
        if not Gfx.hooked[d] then
            -- the game turns some back on later (the map's wind emitters, weather — seen 2026-10-13): off
            -- again at once, never while Normal or while everything is being put back
            Gfx.hooked[d] = true
            d:GetPropertyChangedSignal("Enabled"):Connect(function()
                if Gfx.mode ~= "Normal" and not Gfx.restoring and d.Enabled then Gfx.off[d] = true d.Enabled = false end
            end)
        end
        if d.Enabled then Gfx.off[d] = true d.Enabled = false end
    end
    function Gfx:particles(on)
        if on then
            for d in pairs(self.off) do pcall(function() d.Enabled = true end) end
            self.off = setmetatable({}, { __mode = "k" })
            if self.conn then self.conn:Disconnect() self.conn = nil end
        elseif not self.conn then
            for _, d in ipairs(Workspace:GetDescendants()) do Gfx.quiet(d) end
            self.conn = Workspace.DescendantAdded:Connect(function(d)
                if FX[d.ClassName] or d.ClassName == "Explosion" then task.defer(function() pcall(Gfx.quiet, d) end) end
            end)
        end
    end

    -- the black screen + its small square (UI queue only)
    function Gfx:backdrop(on)
        if not on then
            local g = self.gui
            self.gui = nil
            if g then
                if alive() then ui(function() pcall(function() g:Destroy() end) end)
                else pcall(function() g:Destroy() end) end                 -- stopping: the UI queue is gone
            end
            return
        end
        if self.gui and self.guiUp then return end
        if self.building then return end
        self.building = true
        ui(function()
            self.building = false
            if not alive() or Gfx.mode ~= "3D off" then return end
            -- gethui() where it works, else CoreGui, else PlayerGui: some executors have no gethui and
            -- can't write CoreGui, and a gethui that throws must not cost the black screen
            local parents = {}
            pcall(function() if gethui then parents[#parents + 1] = gethui() end end)
            pcall(function() parents[#parents + 1] = game:GetService("CoreGui") end)
            pcall(function() parents[#parents + 1] = LP:FindFirstChildOfClass("PlayerGui") end)
            for _, p in ipairs(parents) do
                pcall(function() local old = p:FindFirstChild("CometBlackScreen") if old then old:Destroy() end end)
            end
            local sg = Instance.new("ScreenGui")
            sg.Name, sg.ResetOnSpawn, sg.IgnoreGuiInset, sg.DisplayOrder = "CometBlackScreen", false, true, 90
            local bg = Instance.new("Frame")
            bg.Size, bg.BackgroundColor3, bg.BorderSizePixel = UDim2.fromScale(1, 1), Color3.fromRGB(8, 8, 12), 0
            bg.Parent = sg
            local box = Instance.new("Frame")
            box.Name, box.AnchorPoint, box.Position = "Box", Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)
            box.Size, box.BackgroundColor3, box.BorderSizePixel = UDim2.fromOffset(320, 112), Color3.fromRGB(20, 20, 28), 0
            box.Parent = bg
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = box
            local stroke = Instance.new("UIStroke")
            stroke.Color, stroke.Thickness, stroke.Transparency = Color3.fromRGB(255, 200, 60), 1.5, 0.2
            stroke.Parent = box
            local t = Instance.new("TextLabel")
            t.Name, t.BackgroundTransparency = "Txt", 1
            t.Size, t.Position = UDim2.new(1, -24, 1, -16), UDim2.fromOffset(12, 8)
            t.Font, t.TextSize, t.TextColor3 = Enum.Font.GothamBold, 13, Color3.fromRGB(235, 238, 248)
            t.TextWrapped, t.TextXAlignment, t.TextYAlignment = true, Enum.TextXAlignment.Left, Enum.TextYAlignment.Top
            t.Text = "COMETIUM FUSIONS"
            t.Parent = box
            for _, p in ipairs(parents) do
                if pcall(function() sg.Parent = p end) and sg.Parent == p then break end
            end
            if not sg.Parent then pcall(function() sg:Destroy() end) return end
            Gfx.gui, Gfx.guiUp = sg, true
            -- its removal seen from its own signal: reading a gethui() instance from the watcher
            -- thread (it ran game code) throws "lacking capability"
            sg.AncestryChanged:Connect(function() if Gfx.gui == sg and not sg.Parent then Gfx.guiUp = false end end)
        end)
    end

    function Gfx:threeD(on)
        if on and not self.threeOff then return end              -- never touch a 3D off we didn't do
        self.threeOff = not on
        pcall(function() game:GetService("RunService"):Set3dRenderingEnabled(on) end)
    end

    function Gfx:apply(mode)
        mode = (mode == "Low" or mode == "Min" or mode == "3D off") and mode or "Normal"
        if self.mode ~= "Normal" and mode ~= self.mode and mode ~= "Normal" then self:restore() end   -- clean switch
        self:save()
        self.mode = mode
        if mode == "Normal" then self:restore() return end
        self:low()
        self:particles(false)
        if mode == "3D off" then
            self:backdrop(true)
        else
            self:backdrop(false)
            self:threeD(true)
        end
        log("graphics: " .. mode)
    end

    function Gfx:restore()
        self.restoring = true                                    -- effects coming back on stay on
        self:threeD(true)                                        -- the picture first, whatever fails after
        self:backdrop(false)
        local o = self.orig
        if o then
            pcall(function() settings().Rendering.QualityLevel = o.q end)
            pcall(function() Lighting.GlobalShadows = o.shadows end)
            -- the fog only while it is still ours (the game may have set its own since)
            if Lighting.FogEnd == 100 or Lighting.FogEnd == 40 then
                pcall(function() Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = o.fogS, o.fogE, o.fogC end)
            end
            for e in pairs(o.post) do
                if e.Parent == Lighting then pcall(function() e.Enabled = true end) end
            end
            if o.deco ~= nil then pcall(function() Workspace.Terrain.Decoration = o.deco end) end
            pcall(function() Workspace.Terrain.WaterWaveSize = o.wave end)
            if o.mesh ~= nil then pcall(function() settings().Rendering.MeshPartDetailLevel = o.mesh end) end
        end
        for e, v in pairs(self.sky or {}) do
            if e.Parent then pcall(function() for k, x in pairs(v) do e[k] = x end end) end
        end
        self.sky = nil
        self:sounds(true)
        for e, v in pairs(self.atmos or {}) do
            if e.Parent then pcall(function() for k, x in pairs(v) do e[k] = x end end) end
        end
        self.atmos = nil
        self:particles(true)
        self.orig = nil                                          -- a fresh snapshot the next time
        self.restoring = false
    end

    -- every second (the watch thread): the mode asked for, the lighting kept low, the square's text,
    -- and 3D only off while the black screen is really there
    function Gfx:tick()
        local v = tostring(C.GfxMode or "")
        local want = (v:find("^3D off") and "3D off") or (v:find("^Min") and "Min") or (v:find("^Low") and "Low")
            or ((C.GfxMode == nil and C.LowGraphics) and "Min") or "Normal"
        if want ~= self.mode then self:apply(want) end
        if self.mode == "Normal" then return end
        if os.clock() - (self.lowAt or 0) > 5 then self.lowAt = os.clock() self:low() end
        if self.mode == "3D off" then
            local g = self.gui
            if g and self.guiUp then
                if not self.threeOff then self:threeD(false) end
                local up = math.floor((os.clock() - (S.start or os.clock())) / 60)
                local text = ("COMETIUM FUSIONS\n%s\nrunning %dh %02dm · 3D off — Settings › Graphics to see the game")
                    :format(tostring(S.status or ""), math.floor(up / 60), up % 60)
                ui(function()
                    local t = g:FindFirstChild("Txt", true)
                    if t and t.Text ~= text then t.Text = text end
                end)
            else
                self:threeD(true)                                -- no black screen = no blank world
                self:backdrop(true)
            end
        end
    end

    -- the hub stopping puts everything back (own thread: GUI writes need a clean one)
    track({ Disconnect = function() task.spawn(function() pcall(Gfx.restore, Gfx) end) end })
end

------------------------------------------------------------------------------------------------
-- CROWD — other players out of the world in public servers (less lag at 3–5 FPS)
--
--   Characters live in workspace.PlayerCharacters, every pet in workspace.Pets; a pet's
--   owner is CharWrapperClient.get(model).player. Other players' characters and pets are
--   parented to nil on this client only — nothing goes to the server, and turning the option
--   off (or closing the hub) puts back the ones still in the game. Verified 2026-10-04: no
--   errors, and the game doesn't put them back itself; a respawn or a newly streamed pet
--   is caught on the next 1 s sweep. Your own pets are never touched.
------------------------------------------------------------------------------------------------

Crowd = { hidden = {} }

-- Public server or private (VIP)? game.PrivateServerId reads "" on the client now ("cannot be
-- checked on the client", seen 2026-10-11), so the old test called every VIP "public" and a
-- stuck account was hopped out of its VIP into a public server. Adopt Me's own client checks:
-- ReplicatedStorage.PlaceSubtype = "private" (ThemedServersHelper.is_private_server) and
-- ClientData is_vip_server (ServerType). Read once the answer is known; never touches the
-- PrivateServer properties (each read logs a warning).
function Crowd:public()
    if self.isPublic ~= nil then return self.isPublic end
    local ps = game:GetService("ReplicatedStorage"):FindFirstChild("PlaceSubtype")
    local sub = ps and tostring(ps.Value) or ""
    local okV, vip = pcall(function() return G.CD and G.CD.get("is_vip_server") end)
    if sub == "private" or (okV and vip == true) then
        self.isPublic = false
    elseif sub ~= "" then
        self.isPublic = true
    else
        return true                                 -- not replicated yet: ask again next time
    end
    return self.isPublic
end

-- Last resort when the client itself is broken (seen live 2026-10-04: RequestStreamAroundAsync
-- stopped answering for good, the game's trip lock kept jamming, and the server placed the
-- character somewhere else — "too_far" right next to the cat): hop to a fresh public server
-- and run the hub again there when the executor can (queue_on_teleport + the file in the
-- workspace). Private servers can't be rejoined by script (Unauthorized), so only a notice.
-- still (optional): returns true while the problem is still there; checked again after the
-- wait, so a client that recovered meanwhile doesn't hop for nothing.
function Crowd:rejoin(why, still)
    if self.rejoining or not C.AutoRejoin or not alive() then return end
    if not self:public() then
        -- a private server can't be rejoined by script (Unauthorized): repair in place instead —
        -- the game's trip lock, when a trip is what hangs (at most once a minute; it calls back here)
        -- only a real jam (45 s+, not our own trip still inside enter: jamWatch gives it 150 s)
        if G.IM and G.IM.entering and not (Floor.trip and os.clock() - (Floor.tripAt or 0) < 150)
           and Floor.jamSince and os.clock() - Floor.jamSince > 45 and os.clock() - (self.unstuckAt or 0) > 60 then
            self.unstuckAt = os.clock()
            log("stuck in a private server (" .. why .. ") — freeing the trip lock in place")
            pcall(unstickTravel)
        end
        if not self.warnedPrivate then
            self.warnedPrivate = true
            notify("Stuck", why .. " — repaired in place where it can (a private server can't be rejoined by script)")
        end
        return
    end
    self.rejoining = true
    log("rejoining a new server in 10 s: " .. why)
    notify("Rejoining", why .. " — hopping to a new server in 10 s (turn Auto rejoin off to cancel)")
    task.delay(10, function()
        -- never leave in the middle of a Ghost Gallery queue / round, a crypt or cat step, or
        -- in the Hallo.LEAD s before a round; capped at 5 min so a stuck flag can't hold it forever
        local w = 0
        while alive() and C.AutoRejoin and w < 300 do
            local okS, soon = pcall(Hallo.roundSoon, Hallo, 0)
            if not (Hallo.busy or (okS and soon)) then break end
            w += task.wait(2)
        end
        local okB, broken = true, true
        if still then okB, broken = pcall(still) end
        if not (alive() and C.AutoRejoin) or (okB and not broken) then
            if alive() and okB and not broken then log("rejoin cancelled — it recovered: " .. why) end
            self.rejoining = false
            return
        end
        self:hop(why)
        task.delay(60, function() self.rejoining = false end)
    end)
end

-- What a server change carries over (Crowd.queue puts it in queue_on_teleport).
-- The loader's settings survive a server hop: the relaunched hub gets the same board key,
-- dashboard switch and FPS cap (getgenv is empty in the new server).
function Crowd.carry()
    local g = (getgenv and getgenv()) or _G
    local out = ""
    for _, k in ipairs({ "CometTrackKey", "CometDashboard", "CometFPS" }) do
        local v = g[k]
        if type(v) == "string" then out ..= ("getgenv().%s = %q; "):format(k, v)
        elseif type(v) == "number" or type(v) == "boolean" then out ..= ("getgenv().%s = %s; "):format(k, tostring(v)) end
    end
    return out
end

-- How the hub comes back in the next server (asked 2026-10-11: "a better auto rejoin"): from the
-- executor workspace when the file is there, else the way it was started — the jnkie link and
-- script key the Comet loaders put in getgenv (CometLoaderURL / CometScriptKey; this hub's own
-- link otherwise) — after the game and the character are in. Wrapped in the loaders' own
-- once-per-server flag, so an autoexec loader and this queued copy never both start it.
function Crowd.loadLine(file, url)
    -- the game first, from the file too (it started before the game had loaded: "Failed to read
    -- the game"). Not the character: it only spawns once the hub presses Play on the join screen
    local ready = 'repeat task.wait(1) until game:IsLoaded() and game:GetService("Players").LocalPlayer '
    local okF, has = pcall(function() return isfile and isfile(file) end)
    if okF and has then
        -- never an older copy than this run (2026-10-12 on ultra: a v4.4 file left in the workspace
        -- came back on every rejoin while v4.6 was current) — the build line is the file's age
        local okR, src = pcall(readfile, file)
        local fb = okR and type(src) == "string" and src:match('Track%.BUILD = "([^"]+)"')
        local function age(b)
            local d, n = tostring(b):match("^(%d+%-%d+%-%d+)%.?(%d*)$")
            return d and (d .. ("%06d"):format(tonumber(n) or 0))
        end
        local mine, theirs = age(Track and Track.BUILD), fb and age(fb)
        if not (mine and theirs and theirs < mine) then return ready .. ("loadstring(readfile(%q))()"):format(file) end
        log("the workspace " .. file .. " is older (" .. fb .. ") — the next server loads from the link")
    end
    local g = (getgenv and getgenv()) or _G
    local link = (type(g.CometLoaderURL) == "string" and g.CometLoaderURL ~= "") and g.CometLoaderURL or url
    local key = g.CometScriptKey
    if type(key) ~= "string" then
        local okK, v = pcall(function() return SCRIPT_KEY end)
        key = (okK and type(v) == "string") and v or nil
    end
    -- the link path: the jnkie layer reads the character at once ("index nil with 'Mass'"), and on a
    -- fresh join the character only spawns after Play on the join screen (see "ready" above) - Play is
    -- pressed the game's way from a side thread every 5 s, up to 120 s (never a game call on the
    -- thread that then runs the hub), then the link runs through CometGet (Crowd.queue's helper)
    local play = 'local P = game:GetService("Players") local t0 = os.clock() '
        .. 'while not (P.LocalPlayer.Character and P.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and os.clock() - t0 < 120 do '
        .. 'task.spawn(function() pcall(function() local s = setthreadidentity or set_thread_identity or setidentity '
        .. 'if s then pcall(s, 2) end local n = require(game:GetService("ReplicatedStorage"):WaitForChild("Fsys", 30)).load("UIManager").apps.NewsApp '
        .. 'if n and n.cont and n.instance and n.instance.Enabled then n.cont.continue() end end) end) task.wait(5) end '
    return (ready .. play .. '%sloadstring(CometGet(%q))()'):format(key and ("SCRIPT_KEY = %q getgenv().CometScriptKey = SCRIPT_KEY "):format(key) or "", link)
end
function Crowd.queue()
    local q = queue_on_teleport or (syn and syn.queue_on_teleport) or queueonteleport or (fluxus and fluxus.queue_on_teleport)
    if type(q) ~= "function" or Crowd.queued then return Crowd.queued == true end       -- once per server
    local code = Crowd.carry() .. Crowd.loadLine("CometHub_AdoptMe_Lite.lua", "https://api.jnkie.com/api/v1/luascripts/public/27704cc5af934d43acfc7b3d5adea87d4e97dcf80d4cba271852c74a24818ffc/download")
    -- only back in Adopt Me: the queue also fires if you walk into another place (Trade Hub…)
    -- the next server starts from an empty executor state: the queued code brings its own stand-ins
    -- first (no getgenv, only "load", no game:HttpGet -> the request function: CometGet, used by
    -- Crowd.loadLine) and waits for the place before trusting PlaceId (0 that early on some executors)
    local shim = 'if type(getgenv) ~= "function" then getgenv = function() return _G end end '
        .. 'if type(loadstring) ~= "function" then loadstring = load end '
        .. 'CometGet = function(u) local ok, b = pcall(function() return game:HttpGet(u) end) '
        .. 'if ok and type(b) == "string" and b ~= "" then return b end '
        .. 'local r = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) '
        .. 'if type(r) == "function" then local ok2, res = pcall(r, { Url = u, Method = "GET" }) '
        .. 'if ok2 and type(res) == "table" and type(res.Body) == "string" and res.Body ~= "" then return res.Body end end '
        .. 'error("[Comet] could not download " .. tostring(u)) end '
        .. 'if not game:IsLoaded() then game.Loaded:Wait() end '
    Crowd.queued = (pcall(q, shim .. ("if game.PlaceId == %d and not getgenv().__CometMassFarm then "
        .. "getgenv().__CometMassFarm = true %s end"):format(game.PlaceId, code)))
    return Crowd.queued
end

function Crowd:hop(why, same)
    -- never out of a private (VIP) server: a script can't come back to it, so "rejoin" would
    -- land every account in a public server (reported by a user running 8 accounts in a VIP)
    if not self:public() then
        if not self.toldPrivateHop then
            self.toldPrivateHop = true
            log("not leaving the private server (" .. tostring(why) .. ") — rejoin it by hand if the client is stuck")
            notify("Private server", "Not leaving your VIP server (" .. tostring(why) .. "). Rejoin by hand if this account is stuck.")
        end
        return
    end
    Crowd.queue()
    -- same = back into this very server (a kick, a lost connection), else a fresh one
    log((same and "rejoining this server: " or "hopping to a new server: ") .. tostring(why))
    pcall(function()
        local TS = game:GetService("TeleportService")
        if same then TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) else TS:Teleport(game.PlaceId, LP) end
    end)
end

-- Roblox's own Reconnect button on the disconnected screen (a lost connection): the only way a
-- script can get back into a PRIVATE server. Pressed like a real click (VirtualInputManager at
-- its centre) and through its connections as a fallback. True when there was one to press.
function Crowd:pressReconnect()
    local okC, CG = pcall(game.GetService, game, "CoreGui")
    local rpg = okC and CG:FindFirstChild("RobloxPromptGui")
    local po = rpg and rpg:FindFirstChild("promptOverlay")
    if not po then return false end
    -- its words follow the client's language (French: "ReconnexionButton" / "Reconnexion"):
    -- known words first; else, of exactly two buttons, the one that isn't "leave"
    local RECON = { "reconnect", "reconnex", "reconect", "verbind", "riconnet", "rejoin", "переподключ" }
    local LEAVE = { "leave", "quit", "salir", "sair", "verlass", "esci", "выйти" }
    local btn, others = nil, {}
    for _, d in ipairs(po:GetDescendants()) do
        if d:IsA("GuiButton") and d.Visible then
            local t = d:FindFirstChildWhichIsA("TextLabel", true)
            local label = (d.Name .. " " .. (t and t.Text or "")):lower()
            local isLeave = false
            for _, w in ipairs(LEAVE) do if label:find(w, 1, true) then isLeave = true end end
            for _, w in ipairs(RECON) do if not btn and label:find(w, 1, true) then btn = d end end
            if not isLeave then others[#others + 1] = d end
        end
    end
    if not btn and #others == 1 then btn = others[1] end
    if not btn then return false end
    log("pressing Roblox's Reconnect")
    local inset = Vector2.zero
    if not rpg.IgnoreGuiInset then
        local okI, v = pcall(function() return game:GetService("GuiService"):GetGuiInset() end)
        if okI and typeof(v) == "Vector2" then inset = v end
    end
    local p = btn.AbsolutePosition + btn.AbsoluteSize / 2 + inset
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 1)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 1)
    end)
    if typeof(getconnections) == "function" then
        for _, sig in ipairs({ btn.Activated, btn.MouseButton1Click }) do
            -- CoreGui signals: some executors' getconnections throws on them ("not supported")
            local okC, list = pcall(getconnections, sig)
            for _, c in ipairs(okC and type(list) == "table" and list or {}) do pcall(function() c:Fire() end) end
        end
    end
    return true
end

-- The kick / "disconnected" screen (Settings › Auto reconnect): come back, the hub with it (the
-- relaunch is queued first, Crowd.queue). Every 20 s for 10 min while the screen stays up:
-- Roblox's own Reconnect when it offers one (a lost connection — back into the same server,
-- private ones included), else in a public server a teleport: into the same server first, then
-- a fresh one. A kick in a private server has no Reconnect and can't be rejoined by script.
function Crowd:watchErrors()
    local okG, GS = pcall(game.GetService, game, "GuiService")
    if not okG then return end
    track(GS.ErrorMessageChanged:Connect(function(msg)
        if not (alive() and C.AutoReconnect) or tostring(msg) == "" or self.reconnecting then return end
        -- a failed teleport (ConnectionError 768-775) is only a notice: still connected
        local okE, code = pcall(GS.GetErrorCode, GS)
        if okE and typeof(code) == "EnumItem" and code.Value >= 768 and code.Value <= 775 then return end
        -- "joined from another device" (DisconnectEvicted / Duplicate…): the account is open
        -- somewhere else — that's you; reconnecting would kick that session (seen 2026-10-11)
        if okE and typeof(code) == "EnumItem" and (code.Name:find("Evicted") or code.Name:find("Duplicate")) then
            log("disconnected: " .. tostring(msg) .. " — the account is open somewhere else, not reconnecting")
            return
        end
        self.reconnecting = true
        log("disconnected: " .. tostring(msg) .. " — reconnecting")
        task.spawn(function()
            local told = false
            for i = 1, 30 do
                task.wait(i == 1 and 5 or 20)
                if not (alive() and C.AutoReconnect) then break end
                local okM, m = pcall(GS.GetErrorMessage, GS)
                if okM and m == "" then break end                      -- prompt gone
                local okN, nc = pcall(game.FindFirstChildOfClass, game, "NetworkClient")
                if okN and nc and nc:FindFirstChildOfClass("ClientReplicator") then break end   -- still connected
                pcall(Crowd.queue)
                -- reading CoreGui / getconnections throws on some executors: that error ended this
                -- thread with self.reconnecting left true — no reconnect / hop ever again this session
                local okP, pressed = pcall(self.pressReconnect, self)
                if not (okP and pressed) then
                    if self:public() then
                        self:hop("reconnect, try " .. i, i == 1)
                    elseif not told then
                        told = true
                        log("kicked from a private server: no Reconnect offered — it can't be rejoined by script")
                    end
                end
            end
            self.reconnecting = false
        end)
    end))
end

function Crowd:hide(m, owner, isChar)
    -- the game itself moves characters in and out of the world when players change place:
    -- one it brought back gets hidden again
    if Crowd.hidden[m] and m.Parent == nil then return end
    local parent = m.Parent
    if parent and pcall(function() m.Parent = nil end) then
        Crowd.hidden[m] = { parent = parent, owner = owner, char = isChar }
    end
end

-- Still worth putting back: the owner is in the server and it's still their character /
-- an equipped pet (old characters and put-away pets are gone server-side).
function Crowd:still(m, h)
    if not h.owner.Parent then return false end
    if h.char then return h.owner.Character == m end
    local ok, w = pcall(G.CWC.get, m)
    return ok and type(w) == "table" and w.player == h.owner
end

function Crowd:restore()
    for m, h in pairs(self.hidden) do
        pcall(function() if Crowd:still(m, h) and h.parent.Parent then m.Parent = h.parent end end)
    end
    self.hidden = {}
end

-- From the status loop, every second.
function Crowd:tick()
    if not (alive() and C.HidePlayers and self:public()) or (Hallo and Hallo.active) then
        if next(self.hidden) then self:restore() end
        return
    end
    local chars = Workspace:FindFirstChild("PlayerCharacters")
    for _, m in ipairs(chars and chars:GetChildren() or {}) do
        local p = Players:GetPlayerFromCharacter(m)
        if p and p ~= LP then Crowd:hide(m, p, true) end
    end
    local pets = Workspace:FindFirstChild("Pets")
    local CWC = G.CWC
    if pets and CWC then
        for _, m in ipairs(pets:GetChildren()) do
            local ok, w = pcall(CWC.get, m)
            local owner = ok and type(w) == "table" and w.player
            if typeof(owner) == "Instance" and owner:IsA("Player") and owner ~= LP then Crowd:hide(m, owner, false) end
        end
    end
    -- forget what the game has thrown away (player left, respawned, pet put away)
    if os.clock() - (self.pruneAt or 0) > 30 then
        self.pruneAt = os.clock()
        for m, h in pairs(self.hidden) do
            local ok, live = pcall(Crowd.still, Crowd, m, h)
            if not (ok and live) then self.hidden[m] = nil end
        end
    end
end

------------------------------------------------------------------------------------------------
-- STATUS RENDER — collect on the worker, write on Heartbeat
------------------------------------------------------------------------------------------------

local NEED_LABEL = {
    hungry = "Hungry", thirsty = "Thirsty", sick = "Sick", sleepy = "Sleepy", dirty = "Dirty",
    toilet = "Toilet", play = "Play", walk = "Walk", ride = "Ride", mystery = "Mystery",
    school = "School", pizza_party = "Pizza party", salon = "Salon", cat_cafe = "Cat café",
    beach_party = "Beach party", bored = "Bored", camping = "Camping", pet_me = "Pet me",
    at_work = "At work", party_zone = "Party zone",
}

local function commas(n)
    local s = tostring(math.floor(tonumber(n) or 0))
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return (out:gsub("^,", ""):gsub("^%-,", "-"))
end

-- Live progress of a need: progress + rate × (server time − rate_timestamp).
local function needPct(subject, k)
    local e = needEntry(subject, k)
    if not e then return nil end
    local p = tonumber(e.progress) or 0
    local rate, ts = tonumber(e.rate) or 0, tonumber(e.rate_timestamp) or -1
    if rate > 0 and ts > 0 then p += rate * math.max(0, Workspace:GetServerTimeNow() - ts) end
    return math.clamp(p, 0, 1)
end

local function listNeeds(subject)
    local t = needsOf(subject)
    table.sort(t, function(a, b) return (RANK[a] or 99) < (RANK[b] or 99) end)
    for i, k in ipairs(t) do
        local label = NEED_LABEL[k] or k
        local pct = needPct(subject, k)
        if UNSUPPORTED[k] then label ..= " (by hand)"
        elseif blocked(subject, k) then label ..= " (parked)"
        elseif pct and pct > 0.005 then label ..= (" %d%%"):format(math.floor(pct * 100)) end
        t[i] = label
    end
    return #t > 0 and table.concat(t, " · ") or "all done ✔"
end

local function petLine(u)
    local p = petByUnique(u)
    if not p then return "—" end
    local stage = p.egg and ("egg %d/%s xp"):format(math.floor(p.xp), tostring(p.hatchAt or "?"))
        or (AGE_NAME[p.age] or tostring(p.age))
    return ("%s%s (%s)\n   %s"):format(versionPrefix(p), p.name, stage, listNeeds(petSubject(u)))
end

local function renderStatus()
    -- Status: what it's doing, for how long, and where
    local where = location()
    if C.TaskFloor and Floor:onFloor() then where = "on the task floor"
    elseif where == "housing" and inOwnHouse() then where = "at home"
    else where = "at " .. where end
    local since = math.floor(os.clock() - (S.statusAt or os.clock()))
    local status = ("▶ %s%s\n%s · %s · $%s"):format(S.status, since >= 3 and ("  (" .. since .. " s)") or "",
        team() == "Babies" and "Baby" or team(), where, commas(bucks()))

    -- Needs: the baby and each farm pet, with live progress
    local lines = {}
    if C.BabyFarm then
        lines[#lines + 1] = "Baby — " .. (team() == "Babies" and listNeeds(BABY) or "switching to baby…")
    end
    for i, u in ipairs(Farm:uniques()) do lines[#lines + 1] = ("Pet %d — %s"):format(i, petLine(u)) end
    if not (C.BabyFarm or farming()) then lines[#lines + 1] = "Turn on Auto Farm Baby or Pet above." end
    if C.PetCount == "2 pets" and maxPets() < 2 then
        lines[#lines + 1] = "(the game lets this account have 1 pet out — farming 1)"
    end
    local needsText = table.concat(lines, "\n")

    -- Session: when it started, how long it runs, money and potions = start + gained
    local up = math.floor(os.clock() - S.start)          -- whole seconds: %d rejects fractions
    local hours = math.max(up / 3600, 1 / 60)
    local done = S.babyDone + S.petDone
    -- gains and spending are summed separately (checked every second), so buying food
    -- or using a potion never hides what came in
    local function tally(t, now)
        if not t.start then t.start, t.last, t.gain, t.lost = now, now, 0, 0 return t end
        local d = now - t.last
        if d > 0 then t.gain += d elseif d < 0 then t.lost -= d end
        t.last = now
        return t
    end
    local money = tally(S.moneyTally, bucks())
    local potT = tally(S.potTally, Potion:total())
    if me() then S.candyTally = S.candyTally or {} tally(S.candyTally, Hallo:candy()) end
    local function line(label, t, prefix)
        local s = ("%s: %s%s + %s%s"):format(label, prefix, commas(t.start), prefix, commas(t.gain))
        if t.lost > 0 then s ..= (" − %s%s"):format(prefix, commas(t.lost)) end
        return s .. (" = %s%s"):format(prefix, commas(t.last))
    end
    local runFor = up >= 3600 and ("%dh %02dm %02ds"):format(math.floor(up / 3600), math.floor((up % 3600) / 60), up % 60)
        or ("%dm %02ds"):format(math.floor(up / 60), up % 60)
    -- age-ups on the farm pets this session (a pet seen for the first time only sets its
    -- starting age; age potions on other pets are counted where they're used)
    for _, u in ipairs(Farm:uniques()) do Farm:seeAge(u) end
    local session = ("Executed %s · running %s\nTotal bucks gained: $%s (+$%s/h) · age-ups gained: %d (Full Grown %d)\n%s\n%s   (+%d/h)\nTasks done %d (%d/h) · hatched %d · potions used %d · neon %d · mega %d · released %d · sent $%s")
        :format(S.startedAt or "?", runFor, commas(money.gain), commas(money.gain / hours), S.ageUps, S.grown,
            line("Money", money, "$"),
            line("Potions", potT, ""), math.floor(potT.gain / hours),
            done, math.floor(done / hours), S.hatched, S.potions, S.neons, S.megas, S.released, commas(S.paid))
    if Floor.caught > 0 then session ..= (" · falls caught %d"):format(Floor.caught) end

    local _, counts = Potion:owned()
    local pots = {}
    for _, def in ipairs(POTIONS) do
        if (counts[def.id] or 0) > 0 then pots[#pots + 1] = def.label .. ": " .. counts[def.id] end
    end
    if not Neon.readyAt or os.clock() - Neon.readyAt > 5 then
        Neon.readyCache, Neon.readyAt = Neon:ready(), os.clock()
    end
    local ready = Neon.readyCache
    local releasePreview = Release:refreshPreview()
    local wallet = ("Bucks: $%s · Recycler tickets: %s"):format(commas(bucks()), commas(balance("pet_recycler_tickets_2026")))
    local licenseText = License:has() and "You have a trading license ✔" or "No trading license yet."
    local target = findPlayer(C.PayTo)
    local hwText = "Event not running."
    if Hallo:live() then
        local _, roundIn = Hallo:nextRound()
        local keysN = Hallo:keys()
        local dl = {}
        local dd = me()
        local tab = dd and dd.dailies_manager and dd.dailies_manager.serialized_tabs
            and dd.dailies_manager.serialized_tabs.halloween_2026
        for k, v in pairs(tab and tab.active_dailies or {}) do
            local st = type(v) == "table" and v.state or {}
            dl[#dl + 1] = ("%s %s/%s"):format(tostring(k):gsub("^halloween_2026_", ""):gsub("_", " "),
                tostring(st.steps_completed or 0), tostring(st.steps_to_complete or "?"))
        end
        local _, hauntIn = Hallo:nextHaunt()
        local function mmss(t) return t < math.huge and ("%dm %02ds"):format(math.floor(math.max(0, t) / 60), math.max(0, t) % 60) or "?" end
        hwText = ("Candy: %s · crypt keys: %d · Ghost Gallery in %s · Hauntlet in %s%s\nGhost Gallery %d (+%s candy) · Hauntlet %d (+%s candy, best room %d) · keys used %d · cat fed %d\nDailies: %s\nLast: %s")
            :format(commas(Hallo:candy()), keysN, mmss(roundIn), mmss(hauntIn),
                Hallo.busy and " · busy" or "", Hallo.rounds, commas(Hallo.roundCandy),
                Haunt.rounds, commas(Haunt.candy), Haunt.best, Hallo.keysUsed, Hallo.catFeeds,
                #dl > 0 and table.concat(dl, " · ") or "—", Hallo.last)
    end
    local tradeTarget = findPlayer(C.TradeTo)
    local tradeText = ("%s\nTo: %s · pets given this session: %d in %d trade(s)%s"):format(Trade.last,
        tradeTarget and (tradeTarget.Name .. " (in server)") or (C.TradeTo ~= "" and (C.TradeTo .. " (not in server)") or "—"),
        Trade.pets, Trade.trades, Trade.running and " · trading now" or "")
    local payText = ("%s\nTo: %s"):format(Pay.last, target and (target.Name .. " (in server)") or
        (C.PayTo ~= "" and (C.PayTo .. " (not in server)") or "—"))
    local logText = #S.log > 0 and table.concat(S.log, "\n") or "—"
    local bigBucks = ("+$%s bucks this session"):format(commas(money.gain))
    local bucksText = ("Now $%s · started with $%s · $%s/h%s · running %s"):format(commas(money.last),
        commas(money.start), commas(money.gain / hours), money.lost > 0 and (" · spent $" .. commas(money.lost)) or "", runFor)
    local bigPots = ("+%d Age-Up potions this session"):format(potT.gain)
    local potsText = ("Age-Up owned now %d · potions used %d · age-ups %d (Full Grown %d)"):format(potT.last, S.potions, S.ageUps, S.grown)
    -- pictures: the baby + each farm pet (needs under it), the pet pen, the Halloween pets
    local gFarm, gPen, gHw = {}, {}, {}
    pcall(function()
        local function short(subj)
            local t = needsOf(subj)
            table.sort(t, function(a, b) return (RANK[a] or 99) < (RANK[b] or 99) end)
            for i, k in ipairs(t) do t[i] = NEED_LABEL[k] or k end
            return #t > 0 and table.concat(t, ", ") or "all done ✔"
        end
        local function pic(p)
            local db = G.IDB.pets[p.id]
            return db and db.image or ""
        end
        if C.BabyFarm and team() == "Babies" then
            gFarm[#gFarm + 1] = { img = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(LP.UserId),
                title = "Baby", sub = short(BABY), busy = #needsOf(BABY) > 0 }
        end
        for _, u in ipairs(Farm:uniques()) do
            local p = petByUnique(u)
            if p then
                local subj = petSubject(u)
                gFarm[#gFarm + 1] = { img = pic(p), title = p.name, badge = p.mega and "M" or (p.neon and "N" or nil),
                    sub = (p.egg and "Egg" or (AGE_NAME[p.age] or "?")) .. " · " .. short(subj), busy = #needsOf(subj) > 0 }
            end
        end
        gFarm.empty = "Turn on Auto Farm Baby / Pet."
        for u in pairs(Farm.Pen and Farm.Pen:active() or {}) do
            local p = petByUnique(u)
            if p then
                gPen[#gPen + 1] = { img = pic(p), title = p.name, badge = p.mega and "M" or (p.neon and "N" or nil),
                    sub = p.egg and "Egg" or (AGE_NAME[p.age] or "?") }
            end
        end
        gPen.empty = "The pen is empty — turn on Auto pet pen to fill it."
        local dHw = me()
        for _, hp in ipairs(Haunt.PETS) do
            local cat = hp.cat or "pets"                       -- the Poltergeist Box is a gift
            local db = G.IDB[cat] and G.IDB[cat][hp.kind]
            if db then
                local own = not hp.box and Haunt:ownedPet(hp.kind)
                local held = 0
                if hp.box and dHw then
                    for _, it in pairs(dHw.inventory.gifts or {}) do if (it.id or it.kind) == hp.kind then held += 1 end end
                end
                gHw[#gHw + 1] = { img = db.image or "", title = hp.label,
                    sub = (own and "owned ✔ · " or "") .. (held > 0 and ("held " .. held .. " · ") or "")
                        .. (hp.box and Haunt.boxes and ("opened " .. Haunt.boxes .. " · ") or "")
                        .. commas(tonumber(db.cost) or 0) .. " candy", busy = own or held > 0 }
            end
        end
    end)
    local okL, lureText = pcall(function() return Farm.Lure:status() end)
    lureText = okL and lureText or "—"
    local okV, shown = pcall(function() return Rayfield:IsVisible() end)
    if okV and shown == false then return end            -- window hidden: nothing to draw
    ui(function()
        pcall(Look.gallery, "Your farm", gFarm)
        pcall(Look.gallery, "In the pet pen", gPen)
        pcall(Look.gallery, "Halloween pets", gHw)
        UI.PNow:Set({ Title = "Status", Content = status })
        UI.PBucks:Set({ Title = bigBucks, Content = bucksText })
        UI.PPots:Set({ Title = bigPots, Content = potsText })
        UI.PNeeds:Set({ Title = "Needs", Content = needsText })
        UI.PSession:Set({ Title = "Session", Content = session })
        UI.PLog:Set({ Title = "Log", Content = logText })
        UI.PPotions:Set({ Title = "Potions", Content = #pots > 0 and table.concat(pots, " · ") or "none" })
        if UI.PLure then UI.PLure:Set({ Title = "Lure", Content = lureText }) end
        UI.PNeon:Set({ Title = "Ready to fuse", Content = #ready > 0 and table.concat(ready, "\n") or "nothing yet" })
        UI.PRelease:Set({ Title = "Would release", Content = releasePreview })
        UI.PWallet:Set({ Title = "Wallet", Content = wallet })
        UI.PLicense:Set({ Title = "License", Content = licenseText })
        UI.PPay:Set({ Title = "Transfer", Content = payText })
        UI.PTrade:Set({ Title = "Trades", Content = tradeText })
        UI.PHallo:Set({ Title = "Candy", Content = hwText })
    end)
end

------------------------------------------------------------------------------------------------
-- BOOT + LOOPS
------------------------------------------------------------------------------------------------

_G.__CHLITE = {
    C = C, S = S, G = G, Farm = Farm, Shop = Shop, Eggs = Eggs, Release = Release, Floor = Floor,
    Home = Home, License = License, Potion = Potion, Pay = Pay, PetList = PetList,
    Trade = Trade, Popups = Popups, Hallo = Hallo, Crowd = Crowd, Haunt = Haunt, Track = Track,
    Rayfield = Rayfield,
    destroy = function()
        SESSION.dead = true
        for _, c in ipairs(SESSION.conns) do pcall(function() c:Disconnect() end) end
        -- GUI first: Crowd:restore touches a game module, after which this thread may no
        -- longer write GUI (capability split) — so it runs on its own thread
        pcall(function() Rayfield:Destroy() end)
        -- only OUR button: an old run's late destroy used to remove the new run's one by name
        pcall(function() if UI.toggleGui then UI.toggleGui:Destroy() end end)
        if Floor.conn then pcall(function() Floor.conn:Disconnect() end) end
        if Floor.model then pcall(function() Floor.model:Destroy() end) end
        pcall(function() Popups:patch(false) end)
        task.spawn(function() pcall(Crowd.restore, Crowd) end)
        if Trade then Trade.stop = true end
        if _G.__CHLITE == SESSION.handle then _G.__CHLITE = nil end   -- never a newer run's handle
    end,
}
SESSION.handle = _G.__CHLITE

-- Restores saved toggles; their callbacks only set flags until the game layer is up. Guarded: a
-- LoadConfiguration that throws (an older / cached Rayfield on an executor without isfile /
-- readfile, a damaged saved file) ended the file right here — the window up, the boot below never
-- started. (Table fields, not locals: this is the most crowded point of the main chunk.)
UI.cfgOk, UI.cfgErr = pcall(UI.loadConfig)
if not UI.cfgOk then warn("[Cometium Fusions] saved window settings not loaded: " .. tostring(UI.cfgErr)) end

task.spawn(function()
    -- still "Loading…" after 45 s: the status names the step it is stuck at (asked 2026-10-12)
    S.bootStep = "reading the game"
    task.delay(45, function()
        if alive() and not S.booted and not S.bootFailed then
            setStatus("Loading… stuck at: " .. tostring(S.bootStep) .. " — rejoin if it stays")
            log("loading is stuck at: " .. tostring(S.bootStep))
            -- the status panel only draws once booted: say it in the window now (the headless label
            -- shows S.status by itself)
            local text = S.status
            ui(function() if UI.PNow then UI.PNow:Set({ Title = "Status", Content = text }) end end)
        end
    end)
    local ok, err = pcall(loadGame)
    -- a slow device (the game's modules still loading) or an executor whose own identity can't
    -- require them ("Cannot require a non-RobloxScript module from a RobloxScript"): 3 more tries,
    -- 5 s apart, each from a clean ui() thread at the game's identity 2 (G.asGame's way, without
    -- its 10 s cut)
    for try = 1, 3 do
        if ok or not alive() then break end
        log(("reading the game failed (%s) — retry %d of 3 in 5 s"):format(tostring(err):sub(1, 120), try))
        S.bootStep = ("reading the game (retry %d of 3, at the game's identity)"):format(try)
        task.wait(5)
        local res
        ui(function()
            task.spawn(function()
                pcall(function() (setthreadidentity or set_thread_identity or setidentity)(2) end)
                res = table.pack(pcall(loadGame))
            end)
        end)
        local t0 = os.clock()
        while not res and os.clock() - t0 < 60 and alive() do task.wait(0.25) end
        if res then ok, err = res[1], res[2] else err = "no answer in 60 s" end
    end
    if not ok then
        -- nothing can farm without the game's modules: said in the window, the console, the log, the
        -- headless label (S.status) and a toast — it was one line in the Farm tab only, no warn, and
        -- the 45 s "stuck" note wrote over it
        local msg = "Failed to read the game: " .. tostring(err)
            .. "\nMost often this executor can't require() Adopt Me's game modules — nothing can farm"
            .. " without that; use an executor with full require() support. If it names a missing"
            .. " module, Adopt Me changed: wait for an update."
        S.bootFailed = msg
        warn("[Cometium Fusions] " .. msg)
        log("STOPPED: " .. tostring(err):sub(1, 120))
        setStatus("STOPPED — couldn't read the game (require); see the console (F9)")
        ui(function() if UI.PNow then UI.PNow:Set({ Title = "Status", Content = msg }) end end)
        notify("Cometium Fusions can't farm here", "Reading the game failed (require). See the console (F9).")
        return
    end

    pcall(function() Popups:patch(true) end)   -- before the spawn sequence asks (arachnophobia…)
    -- Fresh join: the spawn sequence waits on the news screen's Play button.
    pcall(function()       -- UIManager's app list can still be filling on a slow join: never fatal here
        local news = G.UIM.apps.NewsApp
        if news and news.instance and news.instance.Enabled and news.cont then
            pcall(news.cont.continue)
            log("pressed Play on the join screen")
        end
    end)
    S.bootStep = "your character"
    local waited = 0
    while not (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")) and waited < 30 do
        waited += task.wait(0.5)
    end
    for k in pairs(ANCHOR_PATH) do anchorPos(k) end

    Booted.ready = true
    task.wait(1)
    if not alive() then return end         -- stopped / re-executed while we were starting
    S.bootStep = "the task floor and popups"
    pcall(Floor.apply, Floor)
    pcall(function() Popups:apply() end)
    pcall(function() Crowd:watchErrors() end)
    if C.TradeOff then pcall(function() Trade:applyOff() end) end

    local rb = G.API:FindFirstChild("AilmentsAPI/BabyAilmentCompleted")
    local rp = G.API:FindFirstChild("AilmentsAPI/PetAilmentCompleted")
    if rb then track(rb.OnClientEvent:Connect(function() S.babyDone += 1 end)) end
    if rp then track(rp.OnClientEvent:Connect(function() S.petDone += 1 end)) end
    -- the game's own ClientData hook: a need appearing / moving / clearing stamps S.needAt, which
    -- wakes the worker and every Floor.nap on the next frame. The game AWAITS every hook before it
    -- fires DataChangedEvent — set a number, never yield or touch the UI here. Removed on stop.
    pcall(function()
        local off = G.CD.register_callback("ailments_manager", function(plr)
            if plr == LP then S.needAt = os.clock() end
        end)
        if type(off) == "function" then track({ Disconnect = function() task.spawn(pcall, off) end }) end
    end)

    -- each on its own: one throwing here used to leave the window up and nothing farming
    S.bootStep = "your pets and the shop"
    pcall(Floor.antiAfk, Floor, C.AntiAFK)
    pcall(Kinds.build, Kinds)
    pcall(Kinds.refresh, Kinds, "")
    pcall(PetList.refresh, PetList, "")
    pcall(Shop.build, Shop)
    pcall(Eggs.build, Eggs)
    S.startBucks = bucks()
    S.startedAt = os.date("%d/%m/%Y %H:%M:%S")
    S.moneyTally, S.potTally = {}, {}
    do  -- the loader's getgenv().CometFPS caps the client even with no saved FPS choice
        local f = tonumber((getgenv and getgenv() or _G).CometFPS)
        local cap = setfpscap or (getgenv and getgenv().setfpscap)
        if f and f > 0 and cap then pcall(cap, f) end
    end
    S.bootStep = "the dashboard"
    pcall(Track.start, Track)
    task.delay(20, function() pcall(function() Farm:twoPetsHint() end) end)
    task.spawn(function()                     -- the game's trip lock: freed after 45 s held
        while alive() do pcall(S.statusDog) pcall(Hallo.watch, Hallo) pcall(Floor.jamWatch) pcall(Hallo.camWatch) pcall(Farm.prune) pcall(Floor.Gfx.tick, Floor.Gfx) task.wait(1) end
    end)
    Saver:start()
    S.booted = true
    setStatus("Idle")
    -- a count that throws (ClientData still partial on a slow device) must not end the boot thread
    -- here: the status loop and the worker below would never start ("Idle", nothing farms)
    pcall(function() log(("ready — %d pets, %d shop items, %d pet slot(s)"):format(#allPets(), #Shop.rows, maxPets())) end)

    -- The status loop (window, popups, rejoin watch…). One step that never returned froze it for
    -- good: the window stuck on "Loading…" for a customer, "running 0m 07s" on ultra (2026-10-12).
    -- Each step is named; the 1 s watcher restarts the loop when it hasn't come round in 20 s and
    -- logs the step it hung in (a hung old loop exits by itself if it ever wakes: its gen is old).
    function S.statusLoop()
        local gen = (S.statusGen or 0) + 1
        S.statusGen, S.statusBeat = gen, os.clock()
        task.spawn(function()
            while alive() and S.statusGen == gen do
                S.statusBeat = os.clock()
                S.statusStep = "the status panel" pcall(renderStatus)
                S.statusStep = "popups" pcall(function() Popups:tick() end)
                S.statusStep = "the rejoin watch" pcall(function() Crowd:tick() end)
                local okV, shown = pcall(function() return Rayfield:IsVisible() end)
                if not (okV and shown == false) then
                    S.statusStep = "the window size" pcall(function() Look:tall() end)
                    S.statusStep = "the side tabs" pcall(function() Look:sidebar() end)
                end
                S.statusStep = "the premium theme" pcall(Look.premium)   -- gold theme + the Premium tab (also while hidden)
                -- read on the clean ui thread: this loop has run game code, and reading a gethui()
                -- instance from it throws "lacking capability" — outside any pcall that killed the
                -- loop for good (2026-10-12: the window frozen on "Loading…" / "running 0m 07s")
                S.statusStep = "the show/hide button"
                ui(function()
                    if C.MobileBtn ~= false and not (UI.toggleGui and UI.toggleGui.Parent) and os.clock() - (UI.toggleAt or 0) > 3 then
                        UI.toggleAt = os.clock()
                        UI.MobileBtn(true)
                    end
                end)
                S.statusStep = "waiting"
                task.wait(1)
            end
        end)
    end
    function S.statusDog()
        if S.statusBeat and os.clock() - S.statusBeat > 20 and alive() then
            log("the status loop hung in " .. tostring(S.statusStep) .. " — restarted")
            S.statusLoop()
        end
    end
    S.statusLoop()

    -- the worker: one action at a time so nothing fights over equips or teleports
    while alive() do
        -- the house gets the free crib, bath, bowls and litter box by itself, once a session,
        -- as soon as a farm runs (its own thread: setupAll takes the lock between two steps)
        if not Home.autoDone and not S.paused and (C.BabyFarm or farming()) then
            Home.autoDone = true
            task.spawn(function()
                -- far seats from the file + the server's list first (Home:boot, no trip): setupAll's trip
                -- home and back up (~8-15 s holding the farm) only when a piece is missing
                local okB, full = pcall(Home.boot, Home)
                if not (okB and full) then pcall(function() Home:setupAll() end) end
            end)
        end
        Lock:run(function()
            Lock.byWorker = true
            S.ranJob = false
            -- paused by ▶ FARMING or by the dashboard (Premium): one switch, S.paused
            if S.paused then
                setStatus(S.pausedBy == "remote" and "Paused (remote)" or "Paused — Farm tab › ▶ FARMING")
                return
            end
            -- the game's own transition or trip on screen (a minigame's way out once its state has
            -- cleared, a slow trip at low FPS): no team switch / equip / trip of ours on top of it —
            -- 2 trips at once was the white screen. 90 s at most (Hallo:watch fades a stale screen
            -- back, jamWatch frees a jammed lock).
            if Hallo.whiteout() or (G.IM and G.IM.entering) then
                S.underAt = S.underAt or os.clock()
                if os.clock() - S.underAt < 90 then
                    setStatus("Waiting for the game's transition to finish")
                    return
                end
            else
                S.underAt = nil
            end
            -- a minigame still on this client (played by hand, or the game still taking us out of
            -- a round): no team switch, equips or trips under it — they jammed the game's own trip
            -- (white screen). A round of ours about to start still goes through (Hallo:tick).
            if (Hallo.playing or Hallo.active) and not Hallo:roundSoon(0) then
                S.roundWait = S.roundWait or os.clock()
                if os.clock() - S.roundWait < 900 then
                    setStatus("Waiting for the minigame to finish on this client")
                    return
                end
                if not S.roundFixed then
                    S.roundFixed = true
                    task.spawn(function() pcall(Hallo.fixScreen, Hallo) end)
                end
            else
                S.roundWait, S.roundFixed = nil, nil
            end
            if (S.tpPauseUntil or 0) > os.clock() and Hallo:budget() > 60 then
                setStatus(("Paused after your teleport (%ds) — Teleport tab"):format(math.ceil(S.tpPauseUntil - os.clock())))
                return
            end
            if C.BabyFarm and team() ~= "Babies" and os.clock() - (S.babyAt or 0) > 15 then
                S.babyAt = os.clock()
                guarded("baby team", 20, Baby.become, Baby, true)   -- a ChooseTeam that never answers
            end
            if farming() then guarded("equip", 20, function() Farm:ensure() end) end

            -- Halloween: a Ghost Gallery round can't wait; keys / cat / dailies fit in between
            -- (a team Hauntlet runs ~13 min + its exit: cut at 900 s it left the round's listener
            -- running and the farm travelling while the game was still taking us out)
            local r0 = Hallo.rounds + Haunt.rounds
            local hauntSoon = select(2, Hallo:nextHaunt()) <= Hallo.LEAD
            guarded("halloween", hauntSoon and 1300 or (select(2, Hallo:nextRound()) <= Hallo.LEAD and 900 or 260),
                function() Hallo:tick() end)
            Hallo.busy = false
            -- a round just ended (Ghost Gallery OR Hauntlet): both farm pets out before the next job —
            -- once the game has finished taking us out (the gate above waits for that)
            if Hallo.rounds + Haunt.rounds ~= r0 and (Hallo.active or Hallo.playing) then return end
            if farming() and Hallo.rounds + Haunt.rounds ~= r0 then guarded("equip", 20, function() Farm:ensure() end) end

            -- every step must end before we leave to queue for the next round: start a task
            -- when its usual length fits (an area counts down in ~50 s, ride / walk ~60-90 s, a
            -- task with a trip ~25 s, one right here ~15 s) and cut it at the budget anyway —
            -- the old 160 s for areas kept a fresh beach / park need waiting ~3.5 min a cycle
            local jobs = collectJobs()
            local budget = Hallo:budget()
            if budget < math.huge then
                local keep = {}
                for _, j in ipairs(jobs) do
                    -- a ride / walk keeps its progress when cut short (2026-10-12: 25 s, was 45 — a 33 s
                    -- walk with 26-45 s left finished or banked most of it instead of waiting out the round);
                    -- an area that needs no trip (the floor above it / already inside): ~50 s + a 1 s hop —
                    -- 70 left a fresh beach / park need waiting out a whole round
                    local need = AREA[j.need] and (j.here == 0 and 56 or 70) or ((j.need == "ride" or j.need == "walk") and 25)
                        or (j.here == 0 and 15) or 25
                    if budget > need then keep[#keep + 1] = j
                    elseif j.need == "ride" then
                        Hallo.say(("Ride waits for the next Halloween round (%ds left before queueing)"):format(math.floor(budget)))
                    end
                end
                jobs = keep
            end
            local function fits(secs) return Hallo:budget() > secs end
            S.ranJob = jobs[1] ~= nil
            if jobs[1] then
                runJob(jobs[1], budget)
            else
                local working = C.BabyFarm or farming()
                -- wait for the next need on the task floor (or at home), so most need no trip
                if working and C.TaskFloor and Floor.model then
                    if not Floor:atBase() and fits(45) then guarded("going to the floor", 45, goFloor) end
                elseif working and C.HomeTasks and not inOwnHouse() and os.clock() - (S.homeAt or 0) > 60 and fits(45) then
                    S.homeAt = os.clock()
                    guarded("going home", 45, goTo, "housing")
                end
                setStatus(working and (budget < 0 and "Waiting for the next Halloween round" or "Waiting for new needs")
                    or "Idle — turn on a farm")
            end
            -- the extras are server round trips (buys, potions given one by one, fusing, pen, pay):
            -- while needs are queued (a job just ran) they wait for the queue to empty, 30 s at most
            if not S.ranJob or os.clock() - (S.extrasAt or 0) > 30 then
                S.extrasAt = os.clock()
                -- idle, they give way to a need that comes in meanwhile (2026-10-12: a need landing
                -- mid-pass waited for every extra left — potions 1 s each, pen 2 s+, lure ~5 s, a pay
                -- trade); cut between two extras, never inside one: the rest run on the next idle
                -- loop, or in the full 30 s pass after a job
                local fitsT, seen, cut = fits, S.needAt, false
                local function fits(secs)
                    if not cut and not S.ranJob and S.needAt ~= seen then
                        seen = S.needAt
                        cut = collectJobs()[1] ~= nil
                        if cut then S.ranJob = true end          -- back for it after a 0.05 s nap
                    end
                    return not cut and fitsT(secs)
                end
                if fits(20) then guarded("eggs", 20, function() Eggs:tick() end) end        -- eggs first on the bucks…
                if fits(20) then guarded("auto buy", 20, function() Shop:autoTick() end) end -- …then the auto-bought item
                if fits(30) then guarded("potion", 30, function() Potion:tick() end) end
                if fits(60) then guarded("neon", 60, function() Neon:tick() end) end
                if fits(60) then guarded("release", 60, function() Release:tick() end) end
                if fits(15) then guarded("tickets", 15, function() Release:collect() end) end
                if fits(25) then guarded("pet pen", 25, function() Farm.Pen:tick() end) end
                if fits(45) then guarded("lure", 45, function() Farm.Lure:tick() end) end
                if fits(20) then guarded("daily claims", 20, function() Farm.Claims:tick() end) end
                if fits(200) then guarded("pay", 200, function() Pay:tick() end) end
            end
        end)
        -- straight to the next job after one ran, unless a button is waiting for the lock
        Floor.nap((S.ranJob and (Lock.waiting or 0) == 0) and 0.05 or math.max(tonumber(C.Delay) or 0.25, 0.1))
    end
end)
