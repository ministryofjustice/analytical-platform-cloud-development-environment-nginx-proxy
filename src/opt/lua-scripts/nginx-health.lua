local activity = ngx.shared.activity
local seen, flags = activity:get("last_seen")

--- If the last_seen activity is not set, set it to the current timestamp
if (type(seen) == type(nil)) then
  local timestamp = os.time(os.date("!*t"))
  activity:set("last_seen",timestamp)
end

--- Print OK and return a 200 status code
ngx.print("OK")
ngx.exit(ngx.HTTP_OK)
