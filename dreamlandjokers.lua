------------DreamlandJokers-------------------------

SMODS.Atlas {
    key = 'DreamlandJokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'sleepingjoker',
    loc_txt = {
      name = 'Sleeping Joker',
      text = {
        "After {C:attention}first hand{} played",
        "{C:mult}+#1#{} Mult"
      }
    },
    config = { extra = {
        mult = 15
    }},
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.mult } }
    end,
    rarity = 1,
    atlas = 'DreamlandJokers',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 0, y = 0
    },
    cost = 2,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played > 0 then
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                mult_mod = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { -- Smoking Joker

    key = "smokingjoker",
    loc_txt = {
        name = 'Smoking Joker',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            '{C:attention}-2{} hand size',
        },
    },
    atlas = 'DreamlandJokers',
    cost = 7,
    rarity = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 1,
        y = 0
    },
    config = { extra = {
        Xmult = 4,
        hand_size = -2
    }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.hand_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { -- Stonehenge

    key = "stonehenge",
    loc_txt = {
        name = 'Stonehenge',
        text = {
            'Retrigger all',
            'played {C:attention}Stone{} Cards'
        },
    },
    atlas = 'DreamlandJokers',
    enhancement_gate = 'm_stone',
    cost = 5,
    rarity = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 2,
        y = 0
    },
    config = { extra = {
        repetitions = 1
    } },

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card.ability.name == "Stone Card" then
                return {
                    message = 'Again!',
                    repetitions = card.ability.extra.repetitions,
                    card = context.other_card
                }
            end
        end
    end
}

SMODS.Joker { -- Brick & Mortar 

    key = "brick&mortar",
    loc_txt = {
        name = 'Brick & Mortar',
        text = {
            'Played {C:attention}Stone{} cards give',
            '{C:red}+#1#{} mult when scored',
        },
    },
    atlas = 'DreamlandJokers',
    cost = 3,
    rarity = 1,
    enhancement_gate = 'm_stone',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 3,
        y = 0
    },
    config = { extra = {
        mult = 5
    }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card.ability.name == "Stone Card" then
            return {
                mult = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}

SMODS.Joker { -- Rose Tinted Glasses

    key = "rosetintedglasses",
    loc_txt = {
        name = 'Rose Tinted Glasses',
        text = {
            'This Joker loses {C:red}-#2#{} Mult',
            'for each tarot card used',
            '{C:inactive}(Currently {C:red}+#1#{} {C:inactive}mult)'
        },
    },
    atlas = 'DreamlandJokers',
    cost = 6,
    rarity = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 4,
        y = 0
    },
    config = { extra = {
        mult = 15,
        mult_mod = 2
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                mult_mod = card.ability.extra.mult
            }
        end
        if context.using_consumeable and (context.consumeable.ability.set == "Tarot") and not context.blueprint then
            local new_mult = card.ability.extra.mult - card.ability.extra.mult_mod
            if new_mult > 0 then
                card.ability.extra.mult = new_mult
                return {
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod }},
                        colour = G.C.RED
                    })
                }
            else
                play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true;
                    end
                }))
                return {
                    message = 'Cracked!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Joker { -- Snowscape

    key = "snowscape",
    loc_txt = {
        name = 'Snowscape',
        text = {
            '{C:blue}+1{} Hands for every',
            '{C:attention}7{} enhanced cards in your deck',
            '{C:inactive}(Currently {C:blue}+#1#{C:inactive} hands, {C:attention}#2#{C:inactive} cards)'
        },
    },
    atlas = 'DreamlandJokers',
    cost = 7,
    rarity = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 5,
        y = 0
    },
    config = { extra = {
        hands = 0,
        snow_tally = 0
    } },
    loc_vars = function(self, info_queue, card)
        local tally = G.playing_cards and calculate_snowscape_tally() or 0
        local hands = math.floor(tally / 7)
        return { vars = { card.ability.extra.hands + hands, card.ability.extra.snow_tally + tally} }
    end,
    calculate = function (self, card, context)
        if context.setting_blind then
            local tally = G.playing_cards and calculate_snowscape_tally() or 0
            local hands = math.floor(tally / 7)
            if hands > 0 then
                ease_hands_played(hands)
                return {
                    message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } },
                }
            end
        end
    end
}

function calculate_snowscape_tally()
    local snow_tally = 0
    for _, card in pairs(G.playing_cards) do
        if card.config.center ~= G.P_CENTERS.c_base then
            snow_tally = snow_tally + 1
        end
    end
    return snow_tally
end

SMODS.Joker { -- Ocean Blue

    key = "oceanblue",
    loc_txt = {
        name = 'Ocean Blue',
        text = {
            'This Joker gains {C:chips}#2#{} chips',
            'For each {C:attention}boss blind{} completed',
            '{C:inactive}(Currently {C:chips}+#1#{} {C:inactive}chips)'
        },
    },
    atlas = 'DreamlandJokers',
    cost = 4,
    rarity = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 6,
        y = 0
    },
    config = { extra = {
        chips = 0,
        chip_gain = 50
    }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
      end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
        if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                message = 'Upgraded!',
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
}

SMODS.Joker { -- Mystic Woods

    key = "mysticwoods",
    loc_txt = {
        name = 'Mystic Woods',
        text = {
            'This Joker gains {C:red}+#2#{} Mult',
            'for each Booster Pack opened',
            '{C:inactive}(Currently {C:red}+#1#{} {C:inactive}mult)'
        },
    },
    atlas = 'DreamlandJokers',
    cost = 5,
    rarity = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 7,
        y = 0
    },
    config = { extra = {
        mult = 0,
        mult_mod = 2
    } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 1 then
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                mult_mod = card.ability.extra.mult
            }
        end

        if context.open_booster and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult_mod + card.ability.extra.mult
            return {
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "+" .. tostring(card.ability.extra.mult) .. " Mult",
                    colour = G.C.RED
                }),
            }
        end
    end
}

SMODS.Joker { -- Volcano

    key = "volcano",
    loc_txt = {
        name = 'Volcano',
        text = {
            'Next blind {C:attention}Destroy{} all held jokers {C:attention}once{}',
            'Gain {X:mult,C:white}X#2#{} Mult per {C:attention}Joker{}',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}mult)'
        },
    },
    atlas = 'DreamlandJokers',
    cost = 6,
    rarity = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 8,
        y = 0
    },
    config = { extra = {
        Xmult = 1,
        Xmult_mod = 0.75,
        exploded = 0
    }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_mod, card.ability.extra.exploded } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and card.ability.extra.exploded == 0 then
            volcano_explode(card, context)
        end
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}

function volcano_explode(card, context)
    local destructable_jokers = {}
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then
            destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i]
        end
    end
    local amount_to_destroy = #destructable_jokers
    for i = 1, #destructable_jokers do
        local joker_to_destroy = destructable_jokers[i]
        if joker_to_destroy and not (context.blueprint_card or card).getting_sliced then
            joker_to_destroy.getting_sliced = true
            G.E_MANAGER:add_event(Event({func = function()
                (joker_to_destroy):juice_up(0.8, 0.8)
                joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
            return true end }))
        end
    end
    card.ability.extra.Xmult = card.ability.extra.Xmult_mod * amount_to_destroy + card.ability.extra.Xmult
    card.ability.extra.exploded = 1
    if not (context.blueprint_card or card).getting_sliced then
        card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {
            message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult},
            colour = G.C.RED
        }})
    end
    return amount_to_destroy
end

SMODS.Joker { -- Voyaguer

    key = "voyaguer",
    loc_txt = {
        name = 'Voyaguer',
        text = {
            'When sold,',
            '{C:attention}#1#{} ante',
        },
    },
    atlas = 'DreamlandJokers',
    cost = 30,
    rarity = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    pos = {
        x = 9,
        y = 0
    },
    soul_pos = {
        x = 10,
        y = 0
    },
    config = { extra = {
        ante = -2
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.ante } }
    end,

    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            ease_ante(card.ability.extra.ante)
        end
    end,
}

SMODS.Joker { -- Devil's Machine
    key = "devilsmachine",
    loc_txt = {
        name = 'Devil\'s Machine',
        text = {
            'If hand contains {C:attention}3 or more 6\'s{}',
            '{C:attention}destroy{} 2 random cards in your hand',
            'Gain {C:money}#1#{}'
        },
    },
    atlas = 'DreamlandJokers',
    cost = 7,
    rarity = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 0,
        y = 1
    },
    config = { extra = {
        m_gain = 3
    }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.m_gain } }
      end,
    calculate = function(self, card, context)
        if context.joker_main then
            local sixes = 0
            for k, card in ipairs(context.scoring_hand) do
                if card:get_id() == 6 then
                    sixes = sixes + 1
                end
            end
            if sixes > 2 then
                -- delete 2 random cards
                return {
                    ease_dollars(card.ability.extra.m_gain)
                }
            end
        end
    end
}

SMODS.Joker { -- Queenly Majesty

    key = "queenlymajesty",
    loc_txt = {
        name = 'Queenly Majesty',
        text = {
            'If hand contains {C:attention}2 or more{} queens',
            '{X:mult,C:white}X#1#{} Mult',
        },
    },
    atlas = 'DreamlandJokers',
    cost = 7,
    rarity = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 0,
        y = 2
    },
    config = { extra = {
        Xmult = 2.5,
    }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        local queens = 0
        for k, card in ipairs(context.scoring_hand) do
            if card:get_id() == 12 then
                queens = queens + 1
            end
        end
        if context.joker_main and queens > 1 then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}

-------------