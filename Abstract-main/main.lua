--- STEAMODDED HEADER
--- MOD_NAME: Abstract Mod
--- MOD_ID: ABSTRACTMOD
--- MOD_AUTHOR: [SrMario]
--- MOD_DESCRIPTION: This mod adds 8 new jokers and 2 new legendary jokers (Sorry for my bad english)
--- PREFIX: xmpl
----------------------------------------------
------------MOD CODE -------------------------


SMODS.Atlas {
    key = 'All_jokers_atlas',
    px = 71,
    py = 95,
    path = 'Jokers.png'
}

SMODS.Joker{
    key = "randomchips",
    loc_txt = {
        name = 'Chip Chip',
        text = 
        {
            '{C:blue}Random{} Chips',
        }
    },
    pos = {x = 0, y = 0},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 6, 
    rarity = 3,--cost
    config = { extra = {
        min = 20,
        max = 260,
        chip_mod = 0
    }
},

    calculate = function(self,card,context)
        if context.joker_main then
            local temp_chips = pseudorandom(pseudoseed('chips'), -card.ability.extra.min, card.ability.extra.max)
            return
            {
                chip_mod = card.ability.extra.chip_mod + temp_chips ,
                message = '+' .. card.ability.extra.chip_mod + temp_chips ,
                colour = G.C.CHIPS,
                card = card
            }
        end
    end

}

SMODS.Joker{
    key = "bananapeel",
    loc_txt = {
        name = 'Banana Peel',
        text = 
        {
            '{C:green}#1# in #2#{} chance to  ',
            'add {X:mult,C:white}X#3#{} Mult'
        }
    },
    pos = {x = 1, y = 0},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 3, 
    rarity = 1,--cost
    config = { extra = {
        Xmult = 3,
        odds = 4
    }
},
loc_vars = function(self,info_queue,center)
    return {vars = {G.GAME.probabilities.normal,center.ability.extra.odds,center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
end,

calculate = function(self,card,context)
    
    if context.joker_main then
        if pseudorandom('bananapeel') < G.GAME.probabilities.normal/card.ability.extra.odds then
        return
        {
            card = card,
            Xmult_mod = card.ability.extra.Xmult,
            message = 'X' .. card.ability.extra.Xmult .. ' Mult',
            colour = G.C.MULT
        }
    else
        return 
        {
            card = card,
            message = 'Maybe Not'
        }
        end
    end


end

}

SMODS.Joker{
    key = "jimba",
    loc_txt = {
        name = 'Jimba',
        text = 
        {
        'Every {C:attention}2{} and {C:attention}3{}',
        'gains {C:chips}+#1#{} Chips when they are in your hand'
            
        }
    },
    pos = {x = 3, y = 0},
    atlas = 'All_jokers_atlas',
    unlocked = true, 
    discovered = false, 
    cost = 4, 
    rarity = 1,--cost
    config = { extra = {
        chip_mod = 2
    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.chip_mod}} 
    end,

    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.hand and not context.other_card.debuff and not context.end_of_round then
            if  context.other_card.base.value == '2' or  context.other_card.base.value == '3' then
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chip_mod
                return {
                    extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
    end

}

SMODS.Joker{
    key = "fullmoon",
    loc_txt = {
        name = 'Ducks Watching Comets',
        text = 
        {
            'Creates a {C:planet}Planet card {} ',
            'with {C:dark_edition}Foil edition {}',
            'in the start of the round'
        }
    },
    pos = {x = 5, y = 0},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 5, 
    soul_pos = { x = 3, y = 2},
    rarity = 3,--cost
    calculate = function(self,card,context)
        if context.setting_blind and not card.getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = SMODS.create_card{set = "Planet", area = G.consumeables}
                    card:set_edition({foil = true},true)
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return {
                card = card,
                message = localize('k_planet'),
                colour = G.C.SECONDARY_SET.Planet,
            }
        end
    end

}


SMODS.Joker{
    key = "Underpants",
    loc_txt = {
        name = 'Nice Underpants',
        text = 
        {
            'This Joker gains {C:blue}#+1#{} Chips',
            'if played hand conteins {C:attention}Three of a Kind{}',
            '{C:inactive}(Current action: {C:attention}#3#{C:inactive})'
        }
    },
    pos = {x = 4, y = 0},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 7, 
    rarity = 3,--cost
    config = { extra = {
        chip_mod = 12, 
        chips = 0
    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.chip_mod,center.ability.extra.chips}} 
    end,

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips
            }
        elseif context.before and next(context.poker_hands[card.ability.extra.type])and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return {
                message = localize('k_upgrade_ex'),
                card = card,
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker{
    key = "karuta",
    loc_txt = {
        name = 'Karuta',
        text = 
        {
            '{C:blue}Common {}Jokers each',
            'give{C:red} +#1# {}Mult',
        }
    },
    pos = {x = 8, y = 0},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 4, 
    rarity = 2,--cost
    config = { extra = {
        h_mult = 15
    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.h_mult}} 
    end,
    calculate = function(self, card, context)
        if context.other_joker then
            if context.other_joker.config.center.rarity == 1 and self ~= context.other_joker then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                })) 
                return {
                    mult_mod = card.ability.extra.h_mult,
                    message = '+' .. card.ability.extra.h_mult .. 'Mult',
                    colour = G.C.MULT
                }
            end
        end
    end
}


SMODS.Joker{
    key = "footballprint",
    loc_txt = {
        name = 'Football Print',
        text = 
        {
            '{C:green}#1# in #2#{} chance to',
            'Adds {C:chips}+#4#{} Chips when',
            'the card is score',
            '{C:inactive}(Current action: {C:attention}#3#{C:inactive} )'

        }
    },
    pos = {x = 2, y = 1},
    atlas = 'All_jokers_atlas',
    unlocked = true, 
    discovered = false,
    cost = 7, 
    rarity = 2,
    config = { extra = {
        chip_mod = 0,
        chip = 4,
        odds = 2
        
    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {G.GAME.probabilities.normal,center.ability.extra.odds,center.ability.extra.chip_mod,center.ability.extra.chip}}
    end,

    calculate = function(self,card,context)

        if pseudorandom('footballprint') < G.GAME.probabilities.normal/card.ability.extra.odds then
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.chip_mod = card.ability.extra.chip_mod + card.ability.extra.chip
            return {
                message = 'GOOOAL!!',
                colour = G.C.CHIPS,
            
            }
        end
    end
    
        if context.joker_main then
            return
            {
                chip_mod = card.ability.extra.chip_mod,
                message = '+' .. card.ability.extra.chip_mod,
                colour = G.C.CHIPS
            }
        end
    end

}

SMODS.Joker{
    key = "balanced",
    loc_txt = {
        name = 'Balanced',
        text = 
        {
            '{C:attention}+#1#{} Consumable slots',
            '{C:red}All items cost{} {C:attention}+#1#{}'
        }
    },
    pos = {x = 7, y = 0},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 4, 
    rarity = 2,--cost
    config = { extra = {
        card_limit = 2,
        inflation = 2
    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.card_limit,center.ability.extra.inflation}} 
    end,

    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
            return true end }))

            G.GAME.inflation = G.GAME.inflation + card.ability.extra.inflation
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then
                    v:set_cost()
                end
            end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.card_limit
            return true end }))

            G.GAME.inflation = G.GAME.inflation - card.ability.extra.inflation
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then
                    v:set_cost()
                end
            end
    end
}

SMODS.Joker{
    key = "drop",
    loc_txt = {
        name = 'Drop',
        text = 
        {
            'Retrigger all cards',
            'for the next {C:attention}#1#{} hands',
        }
    },
    pos = {x = 2, y = 0},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 5, 
    rarity = 1,--cost
    config = { extra = {
        retrigger_amt = 1,
        hands = 5
    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.hands}} 
    end,

    calculate = function(self,card,context)
        if context.repetition and context.cardarea == G.play then
            return
            {
                repetitions = card.ability.extra.retrigger_amt,
                card = card
            }     
        elseif context.after and not context.blueprint then
            card.ability.extra.hands = card.ability.extra.hands - 1
            if card.ability.extra.hands <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            end
        end
    end
}


SMODS.Joker{
    key = "NFT",
    loc_txt = {
        name = 'Joker NFT',
        text = 
        {
            'In the setting blind this joker gains {C:attention}$#1#{} for money',
            '{C:green}#2# in #3#{} chance to destroy to end for the round',
            '{C:attention}-Random dollars{} remains'
        }
    },
    pos = {x = 5, y = 3},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 4, 
    rarity = 1,--cost
    config = { extra = {
        dollars = 0,
        increase = 1,
        odds = 8,
        min = 1,
        max = 10
    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.increase,G.GAME.probabilities.normal,center.ability.extra.odds}} 
    end,
    calculate = function(self, card, context)
        local temp_dollars= pseudorandom(pseudoseed('NFT'), -card.ability.extra.min, -card.ability.extra.max)
        if context.setting_blind then 
            card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.increase
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MONEY
            }
        elseif context.end_of_round and not context.game_over and not context.blueprint and not context.individual and not context.repetition then
            if pseudorandom('NFT') < G.GAME.probabilities.normal/card.ability.extra.odds then
            G.E_MANAGER:add_event(Event{
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event{trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true
                        end
                    })
                    return true
                end
            })
            return
            {
                message = '-98% value' .. temp_dollars,
                dollars = temp_dollars
            }
        end
    end
end,

    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    calc_dollar_bonus = function(self,card)
        return card.ability.extra.dollars
        
    end,

}

SMODS.Joker{
    key = "rene",
    loc_txt = {
        name = 'Rene',
        text = 
        {
            'The odds are {C:green}101%{}',
            'that this will happen'
        }
    },
    pos = {x = 8, y = 1},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 10, 
    soul_pos = { x = 9, y = 1 },
    rarity = 4,--cost
    config = { extra = {

    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.retrigger_amt}} --#1# is replaced with card.ability.extra.Xmult
    end,

    add_to_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v*1001
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v/1001
		end
	end

}

SMODS.Joker{
    key = "slasher",
    loc_txt = {
        name = 'Slasher',
        text = 
        {
            'Retrigger {C:attention}#1#{} times',
            'all {C:attention}Steel cards{} in your hand',
        }
    },
    pos = {x = 0, y = 2},
    atlas = 'All_jokers_atlas',
    unlocked = all_unlocked, 
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false, 
    cost = 10, 
    soul_pos = { x = 1, y = 2},
    rarity = 4,--cost
    config = { extra = {
        retrigger_amt = 2
    }
},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.retrigger_amt}} 
    end,

    calculate = function(self,card,context)
        if context.repetition and context.cardarea == G.hand and context.other_card.ability.name == "Steel Card" then
            return
            {
                repetitions = card.ability.extra.retrigger_amt,
                card = card
            }     
        end
    end
}

----------------------------------------------
------------MOD CODE END----------------------
    
