/obj/item/material/ashtray
	name = "ashtray"
	desc = "A thing to keep your butts in."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ashtray"
	max_force = 10
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.1
	randpixel = 5
	var/max_butts = 10

/obj/item/material/ashtray/examine(mob/user)
	. = ..()
	if(material)
		to_chat(user, "It's made of [material.display_name].")
	if(contents.len >= max_butts)
		to_chat(user, "It's full.")
	else if(contents.len)
		to_chat(user, "It has [contents.len] cig butts in it.")

/obj/item/material/ashtray/on_update_icon()
	..()
	overlays.Cut()
	if (contents.len == max_butts)
		overlays |= image('icons/obj/objects.dmi',"ashtray_full")
	else if (contents.len >= max_butts/2)
		overlays |= image('icons/obj/objects.dmi',"ashtray_half")

/obj/item/material/ashtray/attackby(obj/item/W as obj, mob/user as mob)
	if (health <= 0)
		return
	if (istype(W,/obj/item/trash/cigbutt) || istype(W,/obj/item/clothing/mask/smokable/cigarette) || istype(W, /obj/item/flame/match))
		if (contents.len >= max_butts)
			to_chat(user, "\The [src] is full.")
			return

		if (istype(W,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = W
			if (cig.lit == 1)
				visible_message(SPAN_NOTICE("\The [user] crushes \the [cig] in \the [src], putting it out."))
				W = cig.extinguish(no_message = 1)
			else if (cig.lit == 0)
				to_chat(user, SPAN_NOTICE("You place \the [cig] in \the [src] without even smoking it. Why would you do that?"))
		else
			visible_message(SPAN_NOTICE("\The [user] places \the [W] in \the [src]."))

		if(user.unEquip(W, src))
			set_extension(src, /datum/extension/scent/ashtray)
			update_icon()
	else
		..()
		health = max(0,health - W.force)
		if (health < 1)
			shatter()

/obj/item/material/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if (contents.len)
			visible_message("<span class='danger'>\The [src] slams into [hit_atom], spilling its contents!</span>")
			for (var/obj/O in contents)
				O.dropInto(loc)
			remove_extension(src, /datum/extension/scent)
		if (health < 1)
			shatter()
			return
		update_icon()
	return ..()

/obj/item/material/ashtray/plastic/Initialize(mapload)
	. = ..(mapload, MAT_PLASTIC)

/obj/item/material/ashtray/bronze/Initialize(mapload)
	. = ..(mapload, MAT_BRONZE)

/obj/item/material/ashtray/glass/Initialize(mapload)
	. = ..(mapload, MAT_GLASS)
