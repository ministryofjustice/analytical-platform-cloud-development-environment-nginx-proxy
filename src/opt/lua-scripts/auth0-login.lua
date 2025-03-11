--- Load libraries and modules
local activity = ngx.shared.activity
local openidc  = require "resty.openidc"

--- Construct URLs
local discovery_url             = "https://" .. ngx.var.auth0_tenant_domain .. "/.well-known/openid-configuration"
local redirect_after_logout_uri = "https://" .. ngx.var.auth0_tenant_domain .. "/v2/logout?client_id=" .. ngx.var.auth0_client_id .. "&redirectTo=" .. ngx.var.logout_url
local redirect_uri              = "https://" .. ngx.var.username .. "-" .. ngx.var.analytical_platform_tool .. "." .. ngx.var.redirect_domain .. "/callback"

--- Construct the options for the openidc.authenticate function
local opts = {
  access_token_expires_in                  = 28800,
  client_id                                = ngx.var.auth0_client_id,
  client_secret                            = ngx.var.auth0_client_secret,
  discovery                                = discovery_url,
  redirect_uri                             = redirect_uri,
  redirect_after_logout_uri                = redirect_after_logout_uri,
  redirect_after_logout_with_id_token_hint = false,
  refresh_session_interval                 = 28800,
  token_signing_alg_values_expected        = "HS256"
}

--- Authenticate the user
local res, err = openidc.authenticate(opts)

--- If error occurs, log the error and return a 500 status code
if err then
  ngx.status = 500
  ngx.say("Internal Server Error. Please contact the Analytical Platform team.")
  ngx.log(ngx.ERR, err)
  ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

--- If the user is authenticated, set the USER_EMAIL header and update the last_seen activity
if res then
  local id_token_email    = res.id_token.email
  local id_token_nickname = res.id_token.nickname

  --- TODO: is this id_token_email function used for apps?
  if id_token_email then
    local timestamp = os.time(os.date("!*t"))

    ngx.req.set_header("USER_EMAIL", id_token_email)
    activity:set("last_seen",timestamp)
  end

  --- If the user is not the correct user, return a 403 status code
  if id_token_nickname ~= ngx.var.username then
    ngx.status = 403
    ngx.say("User forbidden for this application. Please contact the Analytical Platform team.")
    ngx.log(ngx.ERR, "User" .. id_token_nickname .. " is forbidden for this application.")
    ngx.exit(ngx.HTTP_FORBIDDEN)
  end
end
