
local M = {}

-- Ruta donde se guardarán los registros
local log_file_path = vim.fn.expand('~/Personal/work_session_log.txt')
local session_start = nil

-- Función para obtener la fecha y hora actual
local function get_timestamp()
    return os.date('%Y-%m-%d %H:%M:%S')
end

-- Inicia una nueva sesión
function M.start_session()
    if session_start then
        print("Ya hay una sesión en curso. Usa :EndSession para cerrarla.")
        return
    end

    session_start = get_timestamp()
    print("Inicio de sesión registrado: " .. session_start)
end

-- Termina la sesión actual y guarda el registro
function M.end_session()
    if not session_start then
        return -- No hay sesión activa, salir silenciosamente
    end

    local session_end = get_timestamp()
    local log_entry = string.format("\nFecha: %s\nInicio: %s\nFin: %s\n", os.date('%Y-%m-%d'), session_start, session_end)

    -- Escribe el registro en el archivo
    local file = io.open(log_file_path, 'a')
    if file then
        file:write(log_entry)
        file:close()
        print("Sesión registrada en: " .. log_file_path)
    else
        print("Error al escribir el archivo de registro.")
    end

    session_start = nil
end

-- Muestra el contenido del archivo de registro
function M.show_log()
    local file = io.open(log_file_path, 'r')
    if file then
        local content = file:read('*a')
        file:close()
        print("Registro de sesiones:\n" .. content)
    else
        print("No se encontró el archivo de registro.")
    end
end

-- Opcional: Función para registrar los archivos abiertos
local opened_files = {}
function M.track_file()
    local current_file = vim.fn.expand('%:p')
    if current_file ~= "" and not opened_files[current_file] then
        opened_files[current_file] = true
        local file = io.open(log_file_path, 'a')
        if file then
            file:write("Archivo abierto: " .. current_file .. "\n")
            file:close()
        end
    end
end

-- Autocomando para rastrear archivos abiertos
vim.api.nvim_create_autocmd('BufEnter', {
    callback = M.track_file
})

-- 🔥 Autocomando para cerrar sesión antes de salir de Neovim
vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
        M.end_session()
    end
})

-- Comandos de usuario
vim.api.nvim_create_user_command('StartSession', M.start_session, {})
vim.api.nvim_create_user_command('EndSession', M.end_session, {})
vim.api.nvim_create_user_command('ShowLog', M.show_log, {})

return {
    setup = function()
        return M
    end
}
