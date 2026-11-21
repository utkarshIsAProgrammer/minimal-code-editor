-- ===================================================================
-- Minimal Code Editor - Theme Showroom & Live Syntax Preview
-- This file provides a curated multi-language syntax showcase
-- ===================================================================

local M = {}

--- @class UserProfile
--- Represents an authenticated developer session
local UserProfile = {
  username = "indiedev",
  active = true,
  karma = 2048,
  tags = { "rust", "go", "typescript", "hyprland", "neovim" },
  theme = "Minimal",
}

-- Mathematical & Recursive Computation
--- @param n number The term to compute
--- @return number Resulting sequence value
function M.fibonacci(n)
  if n <= 0 then return 0 end
  if n == 1 then return 1 end

  local prev, curr = 0, 1
  for _ = 2, n do
    prev, curr = curr, prev + curr
  end
  return curr
end

-- String formatting, Regex and API endpoints
function UserProfile:format_greeting(salutation)
  local endpoint = "https://api.github.com/v1/users/" .. self.username
  local message = string.format("[%s] %s %s! Endpoint: %s", os.date("%H:%M:%S"), salutation, self.username, endpoint)
  print(message)
  return message
end

-- Diagnostic & Warning Simulation
local _unused_config = { port = 8080, host = "127.0.0.1", debug = false }

-- Export module
return M
