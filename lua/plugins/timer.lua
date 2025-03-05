return {    
    {
        dir = "~/.config/nvim/lua/user",
        config = function()
            require('user.work_timer').setup()
        end,
    }
}

