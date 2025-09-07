-- Shaders

SMODS.Shader({
    key = "sad", 
    path = "sad.fs", 
})

SMODS.Shader({
    key = "depressed",
    path = "depressed.fs",
})

SMODS.Shader({
    key = "dysphoric", 
    path = "dysphoric.fs", 
}) 

--[[ SMODS.Shader({
    key = "happy", 
    path = "Happy.fs", 
})

SMODS.Shader({
    key = "ecstatic", 
    path = "Ecstatic.fs", 
})

SMODS.Shader({
    key = "euphoric", 
    path = "Euphoric.fs", 
})

SMODS.Shader({
    key = "upset", 
    path = "Upset.fs", 
})

SMODS.Shader({
    key = "angered", 
    path = "Angered.fs", 
})

SMODS.Shader({
    key = "enraged", 
    path = "Enraged.fs", 
})

SMODS.Shader({
    key = "anxious", 
    path = "Anxious.fs", 
})

SMODS.Shader({
    key = "fearful", 
    path = "Fearful.fs", 
})

SMODS.Shader({
    key = "dreadful", 
    path = "Dreadful.fs", 
}) ]]

-- Editions 

SMODS.Edition({
    key = "depressed",
    shader = "depressed",
    loc_txt = {
        name = "Depressed",
        label = "Depressed",
        text = {
            "#1#/4 chance to self-destruct, scores x5 chips"
        }
    },
    disable_shadow = true,
    disable_base_shader = true,
    discovered = true,
    unlocked = true,
    config = {},
    in_shop = false,
    apply_to_float = true,
    loc_vars = function(self)
        return { vars = {} }
    end
})