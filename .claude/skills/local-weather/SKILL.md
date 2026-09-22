---
name: local-weather
description: Fetch current local weather conditions (temperature, sky, humidity, wind) for the user via IP-based geolocation, or for any named city/location. No API key needed. Use this whenever the user asks about the weather, what it's like outside, whether to bring an umbrella/jacket, or for a forecast — even casual phrasing like "what's it like out there" or "is it raining". Not related to the Tetris game code in this repo; this is a standalone local utility.
---

# Local Weather

Get current weather conditions from wttr.in — a free, no-key-required weather
service that also auto-detects location from IP address.

## How to use

Run the bundled script:

```bash
bash .claude/skills/local-weather/scripts/weather.sh "[location]" "[format]"
```

- **location** — leave empty (`""`) to auto-detect from the user's IP address.
  Otherwise pass a city name (`"Xalapa"`), `"City,Country"`, an airport code
  (`"JFK"`), or `"lat,lon"`.
- **format** — one of:
  - `line` (default) — one-line summary, good for quick answers
  - `full` — multi-line report (today's conditions, no forecast ASCII art)
  - `png` — saves a weather image to `/tmp` and prints its path

## Examples

Auto-detect location, quick answer:
```bash
bash .claude/skills/local-weather/scripts/weather.sh "" line
```
Output: `Xalapa, Veracruz, MX: Light rain shower +22°C (feels +21°C), humidity 64%, wind ←11km/h`

Specific city, fuller report:
```bash
bash .claude/skills/local-weather/scripts/weather.sh "Tokyo" full
```

## Notes

- Requires only `curl` — no API key, no signup, no dependencies.
- If the request fails (network down, service unreachable), tell the user
  plainly rather than guessing at conditions.
- Report the result to the user in plain language; don't just dump raw output
  unless they ask for the full report.
