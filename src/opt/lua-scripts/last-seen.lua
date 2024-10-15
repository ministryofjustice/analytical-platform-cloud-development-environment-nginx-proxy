local activity = ngx.shared.activity
local last_seen, flags = activity:get("last_seen")

--- Print last_seen and return a 200 status code
ngx.print(last_seen)
ngx.exit(ngx.HTTP_OK)
