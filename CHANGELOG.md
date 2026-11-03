4.0.0
----
Breaking changes:
- require ruby 3.3 or newer
- remove activesupport and faraday-multipart dependencies
- all errors now inherit from `Adafruit::IO::Error`. argument errors raise `Adafruit::IO::Arguments::ArgumentError` and mqtt "not connected" errors raise `Adafruit::IO::Error` instead of `RuntimeError`
- delete requests raise `Adafruit::IO::RequestError` on 404 instead of returning nil
- `post`, `put`, and `delete` no longer accept an unused `options` argument
- `create_permission` requires a hash of permission attributes
- permission resource types must be exactly `feed`, `group`, or `dashboard`

Fixes:
- mqtt `publish` and `publish_group` no longer crash when given a location
- `create_token` no longer crashes
- `last_page?` returns true when there are no pagination headers, and pagination resets on every request
- request attributes accept string keys as well as symbols
- clear error when a hash without a key is passed where a key is expected
- `update_block` sends attributes given in the same hash as `dashboard_key` and `key`
- debug mode no longer prints JSON parse errors on every response
- passing `username:` to a method no longer modifies the caller's hash
- reuse the faraday connection between requests
- `Client#inspect` shows only the username, endpoint, and a masked key

3.0.0
----
- update dependencies for ruby 3.x, potentially breaking older ruby versions

2.0.0
----
- initial API v2 client release
- basic API support for: activities, blocks, dashboards, data, feeds, groups, permissions, tokens, triggers, and user records
- basic MQTT client



2.0.0.beta.3
----
- MQTT Client

2.0.0.beta.1
----
- Feeds, Data, and Groups

1.1.0
----
- updated test suite
- consolidated shared functionality into IOObject (thanks @rkam)
- deprecate Group#groups

1.0.3
----
Update outgoing user agent

1.0.2
----
Remove unnecessary put statements

1.0.1
----
Fix host for connecting to io.
Remove hashie completely.

1.0.0
----
Initial release

0.0.1
----
Initial Changelog
